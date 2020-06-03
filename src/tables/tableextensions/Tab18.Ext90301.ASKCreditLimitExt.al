tableextension 90301 CreditLimitExtension extends Customer
{
    procedure UpdateCreditLimit(var NewCreditLimit: Decimal)
    begin
        NewCreditLimit := ROUND(NewCreditLimit, 10000);
        Rec.VALIDATE("Credit Limit (LCY)", NewCreditLimit);
        Rec.MODIFY;
    end;

    procedure CalculateCreditLimit(): Decimal
    var
        Cust: Record Customer;
    begin
        Cust := Rec;
        Cust.SETRANGE("Date Filter", CALCDATE('<-12M>', WORKDATE), WORKDATE);
        Cust.CALCFIELDS("Sales (LCY)", "Balance (LCY)");
        EXIT(ROUND(Cust."Sales (LCY)" * 0.5));
    end;
}