*&---------------------------------------------------------------------*
*& Report zaoc_day1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaoc_day1.

START-OF-SELECTION.
  DATA(modules) = VALUE string_table( ).
  DATA(filename) = 'C:\Users\h.neumann\Devel\Advent of Code\2019\day1_input.txt'.
  DATA(programs) = VALUE string_table( ).
  cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( filename )
                                                  filetype = 'ASC'
                                        CHANGING  data_tab = modules ).


  cl_demo_output=>display( |Total fuel: { NEW zfuel( )->calc_total_fuel(
    VALUE #( FOR module IN modules ( CONV #( module ) ) ) )  }| ).
