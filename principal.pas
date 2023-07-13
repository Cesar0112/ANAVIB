unit principal;

interface

uses
  System.SysUtils, Hash, System.Types,
  System.UITypes, System.Classes, DateUtils, Seguridad,
  System.Variants, Configuracion, Analisis, Rutas, UASUtilesDB, Usuarios,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.ExtCtrls, FMX.Controls.Presentation, FMX.StdCtrls, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Controls3D, FMXTee.Chart3D, FMXTee.Series,
  Data.DB, Data.SqlExpr, Data.DbxSqlite, FMX.Layouts, ZAbstractConnection,
  ZConnection, ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  ArrayOfDouble = array of Double;

  TformPrincipal = class(TForm)
    mainMenu: TMainMenu;
    opcionRuta: TMenuItem;
    opcionSalir: TMenuItem;
    opcionRutaManipular: TMenuItem;
    Configuración: TMenuItem;
    opcionAnalisisTendencia: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    btnPlayPausa: TButton;
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
    ZQuery1: TZQuery;
    ZConnection1: TZConnection;
    opcUsuarios: TMenuItem;
    opcGestion: TMenuItem;

    procedure opcionSalirClick(Sender: TObject);
    procedure btnPlayPausaClick(Sender: TObject);
    procedure opcFrecuenciaMuestreoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure opcionAnalisisTendenciaClick(Sender: TObject);
    procedure ConfiguraciónClick(Sender: TObject);
    procedure opcionRutaManipularClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure opcUsuariosClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    x: Double;

  end;

  { A esta funcion se le pasa un arreglo de amplitudes que son de tipo Double }
function CalcularVRMS(const valoresSenial: ArrayOfDouble): Double;
function generarValorALeatorio(): Double;
function ValueListToArrayOfDouble(ValueList: TChartValueList): ArrayOfDouble;

function getUUIDs: String;

procedure insertarSenial(senial: array of Double);

var
  formPrincipal: TformPrincipal;
  ventanaConfiguracion: TformConfiguracion;
  ventanaAnalisis: TAnalisisTendenciario;

  FrecMuestreo: Integer; // en milisegundos
  isPlay: Boolean;
  xAnt: Integer;

implementation

{$R *.fmx}

procedure TformPrincipal.btnPlayPausaClick(Sender: TObject);
var
  i: Integer;
  Pausa: String;
  Play: String;
begin

  // establesco el intervalo de cambio de reloj con la configuracion
  Timer1.Interval := FrecMuestreo;
  Pausa := 'Pausa';
  Play := 'Play';
  if btnPlayPausa.Text = Pausa then
    btnPlayPausa.Text := Play
  else
    btnPlayPausa.Text := Pausa;

  Timer1.Enabled := not Timer1.Enabled; // cambia el estado del reloj

end;

procedure TformPrincipal.btnRegistrarClick(Sender: TObject);
begin
  // va a registrar todos los datos de la señal en la base de datos
  if Timer1.Enabled then
    btnPlayPausaClick(Sender);

  insertarSenial(ValueListToArrayOfDouble(graficoSenial.Series[0].YValues));
  // le paso a la base de datos el arreglo
end;

procedure TformPrincipal.ConfiguraciónClick(Sender: TObject);
begin
  ventanaConfiguracion := TformConfiguracion.Create(Nil);
  ventanaConfiguracion.Show;
end;

procedure TformPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Halt;
end;

procedure TformPrincipal.FormCreate(Sender: TObject);
begin
  FrecMuestreo := 10;
  // configuracion inicial aunque despues va a cambiar por el archivo Config.cfg
  graficoSenial.Series[0].Clear; // Limpia los datos previos del gráfico
  xAnt := 0; // inicializa en 0 pq el tiempo empieza en 0
  x := 0; // inicializa en 0 pq el tiempo empieza en 0
  {
    isPlay inicializa en false ya que inicia la aplicacion y no se ha corrido
    nunca el mostrar grafico

  }
  isPlay := False;

end;

procedure TformPrincipal.FormShow(Sender: TObject);
begin
  Timer1.Interval := FrecMuestreo;
  Timer1.Enabled := True;

  //restricciones de privilegios
  if usuario <> 'admin' then
    begin
    opcUsuarios.Visible := False;
    opcionRutaManipular.Visible:=False;
    end;


end;

procedure TformPrincipal.opcFrecuenciaMuestreoClick(Sender: TObject);
begin
  ventanaConfiguracion := TformConfiguracion.Create(Self);
  ventanaConfiguracion.Show;

end;

procedure TformPrincipal.opcionAnalisisTendenciaClick(Sender: TObject);
begin
  ventanaAnalisis := TAnalisisTendenciario.Create(Self);
  ventanaAnalisis.Show;
end;

procedure TformPrincipal.opcionRutaManipularClick(Sender: TObject);
var
  ventanaRutas: TventanaRutas;
begin
  ventanaRutas := TventanaRutas.Create(Self);
  ventanaRutas.Show;
end;

procedure TformPrincipal.opcionSalirClick(Sender: TObject);
begin
  Halt;
end;

procedure TformPrincipal.Timer1Timer(Sender: TObject);
var
  y, picoMax, picoMin, difPicos, RMS: Double;

begin
  {
    Cada vez que marque un intervalo refresca el grafico agrgando un valor
    aleatorio de señal
    Ademas de:
    1- Calcular el valor del pico maximo
    2- Calcular el valor del pico mínimo
  }

  // generacion del grafico de señal
  y := generarValorALeatorio();
  graficoSenial.Series[0].AddXY(x, y);
  x := (xAnt + FrecMuestreo) / 1000;
  xAnt := xAnt + FrecMuestreo;
  /// /////////////////////////////
  picoMax := graficoSenial.Series[0].MaxYValue;
  picoMin := graficoSenial.Series[0].MinYValue;
  difPicos := picoMax - picoMin;
  RMS := CalcularVRMS(ValueListToArrayOfDouble(graficoSenial.Series[0]
    .YValues));
  lblMuestraValorPicoMaximo.Text := floatToStr(picoMax);
  lblMuestraValorPicoMinimo.Text := floatToStr(picoMin);
  lblMuestraValorDePicoPico.Text := floatToStr(difPicos);
  lblMuestraValorRMS.Text := floatToStr(RMS);
end;

procedure TformPrincipal.opcUsuariosClick(Sender: TObject);
var
  ventanaUsuarios: TformUsuarios;
begin
  ventanaUsuarios := TformUsuarios.Create(Self);
  ventanaUsuarios.Visible := True;
end;

function CalcularVRMS(const valoresSenial: ArrayOfDouble): Double;
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

{
  Funcion que convierte un TChartValueList a TDoubleDynArray
}
function ValueListToArrayOfDouble(ValueList: TChartValueList): ArrayOfDouble;
var
  ValueArrayOfDouble: ArrayOfDouble;
  i: Integer;
begin
  SetLength(ValueArrayOfDouble, ValueList.Count);
  for i := 0 to ValueList.Count - 1 do
  begin
    ValueArrayOfDouble[i] := ValueList[i];
  end;

  Result := ValueArrayOfDouble;
end;

{ Funcion generadora de UUIDs para los ids de las tablas }
function getUUIDs: String;
Var
  uuids: TGUID;
begin
  CreateGUID(uuids); // crea el uuids
  Result := GUIDToString(uuids); // lo convierto a string y listo para usar
end;

procedure insertarSenial(senial: array of Double);
var
  streamSenial: TMemoryStream; // en bytes esto es lo que va a la BD
  consulta: String;
  i: Integer;
begin
  streamSenial := TMemoryStream.Create;
  consulta :=
    'INSERT INTO señales (ID_Señal,Dia,Mes,Año,Frecuencia,RMS,PICO_Max,PICO_Min,Hora,Minuto,Segundo,Señal) VALUES (:id,:dia,:mes,:anio,:frecuencia,:rms,:picoMax,:picoMin,:hora,:minuto,:segundo,:senial);';

  try
    for i := 0 to Length(senial) - 1 do
    begin
      streamSenial.Write(senial[i], SizeOf(Double));
    end;

    { Posicion inicial en 0 para q lea el stream desde el principio }
    streamSenial.Position := 0;

    if formPrincipal.ZQuery1.Active then
      formPrincipal.ZQuery1.close;
    formPrincipal.ZQuery1.SQL.Clear;
    formPrincipal.ZQuery1.SQL.Add(consulta);
    // establece en la consulta a los parametros los valores q le corresponden
    { :id,:dia,:mes,:anio,:frecuencia,:rms,:picoMax,:picoMin,:hora,:minuto,:segundo,:senial }
    formPrincipal.ZQuery1.Params.ParamByName('id').AsString := getUUIDs;
    formPrincipal.ZQuery1.Params.ParamByName('dia').AsInteger := DayOf(Now);
    formPrincipal.ZQuery1.Params.ParamByName('mes').AsInteger := MonthOf(Now);
    formPrincipal.ZQuery1.Params.ParamByName('anio').AsInteger := YearOf(Now);
    formPrincipal.ZQuery1.Params.ParamByName('frecuencia').AsInteger :=
      FrecMuestreo;
    formPrincipal.ZQuery1.Params.ParamByName('rms').AsFloat :=
      StrToFloat(formPrincipal.lblMuestraValorRMS.Text);
    formPrincipal.ZQuery1.Params.ParamByName('picoMax').AsFloat :=
      StrToFloat(formPrincipal.lblMuestraValorPicoMaximo.Text);
    formPrincipal.ZQuery1.Params.ParamByName('picoMin').AsFloat :=
      StrToFloat(formPrincipal.lblMuestraValorPicoMinimo.Text);
    formPrincipal.ZQuery1.Params.ParamByName('hora').AsInteger := HourOf(Now);
    formPrincipal.ZQuery1.Params.ParamByName('minuto').AsInteger :=
      MinuteOf(Now);
    formPrincipal.ZQuery1.Params.ParamByName('segundo').AsInteger :=
      SecondOf(Now);
    formPrincipal.ZQuery1.Params.ParamByName('senial')
      .LoadFromStream(streamSenial, ftBlob);
    formPrincipal.ZQuery1.ExecSQL;

  finally
    streamSenial.Free;
  end;

end;

end.
