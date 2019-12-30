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
      negative_int FOR TESTING RAISING cx_static_check,
      jump_if_true FOR TESTING RAISING cx_static_check,
      no_jump_if_false FOR TESTING RAISING cx_static_check,
      no_jump_if_true FOR TESTING RAISING cx_static_check,
      jump_if_false FOR TESTING RAISING cx_static_check,
      halt_jump_if_false FOR TESTING RAISING cx_static_check,
      add_jump_if_false FOR TESTING RAISING cx_static_check,
      less_than_true FOR TESTING RAISING cx_static_check,
      equals_true FOR TESTING RAISING cx_static_check,
      equals_false FOR TESTING RAISING cx_static_check,
      day5_test1 FOR TESTING RAISING cx_static_check,
      output_404499 FOR TESTING RAISING cx_static_check,
      output_404099 FOR TESTING RAISING cx_static_check,
      day5_test2 FOR TESTING RAISING cx_static_check,
      equals_true_2 FOR TESTING RAISING cx_static_check,
      day5_test3 FOR TESTING RAISING cx_static_check,
      day5_test3_no2 FOR TESTING RAISING cx_static_check,
      day5_test2_no2 FOR TESTING RAISING cx_static_check,
      day5_test4 FOR TESTING RAISING cx_static_check,
      day5_test5 FOR TESTING RAISING cx_static_check,
      day5_test1_no2 FOR TESTING RAISING cx_static_check,
      day5_test5_no2 FOR TESTING RAISING cx_static_check,
      day5_test6_no2 FOR TESTING RAISING cx_static_check,
      day5_test6 FOR TESTING RAISING cx_static_check,
      day5_test7_input7 FOR TESTING RAISING cx_static_check,
      day5_test7_input8 FOR TESTING RAISING cx_static_check,
      day5_test7_input9 FOR TESTING RAISING cx_static_check,
      unkown_opcode FOR TESTING RAISING cx_static_check.
    METHODS setup.
    METHODS create_input_double
      IMPORTING
        input TYPE string.
    METHODS create_output_double
      RETURNING
        VALUE(output_double) TYPE REF TO if_demo_output.
    "! Test if for a program delivers for an input a specific output
    "! @parameter input | input value
    "! @parameter program | intcode program
    "! @parameter output | expected output
    "! @parameter msg | describes the test
    METHODS test_input_output
      IMPORTING
        input   TYPE string
        program TYPE string
        output  TYPE string
        msg     TYPE string.
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
    create_input_double( |5| ).
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
    DATA(output_double) = create_output_double( ).
    intcode->load( |4,0,99| ).
    intcode->run( ).
    DATA(get) = intcode->demo_output->get( ).
    cl_abap_unit_assert=>assert_equals( msg = 'outupt_text = 4'
                                        exp = 4
                                        act = intcode->output_text ).
    cl_abap_testdouble=>verify_expectations( output_double ).
  ENDMETHOD.

  METHOD output_404499.
    DATA(output_double) = create_output_double( ).
    intcode->load( |4,0,4,4,99| ).
    intcode->run( ).
    DATA(get) = intcode->demo_output->get( ).
    cl_abap_unit_assert=>assert_equals( msg = 'output 4 newline 99'
                                        exp = |4\n99|
                                        act = intcode->output_text ).
    cl_abap_testdouble=>verify_expectations( output_double ).
  ENDMETHOD.

  METHOD output_404099.
    DATA(output_double) = create_output_double( ).
    intcode->load( |4,0,4,0,99| ).
    intcode->run( ).
    DATA(get) = intcode->demo_output->get( ).
    cl_abap_unit_assert=>assert_equals( msg = 'output 4 newline 4'
                                        exp = |4\n4|
                                        act = intcode->output_text ).
    cl_abap_testdouble=>verify_expectations( output_double ).
  ENDMETHOD.

  METHOD in_output_304099.

    create_input_double( |5| ).
    DATA(output_double) = create_output_double( ).

    intcode->load( |3,0,4,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = '5 as input at address 0'
                                        exp = 5
                                        act = intcode->read( 0 ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'output = 5'
                                        exp = |5|
                                        act = intcode->output_text ).
    cl_abap_testdouble=>verify_expectations( output_double ).
  ENDMETHOD.

  METHOD abc_immediate.
    intcode->load( |11101| ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'A = 1' exp = 1 act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'B = 1' exp = 1 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'C = 1' exp = 1 act = intcode->c ).
  ENDMETHOD.

  METHOD ac_immediate.
    intcode->load( |10101| ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'A = 1' exp = 1 act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'B = 0' exp = 0 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'C = 1' exp = 1 act = intcode->c ).
  ENDMETHOD.

  METHOD c_immediate.
    intcode->load( |101| ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'A = 0' exp = 0 act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'B = 0' exp = 0 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'C = 1' exp = 1 act = intcode->c ).
  ENDMETHOD.

  METHOD opcode_4.
    intcode->load( |4| ).
    intcode->set_parameter( 0 ).
    intcode->set_opcode( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 4 = 4' exp = |4| act = intcode->opcode ).
  ENDMETHOD.

  METHOD opcode_01002.
    intcode->load( |01002| ).
    intcode->set_opcode( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 1002 = 02' exp = |02| act = intcode->opcode ).
  ENDMETHOD.

  METHOD opcode_11199.
    intcode->load( |11199| ).
    intcode->set_opcode( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 11199 = 99' exp = |99| act = intcode->opcode ).
  ENDMETHOD.

  METHOD opcode_999.
    intcode->load( |999| ).
    intcode->set_opcode( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'opcode 999 = 99' exp = |99| act = intcode->opcode ).
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
    intcode->load( |1002| ).
    intcode->set_opcode( 0 ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_initial( msg = 'instruction 1002 A initial' act = intcode->a ).
    cl_abap_unit_assert=>assert_equals( msg = 'instruction 1002 B = 1' exp = 1 act = intcode->b ).
    cl_abap_unit_assert=>assert_equals( msg = 'instruction 1002 C = 0' exp = 0 act = intcode->c ).
  ENDMETHOD.

  METHOD jump_if_true.
    intcode->load( |1105,1,8| ).
    intcode->set_opcode( 0 ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'true -> 8' exp = 8 act = intcode->log_exp( 0 ) ).
  ENDMETHOD.

  METHOD no_jump_if_true.
    intcode->load( |1105,0,8,1,0,0,2,99| ).
    intcode->set_opcode( 0 ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'false, new address' exp = 3 act = intcode->log_exp( 0 ) ).
  ENDMETHOD.

  METHOD jump_if_false.
    intcode->load( |1106,0,8,1,0,0,2,99| ).
    intcode->set_opcode( 0 ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'false -> 8' exp = 8 act = intcode->log_exp( 0 ) ).
  ENDMETHOD.

  METHOD unkown_opcode.
    intcode->load( |67,1101,1,1,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = 'unkown statement: halt, no add' exp = 67 act = intcode->read( 0 )  ).
  ENDMETHOD.

  METHOD no_jump_if_false.
    intcode->load( |1106,1,8,1,0,0,2,99| ).
    intcode->set_opcode( 0 ).
    intcode->set_parameter( 0 ).
    cl_abap_unit_assert=>assert_equals( msg = 'false, new address = 3' exp = 3 act = intcode->log_exp( 0 ) ).
  ENDMETHOD.

  METHOD halt_jump_if_false.
    intcode->load( |1106,0,7,1,0,0,1,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = 'jump to 99 - no add to 1' exp = 0 act = intcode->read( 1 ) ).
  ENDMETHOD.

  METHOD add_jump_if_false.
    intcode->load( |1106,1,7,1,1,1,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = 'add num 1 + 1 -> store at 0 ' exp = 2 act = intcode->read( 0 ) ).
  ENDMETHOD.

  METHOD less_than_true.
    intcode->load( |7,1,2,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = 'less than true -> [0]=1' exp = 1 act = intcode->read( 0 ) ).
  ENDMETHOD.

  METHOD equals_true.
    intcode->load( |8,2,2,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = 'par1 = par2 -> [0]=1' exp = 1 act = intcode->read( 0 ) ).
  ENDMETHOD.

  METHOD equals_true_2.
    intcode->load( |8,5,6,0,99,6,6| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = '6,6-> [0]=1' exp = 1 act = intcode->read( 0 ) ).
  ENDMETHOD.

  METHOD equals_false.
    intcode->load( |8,1,2,0,99| ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = 'par1 <> par2 -> [0]=0' exp = 0 act = intcode->read( 0 ) ).
  ENDMETHOD.

  METHOD day5_test1.
    test_input_output( msg     = |3,9,8,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is equal to 8, output 1|
                       input   = |8|
                       program = |3,9,8,9,10,9,4,9,99,-1,8|
                       output  = |1| ).
  ENDMETHOD.

  METHOD day5_test1_no2.
    test_input_output( msg     = |3,9,8,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is equal to 8, output 1|
                       input   = |2|
                       program = |3,9,8,9,10,9,4,9,99,-1,8|
                       output  = |0| ).
  ENDMETHOD.

  METHOD day5_test2.
    test_input_output( msg     = |3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is  less than 8|
                       input   = |6|
                       program = |3,9,7,9,10,9,4,9,99,-1,8|
                       output  = |1| ).
  ENDMETHOD.

  METHOD day5_test2_no2.
    test_input_output( msg     = |3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is NOT less than 8|
                       input   = |8|
                       program = |3,9,7,9,10,9,4,9,99,-1,8|
                       output  = |0| ).
  ENDMETHOD.

  METHOD day5_test3.
    test_input_output( msg     = |Using immediate mode, consider whether the input is equal to 8; output 1|
                       input   = |8|
                       program = |3,3,1108,-1,8,3,4,3,99|
                       output  = |1| ).
  ENDMETHOD.

  METHOD day5_test3_no2.
    test_input_output( msg      = |Using immediate mode, consider whether the input is not equal to 8; output 0|
                       input    = |3|
                       program  = |3,3,1108,-1,8,3,4,3,99|
                       output   = |0| ).
  ENDMETHOD.

  METHOD day5_test4.
    test_input_output( msg      = |Using immediate mode, consider whether the input is less than 8; output 1|
                       input    = |6|
                       program  = |3,3,1107,-1,8,3,4,3,99|
                       output   = |1| ).
  ENDMETHOD.

  METHOD day5_test5.
    test_input_output( msg = |jump test: output = 0 for input 0 - using position mode|
                       input = |0|
                       output = |0|
                       program = |3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9| ).
  ENDMETHOD.

  METHOD day5_test5_no2.
    test_input_output( msg = |jump test: output = 1 for input NOT 0 - using position mode|
                       input = |3|
                       output = |1|
                       program = |3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9| ).
  ENDMETHOD.

  METHOD day5_test6.
    test_input_output( msg = |jump test: output = 0 for input  0 - using immediate mode|
                       input = |0|
                       output = |0|
                       program = |3,3,1105,-1,9,1101,0,0,12,4,12,99,1| ).
  ENDMETHOD.

  METHOD day5_test6_no2.
    test_input_output( msg = |jump test: output = 1 for input NOT 0 - using immediate mode|
                       input = |3|
                       output = |1|
                       program = |3,3,1105,-1,9,1101,0,0,12,4,12,99,1| ).
  ENDMETHOD.

  METHOD day5_test7_input7.
    test_input_output( msg = |large example: if below 8 -> 999|
                       input = |7|
                       output = |999|
                       program = |3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99| ).
  ENDMETHOD.

  METHOD day5_test7_input8.
    test_input_output( msg = |large example: if below 8 -> 999|
                       input = |8|
                       output = |1000|
                       program = |3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99| ).
  ENDMETHOD.

  METHOD day5_test7_input9.
    test_input_output( msg = |large example: if below 8 -> 999|
                       input = |9|
                       output = |1001|
                       program = |3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99| ).
  ENDMETHOD.

  METHOD create_input_double.
    DATA str TYPE string.
    DATA input_double TYPE REF TO if_demo_input.
    input_double ?= cl_abap_testdouble=>create( 'if_demo_input' ).
    cl_abap_testdouble=>configure_call( input_double )->set_parameter(
        name  = |field|
        value = input )->ignore_parameter( 'text' )->ignore_parameter( 'AS_CHECKBOX' ).
    input_double->request( CHANGING field = str ).
    intcode->demo_input = input_double.

  ENDMETHOD.


  METHOD create_output_double.
    output_double ?= cl_abap_testdouble=>create( 'if_demo_output' ).
    cl_abap_testdouble=>configure_call( output_double )->ignore_all_parameters(
      )->and_expect(  )->is_called_once( ).
    output_double->display(  ).
    intcode->demo_output = output_double.
  ENDMETHOD.


  METHOD test_input_output.
    create_input_double( input ).
    DATA(output_double) = create_output_double( ).


    intcode->load( program ).
    intcode->run( ).
    cl_abap_unit_assert=>assert_equals( msg = msg
                                        exp = output
                                        act = intcode->output_text ).
    cl_abap_testdouble=>verify_expectations( output_double ).

  ENDMETHOD.

ENDCLASS.
