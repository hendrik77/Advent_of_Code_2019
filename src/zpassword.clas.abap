"! <p class="shorttext synchronized" lang="en">AoC Day 4</p>
CLASS zpassword DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS check_double
      IMPORTING
        VALUE(password)   TYPE char6
      RETURNING
        VALUE(has_double) TYPE boolean.
    METHODS check_increasing
      IMPORTING
        VALUE(password)        TYPE char6
      RETURNING
        VALUE(only_increasing) TYPE abap_bool.
    METHODS count_valid
      IMPORTING
        VALUE(start) TYPE i
        VALUE(end)   TYPE i
      RETURNING
        VALUE(count) TYPE i.
    METHODS check_double2
      IMPORTING
        password          TYPE char6
      RETURNING
        VALUE(has_double) TYPE abap_bool.
    METHODS count_valid2
      IMPORTING
        VALUE(start) TYPE i
        VALUE(end)   TYPE i
      RETURNING
        VALUE(count) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpassword IMPLEMENTATION.


  METHOD check_double.
    FIND REGEX '([0-9])\1' IN password. "two digits
    IF sy-subrc = 0.
      has_double = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD check_increasing.
    FIND REGEX '^(?=\d{6}$)1*2*3*4*5*6*7*8*9*$' IN password.
    IF sy-subrc = 0.
      only_increasing = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD count_valid.

    count = REDUCE #( INIT c = 0
                      FOR i = start UNTIL i > end
                      NEXT c = c + COND #( WHEN check_increasing( CONV #( i ) ) AND check_double( CONV #( i ) ) THEN 1
                                           ELSE 0 ) ).
  ENDMETHOD.


  METHOD check_double2.
    FIND ALL OCCURRENCES OF REGEX '([0-9])\1' IN password RESULTS DATA(double_digit_tab)  . "must contain two equal digits
    LOOP AT double_digit_tab ASSIGNING FIELD-SYMBOL(<line>).
      DATA(double_digit) = substring( val = password off = <line>-offset ).
      DATA checked TYPE i.
      IF checked = double_digit(1).
        CONTINUE. "digit already checked - more than 2
      ELSE.
        FIND REGEX '^([0-9])\1\1' IN double_digit.
        IF sy-subrc <> 0.
          has_double = abap_true.
          RETURN. "only 2 digits - test for 3 false
        ELSE.
          checked = double_digit(1).
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD count_valid2.

    count = REDUCE #( INIT c = 0
                      FOR i = start UNTIL i > end
                      NEXT c = c + COND #( WHEN check_increasing( CONV #( i ) ) AND check_double2( CONV #( i ) ) THEN 1
                                           ELSE 0 ) ).
  ENDMETHOD.

ENDCLASS.
