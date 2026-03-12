CLASS zivar_cl_class_pool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: itab    TYPE TABLE OF string,
          lv_num1 TYPE i,
          lv_num2 TYPE i.

    INTERFACES if_oo_adt_classrun .

    METHODS: calc.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zivar_cl_class_pool IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    me->calc(  ).
    out->write(
      EXPORTING
        data   = me->itab
    ).

  ENDMETHOD.

  METHOD calc.

    lv_num1 = 20.
    lv_num2 = 5.


    DATA(lo_add) = NEW zivar_cl_add( lv_num1 = lv_num1 lv_num2 = lv_num2 ).
    DATA(lo_sub) = NEW zivar_cl_sub( lv_num1 = lv_num1 lv_num2 = lv_num2 ).
    DATA(lo_mul) = NEW zivar_cl_mul( lv_num1 = lv_num1 lv_num2 = lv_num2 ).
    DATA(lo_div) = NEW zivar_cl_div( lv_num1 = lv_num1 lv_num2 = lv_num2 ).

    APPEND |First number:               { me->lv_num1 }| TO itab.
    APPEND |Second number:              { me->lv_num2 }| TO itab.
    APPEND INITIAL LINE TO itab.

    APPEND |Result for Addition:        { lo_add->add_num(  ) }| TO itab.
    APPEND |Result for Subtraction:     { lo_sub->sub_num(  ) }| TO itab.
    APPEND |Result for Multiplication:  { lo_mul->mul_num(  ) }| TO itab.
    APPEND |Result for Division:        { lo_div->div_num(  ) }| TO itab.


  ENDMETHOD.
ENDCLASS.
