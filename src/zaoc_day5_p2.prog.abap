*&---------------------------------------------------------------------*
*& Report zaoc_day5
*&---------------------------------------------------------------------*
*& https://adventofcode.com/2019/day/5
*&---------------------------------------------------------------------*
REPORT zaoc_day5_p2.

START-OF-SELECTION.
  DATA(filename) = 'C:\Users\h.neumann\Devel\Advent of Code\2019\day5_input_p2.txt'.
  DATA(programs) = VALUE string_table( ).
  cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( filename )
                                                  filetype = 'ASC'
                                        CHANGING  data_tab = programs ).

  DATA(intcode) = NEW zintcode( ).
  intcode->load( programs[ 1 ] ).
  intcode->run( ).
