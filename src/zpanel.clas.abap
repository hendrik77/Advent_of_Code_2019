"! <p class="shorttext synchronized" lang="en">AoC Day 3</p>
CLASS zpanel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF point_type,
             x TYPE i,
             y TYPE i,
           END OF point_type,
           BEGIN OF crossing_type,
             x        TYPE i,
             y        TYPE i,
             distance TYPE i,
             delay    TYPE i,
           END OF crossing_type,
           BEGIN OF grid_line,
             x     TYPE i,
             y     TYPE i,
             z     TYPE char1,
             delay TYPE i,
           END OF grid_line,
           grid_type TYPE HASHED TABLE OF grid_line WITH UNIQUE KEY x y.
    METHODS load
      IMPORTING
        VALUE(color) TYPE char1
        wire         TYPE string.
    METHODS calc_manhatten_distance
      IMPORTING VALUE(central_port) TYPE point_type
                VALUE(crossing)     TYPE point_type
      RETURNING VALUE(distance)     TYPE i.
    METHODS: get_grid RETURNING VALUE(r_result) TYPE grid_type,
      get_point
        IMPORTING
          VALUE(x) TYPE i
          VALUE(y) TYPE i
        RETURNING
          VALUE(z) TYPE char1,
      constructor,
      find_closest_crossing
        RETURNING
          VALUE(manhatten_distance) TYPE i,
      get_delay
        IMPORTING
          VALUE(x)     TYPE i
          VALUE(y)     TYPE i
        RETURNING
          VALUE(delay) TYPE i,
      find_min_delay_x
        RETURNING
          VALUE(min_delay) TYPE i.
    DATA crossings TYPE STANDARD TABLE OF crossing_type WITH DEFAULT KEY READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA grid TYPE grid_type.
    DATA pointer TYPE point_type.
ENDCLASS.



CLASS zpanel IMPLEMENTATION.

  METHOD calc_manhatten_distance.
    distance = abs( central_port-x - crossing-x ) + abs( central_port-y - crossing-y ).
  ENDMETHOD.


  METHOD get_grid.
    r_result = me->grid.
  ENDMETHOD.


  METHOD get_point.
    z = VALUE #( grid[ x = x y = y ]-z DEFAULT '.' ).
  ENDMETHOD.

  METHOD constructor.
    grid = VALUE #( (  x = 0  y = 0  z = 'o' delay = 0 ) ).
  ENDMETHOD.

  METHOD load.
    SPLIT wire AT ',' INTO TABLE DATA(wire_table).
    pointer = VALUE #( x = 0 y = 0 ).
    DATA(delay) = 0.
    LOOP AT wire_table INTO DATA(path).
      DATA(direction) = path(1).
      DATA(steps) = CONV i( shift_left( val = path places = 1 ) ).
      DATA: new            TYPE i, crossing_delay TYPE i.
      CASE direction.
        WHEN 'R'.
          DO steps TIMES.
            delay = delay + 1.
            new = pointer-x + sy-index.
            IF line_exists( grid[ x = new y = pointer-y ] ).
              IF grid[ x = new y = pointer-y ]-z <> color.
                crossing_delay = grid[ x = new y = pointer-y ]-delay + delay.
                INSERT VALUE #( x = new y = pointer-y delay = crossing_delay ) INTO TABLE crossings.
                grid[ x = new y = pointer-y ]-z = 'X'.
                grid[ x = new y = pointer-y ]-delay = crossing_delay.
              ENDIF.
            ELSE.
              INSERT VALUE #( x = new y = pointer-y z = color delay = delay ) INTO TABLE grid.
            ENDIF.
          ENDDO.
          pointer-x = pointer-x + steps.
        WHEN 'L'.
          DO steps TIMES.
            delay = delay + 1.
            new = pointer-x - sy-index.
            IF line_exists( grid[ x = new y = pointer-y ] ).
              IF grid[ x = new y = pointer-y ]-z <> color.
                crossing_delay = grid[ x = new y = pointer-y ]-delay + delay.
                INSERT VALUE #( x = new y = pointer-y delay = crossing_delay ) INTO TABLE crossings.
                grid[ x = new y = pointer-y ]-z = 'X'.
                grid[ x = new y = pointer-y ]-delay = crossing_delay.
              ENDIF.
            ELSE.
              INSERT VALUE #( x = new y = pointer-y z = color delay = delay ) INTO TABLE grid.
            ENDIF.
          ENDDO.
          pointer-x = pointer-x - steps.
        WHEN 'U'.
          DO steps TIMES.
            delay = delay + 1.
            new = pointer-y + sy-index.
            IF line_exists( grid[ x = pointer-x y = new ] ).
              IF grid[ x = pointer-x y = new ]-z <> color.
                crossing_delay = grid[ x = pointer-x y = new ]-delay + delay.
                INSERT VALUE #( x = pointer-x y = new delay = crossing_delay ) INTO TABLE crossings.
                grid[ x = pointer-x y = new ]-z = 'X'.
                grid[ x = pointer-x y = new ]-delay = crossing_delay.
              ENDIF.
              grid[ x = pointer-x y = new ]-z = color.
              grid[ x = pointer-x y = new ]-delay = COND #( WHEN grid[ x = pointer-x y = new ]-delay > delay THEN delay
                                                            ELSE grid[ x = pointer-x y = new ]-delay ).
            ELSE.
              INSERT VALUE #( x = pointer-x y = new z = color delay = delay ) INTO TABLE grid.
            ENDIF.
          ENDDO.
          pointer-y = pointer-y + steps.
        WHEN 'D'.
          DO steps TIMES.
            delay = delay + 1.
            new = pointer-y - sy-index.
            IF line_exists( grid[ x = pointer-x y = new ] ).
              IF grid[ x = pointer-x y = new ]-z <> color.
                crossing_delay = grid[ x = pointer-x y = new ]-delay + delay.
                INSERT VALUE #( x = pointer-x y = new delay =  crossing_delay ) INTO TABLE crossings.
                grid[ x = pointer-x y = new ]-z = 'X'.
                grid[ x = pointer-x y = new ]-delay = crossing_delay.
              ENDIF.
            ELSE.
              INSERT VALUE #( x = pointer-x y = new z = color delay = delay ) INTO TABLE grid.
            ENDIF.
          ENDDO.
          pointer-y = pointer-y - steps.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD find_closest_crossing.
    LOOP AT crossings ASSIGNING FIELD-SYMBOL(<crossing>).
      <crossing>-distance = calc_manhatten_distance( central_port = VALUE #( x = 0 y = 0 )
                                                     crossing     = VALUE #( x = <crossing>-x
                                                                             y = <crossing>-y ) ).
    ENDLOOP.
    SORT crossings BY distance ASCENDING.
    manhatten_distance = crossings[ 1 ]-distance.
  ENDMETHOD.


  METHOD get_delay.
    delay = grid[ x = x y = y ]-delay.
  ENDMETHOD.


  METHOD find_min_delay_x.
    SORT crossings BY delay ASCENDING.
    min_delay = crossings[ 1 ]-delay.
  ENDMETHOD.

ENDCLASS.
