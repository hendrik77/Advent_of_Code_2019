*&---------------------------------------------------------------------*
*& Report zaoc_day3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaoc_day3.

START-OF-SELECTION.
  DATA(filename) = 'C:\Users\h.neumann\Devel\Advent of Code\2019\day3_input.txt'.
  DATA wires TYPE string_table.
  cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( filename )
                                                  filetype = 'ASC'
                                        CHANGING  data_tab = wires ).

  DATA(panel) = NEW zpanel( ).
  panel->load( wire = wires[ 1 ] color = 'R' ).
  panel->load( wire = wires[ 2 ] color = 'B' ).
  DATA(distance) = panel->find_closest_crossing( ).
  WRITE |Manhatten Distance to closest crossing: { distance }|.
