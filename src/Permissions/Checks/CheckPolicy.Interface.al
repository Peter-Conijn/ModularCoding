namespace PCO.ModularCoding.Permissions;

using System.Security.User;

/// <summary>
/// Interface for checking posting policies.
/// </summary>
interface "Check Policy"
{
    /// <summary>
    /// Checks the posting policy for a given responsibility center.
    /// </summary>
    /// <param name="RespCenterCode">The code of the responsibility center.</param>
    /// <returns>The sales invoice posting policy.</returns>
    procedure Check(RespCenterCode: Code[20]): Enum "Invoice Posting Policy";
}