*&---------------------------------------------------------------------*
*& Report zaoc_day5
*&---------------------------------------------------------------------*
*& https://adventofcode.com/2019/day/5
*&---------------------------------------------------------------------*
REPORT zaoc_day5.

START-OF-SELECTION.

  DATA(intcode) = NEW zintcode( ).
  intcode->load( |3,0,4,0,99| ).
  intcode->run( ).
