@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test CDS'
@Metadata.ignorePropagatedAnnotations: true
define view entity zc_ivar_test as select from zi_ivar_r_sales_Data
{
    key OrderId,
    key Itemid,
    OrderNo,
    Buyer,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalGross,
    CurrencyCode,
    CreatedBy,
    CreatedOn,
    ChangedBy,
    ChangedOn,
    Product,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    GrossAmount,
    @Semantics.quantity.unitOfMeasure: 'UnitOfMeasure'
    Quantity,
    UnitOfMeasure,
    _PRODUCT.Name,
    /* Associations */
    _BUSINESSPARTNER,
    _PRODUCT
    
}
