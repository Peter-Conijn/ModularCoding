namespace Bunnyhops.ModularCoding.Abstraction;

using Microsoft.Sales.Document;
using Microsoft.Sales.History;

codeunit 50105 "Document Processor"
{
    Access = Public;
    InherentPermissions = X;
    InherentEntitlements = X;

    /// <summary>
    /// Processes a Sales Header document.
    /// </summary>
    /// <param name="NewSalesHeader">The Sales Header record to process.</param>
    procedure ProcessDocument(NewSalesHeader: Record "Sales Header")
    var
        SalesHeaderProcessor: Codeunit "Sales Header Processor";
    begin
        SalesHeaderProcessor.ProcessHeader(NewSalesHeader);
        ProcessDocument(SalesHeaderProcessor);
    end;

    /// <summary>
    /// Processes a Sales Invoice Header document.
    /// </summary>
    /// <param name="NewSalesInvoiceHeader">The Sales Invoice Header record to process.</param>
    procedure ProcessDocument(NewSalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesHeaderProcessor: Codeunit "Sales Header Processor";
    begin
        SalesHeaderProcessor.ProcessHeader(NewSalesInvoiceHeader);
        ProcessDocument(SalesHeaderProcessor);
    end;

    /// <summary>
    /// Processes a Sales Shipment Header document.
    /// </summary>
    /// <param name="NewSalesShipmentHeader">The Sales Shipment Header record to process.</param>
    procedure ProcessDocument(NewSalesShipmentHeader: Record "Sales Shipment Header")
    var
        SalesHeaderProcessor: Codeunit "Sales Header Processor";
    begin
        SalesHeaderProcessor.ProcessHeader(NewSalesShipmentHeader);
        ProcessDocument(SalesHeaderProcessor);
    end;

    local procedure ProcessDocument(SalesHeaderProcessor: Codeunit "Sales Header Processor")
    var
        SalesHeader: Record "Sales Header";
        NotInitializedErr: Label 'The Sales Header Processor was not properly initialized.';
    begin
        if not SalesHeaderProcessor.IsInitialized() then
            Error(NotInitializedErr);

        Message('Processed Document No.: %1\For Customer %2\And Order Date %3',
            SalesHeaderProcessor.GetDocumentNo(), SalesHeaderProcessor.GetSellToCustomerNo(), SalesHeaderProcessor.GetOrderDate());

        if SalesHeaderProcessor.GetTableId() <> Database::"Sales Header" then
            exit;

        SalesHeader := SalesHeaderProcessor.GetRecord();
        Message('Sales Header System ID: %1', SalesHeader.SystemId);
    end;
}
