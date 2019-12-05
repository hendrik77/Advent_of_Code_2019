*&---------------------------------------------------------------------*
*& Report zaoc_day3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaoc_day3_p2.

START-OF-SELECTION.
  DATA(filename) = 'C:\Users\h.neumann\Devel\Advent of Code\2019\day3_input_part2.txt'.
  DATA wires TYPE string_table.
  cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( filename )
                                                  filetype = 'ASC'
                                        CHANGING  data_tab = wires ).

  DATA(panel) = NEW zpanel( ).
  panel->load( wire = wires[ 1 ] color = 'R' ).
  panel->load( wire = wires[ 2 ] color = 'B' ).
  DATA(delay) = panel->find_min_delay_x( ).
  WRITE |Crossing with minimal delay: { delay }|.
