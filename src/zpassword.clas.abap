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
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpassword IMPLEMENTATION.


  METHOD check_double.
    FIND REGEX '([0-9])\1' IN password.
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
                      NEXT c = c + COND #( WHEN check_double( CONV #( i ) ) AND check_increasing( CONV #( i ) ) THEN 1
                                           ELSE 0 ) ).
  ENDMETHOD.

ENDCLASS.
