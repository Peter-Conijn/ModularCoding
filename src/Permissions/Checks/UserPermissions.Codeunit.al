namespace PCO.ModularCoding.Permissions;

using System.Security.User;

codeunit 50100 "User Permissions"
{
    Access = Public;
    SingleInstance = true;
    InherentEntitlements = X;
    InherentPermissions = X;
    Permissions = tabledata "Resp. Center Permissions" = R;

    var
        TempRespCenterPermissions: Record "Resp. Center Permissions" temporary;

    /// <summary>
    /// Updates the user permissions by copying from the temporary table to the permanent table.
    /// </summary>
    procedure UpdateUserPermissions()
    var
        RespCenterPermissions: Record "Resp. Center Permissions";
    begin
        // Clear existing permissions
        TempRespCenterPermissions.DeleteAll();

        // Copy from temporary table to permanent table
        RespCenterPermissions.ReadIsolation := IsolationLevel::ReadUncommitted;
        RespCenterPermissions.SetRange("User ID", UserId());
        if RespCenterPermissions.FindSet() then
            repeat
                TempRespCenterPermissions.Init();
                TempRespCenterPermissions := RespCenterPermissions;
                TempRespCenterPermissions.Insert();
            until RespCenterPermissions.Next() = 0;
    end;

    /// <summary>
    /// Gets the sales invoice posting policy for a given responsibility center for the current user.
    /// </summary>
    /// <param name="RespCenterCode">The code of the responsibility center.</param>
    /// <returns>The sales invoice posting policy.</returns>
    procedure GetSalesInvoicePostingPolicy(RespCenterCode: Code[20]): Enum "Invoice Posting Policy"
    begin
        if TempRespCenterPermissions.Get(UserId, RespCenterCode) then
            exit(TempRespCenterPermissions."Sales Posting Policy");
        exit(TempRespCenterPermissions."Sales Posting Policy"::Prohibited);
    end;
}
