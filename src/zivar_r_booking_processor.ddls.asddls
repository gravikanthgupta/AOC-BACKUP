@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Booking processor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zivar_r_booking_processor
  as projection on ZIVAR_R_bOOKING
{
  key TravelId,
  key BookingId,
      BookingDate,
      @Consumption.valueHelpDefinition: [{
          entity.name :  '/DMO/I_Customer',
          entity.element : 'CustomerID'
          }]
      CustomerId,

      @Consumption.valueHelpDefinition: [{
          entity.name :  '/DMO/I_Carrier',
          entity.element : 'AirlineID'
          }]
      CarrierId,

      @Consumption.valueHelpDefinition: [{
          entity.name :  '/DMO/I_Connection',
          entity.element : 'ConnectionID',
      //          local element is current CDS field
      //          element is the field which should pass into the value help field
          additionalBinding: [{
              localElement: 'CarrierId',
              element: 'AirlineID'
           }]
          }]
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,

      @Consumption.valueHelpDefinition: [{
          entity.name :  '/DMO/I_Booking_Status_VH',
          entity.element : 'BookingStatus'
          }]
      BookingStatus,
      LastChangedAt,
      /* Associations */
      _BookingStatus,
      _BookingSupplement : redirected to composition child ZIVAR_R_BOOkSUPPL_PROCESSOR,
      _Carrier,
      _Connection,
      _Customer,
      _Travel            : redirected to parent zivar_r_travel_processor
}
