@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Root of by RAP BO'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zivar_r_travel
  as select from /dmo/travel_m

  //  Composition to child
  composition [0..*] of ZIVAR_R_bOOKING          as _Booking
  association [1]    to /DMO/I_Agency               as _agency     on $projection.AgencyId = _agency.AgencyID
  association [1]    to /DMO/I_Customer             as _customer   on $projection.CustomerId = _customer.CustomerID
  association [1]    to I_Currency                  as _Currency   on $projection.CurrencyCode = _Currency.Currency
  association [1..1] to /DMO/I_Overall_Status_VH as _OverallStatus on $projection.OverallStatus = _OverallStatus.OverallStatus

{
  key travel_id       as TravelId,
      agency_id       as AgencyId,
      customer_id     as CustomerId,
      begin_date      as BeginDate,
      end_date        as EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee     as BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      description     as Description,
      overall_status  as OverallStatus,

      //      Automatically created by system . should be taken care by system
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true

      //This field we can use as Etag field --> OData etag
      last_changed_at as LastChangedAt,

      _agency,
      _customer,
      _Currency,
      _OverallStatus,

      //      Composition exposition
      _Booking

}
