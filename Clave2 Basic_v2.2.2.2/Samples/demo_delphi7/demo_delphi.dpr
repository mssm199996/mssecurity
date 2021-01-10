program demo_delphi;



{%File 'Sense_LC.inc'}

uses
  Forms,
  demo_delphi7 in 'demo_delphi7.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
