*"* use this source file for your ABAP unit test classes
class test_orbit definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      bbb_orbits_aaa for testing raising cx_static_check.
endclass.


class test_orbit implementation.

  method bbb_orbits_aaa.

  endmethod.

endclass.
