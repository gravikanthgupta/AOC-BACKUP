@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Travel'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZTC_TRAVEL_PROJ as projection on ZTC_TRAVEL
{
    key TravelId,
    AgencyId,
    CustomerId,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    OverallStatus,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _agency,
    _Booking: redirected to composition child ztc_booking_proj,
    _Currency,
    _customer,
    _OverallStatus
}
