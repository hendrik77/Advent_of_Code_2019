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
    CONSTANTS add TYPE i VALUE 1.
    CONSTANTS multiply TYPE i VALUE 2.
    CONSTANTS halt TYPE i VALUE 99.
    CONSTANTS input TYPE i VALUE 3.
    CONSTANTS output TYPE i VALUE 4.
    CONSTANTS immediate TYPE i VALUE 1.
    CONSTANTS position TYPE i VALUE 0.
    CONSTANTS jump_if_true TYPE i VALUE 5.
    CONSTANTS jump_if_false TYPE i VALUE 6.
    CONSTANTS less_than TYPE i VALUE 7.
    CONSTANTS equals TYPE i VALUE 8.
    DATA prog TYPE stringtab.
    DATA parameter_mode TYPE i.
    DATA demo_input TYPE REF TO if_demo_input.
    DATA demo_output TYPE REF TO if_demo_output.
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
    METHODS set_parameter
      IMPORTING VALUE(instruction) TYPE string
      RETURNING VALUE(opcode)      TYPE i.
    METHODS get_opcode
      IMPORTING
        VALUE(instruction) TYPE string
      RETURNING
        VALUE(opcode)      TYPE i.
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
      DATA(opcode) = set_parameter( prog[ pointer ] ).
      DATA(offset) = get_instruction_length( opcode ).

      CASE opcode.
        WHEN add OR multiply.
          calculate( pointer - 1 ).
        WHEN input.
          get_input( pointer - 1 ).
        WHEN output.
          write_output( pointer - 1 ).
        WHEN jump_if_true.
        WHEN jump_if_false.
        WHEN less_than.
        WHEN equals.
        WHEN halt.
          IF demo_output IS BOUND.
            demo_output->display( ).
          ENDIF.
          EXIT.
        WHEN OTHERS."Error case
          EXIT.
      ENDCASE.
      pointer = pointer + offset.
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

  METHOD get_instruction_length.
    len = COND #( WHEN opcode = add
                    OR opcode = multiply THEN 4
                  WHEN opcode = input OR opcode = output THEN 2
                  WHEN opcode = halt THEN 1 ).
  ENDMETHOD.

  METHOD get_input.
    DATA str TYPE string.
    demo_input->request( EXPORTING text  = |Input|
                         CHANGING  field = str ).
    write( address = read( address + 1 ) value = CONV #( str ) ).

  ENDMETHOD.

  METHOD write_output.
    demo_output->begin_section( ).
    demo_output->write( read( read( address + 1 ) ) ).
  ENDMETHOD.

  METHOD constructor.
    demo_input = cl_demo_input=>new( ).
    demo_output = cl_demo_output=>new( ).
  ENDMETHOD.

  METHOD get_opcode.
    opcode = substring_from( val = instruction regex = '..$|.$' ).
  ENDMETHOD.

  METHOD set_parameter.
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
