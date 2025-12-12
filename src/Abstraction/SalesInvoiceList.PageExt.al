namespace Bunnyhops.ModularCoding.Abstraction;

using Microsoft.Sales.Document;

pageextension 50104 "Sales Invoice List" extends "Sales Invoice List"
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
                ToolTip = 'Analyze the selected sales invoice record.';

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
