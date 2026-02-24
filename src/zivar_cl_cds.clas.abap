CLASS zivar_cl_cds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZIVAR_CL_CDS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    SELECT FROM zi_ivar_r_sales_Data\_product as product fIELDS
* product~name
           *
*           WHERE OrderNo = '1'

               INTO TABLE @DATA(itab).




    out->write(
      EXPORTING
        data   = itab
*        name   =
*      RECEIVING
*        output =
    ).
  ENDMETHOD.
ENDCLASS.
