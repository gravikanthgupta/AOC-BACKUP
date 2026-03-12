@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Booking supplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity ztc_booking_suppl_proj as projection on ztc_booking_suppl
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    SupplementId,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ztc_booking_proj,
    _Product,
    _SupplementText,
    _Travel: redirected to ZTC_TRAVEL_PROJ
}
