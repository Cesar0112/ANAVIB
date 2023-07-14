unit Analisis;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Menus, FMXTee.Series, FMXTee.Chart.Functions;

type
  TAnalisisTendenciario = class(TForm)
    MenuBar1: TMenuBar;
    opciones: TMenuItem;
    Diario: TMenuItem;
    Semanal: TMenuItem;
    Mensual: TMenuItem;
    Anual: TMenuItem;
    graficoSenial: TChart;
    Series2: TFastLineSeries;
    TeeFunction1: TAverageTeeFunction;
    Series1: TFastLineSeries;
    TeeFunction2: TAverageTeeFunction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AnalisisTendenciario: TAnalisisTendenciario;

implementation

{$R *.fmx}

end.
