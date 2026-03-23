CLASS zivar_cl_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: lv_opr TYPE c VALUE 'Z'.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zivar_cl_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    " Declare variables for EML response
    DATA lt_failed   TYPE RESPONSE FOR  FAILED   zivar_r_travel.
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
*        CREATE FIELDS ( TravelId AgencyId CustomerId CurrencyCode BeginDate Enddate Description OverallStatus )
        CREATE FIELDS ( AgencyId CustomerId CurrencyCode BeginDate Enddate Description OverallStatus )
        WITH VALUE #(
            (
              %cid = '1'
*              TravelId = '90000000'                         "'00007001'
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
*              TravelId = '00004092'
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

      WHEN 'Z'.
        lv_description = 'Test EML with Class'.
        lv_agency = '070014'.
        lv_customer = '000337'.

        MODIFY ENTITIES OF zivar_r_travel
        ENTITY Travel
        CREATE FIELDS ( AgencyId CustomerId CurrencyCode BeginDate Enddate Description OverallStatus )
        WITH VALUE #(
            (
              %cid = '1'
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
              AgencyId = lv_agency
              CustomerId = lv_customer
              CurrencyCode = 'INR'
              BeginDate = cl_abap_context_info=>get_system_date( )
              EndDate = cl_abap_context_info=>get_system_date( ) + 20
              Description = 'Test EML with Class 2'
              OverallStatus = 'A'
            )
         )

         CREATE BY \_Booking
         FIELDS ( CustomerID CarrierId ConnectionID FlightDate ) WITH
         VALUE #( ( %cid_ref = '1'

                     %target = VALUE #( ( %cid         = 'REF_1_1'
                                          CustomerID   = lv_customer
                                          CarrierId    = 'AA'
                                          ConnectionID = '0322'
                                          FlightPrice  = '1'
                                          CurrencyCode = 'USD'
                                          FlightDate   = cl_abap_context_info=>get_system_date( )
                                         )

                                        ( %cid         = 'REF_1_2'
                                          CustomerID   = lv_customer
                                          CarrierId    = 'AA'
                                          ConnectionID = '0322'
                                          FlightPrice  = '2'
                                          CurrencyCode = 'USD'
                                        FlightDate   = cl_abap_context_info=>get_system_date( )
                                        )

                                       )
                        )
                      ( %cid_ref = '2'

                     %target = VALUE #( ( %cid         = 'REF_2_1'
                                          CustomerID   = lv_customer
                                          CarrierId    = 'AA'
                                          ConnectionID = '0322'
                                          FlightPrice  = '3'
                                          CurrencyCode = 'USD'
                                          FlightDate   = cl_abap_context_info=>get_system_date( ) )

                                        ( %cid         = 'REF_2_2'
                                          CustomerID   = lv_customer
                                          CarrierId    = 'AA'
                                          ConnectionID = '0322'
                                          FlightPrice  = '4'
                                          CurrencyCode = 'USD'
                                        FlightDate   = cl_abap_context_info=>get_system_date( ) )

                                         ) )

                    (
                      TravelID = '00004162'

                     %target = VALUE #( ( %cid         = 'REF_3_1'
                                          CustomerID   = lv_customer
                                          CarrierId    = 'AA'
                                          ConnectionID = '0322'
                                          FlightPrice  = '5'
                                          CurrencyCode = 'USD'
                                          FlightDate   = cl_abap_context_info=>get_system_date( ) )

                                        ( %cid         = 'REF_3_2'
                                          CustomerID   = lv_customer
                                          CarrierId    = 'AA'
                                          ConnectionID = '0322'
                                          FlightPrice  = '6'
                                          CurrencyCode = 'USD'
                                        FlightDate   = cl_abap_context_info=>get_system_date( ) )

                                         ) ) )

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

    ENDCASE.
  ENDMETHOD.
ENDCLASS.
