CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS copyTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~copyTravel.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travel.

    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE Travel\_Booking.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA: entity        TYPE STRUCTURE FOR CREATE zivar_r_travel,
          travel_id_max TYPE /dmo/travel_id.

    " Step 1: Check Travel Id is not set in instance
    LOOP AT entities INTO entity WHERE travelId IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-travel.
    ENDLOOP.

    DATA(entities_wo_travelid) = entities.
    DELETE entities_wo_travelid WHERE TravelId IS NOT INITIAL.

    " Step 2: Get the Sequence numbers from SNRO
    TRY.
        " Step 3: If there is an exception throw error
        cl_numberrange_runtime=>number_get(
          EXPORTING
*            ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRAVL'
            quantity          = CONV #( lines( entities_wo_travelid ) )
          IMPORTING
            number            = DATA(number_range_key)
            returncode        = DATA(number_range_return_code)
            returned_quantity = DATA(number_range_returned_qty)
        ).

      CATCH cx_number_ranges INTO DATA(lx_number_ranges).
        LOOP AT entities_wo_travelid INTO entity .
          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key
                          %msg = lx_number_ranges )
                        TO reported-travel.
          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key  )
                        TO failed-travel.
        ENDLOOP.
        EXIT.

    ENDTRY.

    CASE number_range_return_code.
      WHEN '1'.
        " Step 4: Handle special cases where number range exceed critical %
        "1 - the returned number is in a critical range (specified under “percentage warning” in the object definition)
        LOOP AT entities_wo_travelid INTO entity .
          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key
                          %msg = NEW /dmo/cm_flight_messages(
                                  textid = /dmo/cm_flight_messages=>number_range_depleted
                                  severity = if_abap_behv_message=>severity-warning ) )
                       TO reported-travel.
        ENDLOOP.
      WHEN '2' OR '3'.
        " Step 5: Number range return last number, or number exhausted
        " 2 - the last number of the interval was returned
        " 3 - if fewer numbers are available than requested,  the return code is 3
        LOOP AT entities_wo_travelid INTO entity .
          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key
                          %msg = NEW /dmo/cm_flight_messages(
                                  textid = /dmo/cm_flight_messages=>not_sufficient_numbers
                                  severity = if_abap_behv_message=>severity-warning ) )
                       TO reported-travel.

          APPEND VALUE #( %cid = entity-%cid
                          %key = entity-%key
                          %fail-cause = if_abap_behv=>cause-conflict )
                        TO failed-travel.
        ENDLOOP.
        EXIT.

    ENDCASE.

    " Step 6: Final check for all number
    ASSERT number_range_returned_qty = lines( entities_wo_travelid ).

    " Step 7: Loop over the incoming travel data and assign the numbers from number range and return mapped data
    travel_id_max = number_range_key - number_range_returned_qty.

    LOOP AT entities_wo_travelid INTO entity .
      travel_id_max += 1.
      entity-TravelId = travel_id_max.

      APPEND VALUE #( %cid = entity-%cid
                      %key = entity-%key )
                    TO mapped-travel.
    ENDLOOP.
  ENDMETHOD.

  " Create by Association
  METHOD earlynumbering_cba_Booking.
*    DATA max_booking_id TYPE /dmo/booking_id.
*
*    " Step 1: get all the travel requests and their booking data
*    READ ENTITIES OF zivar_r_travel IN LOCAL MODE
*    ENTITY travel BY \_Booking
*    FROM CORRESPONDING #( Entities )
*    LINK DATA(bookings).
*
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_group>) GROUP BY <travel_group>-TravelId.
*      " Step 2: get the highest booking number which is already there
*      LOOP AT bookings INTO DATA(ls_booking) USING KEY entity
*            WHERE source-travelId = <travel_group>-travelID.
*        IF  max_booking_id < ls_booking-target-BookingId.
*          max_booking_id = ls_booking-target-bookingId.
*        ENDIF.
*      ENDLOOP.
*      " Step 3: Get the assigned booking numbers for incoming requests
*      LOOP AT entities INTO DATA(ls_entity) USING KEY entity
*            WHERE travelId = <travel_group>-travelID.
*        LOOP AT ls_entity-%target INTO DATA(ls_target).
*          IF  max_booking_id < ls_target-BookingId.
*            max_booking_id = ls_target-bookingId.
*          ENDIF.
*        ENDLOOP.
*      ENDLOOP.
*
*      " Step 4: Loop over all the entities of travel with same travel id
*      LOOP  AT entities ASSIGNING FIELD-SYMBOL(<fs_travel>) USING KEY entity WHERE travelId = <travel_group>-travelId.
*
*        " Step 5: Assign new booking IDs to the booking entity inside each travel
*        LOOP AT <fs_travel>-%target ASSIGNING FIELD-SYMBOL(<booking_wo_numbers>).
*          APPEND CORRESPONDING #( <booking_wo_numbers> ) TO mapped-booking ASSIGNING FIELD-SYMBOL(<mapped_booking>).
*          IF  <mapped_booking>-bookingId IS INITIAL.
*            max_booking_id += 10.
*            <mapped_booking>-bookingId = max_booking_id.
*          ENDIF.
*        ENDLOOP.
*      ENDLOOP.
*    ENDLOOP.

    DATA: max_booking_id TYPE /dmo/booking_id.

    READ ENTITIES OF zivar_r_travel IN LOCAL MODE
      ENTITY travel BY \_booking
        FROM CORRESPONDING #( entities )
        LINK DATA(bookings).

    " Loop over all unique TravelIDs
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel>) GROUP BY <travel>-travelid.

      " Get highest booking_id from existing bookings belonging to travel
      max_booking_id = REDUCE #( INIT max = CONV /dmo/booking_id( '0' )
                                 FOR  booking IN bookings USING KEY entity WHERE ( source-travelid  = <travel>-travelid )
                                 NEXT max = COND /dmo/booking_id( WHEN booking-target-bookingid > max
                                                                    THEN booking-target-bookingid
                                                                    ELSE max )
                               ).
      " Get highest assigned booking_id from incoming entities, eg from internal operations
      max_booking_id = REDUCE #( INIT max = max_booking_id
                                 FOR  entity IN entities USING KEY entity WHERE ( travelid  = <travel>-travelid )
                                 FOR  target IN entity-%target
                                 NEXT max = COND /dmo/booking_id( WHEN   target-bookingid > max
                                                                    THEN target-bookingid
                                                                    ELSE max )
                               ).

      " Assign new booking-ids if not already assigned
      LOOP AT <travel>-%target ASSIGNING FIELD-SYMBOL(<booking_wo_numbers>).
        APPEND CORRESPONDING #( <booking_wo_numbers> ) TO mapped-booking ASSIGNING FIELD-SYMBOL(<mapped_booking>).
        IF <booking_wo_numbers>-bookingid IS INITIAL.
          max_booking_id += 10 .
          <mapped_booking>-bookingid = max_booking_id .
        ENDIF.
      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.

  METHOD copyTravel.
  data: travels type table for create zivar_r_travel\\Travel,
        booking_cba type table for create zivar_r_travel\\Travel\_Booking,
        bookingsuppl_cba type table for create zivar_r_travel\\Booking\_BookingSupplement.
    " Step 1: Remove the travel instances with initial %cid
    " Step 2: Read all travel, booking and booking supplement using EML
    " Step 3: Fill travel internal table for travel data creation - %cid
    " Step 4: Fill booking internal table for booking data creation - %cid_ref
    " Step 5: Fill booking Supplement internal table for booking Suppl data creation - %cid_ref
    " Step 6" EML for modify entity to create new BO instance using exisiting data

  ENDMETHOD.

ENDCLASS.
