"! <p class="shorttext synchronized" lang="en">AoC Day 2 & 5 & 9</p>
CLASS zintcode DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS load
      IMPORTING
        program TYPE string.

    METHODS save
      RETURNING
        VALUE(program) TYPE string.
    METHODS run.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS immediate TYPE i VALUE 1.
    CONSTANTS position TYPE i VALUE 0.
    CONSTANTS relative TYPE i VALUE 2.
    CONSTANTS add TYPE i VALUE 1.
    CONSTANTS multiply TYPE i VALUE 2.
    CONSTANTS input TYPE i VALUE 3.
    CONSTANTS output TYPE i VALUE 4.
    CONSTANTS jump_if_true TYPE i VALUE 5.
    CONSTANTS jump_if_false TYPE i VALUE 6.
    CONSTANTS less_than TYPE i VALUE 7.
    CONSTANTS equals TYPE i VALUE 8.
    CONSTANTS adjust_relative_base TYPE i VALUE 9.
    CONSTANTS halt TYPE i VALUE 99.
    TYPES: BEGIN OF memory_type,
             addr  TYPE int8,
             value TYPE int8,
           END OF memory_type,
           memory_table_type TYPE HASHED TABLE OF memory_type WITH UNIQUE KEY addr.
    DATA memory TYPE memory_table_type.
    DATA prog TYPE stringtab.
    DATA parameter_mode TYPE i.
    DATA demo_input TYPE REF TO if_demo_input.
    DATA demo_output TYPE REF TO if_demo_output.
    DATA output_text TYPE string.
    DATA: a             TYPE i,
          b             TYPE i,
          c             TYPE i,
          param1        TYPE int8,
          param2        TYPE int8,
          param3        TYPE int8,
          opcode        TYPE i,
          relative_base TYPE i.
    METHODS read
      IMPORTING
        VALUE(address) TYPE int8
      RETURNING
        VALUE(result)  TYPE int8.
    METHODS write
      IMPORTING
        VALUE(address) TYPE int8
        VALUE(value)   TYPE int8.
    METHODS calculate
      IMPORTING VALUE(address) TYPE int8.
    METHODS get_new_pointer
      IMPORTING VALUE(old_pointer) TYPE int8
      RETURNING VALUE(new_pointer) TYPE int8.
    METHODS get_input
      IMPORTING VALUE(address) TYPE int8.
    METHODS write_output
      IMPORTING VALUE(address) TYPE int8.
    METHODS set_parameter
      IMPORTING VALUE(address) TYPE int8.
    METHODS set_opcode
      IMPORTING
        VALUE(address) TYPE int8.
    METHODS log_exp
      IMPORTING VALUE(address)     TYPE int8
      RETURNING VALUE(new_address) TYPE int8.
    METHODS get_instruction_length
      RETURNING
        VALUE(instruction_length) TYPE i.
ENDCLASS.



CLASS zintcode IMPLEMENTATION.

  METHOD load.
    CLEAR prog.
    SPLIT program AT ',' INTO TABLE prog.
  ENDMETHOD.


  METHOD read.
    result = COND #( WHEN address >= lines( prog )
                     THEN VALUE #( memory[ addr = address ]-value DEFAULT 0 )
                     ELSE prog[ address + 1 ]  ).
  ENDMETHOD.

  METHOD write.
    IF address >= lines( prog ).
      IF line_exists( memory[ addr = address ] ).
        memory[ addr = address ]-value = value.
      ELSE.
        INSERT VALUE #( addr = address value = value )
               INTO TABLE memory.
      ENDIF.
    ELSE.
      prog[ address + 1 ] = condense( CONV string( value ) ).
    ENDIF.
  ENDMETHOD.


  METHOD save.
    program = concat_lines_of( table = prog sep = ',' ).
  ENDMETHOD.

  METHOD run.

    DATA(pointer) = CONV int8( 1 ).
    DO.
      DATA(address) = pointer - 1." address always "- 1" -> intcode starts with 0, ABAP table index with 1
      set_opcode( address ).
      set_parameter( address ).
      CASE opcode.
        WHEN add OR multiply.
          calculate( address ).
          pointer = get_new_pointer( pointer ).
        WHEN input.
          get_input( address ).
          pointer = get_new_pointer( pointer ).
        WHEN output.
          write_output( address ).
          pointer = get_new_pointer( pointer ).
        WHEN jump_if_true OR jump_if_false OR less_than OR equals.
          pointer = log_exp( address ) + 1. "plus 1 due to abap table starts with 1 and intcode memory with 0
        WHEN adjust_relative_base.
          relative_base = relative_base + param1.
          pointer = get_new_pointer( pointer ).
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
                          ELSE address + get_instruction_length( ) ).
      WHEN less_than OR equals.
        write( address = param3
               value   = COND #( WHEN opcode = less_than AND param1 < param2
                                   OR opcode = equals    AND param1 = param2
                                 THEN 1
                                 ELSE 0 ) ).
        new_address = address + get_instruction_length( ).
    ENDCASE.

  ENDMETHOD.

  METHOD get_new_pointer.
    new_pointer = old_pointer + get_instruction_length( ).
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
                          ELSE condense( output_text && |,| && param1 ) ).
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
                                OR adjust_relative_base
                              THEN SWITCH #( LET pos = read( address + 1 ) IN
                                             c WHEN immediate THEN pos
                                               WHEN position  THEN read( pos )
                                               WHEN relative  THEN read( pos + relative_base ) )
    " write position in param1 differs from read -> write to parameter or to position mentioned in parameter
                              WHEN input
                              THEN SWITCH #( c WHEN immediate THEN address + 1
                                               WHEN position  THEN read( address + 1 )
                                               WHEN relative  THEN read( address + 1 ) + relative_base ) ).
    param2 = SWITCH #( opcode WHEN add
                                OR multiply
                                OR jump_if_true
                                OR jump_if_false
                                OR equals
                                OR less_than
                              THEN SWITCH #( LET pos = read( address + 2 ) IN
                                             b WHEN immediate THEN pos
                                               WHEN position  THEN read( pos )
                                               WHEN relative  THEN read( pos + relative_base ) ) ).
    " write position in param1 differs from read -> write to parameter pos or to position mentioned in parameter
    param3 = SWITCH #( opcode WHEN add
                                OR multiply
                                OR equals
                                OR less_than
                              THEN SWITCH #( a WHEN immediate THEN address + 3
                                               WHEN position  THEN read( address + 3 )
                                               WHEN relative  THEN read( address + 3 ) + relative_base ) ).
  ENDMETHOD.


  METHOD get_instruction_length.

    instruction_length  = SWITCH #(  opcode WHEN input
                                     OR output
                                     OR adjust_relative_base THEN 2
                                   WHEN jump_if_true
                                     OR jump_if_false THEN 3
                                   WHEN add
                                     OR multiply
                                     OR less_than
                                     OR equals THEN 4 ).

  ENDMETHOD.

ENDCLASS.
