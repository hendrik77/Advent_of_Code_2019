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
      opcode_long FOR TESTING RAISING cx_static_check,
      input_3099 FOR TESTING RAISING cx_static_check,
      output_4099 FOR TESTING RAISING cx_static_check,
      in_output_304099 FOR TESTING RAISING cx_static_check,
      write_position_0 FOR TESTING RAISING cx_static_check,
      parameter_mode_1002_43_4_33 FOR TESTING RAISING cx_static_check,
      opcode_01002 FOR TESTING RAISING cx_static_check,
      opcode_11199 FOR TESTING RAISING cx_static_check,
      opcode_999 FOR TESTING RAISING cx_static_check,
      opcode_4 FOR TESTING RAISING cx_static_check,
      instruction_1002 FOR TESTING RAISING cx_static_check,
      abc_immediate FOR TESTING RAISING cx_static_check,
      ac_immediate FOR TESTING RAISING cx_static_check,
      c_immediate FOR TESTING RAISING cx_static_check,
      offset_1002 FOR TESTING RAISING cx_static_check,
      negative_int FOR TESTING RAISING cx_static_check.
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

  METHOD write_position_0.
    intcode->load( |1,9,10,3,2,3,11,0,99,30,40,50| ).
    intcode->write( address = 0 value = 42 ).
    cl_abap_unit_assert=>assert_equals( msg = 'write pos 10' exp = 42 act = intcode->prog[ 1 ] ).
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

  METHOD input_3099.
    DATA str TYPE string.
    DATA input_double TYPE REF TO if_demo_input.
    input_double ?= cl_abap_testdouble=>create( 'if_demo_input' ).
    cl_abap_testdouble=>configure_call( input_double )->set_parameter(
        name          = |field|
        value         = |5| )->ignore_parameter( 'text' )->ignore_parameter( 'AS_CHECKBOX' ).
    input_double->request( CHANGING field = str ).
    intcode->demo_input = input_double.
    intcode->load( |3,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = '5 as input at address 0'
                                        exp = 5
                                        act = intcode->read( 0 ) ).
  ENDMETHOD.

  METHOD offset_1002.
    cl_abap_unit_assert=>assert_equals( msg = 'offset' exp = 4 act = intcode->get_instruction_length( 02 ) ).
  ENDMETHOD.

  METHOD output_4099.
    DATA output_double TYPE REF TO if_demo_output.
    output_double ?= cl_abap_testdouble=>create( 'if_demo_output' ).
    cl_abap_testdouble=>configure_call( output_double
      )->ignore_all_parameters( ).
    output_double->write( 4 ).
    intcode->demo_output = output_double.
    intcode->load( |4,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = '5 as input at address 0'
                                        exp = 4
                                        act = intcode->read( 0 ) ).
  ENDMETHOD.


  METHOD in_output_304099.
    DATA str TYPE string.
    DATA input_double TYPE REF TO if_demo_input.
    input_double ?= cl_abap_testdouble=>create( 'if_demo_input' ).
    cl_abap_testdouble=>configure_call( input_double )->set_parameter(
        name          = |field|
        value         = |5| )->ignore_parameter( 'text' )->ignore_parameter( 'AS_CHECKBOX' ).
    input_double->request( CHANGING field = str ).
    intcode->demo_input = input_double.

    DATA output_double TYPE REF TO if_demo_output.
    output_double ?= cl_abap_testdouble=>create( 'if_demo_output' ).
    cl_abap_testdouble=>configure_call( output_double
      )->ignore_all_parameters( ).

    intcode->load( |3,0,4,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = '5 as input at address 0'
                                        exp = 5
                                        act = intcode->read( 0 ) ).
  ENDMETHOD.

  METHOD abc_immediate.
    intcode->set_parameter( |11101| ).
    cl_abap_unit_assert=>assert_equals( msg = 'A = 1' exp = 1 act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'B = 1' exp = 1 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'C = 1' exp = 1 act = intcode->c ).
  ENDMETHOD.

  METHOD ac_immediate.
    intcode->set_parameter( |10101| ).
    cl_abap_unit_assert=>assert_equals( msg = 'A = 1' exp = 1 act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'B = 0' exp = 0 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'C = 1' exp = 1 act = intcode->c ).
  ENDMETHOD.

  METHOD c_immediate.
    intcode->set_parameter( |101| ).
    cl_abap_unit_assert=>assert_equals( msg = 'A = 0' exp = 0 act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'B = 0' exp = 0 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'C = 1' exp = 1 act = intcode->c ).
  ENDMETHOD.

  METHOD opcode_4.
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 4 = 4' exp = |4| act = intcode->set_parameter( |4| ) ).
  ENDMETHOD.

  METHOD opcode_01002.
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 1002 = 02' exp = |02| act = intcode->set_parameter( |01002| ) ).
  ENDMETHOD.

  METHOD opcode_11199.
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 11199 = 99' exp = |99| act = intcode->set_parameter( |11199| ) ).
  ENDMETHOD.

  METHOD opcode_999.
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 999 = 99' exp = |99| act = intcode->set_parameter( |999| ) ).
  ENDMETHOD.

  METHOD parameter_mode_1002_43_4_33.
    intcode->load( |1002,4,3,4,33| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = '33 * 3 = 99'
                                        exp = 99
                                        act = intcode->read( 4 ) ).
  ENDMETHOD.

  METHOD negative_int.
    intcode->load( |1101,100,-1,4,0| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = 'negative 100 - 11 = 99'
                                        exp = 99
                                        act = intcode->read( 4 ) ).
  ENDMETHOD.

  METHOD instruction_1002.
    intcode->set_parameter( |1002| ).
    cl_abap_unit_assert=>assert_initial( msg = 'instruction 1002 A initial' act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'instruction 1002 B = 1' exp = 1 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'instruction 1002 C = 0' exp = 0 act = intcode->c ).
  ENDMETHOD.

ENDCLASS.
