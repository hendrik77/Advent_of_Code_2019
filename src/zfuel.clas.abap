"! <p class="shorttext synchronized" lang="en">AoC Day 1</p>
CLASS zfuel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: module_fuel     TYPE i,
           module_fuel_tab TYPE STANDARD TABLE OF module_fuel.
    METHODS calc
      IMPORTING
        VALUE(mass) TYPE i
      RETURNING
        VALUE(fuel) TYPE i.
    METHODS calc_total_fuel
      IMPORTING
        modules           TYPE module_fuel_tab
      RETURNING
        VALUE(total_fuel) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zfuel IMPLEMENTATION.

  METHOD calc.
    DATA(x) = CONV i( floor( CONV float( mass / 3 ) ) ) - 2.
    fuel = COND #( WHEN x < 0 THEN 0 ELSE x + calc( x ) ).
  ENDMETHOD.

  METHOD calc_total_fuel.
    total_fuel = REDUCE #( INIT x = 0 FOR module IN modules
                           NEXT x = x + calc( module ) ).
  ENDMETHOD.

ENDCLASS.
