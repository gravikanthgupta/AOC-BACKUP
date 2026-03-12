*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS zivar_cl_add DEFINITION.
  PUBLIC SECTION.
    DATA: lv_num1 TYPE i,
          lv_num2 TYPE i.
    METHODS: constructor IMPORTING lv_num1 TYPE i
                                   lv_num2 TYPE i.
    METHODS: add_num RETURNING VALUE(lv_result) TYPE i.
ENDCLASS.

CLASS zivar_cl_add IMPLEMENTATION.

  METHOD constructor.
    me->lv_num1 = lv_num1.
    me->lv_num2 = lv_num2.
  ENDMETHOD.
  METHOD add_num.
    lv_result = lv_num1 + lv_num2.
  ENDMETHOD.
ENDCLASS.

CLASS zivar_cl_sub DEFINITION.
  PUBLIC SECTION.
    DATA: lv_num1 TYPE i,
          lv_num2 TYPE i.
    METHODS: constructor IMPORTING lv_num1 TYPE i
                                   lv_num2 TYPE i.
    METHODS: sub_num     RETURNING VALUE(lv_result) TYPE i.
ENDCLASS.

CLASS zivar_cl_sub IMPLEMENTATION.

  METHOD constructor.
    me->lv_num1 = lv_num1.
    me->lv_num2 = lv_num2.
  ENDMETHOD.

  METHOD sub_num.
    lv_result = lv_num1 - lv_num2.
  ENDMETHOD.
ENDCLASS.


CLASS zivar_cl_mul DEFINITION.
  PUBLIC SECTION.
    DATA: lv_num1 TYPE i,
          lv_num2 TYPE i.
    METHODS: constructor IMPORTING lv_num1 TYPE i
                                   lv_num2 TYPE i.
    METHODS: mul_num  RETURNING VALUE(lv_result) TYPE i.
ENDCLASS.

CLASS zivar_cl_mul IMPLEMENTATION.


  METHOD constructor.
    me->lv_num1 = lv_num1.
    me->lv_num2 = lv_num2.
  ENDMETHOD.

  METHOD mul_num.
    lv_result = lv_num1 * lv_num2.
  ENDMETHOD.
ENDCLASS.


CLASS zivar_cl_div DEFINITION.
  PUBLIC SECTION.
    DATA: lv_num1 TYPE i,
          lv_num2 TYPE i.
    METHODS: constructor IMPORTING lv_num1 TYPE i
                                   lv_num2 TYPE i.
    METHODS: div_num RETURNING VALUE(lv_result) TYPE i.
ENDCLASS.

CLASS zivar_cl_div IMPLEMENTATION.

  METHOD constructor.
    me->lv_num1 = lv_num1.
    me->lv_num2 = lv_num2.
  ENDMETHOD.

  METHOD div_num.
    lv_result = lv_num1 / lv_num2.
  ENDMETHOD.
ENDCLASS.
