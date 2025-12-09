namespace PCO.ModularCoding.Permissions;

using Microsoft.Sales.Document;
using System.Security.User;

pageextension 50101 "Sales Order Card" extends "Sales Order"
{
    actions
    {
        addlast(Processing)
        {
            action("Check Posting Permissions - Table")
            {
                Caption = 'Check Posting Permissions - Table';
                Image = Permission;
                ToolTip = 'Specifies to check posting permissions using direct table access and shows execution time.';
                ApplicationArea = All;

                trigger OnAction()
                var
                    SalesPostCheck: Enum "Sales Post Check";
                    CheckPolicy: Interface "Check Policy";
                    PostingPolicy: Enum "Invoice Posting Policy";
                    StartTime: DateTime;
                    EndTime: DateTime;
                    ElapsedTime: Duration;
                    ElapsedTimeMsg: Label 'Posting Policy: %1\\Execution Time (Table): %2 ms', Comment = '%1 = Posting Policy, %2 = Elapsed time in milliseconds';
                begin
                    StartTime := CurrentDateTime;

                    SalesPostCheck := SalesPostCheck::Table;
                    CheckPolicy := SalesPostCheck;
                    PostingPolicy := CheckPolicy.Check(Rec."Responsibility Center");

                    EndTime := CurrentDateTime;
                    ElapsedTime := EndTime - StartTime;

                    Message(ElapsedTimeMsg, PostingPolicy, ElapsedTime);
                end;
            }
            action("Check Posting Permissions - Codeunit")
            {
                ApplicationArea = All;
                Caption = 'Check Posting Permissions - Codeunit';
                Image = Permission;
                ToolTip = 'Specifies to check posting permissions using codeunit access and shows execution time.';

                trigger OnAction()
                var
                    SalesPostCheck: Enum "Sales Post Check";
                    CheckPolicy: Interface "Check Policy";
                    PostingPolicy: Enum "Invoice Posting Policy";
                    StartTime: DateTime;
                    EndTime: DateTime;
                    ElapsedTime: Duration;
                    ElapsedTimeMsg: Label 'Posting Policy: %1\\Execution Time (Codeunit): %2 ms', Comment = '%1 = Posting Policy, %2 = Elapsed time in milliseconds';
                begin
                    StartTime := CurrentDateTime;

                    SalesPostCheck := SalesPostCheck::Codeunit;
                    CheckPolicy := SalesPostCheck;
                    PostingPolicy := CheckPolicy.Check(Rec."Responsibility Center");

                    EndTime := CurrentDateTime;
                    ElapsedTime := EndTime - StartTime;

                    Message(ElapsedTimeMsg, PostingPolicy, ElapsedTime);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("Check Posting Permissions - Table_Promoted"; "Check Posting Permissions - Table")
            {
            }
            actionref("Check Posting Permissions - Codeunit_Promoted"; "Check Posting Permissions - Codeunit")
            {
            }
        }
    }
}