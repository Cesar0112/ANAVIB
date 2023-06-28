program Project1;

uses
  System.StartUpCopy,
  FMX.Forms,
  principal in 'principal.pas' {Form1},
  Configuracion in 'Configuracion.pas' {formConfiguracion};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TformConfiguracion, formConfiguracion);
  Application.Run;
end.
