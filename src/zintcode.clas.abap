"! <p class="shorttext synchronized" lang="en">AoC Day 2 & 5</p>
CLASS zintcode DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS load
      IMPORTING
        program TYPE string.
    METHODS read
      IMPORTING
        VALUE(address) TYPE i
      RETURNING
        VALUE(result)  TYPE i.
    METHODS write
      IMPORTING
        VALUE(address) TYPE i
        VALUE(value)   TYPE i.
    METHODS save
      RETURNING
        VALUE(program) TYPE string.
    METHODS run.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS immediate TYPE i VALUE 1.
    CONSTANTS position TYPE i VALUE 0.
    CONSTANTS add TYPE i VALUE 1.
    CONSTANTS multiply TYPE i VALUE 2.
    CONSTANTS input TYPE i VALUE 3.
    CONSTANTS output TYPE i VALUE 4.
    CONSTANTS jump_if_true TYPE i VALUE 5.
    CONSTANTS jump_if_false TYPE i VALUE 6.
    CONSTANTS less_than TYPE i VALUE 7.
    CONSTANTS equals TYPE i VALUE 8.
    CONSTANTS halt TYPE i VALUE 99.
    DATA prog TYPE stringtab.
    DATA parameter_mode TYPE i.
    DATA demo_input TYPE REF TO if_demo_input.
    DATA demo_output TYPE REF TO if_demo_output.
    DATA output_text TYPE string.
    DATA: a TYPE i, b TYPE i, c TYPE i.
    METHODS calculate
      IMPORTING VALUE(address) TYPE i.
    METHODS get_instruction_length
      IMPORTING VALUE(opcode) TYPE i
      RETURNING VALUE(len)    TYPE i.
    METHODS get_input
      IMPORTING VALUE(address) TYPE i.
    METHODS write_output
      IMPORTING VALUE(address) TYPE i.
    METHODS set_parameter_mode
      IMPORTING VALUE(instruction) TYPE string
      RETURNING VALUE(opcode)      TYPE i.
    METHODS get_opcode
      IMPORTING
        VALUE(instruction) TYPE string
      RETURNING
        VALUE(opcode)      TYPE i.
    METHODS log_exp
      IMPORTING VALUE(address) TYPE i
      RETURNING VALUE(pointer) TYPE i.
ENDCLASS.



CLASS zintcode IMPLEMENTATION.

  METHOD load.
    CLEAR prog.
    SPLIT program AT ',' INTO TABLE prog.
  ENDMETHOD.


  METHOD read.
    result = VALUE i( prog[ address + 1 ] OPTIONAL ).
  ENDMETHOD.


  METHOD write.
    prog[ address + 1 ] = condense( CONV string( value ) ).
  ENDMETHOD.


  METHOD save.
    program = concat_lines_of( table = prog sep = ',' ).
  ENDMETHOD.

  METHOD run.

    DATA(pointer) = 1.
    DO.
      DATA(opcode) = set_parameter_mode( prog[ pointer ] ).

      CASE opcode.
        WHEN add OR multiply.
          calculate( pointer - 1 ). " address always "- 1" -> intcode starts with 0, ABAP table index with 1
          pointer = pointer + get_instruction_length( opcode ).
        WHEN input.
          get_input( pointer - 1 ).
          pointer = pointer + get_instruction_length( opcode ).
        WHEN output.
          write_output( pointer - 1 ).
          pointer = pointer + get_instruction_length( opcode ).
        WHEN jump_if_true OR jump_if_false OR less_than OR equals.
          pointer = log_exp( pointer - 1 ).
        WHEN halt.
          IF output_text IS NOT INITIAL.
            demo_output->display( output_text ).
          ENDIF.
          EXIT.
        WHEN OTHERS."Error case
          EXIT.
      ENDCASE.
    ENDDO.

  ENDMETHOD.

  METHOD calculate.
    DATA(param1) = COND i( LET p = read( address + 1 ) IN
                           WHEN c = immediate THEN p
                           WHEN c = position  THEN read( p ) ).
    DATA(param2) = COND i( LET p = read( address + 2 ) IN
                           WHEN b = immediate THEN p
                           WHEN b = position  THEN read( p ) ).
    DATA(new_address) = COND i( WHEN a = immediate THEN address + 3
                                WHEN a = position  THEN read( address + 3 ) ).
    CASE get_opcode( CONV #( read( address ) ) ).
      WHEN add.
        write( address = new_address value = param1 + param2 ).
      WHEN multiply.
        write( address = new_address value = param1 * param2 ).
    ENDCASE.
  ENDMETHOD.

  METHOD log_exp.
    DATA(opcode) = get_opcode( CONV #( read( address ) ) ).
    DATA(param1) = SWITCH i( LET p = read( address + 1 ) IN
                             c WHEN immediate THEN p
                               WHEN position  THEN read( p ) ).
    DATA(param2) = SWITCH i( LET p = read( address + 2 ) IN
                             b WHEN immediate THEN p
                               WHEN position  THEN read( p ) ).
    IF opcode = less_than OR opcode = equals.
      DATA(param3) = SWITCH i( a  WHEN immediate THEN address + 3
                                  WHEN position  THEN read( address + 3 ) ).
    ENDIF.

    CASE opcode.
      WHEN jump_if_true OR jump_if_false.
        pointer = COND #( WHEN opcode = jump_if_true AND param1 <> 0
                            OR opcode = jump_if_false AND param1 = 0
                          THEN param2 + 1
                          ELSE address + 1 + get_instruction_length( jump_if_true ) ).
      WHEN less_than OR equals.
        write( address = param3
               value   = COND #( WHEN opcode = less_than AND param1 < param2
                                   OR opcode = equals    AND param1 = param2
                                 THEN 1
                                 ELSE 0 ) ).
        pointer = address + 1 + get_instruction_length( opcode ). " + 1 due to internal table starts at 0
    ENDCASE.

  ENDMETHOD.

  METHOD get_instruction_length.
    len = COND #( WHEN opcode = halt THEN 1
                  WHEN opcode = input
                    OR opcode = output THEN 2
                  WHEN opcode = jump_if_true
                    OR opcode = jump_if_false THEN 3
                  WHEN opcode = add
                    OR opcode = multiply
                    OR opcode = less_than
                    OR opcode = equals THEN 4 ).
  ENDMETHOD.

  METHOD get_input.
    DATA str TYPE string.
    demo_input->request( EXPORTING text  = |Input|
                         CHANGING  field = str ).
    write( address = read( address + 1 ) value = CONV #( str ) ).
  ENDMETHOD.

  METHOD write_output.
    output_text = COND #( WHEN output_text IS INITIAL
                          THEN condense( read( read( address + 1 ) ) )
                          ELSE condense( output_text ) && |\n{ read( read( address + 1 ) ) }| ).
  ENDMETHOD.

  METHOD constructor.
    demo_input = cl_demo_input=>new( ).
    demo_output = cl_demo_output=>new( ).
  ENDMETHOD.

  METHOD get_opcode.
    opcode = substring_from( val = instruction regex = '..$|.$' ).
  ENDMETHOD.

  METHOD set_parameter_mode.
    " return opcode
    opcode = get_opcode( instruction ).

    " ABC in position mode per default
    CLEAR: a,b,c.
    " set ABC according to instruction
    CASE strlen( instruction ).
      WHEN 1 OR 2.
        RETURN. "only opcode in instruction
      WHEN 3.
        c = instruction(1).
      WHEN 4.
        b = instruction(1).
        c = instruction+1(1).
      WHEN 5.
        a = instruction(1).
        b = instruction+1(1).
        c = instruction+2(1).
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
