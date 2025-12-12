namespace Bunnyhops.ModularCoding.Abstraction;

using Microsoft.Sales.History;

pageextension 50105 "Posted Sales Shipments" extends "Posted Sales Shipments"
{
    actions
    {
        addlast(processing)
        {
            action(AnalyzeRecord)
            {
                ApplicationArea = All;
                Caption = 'Analyze Record';
                Image = ViewDetails;
                ToolTip = 'Analyze the selected sales shipment record.';

                trigger OnAction()
                var
                    DocumentProcessor: Codeunit "Document Processor";
                begin
                    DocumentProcessor.ProcessDocument(Rec);
                end;
            }
        }

        addfirst(Promoted)
        {
            actionref(AnalyzeRecord_Promoted; AnalyzeRecord)
            {
            }
        }
    }
}
