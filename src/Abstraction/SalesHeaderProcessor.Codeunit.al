namespace Bunnyhops.ModularCoding.Abstraction;

using Microsoft.Sales.Document;
using Microsoft.Sales.History;

codeunit 50104 "Sales Header Processor"
{
    Access = Public;
    InherentPermissions = X;
    InherentEntitlements = X;

    var
        HeaderRecordRef: RecordRef;
        DocumentNo: Code[20];
        SellToCustomerNo: Code[20];
        OrderDate: Date;
        Initialized: Boolean;

    /// <summary>
    /// Processes a sales header record (Sales Header, Sales Shipment Header, or Sales Invoice Header)
    /// and extracts item-related information into global variables.
    /// </summary>
    /// <param name="HeaderRecord">A variant containing one of the supported sales header record types.</param>
    procedure ProcessHeader(HeaderRecord: Variant)
    var
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if not HeaderRecord.IsRecord then
            Error('The provided variant is not a record.');

        HeaderRecordRef.GetTable(HeaderRecord);

        this.Initialized := true;
        case HeaderRecordRef.Number of
            Database::"Sales Header":
                begin
                    HeaderRecordRef.SetTable(SalesHeader);
                    ProcessSalesDocument(SalesHeader);
                end;
            Database::"Sales Shipment Header":
                begin
                    HeaderRecordRef.SetTable(SalesShipmentHeader);
                    ProcessSalesDocument(SalesShipmentHeader);
                end;
            Database::"Sales Invoice Header":
                begin
                    HeaderRecordRef.SetTable(SalesInvoiceHeader);
                    ProcessSalesDocument(SalesInvoiceHeader);
                end;
            else
                this.Initialized := false;
        end;
    end;

    /// <summary>
    /// Gets the Document No. extracted from the processed header.
    /// </summary>
    /// <returns>The Document No. as a Code[20].</returns>
    procedure GetDocumentNo(): Code[20]
    begin
        exit(this.DocumentNo);
    end;

    /// <summary>
    /// Gets the Sell-to Customer No. extracted from the processed header.
    /// </summary>
    /// <returns>The Sell-to Customer No. as a Code[20].</returns>
    procedure GetSellToCustomerNo(): Code[20]
    begin
        exit(this.SellToCustomerNo);
    end;

    /// <summary>
    /// Gets the Order Date extracted from the processed header.
    /// </summary>
    /// <returns>The Order Date as a Date.</returns>
    procedure GetOrderDate(): Date
    begin
        exit(this.OrderDate);
    end;

    /// <summary>
    /// Gets the Table ID of the processed header record.
    /// </summary>
    /// <returns>The Table ID as an Integer.</returns>
    procedure GetTableId(): Integer
    begin
        exit(HeaderRecordRef.Number);
    end;

    /// <summary>
    /// Gets the original record that was processed.
    /// </summary>
    /// <returns>The processed record as a Variant.</returns>
    procedure GetRecord(): Variant
    var
        SalesHeader: Record "Sales Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        UnsupportedTypeErr: Label 'The processed record is of an unsupported type.';
        RecordVariant: Variant;
    begin
        case HeaderRecordRef.Number of
            Database::"Sales Header":
                begin
                    HeaderRecordRef.SetTable(SalesHeader);
                    RecordVariant := SalesHeader;
                end;
            Database::"Sales Shipment Header":
                begin
                    HeaderRecordRef.SetTable(SalesShipmentHeader);
                    RecordVariant := SalesShipmentHeader;
                end;
            Database::"Sales Invoice Header":
                begin
                    HeaderRecordRef.SetTable(SalesInvoiceHeader);
                    RecordVariant := SalesInvoiceHeader;
                end;
            else
                Error(UnsupportedTypeErr);
        end;
        exit(RecordVariant);
    end;

    /// <summary>
    /// Indicates whether the processor has been successfully initialized with a header record.
    /// </summary>
    /// <returns>True if ProcessHeader has completed successfully, otherwise false.</returns>
    procedure IsInitialized(): Boolean
    begin
        exit(this.Initialized);
    end;

    local procedure ProcessSalesDocument(SalesHeader: Record "Sales Header")
    begin
        FillGlobalVariables(SalesHeader."No.", SalesHeader."Sell-to Customer No.", SalesHeader."Order Date");
    end;

    local procedure ProcessSalesDocument(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        FillGlobalVariables(SalesInvoiceHeader."No.", SalesInvoiceHeader."Sell-to Customer No.", SalesInvoiceHeader."Order Date");
    end;

    local procedure ProcessSalesDocument(SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        FillGlobalVariables(SalesShipmentHeader."No.", SalesShipmentHeader."Sell-to Customer No.", SalesShipmentHeader."Order Date");
    end;

    local procedure FillGlobalVariables(NewDocumentNo: Code[20]; NewSellToCustomerNo: Code[20]; NewOrderDate: Date)
    begin
        this.DocumentNo := NewDocumentNo;
        this.SellToCustomerNo := NewSellToCustomerNo;
        this.OrderDate := NewOrderDate;
    end;
}
