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
    DATA: a      TYPE i,
          b      TYPE i,
          c      TYPE i,
          param1 TYPE i,
          param2 TYPE i,
          param3 TYPE i,
          opcode TYPE i.
    METHODS calculate
      IMPORTING VALUE(address) TYPE i.
    METHODS get_instruction_length
      IMPORTING VALUE(opcode) TYPE i
      RETURNING VALUE(length)    TYPE i.
    METHODS get_input
      IMPORTING VALUE(address) TYPE i.
    METHODS write_output
      IMPORTING VALUE(address) TYPE i.
    METHODS set_parameter
      IMPORTING VALUE(address) TYPE i.
    METHODS set_opcode
      IMPORTING
        VALUE(address) TYPE i.
    METHODS log_exp
      IMPORTING VALUE(address) TYPE i
      RETURNING VALUE(new_address) TYPE i.
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
      DATA(address) = pointer - 1." address always "- 1" -> intcode starts with 0, ABAP table index with 1
      set_opcode( address ).
      set_parameter( address ).
      CASE opcode.
        WHEN add OR multiply.
          calculate( address ).
          pointer = pointer + get_instruction_length( opcode ).
        WHEN input.
          get_input( address ).
          pointer = pointer + get_instruction_length( opcode ).
        WHEN output.
          write_output( address ).
          pointer = pointer + get_instruction_length( opcode ).
        WHEN jump_if_true OR jump_if_false OR less_than OR equals.
          pointer = log_exp( address ) + 1.
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
    CASE opcode.
      WHEN add.
        write( address = param3 value = param1 + param2 ).
      WHEN multiply.
        write( address = param3 value = param1 * param2 ).
    ENDCASE.
  ENDMETHOD.

  METHOD log_exp.
    CASE opcode.
      WHEN jump_if_true OR jump_if_false.
        new_address = COND #( WHEN opcode = jump_if_true AND param1 <> 0
                            OR opcode = jump_if_false AND param1 = 0
                          THEN param2
                          ELSE address + get_instruction_length( jump_if_true ) ).
      WHEN less_than OR equals.
        write( address = param3
               value   = COND #( WHEN opcode = less_than AND param1 < param2
                                   OR opcode = equals    AND param1 = param2
                                 THEN 1
                                 ELSE 0 ) ).
        new_address = address + get_instruction_length( opcode ). " + 1 due to internal table starts at 0
    ENDCASE.

  ENDMETHOD.

  METHOD get_instruction_length.
    length = COND #(  WHEN opcode = input
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
    write( address = param1 value = CONV #( str ) ).
  ENDMETHOD.

  METHOD write_output.
    output_text = COND #( WHEN output_text IS INITIAL
                          THEN condense( |{ param1 }| )
                          ELSE condense( output_text && |\n| && param1 ) ).
  ENDMETHOD.

  METHOD constructor.
    demo_input = cl_demo_input=>new( ).
    demo_output = cl_demo_output=>new( ).
  ENDMETHOD.

  METHOD set_opcode.
    DATA(instruction) = prog[ address + 1 ].
    opcode = substring_from( val = instruction regex = '..$|.$' ).
  ENDMETHOD.

  METHOD set_parameter.
    DATA(instruction) = prog[ address + 1 ].
    " ABC in position mode per default
    CLEAR: a,b,c,param1,param2,param3.
    " set ABC according to instruction
    CASE strlen( instruction ).
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

    " set parameter if exist for opcode
    param1 = SWITCH #( opcode WHEN add
                                OR multiply
                                OR equals
                                OR less_than
                                OR output
                                OR jump_if_true
                                OR jump_if_false
                              THEN SWITCH i( LET pos = read( address + 1 ) IN
                                             c WHEN immediate THEN pos
                                               WHEN position  THEN read( pos ) )
    " write position in param1 differs from read -> write to parameter or to position mentioned in parameter
                              WHEN input
                              THEN SWITCH i( c WHEN immediate THEN address + 1
                                               WHEN position  THEN read( address + 1 ) ) ).
    param2 = SWITCH #( opcode WHEN add
                                OR multiply
                                OR jump_if_true
                                OR jump_if_false
                                OR equals
                                OR less_than
                              THEN SWITCH i( LET pos = read( address + 2 ) IN
                                             b WHEN immediate THEN pos
                                               WHEN position  THEN read( pos ) ) ).
    " write position in param1 differs from read -> write to parameter pos or to position mentioned in parameter
    param3 = SWITCH #( opcode WHEN add
                                OR multiply
                                OR equals
                                OR less_than
                              THEN SWITCH i( a WHEN immediate THEN address + 3
                                               WHEN position  THEN read( address + 3 ) ) ).
  ENDMETHOD.

ENDCLASS.
