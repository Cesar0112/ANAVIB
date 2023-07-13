program ANAVIB;

uses
  System.StartUpCopy,
  FMX.Forms,
  Login in 'Login.pas' {formLogin},
  principal in 'principal.pas' {formPrincipal},
  Configuracion in 'Configuracion.pas' {formConfiguracion},
  Analisis in 'Analisis.pas' {AnalisisTendenciario},
  Rutas in 'Rutas.pas' {ventanaRutas};

//ConexionDB in 'ConexionDB.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformLogin, formLogin);
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TformConfiguracion, formConfiguracion);
  Application.CreateForm(TAnalisisTendenciario, AnalisisTendenciario);
  Application.CreateForm(TventanaRutas, ventanaRutas);
  //Application.CreateForm(TDM, DM);
  Application.Run;
end.
