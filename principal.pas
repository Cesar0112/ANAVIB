unit principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Configuracion, Login,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.ExtCtrls, FMX.Controls.Presentation, FMX.StdCtrls, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Controls3D, FMXTee.Chart3D, FMXTee.Series,
  Data.DB, Data.SqlExpr, Data.DbxSqlite;

type

  TformPrincipal = class(TForm)
    mainMenu: TMainMenu;
    opcionRuta: TMenuItem;
    opcionSalir: TMenuItem;
    opcionRutaVer: TMenuItem;
    Configuraci�n: TMenuItem;
    opcionAnalisisTendencia: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    btnPlayPausa: TButton;
    btnCongelar: TButton;
    graficoSenial: TChart;
    Series1: TFastLineSeries;
    lblPicoMax: TLabel;
    lblPicoMin: TLabel;
    lblRMS: TLabel;
    label2: TLabel;
    valoresGlobales: TGroupBox;
    lblMuestraValorRMS: TLabel;
    lblMuestraValorPicoMaximo: TLabel;
    lblMuestraValorPicoMinimo: TLabel;
    lblMuestraValorDePicoPico: TLabel;
    btnRegistrar: TButton;
    comandosGrafico: TGroupBox;
    graficoEspectro: TChart;
    FastLineSeries1: TFastLineSeries;
    panelPrincipal: TPanel;
    Timer1: TTimer;

    procedure opcionSalirClick(Sender: TObject);
    procedure btnPlayPausaClick(Sender: TObject);
    procedure opcFrecuenciaMuestreoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  { A esta funcion se le pasa un arreglo de amplitudes que son de tipo Double }
function CalcularVRMS(const valoresSenial: array of Double): Double;
function MostrarLogin(): Boolean;
function generarValorALeatorio(): Double;

var
  formPrincipal: TformPrincipal;
  ventanaConfiguracion: TformConfiguracion;
  ventanaLogin: TformLogin;
  FrecMuestreo: Integer; // en milisegundos
  isPlay: Boolean;
  xAnt: Integer;

implementation

{$R *.fmx}

procedure TformPrincipal.btnPlayPausaClick(Sender: TObject);
var
  i: Integer;
  x, y: Double;
  Pausa: String;
  Play: String;
begin

  // establesco el intervalo de cambio de reloj con la configuracion
  Timer1.Interval := FrecMuestreo;
  Pausa:='Pausa';
  Play:='Play';
  if btnPlayPausa.Text = Pausa then
    btnPlayPausa.Text:= Play
  else
    btnPlayPausa.Text := Pausa;

  Timer1.Enabled := not Timer1.Enabled; // cambia el estado del reloj
end;

function MostrarLogin(): Boolean;
begin
  ventanaLogin := TformLogin.Create(Application);
  ventanaLogin.Visible := True;
  ventanaLogin.Active := True;
  ventanaLogin.ShowModal;
  ventanaLogin.ComboEditUser.SetFocus;
  Result := False;
  while not ventanaLogin.isValido do
  begin

  end;

  if ventanaLogin.isValido then
    Result := True;
end;

procedure TformPrincipal.FormCreate(Sender: TObject);
begin
  FrecMuestreo := 10; // milisegundos
  graficoSenial.Series[0].Clear; // Limpia los datos previos del gr�fico
  Visible := False;
  xAnt := 0; // inicializa en 0 pq el tiempo empieza en 0
  {
    isPlay inicializa en false ya que inicia la aplicacion y no se ha corrido
    nunca el mostrar grafico

  }
  isPlay := False;

  if MostrarLogin then
    Visible := True;
end;

procedure TformPrincipal.FormShow(Sender: TObject);
begin
  Timer1.Interval := FrecMuestreo;
  Timer1.Enabled := True;

end;

procedure TformPrincipal.opcFrecuenciaMuestreoClick(Sender: TObject);
begin
  ventanaConfiguracion := TformConfiguracion.Create(Self);
  ventanaConfiguracion.Show;

end;

procedure TformPrincipal.opcionSalirClick(Sender: TObject);
begin
  close;
end;

procedure TformPrincipal.Timer1Timer(Sender: TObject);
var
  x: Double;
begin
  {
    Cada vez que marque un intervalo refresca el grafico
  }

  x := (xAnt + FrecMuestreo) / 1000;
  xAnt := xAnt + FrecMuestreo;
  graficoSenial.Series[0].AddXY(x, generarValorALeatorio());
end;

function CalcularVRMS(const valoresSenial: array of Double): Double;
var
  i, N: Integer; // N tamanio del arreglo
  sumatoria, VRMS: Double;
begin
  { Funcion que devuelve el valor RMS con paramtros
    una lista de valores double
    mediante la formula: Vrms = sqrt((1/N) * sum(x^2)) }
  N := Length(valoresSenial); // obtengo el tamanio del arreglo
  sumatoria := 0;
  // calcula la sumatoria de cada valor del arreglo al cuadrado
  for i := 0 to N - 1 do
    sumatoria := sumatoria + valoresSenial[i] * valoresSenial[i];
  VRMS := sqrt((1 / N) * sumatoria); // se aplica la formula
  Result := VRMS; // se retorna el valor
end;

{ funcion que devuelve el valor maximo de un arreglo de double
  que es el pico maximo
}
function VPicoMax(const valoresSenial: array of Double): Double;
var
  i, N: Integer;
  maximo: Double;

begin
  N := Length(valoresSenial);
  maximo := valoresSenial[0];
  // asigno el primer valor del arreglo para no compararlo despues por gusto
  for i := 1 to N - 1 do
  begin
    if valoresSenial[i] > maximo then
      maximo := valoresSenial[i];
  end;
  Result := maximo;
end;

// esta funcion devuelve el pico minimo
function VPicoMin(const valoresSenial: array of Double): Double;
var
  i, N: Integer;
  minimo: Double;

begin
  N := Length(valoresSenial);
  minimo := valoresSenial[0];
  // asigno el primer valor del arreglo para no compararlo despues por gusto
  for i := 1 to N - 1 do
  begin
    if valoresSenial[i] < minimo then
      minimo := valoresSenial[i];
  end;
  Result := minimo;
end;

function generarValorALeatorio(): Double;
var
  i: Integer;
  yTmp1, yTmp2, SbFreq1, y: Double;

begin
  Randomize; // inicializo el motor de aleatoridad

  SbFreq1 := Random(100) + 1;
  yTmp1 := 100 - SbFreq1;
  SbFreq1 := Random(100) + 1;
  yTmp2 := 100 - SbFreq1;
  y := 100 * (Sin(0.01 * i * (yTmp1)) + 0.05 * (Random(Trunc(yTmp2)) - 0.05 *
    (yTmp2)));
  Result := y;

end;

end.
