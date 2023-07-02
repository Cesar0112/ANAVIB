program ANAVIB;

uses
  System.StartUpCopy,
  FMX.Forms,
  principal in 'principal.pas' {formPrincipal},
  Configuracion in 'Configuracion.pas' {formConfiguracion},
  Login in 'Login.pas' {formLogin};
  //ConexionDB in 'ConexionDB.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TformConfiguracion, formConfiguracion);
  Application.CreateForm(TformLogin, formLogin);
  //Application.CreateForm(TDM, DM);
  Application.Run;
end.
