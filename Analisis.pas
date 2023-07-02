unit Analisis;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Menus, FMXTee.Series;

type
  TAnalisisTendenciario = class(TForm)
    Chart1: TChart;
    Series1: TFastLineSeries;
    MenuBar1: TMenuBar;
    opciones: TMenuItem;
    Diario: TMenuItem;
    Semanal: TMenuItem;
    Mensual: TMenuItem;
    Anual: TMenuItem;
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
