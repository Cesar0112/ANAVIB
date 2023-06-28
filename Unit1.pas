unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
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

    procedure opcionSalirClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function CalcularVRMS(const valoresSenial: array of Double): Double;

var
  Form1: TForm1;

implementation

{$R *.fmx}

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
  VRMS := sqrt((1 / N) * sumatoria);//se aplica la formula
  Result := VRMS;//se retorna el valor
end;

end.
