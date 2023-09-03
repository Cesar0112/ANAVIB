program ANAVIB;

uses
  System.StartUpCopy,
  FMX.Forms,
  Login in 'Src\Visual\Login.pas' {formLogin},
  principal in 'Src\Visual\principal.pas' {formPrincipal},
  Rutas in 'Src\Visual\Rutas.pas' {ventanaRutas},
  Usuarios in 'Src\Visual\Usuarios.pas' {formUsuarios},
  CambioDeUbicacion in 'Src\Visual\CambioDeUbicacion.pas' {Form1},
  Configuracion in 'Src\Visual\Configuracion.pas' {formConfiguracion},
  Analisis in 'Src\Visual\Analisis.pas' {AnalisisTendenciario},
  Seleccion in 'Src\Visual\Seleccion.pas' {ventanaSeleccion},
  fftCalculo in 'Src\Logic\fftCalculo.pas',
  Seguridad in 'Src\Logic\Seguridad.pas',
  MetodoConfiguracion in 'Src\Logic\MetodoConfiguracion.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformLogin, formLogin);
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TventanaRutas, ventanaRutas);
  Application.CreateForm(TformUsuarios, formUsuarios);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TformConfiguracion, formConfiguracion);
  Application.CreateForm(TAnalisisTendenciario, AnalisisTendenciario);
  Application.CreateForm(TventanaSeleccion, ventanaSeleccion);
  Application.Run;
end.
