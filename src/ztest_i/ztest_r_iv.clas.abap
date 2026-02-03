CLASS ztest_r_iv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    METHODS: get_add IMPORTING a   TYPE i
                               b   TYPE i
                     EXPORTING res TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ztest_r_iv IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA(lo_obj) = NEW ztest_r_iv(  ).
    lo_obj->get_add(
      EXPORTING
        a   = 1
        b   =  3
      IMPORTING
        res = DATA(lv_res)
    ).
    out->write( |Result: { lv_res } | ).

  ENDMETHOD.

  METHOD get_add.
    res = a + b.

  ENDMETHOD.

ENDCLASS.
