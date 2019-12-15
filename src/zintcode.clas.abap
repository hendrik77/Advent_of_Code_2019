"! <p class="shorttext synchronized" lang="en">AoC Day 2</p>
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
    CONSTANTS immediate TYPE i VALUE 0.
    CONSTANTS position TYPE i VALUE 1.
    DATA prog TYPE stringtab.
    DATA parameter_mode TYPE i.
    DATA demo_input TYPE REF TO if_demo_input.
    DATA demo_output TYPE REF TO if_demo_output.
    METHODS calculate
      IMPORTING VALUE(address) TYPE i.
    METHODS len_instruction
      IMPORTING VALUE(opcode) TYPE i
      RETURNING VALUE(len)    TYPE i.
    METHODS get_input
      IMPORTING VALUE(address) TYPE i.
    METHODS write_output
      IMPORTING VALUE(address) TYPE i.
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
      DATA(offset) = len_instruction( CONV #( prog[ pointer ] ) ).
      CASE prog[ pointer ].
        WHEN add OR multiply.
          calculate( pointer - 1 ).
        WHEN input.
          get_input( pointer - 1 ).
        WHEN output.
          write_output( pointer - 1 ).
        WHEN halt.
          EXIT.
        WHEN OTHERS."Error case
          EXIT.
      ENDCASE.
      pointer = pointer + offset.
    ENDDO.

  ENDMETHOD.


  METHOD calculate.

    CASE read( address ).
      WHEN add.
        write( address = read( address + 3 ) value = read( read( address + 1 ) ) + read( read( address + 2 ) ) ).
      WHEN multiply.
        write( address = read( address + 3 ) value = read( read( address + 1 ) ) * read( read( address + 2 ) ) ).
    ENDCASE.

  ENDMETHOD.

  METHOD len_instruction.
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
    demo_output->write( read( read( address + 1 ) ) ).
    demo_output->display( ).
  ENDMETHOD.

  METHOD constructor.
    demo_input = cl_demo_input=>new( ).
    demo_output = cl_demo_output=>new( ).
  ENDMETHOD.

ENDCLASS.
