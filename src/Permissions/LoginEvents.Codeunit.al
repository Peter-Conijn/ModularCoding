namespace PCO.ModularCoding.Permissions;

using System.Environment.Configuration;

/// <summary>
/// Handles login events and updates user permissions.
/// </summary>
codeunit 50103 "Login Events"
{
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;

    /// <summary>
    /// Event subscriber for OnAfterLogin to update user permissions.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", 'OnAfterLogin', '', false, false)]
    local procedure OnAfterLogin()
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        UserPermissions.UpdateUserPermissions();
    end;
}