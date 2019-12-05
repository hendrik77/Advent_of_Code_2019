*"* use this source file for your ABAP unit test classes
CLASS ltcl_intcode DEFINITION DEFERRED.
CLASS zintcode DEFINITION LOCAL FRIENDS ltcl_intcode.
CLASS ltcl_intcode DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: intcode TYPE REF TO zintcode.
    METHODS:
      set_prog_code FOR TESTING RAISING cx_static_check,
      read_position_10 FOR TESTING RAISING cx_static_check,
      write_position_10 FOR TESTING RAISING cx_static_check,
      save_prog FOR TESTING RAISING cx_static_check,
      opcode_100099 FOR TESTING RAISING cx_static_check,
      opcode_230399 FOR TESTING RAISING cx_static_check,
      opcode_2445990 FOR TESTING RAISING cx_static_check,
      opcode_11149956099 FOR TESTING RAISING cx_static_check,
      opcode_long FOR TESTING RAISING cx_static_check.
    METHODS setup.
ENDCLASS.


CLASS ltcl_intcode IMPLEMENTATION.

  METHOD set_prog_code.
    intcode->load( |1,9,10,3,2,3,11,0,99,30,40,50| ).
    cl_abap_unit_assert=>assert_equals( msg = 'program hast 12 numbers' exp = 12 act = lines( intcode->prog ) ).
  ENDMETHOD.

  METHOD setup.
    intcode = NEW zintcode( ).
  ENDMETHOD.

  METHOD read_position_10.
    intcode->load( |1,9,10,3,2,3,11,0,99,30,40,50| ).
    cl_abap_unit_assert=>assert_equals( msg = 'read pos 10' exp = 40 act = intcode->read( 10 ) ).
  ENDMETHOD.

   METHOD write_position_10.
    intcode->load( |1,9,10,3,2,3,11,0,99,30,40,50| ).
    intcode->write( address = 10 value = 42 ).
    cl_abap_unit_assert=>assert_equals( msg = 'write pos 10' exp = 42 act = intcode->read( 10 ) ).
  ENDMETHOD.

  METHOD save_prog.
    intcode->load( |1,0,0,0,99| ).
    cl_abap_unit_assert=>assert_equals( msg = 'save prog' exp = |1,0,0,0,99| act = intcode->save( ) ).
  ENDMETHOD.

METHOD opcode_long.
        intcode->load( |1,9,10,3,2,3,11,0,99,30,40,50| ).
        intcode->run( ).
        cl_abap_unit_assert=>assert_equals( msg = 'run opcode 1,9,10,3,2,3,11,0,99,30,40,50' exp = |3500,9,10,70,2,3,11,0,99,30,40,50| act = intcode->save(  ) ).
  ENDMETHOD.

  METHOD opcode_100099.
        intcode->load( |1,0,0,0,99| ).
        intcode->run( ).
        cl_abap_unit_assert=>assert_equals( msg = 'run opcode 1,0,0,0,99' exp = |2,0,0,0,99| act = intcode->save(  ) ).
  ENDMETHOD.

  METHOD opcode_230399.
        intcode->load( |2,3,0,3,99| ).
        intcode->run( ).
        cl_abap_unit_assert=>assert_equals( msg = 'run opcode 2,3,0,3,99' exp = |2,3,0,6,99| act = intcode->save(  ) ).
  ENDMETHOD.

  METHOD opcode_2445990.
        intcode->load( |2,4,4,5,99,0| ).
        intcode->run( ).
        cl_abap_unit_assert=>assert_equals( msg = 'run opcode 2,4,4,5,99,0' exp = |2,4,4,5,99,9801| act = intcode->save(  ) ).
  ENDMETHOD.

  METHOD opcode_11149956099.
        intcode->load( |1,1,1,4,99,5,6,0,99| ).
        intcode->run( ).
        cl_abap_unit_assert=>assert_equals( msg = 'run opcode 1,1,1,4,99,5,6,0,99' exp = |30,1,1,4,2,5,6,0,99| act = intcode->save(  ) ).
  ENDMETHOD.

ENDCLASS.
