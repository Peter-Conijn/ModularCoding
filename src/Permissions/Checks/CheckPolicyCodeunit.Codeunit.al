namespace PCO.ModularCoding.Permissions;

using System.Security.User;

/// <summary>
/// Implementation of Check Policy interface using the User Permissions codeunit.
/// </summary>
codeunit 50101 "Check Policy Codeunit" implements "Check Policy"
{
    Access = Public;
    InherentEntitlements = X;
    InherentPermissions = X;

    /// <summary>
    /// Checks the posting policy for a given responsibility center using the User Permissions codeunit.
    /// </summary>
    /// <param name="RespCenterCode">The code of the responsibility center.</param>
    /// <returns>The sales invoice posting policy.</returns>
    procedure Check(RespCenterCode: Code[20]): Enum "Invoice Posting Policy"
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        exit(UserPermissions.GetSalesInvoicePostingPolicy(RespCenterCode));
    end;
}