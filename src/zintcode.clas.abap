"! <p class="shorttext synchronized" lang="en">AoC Day 2</p>
CLASS zintcode DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
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
    DATA prog TYPE stringtab.
    METHODS solve_instruction
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
    LOOP AT prog ASSIGNING FIELD-SYMBOL(<pointer>).
      IF ( sy-tabix - 1 ) MOD 4 = 0.
        CASE <pointer>.
          WHEN add OR multiply.
            solve_instruction( sy-tabix - 1 ).
          WHEN halt.
            EXIT.
          WHEN OTHERS."Error case
            EXIT.
        ENDCASE.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD solve_instruction.

    CASE read( pointer ).
      WHEN add.
        write( address = read( pointer + 3 ) value = read( read( pointer + 1 ) ) + read( read( pointer + 2 ) ) ).
      WHEN multiply.
        write( address = read( pointer + 3 ) value = read( read( pointer + 1 ) ) * read( read( pointer + 2 ) ) ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
