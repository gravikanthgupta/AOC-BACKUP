@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Booking'
@Metadata.ignorePropagatedAnnotations: true
define view entity ztc_booking_proj as projection on ztc_booking
{
    key TravelId,
    key BookingId,
    BookingDate,
    CustomerId,
    CarrierId,
    ConnectionId,
    FlightDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FlightPrice,
    CurrencyCode,
    BookingStatus,
    LastChangedAt,
    /* Associations */
    _BookingStatus,
    _BookingSupplement,
    _Carrier,
    _Connection,
    _Customer,
    _Travel: redirected to parent ZTC_TRAVEL_PROJ
}
