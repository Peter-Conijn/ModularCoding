namespace PCO.ModularCoding.Permissions;

using System.Security.User;

pageextension 50100 "User Setup" extends "User Setup"
{
    actions
    {
        addfirst(Processing)
        {
            action("Resp. Center Permissions")
            {
                ApplicationArea = All;
                Caption = 'Resp. Center Permissions';
                Image = Permission;
                ToolTip = 'Specifies responsibility center permissions for the selected user.';
                RunObject = page "Resp. Center Permissions";
                RunPageLink = "User ID" = field("User ID");
            }
        }
    }
}