*&---------------------------------------------------------------------*
*& Report zaoc_day2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaoc_day2.

START-OF-SELECTION.
  DATA(filename) = 'C:\Users\h.neumann\Devel\Advent of Code\2019\day2_input.txt'.
  DATA(programs) = VALUE string_table( ).
  cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( filename )
                                                  filetype = 'ASC'
                                        CHANGING  data_tab = programs ).

  DATA(intcode) = NEW zintcode( ).
  intcode->load( programs[ 1 ] ).
  intcode->write( address = 1 value = 12 ).
  intcode->write( address = 2 value = 2 ).
  intcode->run( ).

  cl_demo_output=>display( intcode->read( 0 ) ).
