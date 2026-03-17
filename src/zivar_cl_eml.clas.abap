CLASS zivar_cl_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: lv_opr TYPE c VALUE 'C'.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zivar_cl_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " Declare variables for EML response
    DATA lt_failed   TYPE response FOR  FAILED   zivar_r_travel.
    DATA lt_messages TYPE RESPONSE FOR REPORTED zivar_r_travel.
    DATA lt_mapped   TYPE RESPONSE FOR MAPPED   zivar_r_travel.


    CASE lv_opr.
      WHEN 'R'.
        READ ENTITIES OF zivar_r_travel
        ENTITY Travel
        ALL FIELDS
*        FIELDS ( TravelID AgencyId CustomerId TotalPrice OverallStatus )
        WITH VALUE #( ( TravelID = '00000003' )
                      ( TravelID = '00000004' )
                      ( TravelID = '99999992' )
                     )
        RESULT DATA(lt_result)
        FAILED lt_failed
        REPORTED lt_messages.

        out->write(
          EXPORTING
            data   = lt_result
        ).
        out->write(
          EXPORTING
            data   = lt_failed
        ).
      WHEN 'C'.
        DATA(lv_description) = 'Test EML with Class'.
        DATA(lv_agency) = '070014'.
        DATA(lv_customer) = '000337'.

        MODIFY ENTITIES OF zivar_r_travel
        ENTITY Travel
        CREATE FIELDS ( TravelId AgencyId CustomerId CurrencyCode BeginDate Enddate Description OverallStatus )
        WITH VALUE #(
            (
              %cid = '1'
              TravelId = '90000000'                         "'00007001'
              AgencyId = lv_agency
              CustomerId = lv_customer
              CurrencyCode = 'INR'
              BeginDate = cl_abap_context_info=>get_system_date( )
              EndDate = cl_abap_context_info=>get_system_date( ) + 20
              Description = lv_description
              OverallStatus = 'A'
            )

            (
              %cid = '2'
              TravelId = '00004092'
              AgencyId = lv_agency
              CustomerId = lv_customer
              CurrencyCode = 'IR' "'INR'
              BeginDate = cl_abap_context_info=>get_system_date( )
              EndDate = cl_abap_context_info=>get_system_date( ) + 20
              Description = lv_description
              OverallStatus = 'A'
            )
         )
         MAPPED lt_mapped
         FAILED lt_failed
         REPORTED lt_messages.

        COMMIT ENTITIES.

        out->write(
         EXPORTING
           data   = lt_mapped
       ).
        out->write(
          EXPORTING
            data   = lt_failed
         ).

         out->write(
          EXPORTING
            data   = lt_messages
         ).




      WHEN 'U'.

        MODIFY ENTITIES OF zivar_r_travel
          ENTITY Travel
          UPDATE FIELDS (  Description )
          WITH VALUE #(
              (
                TravelId = '00007001'
                Description = 'Updated using EML'
              )
           )
           MAPPED lt_mapped
           FAILED lt_failed
           REPORTED lt_messages.

        COMMIT ENTITIES.

        out->write(
         EXPORTING
           data   = lt_mapped
       ).
        out->write(
          EXPORTING
            data   = lt_failed
         ).

      WHEN 'D'.
        MODIFY ENTITIES OF zivar_r_travel
            ENTITY Travel
            DELETE FROM
             VALUE #(
                (
                  TravelId = '90000000'
                )
             )
             MAPPED lt_mapped
             FAILED lt_failed
             REPORTED lt_messages.

        COMMIT ENTITIES.

        out->write(
         EXPORTING
           data   = lt_mapped
       ).
        out->write(
          EXPORTING
            data   = lt_failed
         ).

    ENDCASE.
  ENDMETHOD.
ENDCLASS.
