@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for Booking sUPPLEMENT processor'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZIVAR_R_BOOkSUPPL_PROCESSOR as projection on zivar_r_booksuppl
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
 _Booking: redirected to parent zivar_r_booking_processor,
 _Product,
 _SupplementText,
 _Travel   
}
