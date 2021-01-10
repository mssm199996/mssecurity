program LCDemo;

uses
  Windows,
  ComObj,
  Forms,
  Main in 'Main.pas' {MainForm},
  LCMod in 'LCMod.pas',
  LC_FULLLib_TLB in 'LC_FULLLib_TLB.pas';

//LC_FULLLib_TLB in 'LC_FULLLib_TLB.pas';

{$R *.res}
begin
  Application.Initialize;
  Try
      Application.Title := 'iToken LC Control Demo - Delphi';
  Application.CreateForm(TMainForm, MainForm);
  Except
    begin
      Application.MessageBox('Cannot find control,Please confirm LC_AUTH_FULL.dll has already registered!', 'Warning');
      Exit;
    end;
  End;
  Application.Run;
end.
