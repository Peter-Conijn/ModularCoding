namespace PCO.ModularCoding.Permissions;

using Microsoft.Inventory.Location;
using System.Security.User;

page 50100 "Resp. Center Permissions"
{
    ApplicationArea = All;
    Caption = 'Resp. Center Permissions';
    PageType = List;
    SourceTable = "Resp. Center Permissions";
    UsageCategory = None;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Sales Posting Policy"; Rec."Sales Posting Policy")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Fill for Current User")
            {
                Caption = 'Fill for Current User';
                Image = SetupColumns;
                ToolTip = 'Create permission lines for the current user for all responsibility centers with default posting policy from User Setup.';

                trigger OnAction()
                var
                    ResponsibilityCenter: Record "Responsibility Center";
                    UserSetup: Record "User Setup";
                    CurrentUserId: Code[50];
                    DefaultPostingPolicy: Enum "Invoice Posting Policy";
                begin
                    CurrentUserId := CopyStr(UserId, 1, MaxStrLen(CurrentUserId));

                    // Get default posting policy from User Setup
                    UserSetup.ReadIsolation := IsolationLevel::ReadUncommitted;
                    UserSetup.SetLoadFields("Sales Invoice Posting Policy");
                    if UserSetup.Get(CurrentUserId) then
                        DefaultPostingPolicy := UserSetup."Sales Invoice Posting Policy"
                    else
                        DefaultPostingPolicy := DefaultPostingPolicy::Prohibited;

                    // Remove existing records for current user
                    Rec.SetRange("User ID", CurrentUserId);
                    Rec.DeleteAll();

                    ResponsibilityCenter.ReadIsolation := IsolationLevel::ReadUncommitted;
                    ResponsibilityCenter.SetLoadFields(Code);
                    // Create new records for each responsibility center
                    if ResponsibilityCenter.FindSet() then
                        repeat
                            InsertRecord(ResponsibilityCenter.Code, CurrentUserId, DefaultPostingPolicy);
                        until ResponsibilityCenter.Next() = 0;

                    InsertRecord('', CurrentUserId, DefaultPostingPolicy);
                    Commit();

                    // Update the UserPermissions codeunit cache
                    UpdateUserPermissionsCache();
                end;
            }
            action("Update User Permissions Cache")
            {
                Caption = 'Update User Permissions Cache';
                Image = Refresh;
                ToolTip = 'Updates the user permissions cache in the UserPermissions codeunit with current data.';

                trigger OnAction()
                begin
                    UpdateUserPermissionsCache();
                    Message('User permissions cache has been updated.');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Fill for Current User_Promoted"; "Fill for Current User")
                {
                }
                actionref("Update User Permissions Cache_Promoted"; "Update User Permissions Cache")
                {
                }
            }
        }
    }

    local procedure UpdateUserPermissionsCache()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        UserPermissions.UpdateUserPermissions();
    end;

    local procedure InsertRecord(ResponsibilityCenterCode: Code[20]; CurrentUserId: Code[50]; var DefaultPostingPolicy: Enum "Invoice Posting Policy")
    begin
        Rec.Init();
        Rec."User ID" := CurrentUserId;
        Rec."Responsibility Center" := ResponsibilityCenterCode;
        Rec."Sales Posting Policy" := DefaultPostingPolicy;
        Rec.Insert();
    end;
}