*"* use this source file for your ABAP unit test classes
CLASS ltcl_pw DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: pw TYPE REF TO zpassword.
    METHODS:
      has_double_111111 FOR TESTING RAISING cx_static_check,
      has_double_223450 FOR TESTING RAISING cx_static_check,
      has_no_double_123789 FOR TESTING RAISING cx_static_check,
      has_only_increasing_123456 FOR TESTING RAISING cx_static_check,
      has_only_increasing_122446 FOR TESTING RAISING cx_static_check,
      has_not_only_increasing_152446 FOR TESTING RAISING cx_static_check,
      count_pw_2 FOR TESTING RAISING cx_static_check,
      count_adv_day4 FOR TESTING RAISING cx_static_check,
      count_pw_3 FOR TESTING RAISING cx_static_check,
      no_larger_group_123444 FOR TESTING RAISING cx_static_check,
      setup.
ENDCLASS.


CLASS ltcl_pw IMPLEMENTATION.

  METHOD has_double_111111.
    cl_abap_unit_assert=>assert_true( msg = 'double in 111111' act = pw->check_double( '111111' ) ).
  ENDMETHOD.

  METHOD has_double_223450.
    cl_abap_unit_assert=>assert_true( msg = 'double in 223450' act = pw->check_double( '223450' ) ).
  ENDMETHOD.

  METHOD has_no_double_123789.
    cl_abap_unit_assert=>assert_false( msg = 'no double in 123789' act = pw->check_double( '123789' ) ).
  ENDMETHOD.

  METHOD has_only_increasing_123456.
    cl_abap_unit_assert=>assert_true( msg = 'only increasing' act = pw->check_increasing( '123456' ) ).
  ENDMETHOD.

  METHOD has_only_increasing_122446.
    cl_abap_unit_assert=>assert_true( msg = 'only increasing' act = pw->check_increasing( '122446' ) ).
  ENDMETHOD.

  METHOD has_not_only_increasing_152446.
    cl_abap_unit_assert=>assert_false( msg = 'not only increasing' act = pw->check_increasing( '152446' ) ).
  ENDMETHOD.

  METHOD count_pw_2.
    cl_abap_unit_assert=>assert_equals( msg = 'count no pw in 111111 to 111112'
                                        exp = 2
                                        act = pw->count_valid( start = 111111
                                                               end   = 111112 ) ).
  ENDMETHOD.

  METHOD count_pw_3.
    cl_abap_unit_assert=>assert_equals( msg = 'count no pw in 111111 to 111112'
                                        exp = 3
                                        act = pw->count_valid( start = 123450
                                                               end   = 123480 ) ).
  ENDMETHOD.

  METHOD no_larger_group_123444.
    cl_abap_unit_assert=>assert_false( msg = 'no double - 444' act = pw->check_increasing( '123444' ) ).
  ENDMETHOD.

  METHOD count_adv_day4.
    cl_abap_unit_assert=>assert_equals( msg = 'count no pw in 137683 to 596253'
                                        exp = 1864 "Riddle solution :)
                                        act = pw->count_valid( start = 137683
                                                               end   = 596253 ) ).
  ENDMETHOD.

  METHOD setup.
    pw = NEW zpassword( ).
  ENDMETHOD.

ENDCLASS.
