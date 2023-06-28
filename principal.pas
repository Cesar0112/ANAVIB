unit principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, Configuracion,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.ExtCtrls, FMX.Controls.Presentation, FMX.StdCtrls, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Controls3D, FMXTee.Chart3D, FMXTee.Series;

type

  TForm1 = class(TForm)
    mainMenu: TMainMenu;
    opcionRuta: TMenuItem;
    opcionSalir: TMenuItem;
    opcionRutaVer: TMenuItem;
    Configuración: TMenuItem;
    opcionAnalisisTendencia: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    btnMostrar: TButton;
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
    opcFrecuenciaMuestreo: TMenuItem;

    procedure opcionSalirClick(Sender: TObject);
    procedure btnMostrarClick(Sender: TObject);
    procedure opcFrecuenciaMuestreoClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  { A esta funcion se le pasa un arreglo de amplitudes que son de tipo Double }
function CalcularVRMS(const valoresSenial: array of Double): Double;

var
  Form1: TForm1;
  ventanaConfiguracion: TForm2;

implementation

{$R *.fmx}

procedure TForm1.btnMostrarClick(Sender: TObject);
var
  i: Integer;
  x, y: Double;
begin
  graficoSenial.Series[0].Clear; // Limpia los datos previos del gráfico

  for i := 0 to 1000 do // Genera los datos de la función de señal
  begin
    x := i / 100; // Valores de x
    // Calcula el valor de y para la función de señal (en este caso, seno)
    y := Sin(x);

    graficoSenial.Series[0].AddXY(x, y); // Agrega los puntos al gráfico
  end;
end;

procedure TForm1.opcFrecuenciaMuestreoClick(Sender: TObject);
begin
  ventanaConfiguracion := TForm2.Create(Self);
  ventanaConfiguracion.Show;
end;

procedure TForm1.opcionSalirClick(Sender: TObject);
begin
  close;
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
//esta funcion devuelve el pico minimo
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
end.
