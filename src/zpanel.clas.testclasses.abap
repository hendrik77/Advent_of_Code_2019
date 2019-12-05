*"* use this source file for your ABAP unit test classes
CLASS ltcl_board DEFINITION DEFERRED.
CLASS zpanel DEFINITION LOCAL FRIENDS ltcl_board.
CLASS ltcl_board DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: panel TYPE REF TO zpanel.
    METHODS:
      md_for_22x555 FOR TESTING RAISING cx_static_check,
      fill_board FOR TESTING RAISING cx_static_check,
      fill_board_u5 FOR TESTING RAISING cx_static_check,
      fill_board_u5r2 FOR TESTING RAISING cx_static_check,
      two_wires FOR TESTING RAISING cx_static_check,
      find_closest_crossing_6 FOR TESTING RAISING cx_static_check,
      find_closest_crossing_159 FOR TESTING RAISING cx_static_check,
      wire_right_down FOR TESTING RAISING cx_static_check,
      wire_r4 FOR TESTING RAISING cx_static_check,
      wire_l2 FOR TESTING RAISING cx_static_check,
      wire_l10 FOR TESTING RAISING cx_static_check,
      find_closest_crossing_135 FOR TESTING RAISING cx_static_check,
      find_min_delay_30 FOR TESTING RAISING cx_static_check,
      delay_9 FOR TESTING RAISING cx_static_check,
      delay_at_crossing_40 FOR TESTING RAISING cx_static_check,
      delay_13 FOR TESTING RAISING cx_static_check,
      find_min_delay_610 FOR TESTING RAISING cx_static_check,
      find_min_delay_410 FOR TESTING RAISING cx_static_check,
      setup.
ENDCLASS.


CLASS ltcl_board IMPLEMENTATION.

  METHOD md_for_22x555.
    cl_abap_unit_assert=>assert_equals( msg = '(2,2)(5,5) => 6'
                                        exp = 6
                                        act = panel->calc_manhatten_distance(
                                                central_port = VALUE #( x = 2 y = 2 )
                                                crossing = VALUE #( x = 5 y = 5 ) ) ).
  ENDMETHOD.

  METHOD fill_board.
    panel->load( wire = |R8,U5,L5,D3| color = 'R' ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'grid has a wire' act = panel->get_grid( ) ).
  ENDMETHOD.
  METHOD fill_board_u5.
    panel->load( wire = |U5| color = 'R' ).
    DATA(z) = panel->get_point(
      x = 0
      y = 5 ).
    cl_abap_unit_assert=>assert_equals( msg = 'U5' exp = 'R' act = z ).
    cl_abap_unit_assert=>assert_equals( msg = 'pointer y' exp = 5 act = panel->pointer-y ).
    cl_abap_unit_assert=>assert_equals( msg = 'pointer x' exp = 0 act = panel->pointer-x ).

  ENDMETHOD.
  METHOD fill_board_u5r2.
    panel->load( wire = |U5,R2| color = 'R' ).
    DATA(z) = panel->get_point(
      x = 2
      y = 5 ).
    cl_abap_unit_assert=>assert_equals( msg = 'U5,R2' exp = 'R' act = z ).
    cl_abap_unit_assert=>assert_equals( msg = 'pointer y' exp = 5 act = panel->pointer-y ).
    cl_abap_unit_assert=>assert_equals( msg = 'pointer x' exp = 2 act = panel->pointer-x ).

  ENDMETHOD.

  METHOD two_wires.
    panel->load( wire = |R8,U5,L5,D3| color = 'R' ).
    panel->load( wire = |U7,R6,D4,L4| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'Blue wire (0,5)' exp = 'B' act = panel->get_point( x = 0 y = 5 ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'Red wire (7,0)'  exp = 'R' act = panel->get_point( x = 7 y = 0 ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'two crossings' exp = 2 act = lines( panel->crossings ) ).
  ENDMETHOD.

  METHOD setup.
    panel = NEW zpanel( ).
  ENDMETHOD.

  METHOD find_closest_crossing_6.
    panel->load( wire = |R8,U5,L5,D3| color = 'R' ).
    panel->load( wire = |U7,R6,D4,L4| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'distance = 6' exp = 6 act = panel->find_closest_crossing( ) ).
  ENDMETHOD.
  METHOD wire_right_down.
    panel->load( wire = |R5,D5,R1,U10| color = 'R' ).
*    DATA(pointer) = panel->pointer.
    cl_abap_unit_assert=>assert_equals( msg = '5,-5' exp = 'R' act = panel->get_point( x = 5 y = -5 ) ).
    cl_abap_unit_assert=>assert_equals( msg = '5,-6' exp = '.' act = panel->get_point( x = 5 y = -6 ) ).
    cl_abap_unit_assert=>assert_equals( msg = '6,-5' exp = 'R' act = panel->get_point( x = 6 y = -5 ) ).
    cl_abap_unit_assert=>assert_equals( msg = '6,4' exp = 'R' act = panel->get_point( x = 6 y = 5 ) ).
  ENDMETHOD.
  METHOD wire_l2.
    panel->load( wire = |L9| color = 'R' ).
    cl_abap_unit_assert=>assert_equals( msg = '-9,0' exp = 'R' act = panel->get_point( x = -9 y = 0 ) ).
    cl_abap_unit_assert=>assert_equals( msg = '-10,0' exp = '.' act = panel->get_point( x = -10 y = 0 ) ).
  ENDMETHOD.
  METHOD delay_9.
    panel->load( wire = |L9| color = 'R' ).
    cl_abap_unit_assert=>assert_equals( msg = 'delay 9' exp = 9 act = panel->get_delay( x = -9 y = 0 ) ).
  ENDMETHOD.
  METHOD delay_13.
    panel->load( wire = |L9,U4| color = 'R' ).
    cl_abap_unit_assert=>assert_equals( msg = 'delay 9+4 = 13' exp = 13 act = panel->get_delay( x = -9 y = 4 ) ).
  ENDMETHOD.
  METHOD wire_l10.
    panel->load( wire = |L10| color = 'R' ).
    cl_abap_unit_assert=>assert_equals( msg = '-10,0' exp = 'R' act = panel->get_point( x = -10 y = 0 ) ).
  ENDMETHOD.
  METHOD wire_r4.
    panel->load( wire = |R1,R1,R1,R1,L1| color = 'R' ).
    cl_abap_unit_assert=>assert_equals( msg = '4,0' exp = 'R' act = panel->get_point( x = 4 y = 0 ) ).
  ENDMETHOD.
  METHOD find_closest_crossing_159.
    panel->load( wire = |R75,D30,R83,U83,L12,D49,R71,U7,L72| color = 'R' ).
    panel->load( wire = |U62,R66,U55,R34,D71,R55,D58,R83| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'distance = 159' exp = 159 act = panel->find_closest_crossing( ) ).
  ENDMETHOD.
  METHOD find_closest_crossing_135.
    panel->load( wire = |R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51| color = 'R' ).
    panel->load( wire = |U98,R91,D20,R16,D67,R40,U7,R15,U6,R7| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'distance = 159' exp = 135 act = panel->find_closest_crossing( ) ).
  ENDMETHOD.
  METHOD delay_at_crossing_40.
    panel->load( wire = |R8,U5,L5,D3| color = 'R' ).
    panel->load( wire = |U7,R6,D4,L4| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'delay(3,3)' exp = 40 act = panel->get_delay( x = 3 y = 3 ) ).
  ENDMETHOD.
  METHOD find_min_delay_30.
    panel->load( wire = |R8,U5,L5,D3| color = 'R' ).
    panel->load( wire = |U7,R6,D4,L4| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'min delay = 30' exp = 30 act = panel->find_min_delay_X( ) ).
  ENDMETHOD.
    METHOD find_min_delay_610.
    panel->load( wire = |R75,D30,R83,U83,L12,D49,R71,U7,L72| color = 'R' ).
    panel->load( wire = |U62,R66,U55,R34,D71,R55,D58,R83| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'min delay = 30' exp = 610 act = panel->find_min_delay_X( ) ).
  ENDMETHOD.
    METHOD find_min_delay_410.
    panel->load( wire = |R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51| color = 'R' ).
    panel->load( wire = |U98,R91,D20,R16,D67,R40,U7,R15,U6,R7| color = 'B' ).
    cl_abap_unit_assert=>assert_equals( msg = 'min delay = 30' exp = 410 act = panel->find_min_delay_X( ) ).
  ENDMETHOD.
ENDCLASS.
