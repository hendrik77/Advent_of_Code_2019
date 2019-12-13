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
    DATA prog TYPE stringtab.
    DATA demo_input TYPE REF TO if_demo_input.
    data demo_output type ref to if_demo_output.
    METHODS solve
      IMPORTING VALUE(pointer) TYPE i.
    METHODS len_instruction
      IMPORTING VALUE(opcode) TYPE i
      RETURNING VALUE(len)    TYPE i.
    METHODS get_input
      IMPORTING VALUE(pointer) TYPE i.
    METHODS write_output
      IMPORTING VALUE(pointer) TYPE i.
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
      CASE prog[ pointer ].
        WHEN add OR multiply.
          solve( pointer - 1 ).
        WHEN input.
          get_input( CONV #( prog[ pointer ] ) ).
        WHEN output.
          write_output( CONV #( prog[ pointer ] ) ).
        WHEN halt.
          EXIT.
        WHEN OTHERS."Error case
          EXIT.
      ENDCASE.
      pointer = pointer + len_instruction( CONV #( prog[ pointer ] ) ).
    ENDDO.

  ENDMETHOD.


  METHOD solve.

    CASE read( pointer ).
      WHEN add.
        write( address = read( pointer + 3 ) value = read( read( pointer + 1 ) ) + read( read( pointer + 2 ) ) ).
      WHEN multiply.
        write( address = read( pointer + 3 ) value = read( read( pointer + 1 ) ) * read( read( pointer + 2 ) ) ).
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

    demo_input->request( EXPORTING text  =  |Input|
                         CHANGING  field =  str    ).

  ENDMETHOD.

  METHOD write_output.

  ENDMETHOD.

  METHOD constructor.
    demo_input = cl_demo_input=>new( ).
    demo_output = cl_demo_output=>new( ).
  ENDMETHOD.

ENDCLASS.
