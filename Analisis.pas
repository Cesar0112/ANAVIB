unit Analisis;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Menus, FMXTee.Series;

type
  TAnalisisTendenciario = class(TForm)
    Chart1: TChart;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Series1: TFastLineSeries;
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
