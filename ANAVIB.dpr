program ANAVIB;

uses
  System.StartUpCopy,
  FMX.Forms,
  principal in 'principal.pas' {formPrincipal},
  Configuracion in 'Configuracion.pas' {formConfiguracion},
  Login in 'Login.pas' {formLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TformConfiguracion, formConfiguracion);
  Application.CreateForm(TformLogin, formLogin);
  Application.Run;
end.
