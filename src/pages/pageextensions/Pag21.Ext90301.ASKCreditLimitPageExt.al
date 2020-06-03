pageextension 90301 CreditLimitPageExtension extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("F&unctions")
        {
            action(UpdateCreditLimit)
            {
                ApplicationArea = All;
                Caption = 'Update Credit Limit';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CalculateCost;
                trigger OnAction()
                begin
                    CallUpdateCreditLimit();
                end;
            }
        }
    }
    local procedure CallUpdateCreditLimit()
    var
        CreditLimitCalculated: Decimal;
        CreditLimitActual: Decimal;
    begin
        CreditLimitCalculated := Rec.CalculateCreditLimit;
        IF CreditLimitCalculated = Rec."Credit Limit (LCY)" THEN BEGIN
            MESSAGE(Text90003);
            EXIT;
        END;

        IF GUIALLOWED AND NOT CONFIRM(Text90001, FALSE, FIELDCAPTION("Credit Limit (LCY)"), CreditLimitCalculated) THEN
            EXIT;

        CreditLimitActual := CreditLimitCalculated;
        Rec.UpdateCreditLimit(CreditLimitActual);
        IF CreditLimitActual <> CreditLimitCalculated THEN
            MESSAGE(Text90002, CreditLimitActual);
    end;

    var
        Text90001: Label 'Are you sure that you want to set the %1 to %2?';
        Text90002: Label 'The credit limit was rounded to %1 to comply with company policies.';
        Text90003: Label 'The credit limit is up to date.';

}