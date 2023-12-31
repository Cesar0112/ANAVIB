unit principal;

interface

uses
  System.SysUtils, System.StrUtils, Hash, System.Types, System.Math,
  System.UITypes, System.Classes, DateUtils, Seguridad, Seleccion,
  System.Variants, Configuracion, Analisis, Rutas, UASUtilesDB, Usuarios,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  FMX.ExtCtrls, FMX.Controls.Presentation, FMX.StdCtrls, FMXTee.Engine,
  FMXTee.Procs, FMXTee.Chart, FMX.Controls3D, FMXTee.Chart3D, FMXTee.Series,
  Data.DB, Data.SqlExpr, Data.DbxSqlite, FMX.Layouts, ZAbstractConnection,
  ZConnection, ZAbstractRODataset, ZAbstractDataset, ZDataset, FMX.ListBox,
  fftCalculo, Winapi.Windows, LPComponent, SLCommonFilter, SLBasicGenericReal,
  SLGenericReal, Mitov.Types, SLCommonGen, SLRandomGen, SLFourier,
  MetodoConfiguracion;

type
  ArrayOfDouble = array of Double;

  Complex = record
    re, im: Double;
  end;

  ComplexArray = array of Complex;

  TformPrincipal = class(TForm)
    mainMenu: TMainMenu;
    opcionRuta: TMenuItem;
    opcionSalir: TMenuItem;
    opcionAnalisisTendencia: TMenuItem;
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
    LabelRuta: TLabel;
    ComboBoxRutas: TComboBox;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    opcDriver: TMenuItem;
    Label4: TLabel;
    lblModo: TLabel;
    opcModo: TMenuItem;
    opcRuta: TMenuItem;
    opcSimple: TMenuItem;
    StyleClaro: TStyleBook;
    StyleOscuro: TStyleBook;
    R: TScrollBox;
    MenuItem1: TMenuItem;
    opcVisualClaro: TMenuItem;
    MenuItem3: TMenuItem;
    RandomGenerator: TSLRandomGen;
    SLGenericReal1: TSLGenericReal;
    SLFourier1: TSLFourier;
    SLGenericReal2: TSLGenericReal;
    btnPlayPause: TButton;

    procedure opcionSalirClick(Sender: TObject);
    procedure opcFrecuenciaMuestreoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure opcionAnalisisTendenciaClick(Sender: TObject);
    procedure Configuraci�nClick(Sender: TObject);
    procedure opcionRutaManipularClick(Sender: TObject);
    procedure btnRegistrarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure opcUsuariosClick(Sender: TObject);
    procedure opcDriverClick(Sender: TObject);
    procedure opcRutaClick(Sender: TObject);
    procedure opcSimpleClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure opcAutenticarClick(Sender: TObject);
    procedure opcionRutaClick(Sender: TObject);
    procedure opcVisualClaroClick(Sender: TObject);
    procedure SLGenericReal1ProcessData(ASender: TObject;
      AInBuffer: ISLRealBuffer; var AOutBuffer: ISLRealBuffer;
      var ASendOutputData: Boolean);
    procedure SLGenericReal2ProcessData(ASender: TObject;
      AInBuffer: ISLRealBuffer; var AOutBuffer: ISLRealBuffer;
      var ASendOutputData: Boolean);
    procedure btnPlayPauseClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    x: Double;
    id_RoleActual: Integer;
    id_UsuarioActual: Integer;
    RutaActual: String;
    id_RutaActual: Integer;
    listado_mediciones: TStringList;
    indice_medicion_actual: Integer;
    tamanio_list_mediciones: Integer;
    data_global: ArrayOfDouble;
  end;

  { A esta funcion se le pasa un arreglo de amplitudes que son de tipo Double }
function CalcularVRMS(const valoresSenial: ArrayOfDouble): Double;
function generarValorALeatorio(): Double;
function ValueListToArrayOfDouble(ValueList: TChartValueList): ArrayOfDouble;
function getMediciones(ruta_etiqueta: String): TStringList;
function getUUIDs: String;
function GenerateSinArray(n: Integer): TArray<Double>;
procedure insertarSenial(signal: array of Double);
procedure llenarcomboMaquinas;
procedure cargarEstilo(var Ventana: TformPrincipal);

var
  formPrincipal: TformPrincipal;
  ventanaConfiguracion: TformConfiguracion;
  ventanaAnalisis: TAnalisisTendenciario;

  // FrecMuestreo: Integer; // en milisegundos
  isPlay: Boolean;
  xAnt: Integer;
  i_global: Integer;

implementation

{$R *.fmx}

procedure TformPrincipal.btnPlayPauseClick(Sender: TObject);
begin
  // Boton que detiene y reanuda la captura de la se�al
  if btnPlayPause.StyleLookup <> 'playtoolbutton' then
  begin
    btnPlayPause.StyleLookup := 'playtoolbutton';
    Timer1.Enabled := true;
  end
  else
  begin
    btnPlayPause.StyleLookup := 'pausetoolbutton';
    Timer1.Enabled := false;
  end;

end;

procedure TformPrincipal.btnRegistrarClick(Sender: TObject);
begin
  // va a registrar todos los datos de la se�al en la base de datos
  if Timer1.Enabled then
  begin
    btnPlayPause.StyleLookup := 'pausetoolbutton';
    Timer1.Enabled := false;
  end;

  data_global := ValueListToArrayOfDouble(graficoSenial.Series[0].YValues);
  // le paso a la base de datos el arreglo
  insertarSenial(data_global);
  ShowMessageUser('Se�al registrada correctamente');
end;

procedure TformPrincipal.Button1Click(Sender: TObject);
begin

  if tamanio_list_mediciones > 0 then
  begin
    // lblMedicion.Text := listado_mediciones[indice_medicion_actual];
    indice_medicion_actual := indice_medicion_actual + 1;
    tamanio_list_mediciones := tamanio_list_mediciones - 1;
  end
  else
  begin

    // lblMedicion.Text := '';
    MessageDlg('Final de las mediciones', TMsgDlgType.mtInformation,
      [TMsgDlgBtn.mbOK], 0);
  end;

end;

procedure TformPrincipal.Button2Click(Sender: TObject);
begin
  if indice_medicion_actual < 1 then
  begin
    // Button2.Visible := False;
  end
  else
  begin
    // lblMedicion.Text := listado_mediciones[indice_medicion_actual - 1];
    indice_medicion_actual := indice_medicion_actual - 1;
    tamanio_list_mediciones := tamanio_list_mediciones + 1;
  end;

end;

procedure TformPrincipal.Configuraci�nClick(Sender: TObject);
begin
  ventanaConfiguracion := TformConfiguracion.Create(Nil);
  ventanaConfiguracion.ShowModal;
end;

procedure TformPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Halt;
end;

procedure TformPrincipal.FormCreate(Sender: TObject);
begin

  graficoSenial.Series[0].Clear; // Limpia los datos previos del gr�fico
  xAnt := 0; // inicializa en 0 pq el tiempo empieza en 0
  x := 0; // inicializa en 0 pq el tiempo empieza en 0
  {
    isPlay inicializa en false ya que inicia la aplicacion y no se ha corrido
    nunca el mostrar grafico

  }
  isPlay := false;

end;

procedure TformPrincipal.FormShow(Sender: TObject);
var
  list_aux: TStringList;
  elemento: String;

begin
  cargarConfiguracion;
  cargarEstilo(Self);
  Timer1.Interval := FrecMuestreo;
  Timer1.Enabled := true;
  i_global := 0;
  // Llena el combo de rutas
  if ZConnection1.Connected then
  begin
    llenarcomboeditRutas;
    ComboBoxRutas.Items.Assign(listado_rutas);
    ComboBoxRutas.ItemIndex := 0;
  end;
  // restricciones de privilegios
  // si no es administrador no se muestra la gestion->usuarios
  if id_RoleActual <> 1 then
  begin
    opcUsuarios.Visible := false;
    // opcionRutaManipular.Visible := False;
  end;
  if id_RoleActual = 3 then
  begin
    btnRegistrar.Visible := false;
    opcGestion.Visible := false;
  end;

  { llenar mediciones }
  listado_mediciones := TStringList.Create;
  list_aux := TStringList.Create;
  list_aux := getMediciones(ComboBoxRutas.Items[ComboBoxRutas.ItemIndex]);

  for elemento in list_aux do
  begin
    listado_mediciones.Add(elemento);
    tamanio_list_mediciones := tamanio_list_mediciones + 1;
  end;

  indice_medicion_actual := 0;
  // si tiene al menos un elemento
  if tamanio_list_mediciones > 0 then
  begin
    // lblMedicion.Text := listado_mediciones[indice_medicion_actual];
    indice_medicion_actual := indice_medicion_actual + 1;
    tamanio_list_mediciones := tamanio_list_mediciones - 1;
  end;

  if indice_medicion_actual < 1 then
  begin
    // Button2.Visible := False;
  end;

end;

procedure TformPrincipal.MenuItem3Click(Sender: TObject);
begin
  /// Cuando de click se va a poner el tema claro y va a cambiar las configuraciones
  /// en el txt de config.cfg
  if not(Self.StyleBook = StyleOscuro) then
  begin
    Self.StyleBook := StyleClaro;
    // Aqui llama al metodo que cambia la configuracion
  end;
end;

function GenerateSinArray(n: Integer): TArray<Double>;
var
  i: Integer;
begin
  SetLength(Result, n);
  for i := 0 to n - 1 do
    Result[i] := Sin(2 * Pi * i / n);
end;

function getMediciones(ruta_etiqueta: String): TStringList;
var
  mediciones: TArray<String>;
  camino: String;
  medicion: String;
  listado: TStringList;
begin
  ConsultaSQL(formPrincipal.ZReadOnlyQuery1,
    'SELECT camino FROM rutas WHERE rutas.etiqueta ="' + ruta_etiqueta + '"');
  if not formPrincipal.ZReadOnlyQuery1.IsEmpty then
  begin
    camino := formPrincipal.ZReadOnlyQuery1.FieldByName('camino').AsString;
    mediciones := SplitString(camino, ',');
    listado := TStringList.Create;
    for medicion in mediciones do
    begin
      listado.Add(medicion);
    end;
    Result := listado;
  end;

end;

procedure TformPrincipal.opcAutenticarClick(Sender: TObject);
begin
  // Application.Restart;
end;

procedure TformPrincipal.opcDriverClick(Sender: TObject);
var
  ventanaSeleccion: TventanaSeleccion;
begin
  ventanaSeleccion := TventanaSeleccion.Create(Self);
  ventanaSeleccion.ShowModal;
end;

procedure TformPrincipal.opcFrecuenciaMuestreoClick(Sender: TObject);
begin
  ventanaConfiguracion := TformConfiguracion.Create(Self);
  ventanaConfiguracion.Show;

end;

procedure TformPrincipal.opcionAnalisisTendenciaClick(Sender: TObject);
begin
  ventanaAnalisis := TAnalisisTendenciario.Create(Self);
  ventanaAnalisis.ShowModal;
end;

procedure TformPrincipal.opcionRutaClick(Sender: TObject);
begin
  opcionRutaManipularClick(Sender);
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

procedure TformPrincipal.opcRutaClick(Sender: TObject);
begin
  lblModo.Text := 'Ruta';
  LabelRuta.Visible := true;
  ComboBoxRutas.Visible := true;
  // Label3.Visible := True;
  // lblMedicion.Visible := True;
end;

procedure TformPrincipal.opcSimpleClick(Sender: TObject);
begin
  lblModo.Text := 'Simple';
  LabelRuta.Visible := false;
  ComboBoxRutas.Visible := false;
  // Label3.Visible := False;
  // lblMedicion.Visible := False;
end;

procedure TformPrincipal.Timer1Timer(Sender: TObject);
var
  y, picoMax, picoMin, difPicos, RMS: Double;

begin
  {
    Cada vez que marque un intervalo refresca el grafico agregando un valor
    aleatorio de se�al
    Ademas de:
    1- Calcular el valor del pico maximo
    2- Calcular el valor del pico m�nimo
    3- Calcular RMS
    4- Calcular el valor pico a pico
  }

  RandomGenerator.Pump(); // Le da el siguiente impulso
  picoMax := graficoSenial.Series[0].MaxYValue;
  picoMin := graficoSenial.Series[0].MinYValue;
  difPicos := picoMax - picoMin;
  RMS := CalcularVRMS(ValueListToArrayOfDouble(graficoSenial.Series[0]
    .YValues));
  lblMuestraValorPicoMaximo.Text := floatToStr(RoundTo(picoMax, -2));
  lblMuestraValorPicoMinimo.Text := floatToStr(RoundTo(picoMin, -2));
  lblMuestraValorDePicoPico.Text := floatToStr(RoundTo(difPicos, -2));
  lblMuestraValorRMS.Text := floatToStr(RoundTo(RMS, -2));
  /// /////////////////////////////////////

end;

procedure mostrarFFT();
begin

end;

procedure TformPrincipal.opcUsuariosClick(Sender: TObject);
var
  ventanaUsuarios: TformUsuarios;
begin
  ventanaUsuarios := TformUsuarios.Create(Self);
  ventanaUsuarios.Visible := true;
end;

procedure TformPrincipal.opcVisualClaroClick(Sender: TObject);
begin
  /// Cuando de click se va a poner el tema claro y va a cambiar las configuraciones
  /// en el txt de config.cfg
  if not(Self.StyleBook = StyleClaro) then
  begin
    Self.StyleBook := StyleOscuro;
    // Aqui llama al metodo que cambia la configuracion
  end;
end;

procedure TformPrincipal.SLGenericReal1ProcessData(ASender: TObject;
  AInBuffer: ISLRealBuffer; var AOutBuffer: ISLRealBuffer;
  var ASendOutputData: Boolean);
var
  i: Integer;
begin
  { Este metodo va a mostrar la se�al aleatoria en el TChart de la se�al }
  graficoSenial.Series[0].Clear;

  for i := 0 to AInBuffer.Size - 1 do
    graficoSenial.Series[0].Add(AInBuffer.Items[i], '', clTeeColor);

end;

procedure TformPrincipal.SLGenericReal2ProcessData(ASender: TObject;
  AInBuffer: ISLRealBuffer; var AOutBuffer: ISLRealBuffer;
  var ASendOutputData: Boolean);
var
  i: Integer;
begin
  graficoEspectro.Series[0].Clear;

  for i := 0 to AInBuffer.Size - 1 do
    graficoEspectro.Series[0].Add(AInBuffer.Items[i], '', clTeeColor);
end;

function CalcularVRMS(const valoresSenial: ArrayOfDouble): Double;
{ RMS : Valor eficaz de la se�al }
var
  i, n: Integer; // N tamanio del arreglo
  sumatoria, VRMS: Double;
begin
  { Funcion que devuelve el valor RMS con paramtros
    una lista de valores double
    mediante la formula: Vrms = sqrt((1/N) * sum(x^2)) }
  n := Length(valoresSenial); // obtengo el tamanio del arreglo
  sumatoria := 0;
  // calcula la sumatoria de cada valor del arreglo al cuadrado
  for i := 0 to n - 1 do
    sumatoria := sumatoria + valoresSenial[i] * valoresSenial[i];
  VRMS := sqrt((1 / n) * sumatoria); // se aplica la formula
  Result := VRMS; // se retorna el valor
end;

{ funcion que devuelve el valor maximo de un arreglo de double
  que es el pico maximo
}
function VPicoMax(const valoresSenial: array of Double): Double;
var
  i, n: Integer;
  maximo: Double;

begin
  n := Length(valoresSenial);
  maximo := valoresSenial[0];
  // asigno el primer valor del arreglo para no compararlo despues por gusto
  for i := 1 to n - 1 do
  begin
    if valoresSenial[i] > maximo then
      maximo := valoresSenial[i];
  end;
  Result := maximo;
end;

// esta funcion devuelve el pico minimo
function VPicoMin(const valoresSenial: array of Double): Double;
var
  i, n: Integer;
  minimo: Double;

begin
  n := Length(valoresSenial);
  minimo := valoresSenial[0];
  // asigno el primer valor del arreglo para no compararlo despues por gusto
  for i := 1 to n - 1 do
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

procedure insertarSenial(signal: array of Double);
var
  streamSenial: TMemoryStream; // en bytes esto es lo que va a la BD
  consulta: String;
  i: Integer;
begin
  streamSenial := TMemoryStream.Create;
  consulta :=
    'INSERT INTO se�ales (ID_Se�al,Dia,Mes,A�o,Frecuencia,RMS,PICO_Max,PICO_Min,Hora,Minuto,Segundo,Se�al,fk_id_usuario,fk_id_ruta) VALUES (:id,:dia,:mes,:anio,:frecuencia,:rms,:picoMax,:picoMin,:hora,:minuto,:segundo,:senial,:fk_id_usuario,:fk_id_ruta);';
  formPrincipal.ZConnection1.Connect;
  try
    for i := 0 to Length(signal) - 1 do
    begin
      streamSenial.Write(signal[i], sizeof(Double));
    end;

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
    formPrincipal.ZQuery1.Params.ParamByName('fk_id_ruta').AsInteger :=
      formPrincipal.id_RutaActual;
    formPrincipal.ZQuery1.Params.ParamByName('fk_id_usuario').AsInteger :=
      formPrincipal.id_UsuarioActual;

    formPrincipal.ZQuery1.ExecSQL;

  finally
    streamSenial.Free;
  end;

end;

procedure llenarcomboMaquinas;
var
  consulta: String;
begin
  consulta := 'SELECT Etiqueta FROM maquinas';

  if not formPrincipal.ZQuery1.Connection.Connected then
    ShowMessage('Error de carga de base de datos.')
  else // si se conecto
  begin
    ConsultaSQL(ventanaRutas.ZReadOnlyQuery1, consulta);
    maquinas := TStringList.Create;
    ventanaRutas.ZReadOnlyQuery1.First; // muevete al primer elemento

    while not ventanaRutas.ZReadOnlyQuery1.Eof do
    begin
      maquinas.Add(ventanaRutas.ZReadOnlyQuery1.FieldByName('Etiqueta')
        .AsString);
      // agrego el nombre de la maquina al combobox
      ventanaRutas.ZReadOnlyQuery1.Next; // pasa al siguiente
    end;

  end;
end;

procedure ReiniciarAplicacion;
const
  SW_SHOW = 5;
var
  rutaAplicacion: string;
begin
  rutaAplicacion := ParamStr(0); // Ruta del archivo ejecutable actual
  // WinExec(PChar(rutaAplicacion), SW_SHOW);  // Inicia un nuevo proceso reemplazando el actual
  Application.Terminate; // Cierra el proceso actual
end;

procedure cargarEstilo(var Ventana: TformPrincipal);
begin
  if modo = 'claro' then
    Ventana.StyleBook := formPrincipal.StyleClaro
  else
    Ventana.StyleBook := formPrincipal.StyleOscuro
end;

end.
