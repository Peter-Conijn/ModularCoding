namespace PCO.ModularCoding.Permissions;

/// <summary>
/// Enum for sales posting check implementations.
/// </summary>
enum 50100 "Sales Post Check" implements "Check Policy"
{
    Extensible = true;

    value(0; "Codeunit")
    {
        Caption = 'Codeunit';
        Implementation = "Check Policy" = "Check Policy Codeunit";
    }
    value(1; "Table")
    {
        Caption = 'Table';
        Implementation = "Check Policy" = "Check Policy Table";
    }
}