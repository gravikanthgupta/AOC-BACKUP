@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Suppliments as Child of Comp tree'
@Metadata.ignorePropagatedAnnotations: true
define view entity zivar_r_booksuppl as select from /dmo/booksuppl_m

//association to parent
association to parent ZIVAR_R_bOOKING as _Booking on $projection.BookingId = _Booking.BookingId and
                                                     $projection.TravelId = _Booking.TravelId

association[1..1] to zivar_r_travel as _Travel on $projection.TravelId = _Travel.TravelId
association[1..1] to /DMO/I_Supplement as _Product on $projection.SupplementId = _Product.SupplementID
association[1..*] to /DMO/I_SupplementText as _SupplementText on $projection.SupplementId = _SupplementText.SupplementID
{
    key travel_id as TravelId,
    key booking_id as BookingId,
    key booking_supplement_id as BookingSupplementId,
    supplement_id as SupplementId,
    
    @Semantics.amount.currencyCode: 'CurrencyCode'
    price as Price,
    currency_code as CurrencyCode,
    
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    
    _Travel,
    _Product,
    _SupplementText,
    
    _Booking
}
