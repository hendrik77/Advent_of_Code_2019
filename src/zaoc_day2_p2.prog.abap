*&---------------------------------------------------------------------*
*& Report zaoc_day2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaoc_day2_p2.

START-OF-SELECTION.
  DATA(filename) = 'C:\Users\h.neumann\Devel\Advent of Code\2019\day2_input.txt'.
  DATA(programs) = VALUE string_table( ).
  cl_gui_frontend_services=>gui_upload( EXPORTING filename = CONV #( filename )
                                                  filetype = 'ASC'
                                        CHANGING  data_tab = programs ).

  DATA(intcode) = NEW zintcode( ).
  DATA(noun) = 0.
  DATA(verb) = 0.
  DO 100 TIMES.
    DO 100 TIMES.
      intcode->load( programs[ 1 ] ).
      intcode->write( address = 1 value = noun ).
      intcode->write( address = 2 value = verb ).
      intcode->run( ).
      IF intcode->read( 0 ) = 19690720.
        EXIT.
      ENDIF.
      verb = verb + 1.
    ENDDO.
    IF intcode->read( 0 ) = 19690720.
      EXIT.
    ENDIF.
    CLEAR verb.
    noun = noun + 1.
  ENDDO.
  cl_demo_output=>display( |output: { 100 * noun + verb }| ).
