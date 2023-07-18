program ANAVIB;

uses
  System.StartUpCopy,
  FMX.Forms,
  Login in 'Login.pas' {formLogin},
  principal in 'principal.pas' {formPrincipal},
  Configuracion in 'Configuracion.pas' {formConfiguracion},
  Analisis in 'Analisis.pas' {AnalisisTendenciario},
  Rutas in 'Rutas.pas' {ventanaRutas},
  Usuarios in 'Usuarios.pas' {formUsuarios},
  Seguridad in 'Seguridad.pas',
  Seleccion in 'Seleccion.pas'{ventanaSeleccion};


{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformLogin, formLogin);
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TformConfiguracion, formConfiguracion);
  Application.CreateForm(TAnalisisTendenciario, AnalisisTendenciario);
  Application.CreateForm(TventanaRutas, ventanaRutas);
  Application.CreateForm(TformUsuarios, formUsuarios);
  Application.CreateForm(TventanaSeleccion, ventanaSeleccion);
  Application.Run;
end.
