*"* use this source file for your ABAP unit test classes
CLASS ltcl_day1 DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    TYPES: module_fuel type i,
           module_fuel_tab TYPE STANDARD TABLE OF module_fuel.
    DATA:
          fup TYPE REF TO zfuel.
    METHODS:
      setup,
      mass_of_12 FOR TESTING RAISING cx_static_check,
      fuel_for_mass_14 FOR TESTING RAISING cx_static_check,
      fuel_for_mass_1969 FOR TESTING RAISING cx_static_check,
      fuel_for_2_modules FOR TESTING RAISING cx_static_check,
      fuel_for_mass_2 FOR TESTING RAISING cx_static_check,
      fuel_for_mass_100756 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_day1 IMPLEMENTATION.

  METHOD setup.
    fup = NEW #(  ).
  ENDMETHOD.

  METHOD mass_of_12.
    cl_abap_unit_assert=>assert_equals( msg = 'mass 12 -> 2' exp = 2 act = fup->calc( 12 ) ).
  ENDMETHOD.

  METHOD fuel_for_mass_14.
    cl_abap_unit_assert=>assert_equals( msg = 'mass 14 -> 2' exp = 2 act = fup->calc( 14 ) ).
  ENDMETHOD.

  METHOD fuel_for_mass_1969.
    cl_abap_unit_assert=>assert_equals( msg = 'mass 1969 -> 966' exp = 966 act = fup->calc( 1969 ) ).
  ENDMETHOD.

  METHOD fuel_for_mass_100756.
    cl_abap_unit_assert=>assert_equals( msg = 'mass 100756 -> 966' exp = 50346 act = fup->calc( 100756 ) ).
  ENDMETHOD.

  METHOD fuel_for_2_modules.
    data modules type module_fuel_tab.
    modules = VALUE #( ( 12 ) ( 14 ) ).
    cl_abap_unit_assert=>assert_equals( msg = '12, 14 -> 4' exp = 4 act = fup->calc_total_fuel( modules ) ).
  endmethod.

  METHOD fuel_for_mass_2.
    cl_abap_unit_assert=>assert_equals( msg = '2 -> 0' exp = 0 act = fup->calc( 2 ) ).
  ENDMETHOD.


ENDCLASS.
