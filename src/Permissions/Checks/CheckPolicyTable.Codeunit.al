namespace PCO.ModularCoding.Permissions;

using System.Security.User;

/// <summary>
/// Implementation of Check Policy interface using direct table access.
/// </summary>
codeunit 50102 "Check Policy Table" implements "Check Policy"
{
    Access = Public;
    InherentEntitlements = X;
    InherentPermissions = X;

    /// <summary>
    /// Checks the posting policy for a given responsibility center using direct table access.
    /// </summary>
    /// <param name="RespCenterCode">The code of the responsibility center.</param>
    /// <returns>The sales invoice posting policy.</returns>
    procedure Check(RespCenterCode: Code[20]): Enum "Invoice Posting Policy"
    var
        RespCenterPermissions: Record "Resp. Center Permissions";
        DefaultPolicy: Enum "Invoice Posting Policy";
    begin
        DefaultPolicy := DefaultPolicy::Prohibited;

        RespCenterPermissions.SetLoadFields("Sales Posting Policy");
        RespCenterPermissions.ReadIsolation := IsolationLevel::ReadUncommitted;
        if RespCenterPermissions.Get(UserId, RespCenterCode) then
            exit(RespCenterPermissions."Sales Posting Policy");

        exit(DefaultPolicy);
    end;
}