program ANAVIB;

uses
  System.StartUpCopy,
  FMX.Forms,
  principal in 'principal.pas' {Form1},
  Configuracion in 'Configuracion.pas' {formConfiguracion},
  Login in 'Login.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TformConfiguracion, formConfiguracion);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
