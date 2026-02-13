@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection for TRAVEL BO'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zivar_r_travel_processor
  as projection on zivar_r_travel
{
      @ObjectModel.text.element: [ 'Description' ]

  key TravelId,
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Consumption.valueHelpDefinition: [{
            entity.name: '/DMO/I_AGENCY',
            entity.element: 'AgencyID'
         }]
      AgencyId,
      @Semantics.text: true
      _agency.Name       as AgencyName,
      @Consumption.valueHelpDefinition: [{
           entity.name: '/DMO/I_CUSTOMER',
           entity.element: 'CustomerID'
        }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      @Semantics.text: true
      _customer.LastName as CustomerName,

      BeginDate,
      EndDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      CurrencyCode,
      @Semantics.text: true
      Description,
      @Consumption.valueHelpDefinition: [{
           entity.name: '/DMO/I_Overall_Status_VH',
           entity.element: 'OverallStatus'
        }]
      @ObjectModel.text.element: [ 'StatusText' ]
      OverallStatus,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      @Semantics.text: true
      StatusText,
      Criticality,
      /* Associations */
      _agency,
      _Booking: redirected to composition child zivar_r_booking_processor,
      _Currency,
      _customer,
      _OverallStatus
}
