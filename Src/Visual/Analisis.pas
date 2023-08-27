unit Analisis;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, UASUtilesDB,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Menus, FMXTee.Series, FMXTee.Chart.Functions,
  FMX.Controls.Presentation, FMX.StdCtrls, Data.DB, ZAbstractRODataset,
  ZDataset, ZAbstractConnection, ZConnection;

type
  TAnalisisTendenciario = class(TForm)
    graficoSenial: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series4: TFastLineSeries;
    Label1: TLabel;
    asd: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblMediaRMS: TLabel;
    lblMediaPicoMax: TLabel;
    lblMediaPicoMin: TLabel;
    lblMediaPicoPico: TLabel;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    ZConnection1: TZConnection;
    Label2: TLabel;
    Label6: TLabel;
    lblVarRms: TLabel;
    lblVarMax: TLabel;
    lblVarPicoMin: TLabel;
    lblVarPicos: TLabel;
    lblDesRms: TLabel;
    lblDesMax: TLabel;
    lblDesMin: TLabel;
    lblDesPicos: TLabel;
    StyleBook1: TStyleBook;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AnalisisTendenciario: TAnalisisTendenciario;
  arrayRms, arrayMax, arrayMin, arrayPicos: array of Double;

implementation

{$R *.fmx}

procedure TAnalisisTendenciario.FormShow(Sender: TObject);
var
  consulta, consultaAVG, consultaSTDDEV, consultaVAR, consultaMedian: String;

  cant, i: Integer;
begin
  ZConnection1.Connect;
  consultaAVG :=
    'SELECT AVG(RMS) as avg_rms,AVG(PICO_Max) as avg_max,AVG(PICO_Min) as avg_min, AVG(PICO_Max-PICO_Min) as avg_picos FROM señales';

  consultaSTDDEV :=
    'SELECT STDDEV(RMS) as devrms,STDDEV(PICO_Max) as devmax,STDDEV(PICO_Min) as devmin, STDDEV(PICO_Max-PICO_Min) as devpicos FROM señales';

  consultaVAR :=
    'SELECT VARIANCE(RMS) as varrms,VARIANCE(PICO_Max) as varmax,VARIANCE(PICO_Min) as varmin, VARIANCE(PICO_Max-PICO_Min) as varpicos FROM señales';

  consultaMedian :=
    'SELECT MEDIAN(RMS) as medrms,MEDIAN(PICO_Max) as medmax,MEDIAN(PICO_Min) as medmin, MEDIAN(PICO_Max-PICO_Min) as medpicos FROM señales';

  if ZConnection1.Connected then
  begin
    ConsultaSQL(ZReadOnlyQuery1, consultaAVG);
    lblMediaRMS.Text := ZReadOnlyQuery1.FieldByName('avg_rms').AsString;
    lblMediaPicoMax.Text := ZReadOnlyQuery1.FieldByName('avg_max').AsString;
    lblMediaPicoMin.Text := ZReadOnlyQuery1.FieldByName('avg_min').AsString;
    lblMediaPicoPico.Text := ZReadOnlyQuery1.FieldByName('avg_picos').AsString;
    // varianza
    { ConsultaSQL(ZReadOnlyQuery1,consultaVAR);
      lblVarRms.Text:=ZReadOnlyQuery1.FieldByName('varrms').AsString;
      lblVarMax.Text:=ZReadOnlyQuery1.FieldByName('varmax').AsString;
      lblVarPicoMin.Text:=ZReadOnlyQuery1.FieldByName('varmin').AsString;
      lblVarPicos.Text:=ZReadOnlyQuery1.FieldByName('varpicos').AsString;
      //desviacion
      ConsultaSQL(ZReadOnlyQuery1,consultaSTDDEV);
      lblDesRms.Text:=ZReadOnlyQuery1.FieldByName('devrms').AsString;
      lblDesMax.Text:=ZReadOnlyQuery1.FieldByName('devmax').AsString;
      lblDesMin.Text:=ZReadOnlyQuery1.FieldByName('devmin').AsString;
      lblDesPicos.Text:=ZReadOnlyQuery1.FieldByName('devpicos').AsString;
    }
    consulta := 'SELECT count(*) as cantd FROM señales';

    ConsultaSQL(ZReadOnlyQuery1, consulta);

    cant := ZReadOnlyQuery1.FieldByName('cantd').AsInteger;
    SetLength(arrayRms, cant);
    SetLength(arrayMax, cant);
    SetLength(arrayMin, cant);
    SetLength(arrayPicos, cant);
    consulta :=
      'SELECT RMS ,PICO_Max as max, PICO_Min as min,(PICO_Max-PICO_Min) as picos FROM señales';
    i := 0;
    ConsultaSQL(ZReadOnlyQuery1, consulta);
    while not ZReadOnlyQuery1.Eof do
    begin
      arrayRms[i] := ZReadOnlyQuery1.FieldByName('RMS').AsFloat;
      arrayMax[i] := ZReadOnlyQuery1.FieldByName('max').AsFloat;
      arrayMin[i] := ZReadOnlyQuery1.FieldByName('min').AsFloat;
      arrayPicos[i] := ZReadOnlyQuery1.FieldByName('picos').AsFloat;
      ZReadOnlyQuery1.Next;
      i := i + 1;
    end;

    graficoSenial.Series[0].AddArray(arrayRms);
    graficoSenial.Series[1].AddArray(arrayMax);
    graficoSenial.Series[2].AddArray(arrayMin);
    graficoSenial.Series[3].AddArray(arrayPicos);
  end;

end;

end.
