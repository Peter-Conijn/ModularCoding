namespace PCO.ModularCoding.Permissions;

using System.Security.User;
using Microsoft.Inventory.Location;

table 50100 "Resp. Center Permissions"
{
    Caption = 'Resp. Center Permissions';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            ToolTip = 'Specifies the user who has permissions for the responsibility center.';
            TableRelation = "User Setup";
        }
        field(2; "Responsibility Center"; Code[20])
        {
            Caption = 'Responsibility Center';
            ToolTip = 'Specifies the responsibility center for which the user has permissions.';
            TableRelation = "Responsibility Center";
        }
        field(3; "Sales Posting Policy"; Enum "Invoice Posting Policy")
        {
            Caption = 'Sales Posting Policy';
            ToolTip = 'Specifies the posting policy for sales documents in this responsibility center.';
        }
    }
    keys
    {
        key(PK; "User ID", "Responsibility Center")
        {
            Clustered = true;
        }
    }
}
