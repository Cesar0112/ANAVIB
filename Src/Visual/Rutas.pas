unit Rutas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.StrUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.StdCtrls, FMX.Edit, FMX.ComboEdit, FMX.Layouts, FMX.ListBox,
  ZAbstractConnection, ZConnection, UASUtilesDB, Data.DB,
  ZAbstractRODataset, ZDataset, ZAbstractDataset;

type
  TventanaRutas = class(TForm)
    Label1: TLabel;
    ListBox_ruta: TListBox;
    Label2: TLabel;
    btn_agregar_horizontal: TButton;
    btn_agregar_vertical: TButton;
    btn_agregar_axial: TButton;
    Label3: TLabel;
    ComboEdit_etiqueta: TComboEdit;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    btn_eliminar_todo: TButton;
    btn_eliminar_seleccionado: TButton;
    Label5: TLabel;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    ZQuery1: TZQuery;
    btnEliminarRuta: TButton;
    btnEliminarMaquina: TButton;
    ComboEditMaquina: TComboEdit;
    StyleBook1: TStyleBook;
    procedure FormShow(Sender: TObject);
    procedure ComboEdit_etiquetaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure ComboEdit_etiquetaChange(Sender: TObject);
    procedure btn_agregar_horizontalClick(Sender: TObject);
    procedure btn_agregar_verticalClick(Sender: TObject);
    procedure btn_agregar_axialClick(Sender: TObject);
    procedure btn_eliminar_todoClick(Sender: TObject);
    procedure btn_eliminar_seleccionadoClick(Sender: TObject);
    procedure btnEliminarRutaClick(Sender: TObject);
    procedure ComboEditMaquinaKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure btnEliminarMaquinaClick(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

  end;

procedure llenarcomboeditRutas();
procedure llenarcomboMaquinas();
procedure actualizarListaCamino(etiqueta: String);

var
  ventanaRutas: TventanaRutas;
  listado_camino, listado_rutas, maquinas: TStringList;
  arrayCamino: TArray<String>;

implementation

{$R *.fmx}

uses principal;

procedure TventanaRutas.btnEliminarMaquinaClick(Sender: TObject);
var
  consulta: String;
begin
  consulta := 'DELETE FROM maquinas WHERE Etiqueta="' +
    ComboEditMaquina.Text + '"';
  EliminarSQL(ZQuery1, consulta);
  llenarcomboMaquinas;
  ComboEditMaquina.Items.Assign(maquinas);
  ComboEditMaquina.ItemIndex := 0;

end;

procedure TventanaRutas.btnEliminarRutaClick(Sender: TObject);
var
  consulta: String;
begin
  consulta := 'DELETE FROM rutas WHERE Etiqueta="' +
    ComboEdit_etiqueta.Text + '"';
  EliminarSQL(ZQuery1, consulta);
  llenarcomboeditRutas;
  ComboEdit_etiqueta.Items.Assign(listado_rutas);
  ComboEdit_etiqueta.ItemIndex := 0;

end;

procedure TventanaRutas.btn_agregar_axialClick(Sender: TObject);
var
  consulta: String;
  elementoA: String;
begin
  elementoA := StringReplace(listado_camino.Text, #13#10, ',', [rfReplaceAll]) +
    ComboEditMaquina.Items[ComboEditMaquina.ItemIndex] + 'A';
  consulta := 'UPDATE rutas SET Camino="' + elementoA + '" WHERE Etiqueta="' +
    ComboEdit_etiqueta.Text + '"';
  ActualizarSQL(ZQuery1, consulta);
  ListBox_ruta.Clear;
  actualizarListaCamino(ComboEdit_etiqueta.Text);
  // agrega el camino
  try
    ListBox_ruta.Items.AddStrings(listado_camino);
    ListBox_ruta.ItemIndex := 0;
  except
    on E: Exception do
  end;

end;

procedure TventanaRutas.btn_agregar_horizontalClick(Sender: TObject);
var
  consulta: String;
  elementoH: String;
begin
  elementoH := StringReplace(listado_camino.Text, #13#10, ',', [rfReplaceAll]) +
    ComboEditMaquina.Items[ComboEditMaquina.ItemIndex] + 'H';
  consulta := 'UPDATE rutas SET Camino="' + elementoH + '" WHERE Etiqueta="' +
    ComboEdit_etiqueta.Text + '"';
  ActualizarSQL(ZQuery1, consulta);
  ListBox_ruta.Clear;
  actualizarListaCamino(ComboEdit_etiqueta.Text);
  // agrega el camino

  try
    ListBox_ruta.Items.AddStrings(listado_camino);
    ListBox_ruta.ItemIndex := 0;
  except
    on E: Exception do
  end;

end;

procedure TventanaRutas.btn_agregar_verticalClick(Sender: TObject);
var
  consulta: String;
  elementoV: String;
begin
  // obtengo todos los elementos en forma de string asi M1H,M2v....
  elementoV := StringReplace(listado_camino.Text, #13#10, ',', [rfReplaceAll]) +
    ComboEditMaquina.Items[ComboEditMaquina.ItemIndex] + 'V';
  consulta := 'UPDATE rutas SET Camino="' + elementoV + '" WHERE Etiqueta="' +
    ComboEdit_etiqueta.Text + '"';
  ActualizarSQL(ZQuery1, consulta);
  ListBox_ruta.Clear;
  actualizarListaCamino(ComboEdit_etiqueta.Text);
  // agrega el camino
  try
    ListBox_ruta.Items.AddStrings(listado_camino);
    ListBox_ruta.ItemIndex := 0;
  except
    on E: Exception do
  end;

end;

procedure TventanaRutas.btn_eliminar_seleccionadoClick(Sender: TObject);
var
  elementoSeleccionado: Integer;

  consulta: String;

  nuevoCamino: String;

begin

  if ListBox_ruta.ItemIndex <> -1 then
  begin

    elementoSeleccionado := ListBox_ruta.ItemIndex;
    // elimino el elemnto seleccionado
    listado_camino.Delete(elementoSeleccionado);

    nuevoCamino := StringReplace(listado_camino.Text, #13#10, ',',
      [rfReplaceAll]);
    consulta := 'UPDATE rutas SET Camino="' + nuevoCamino + '" WHERE Etiqueta="'
      + ComboEdit_etiqueta.Text + '"';
    ActualizarSQL(ZQuery1, consulta);
    ListBox_ruta.Clear;
    actualizarListaCamino(ComboEdit_etiqueta.Text);
    // agrega el camino
    try
      ListBox_ruta.Items.AddStrings(listado_camino);
      ListBox_ruta.ItemIndex := 0;
    except
      on E: Exception do
    end;

  end;

end;

procedure TventanaRutas.btn_eliminar_todoClick(Sender: TObject);
var
  consulta: String;
begin
  consulta := 'UPDATE rutas SET Camino="" WHERE Etiqueta="' +
    ComboEdit_etiqueta.Text + '"';
  ActualizarSQL(ZQuery1, consulta);
  ListBox_ruta.Clear;
  actualizarListaCamino(ComboEdit_etiqueta.Text);
  // agrega el camino

  try
    ListBox_ruta.Items.AddStrings(listado_camino);
    ListBox_ruta.ItemIndex := 0;
  except
    on E: Exception do

  end;

end;

procedure TventanaRutas.ComboEditMaquinaKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  consulta: String;
begin
  if Key = vkReturn then
  begin
    if ComboEditMaquina.Text <> '' then
    begin
      // si el elemento no esta en la lista
      if ComboEditMaquina.Items.IndexOf(ComboEditMaquina.Text) = -1 then
      begin
        consulta := 'INSERT INTO maquinas (Etiqueta) VALUES ("' +
          ComboEditMaquina.Text + '")';
        insertarSQL(ZQuery1, consulta);
        llenarcomboMaquinas;
        ComboEditMaquina.Items.Assign(maquinas);
        ComboEditMaquina.ItemIndex := 0;
      end;
    end;
  end;
end;

procedure TventanaRutas.ComboEdit_etiquetaChange(Sender: TObject);
begin
  ListBox_ruta.Clear;
  actualizarListaCamino(ComboEdit_etiqueta.Text);
  // agrega el camino
  try
    ListBox_ruta.Items.AddStrings(listado_camino);
    ListBox_ruta.ItemIndex := 0;
  except
    on E: Exception do
  end;

end;

procedure TventanaRutas.ComboEdit_etiquetaKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  consulta: String;
begin
  if Key = vkReturn then
  begin
    if ComboEdit_etiqueta.Text <> '' then
    begin
      // si el elemento no esta en la lista
      if ComboEdit_etiqueta.Items.IndexOf(ComboEdit_etiqueta.Text) = -1 then
      begin
        consulta := 'INSERT INTO rutas (Etiqueta,Camino) VALUES ("' +
          ComboEdit_etiqueta.Text + '","")';
        insertarSQL(ZQuery1, consulta);
        llenarcomboeditRutas;
        ComboEdit_etiqueta.Items.Assign(listado_rutas);
        ComboEdit_etiqueta.ItemIndex := 0;
      end;
    end;
  end;
end;

procedure TventanaRutas.FormShow(Sender: TObject);
begin
  llenarcomboMaquinas;
  ComboEditMaquina.Items.Assign(maquinas);
  ComboEditMaquina.ItemIndex := 0;

  llenarcomboeditRutas;
  ComboEdit_etiqueta.Items.Assign(listado_rutas);
  ComboEdit_etiqueta.ItemIndex := 0;

  ListBox_ruta.Clear;
  actualizarListaCamino(ComboEdit_etiqueta.Text);
  // agrega el camino
  ListBox_ruta.Items.Assign(listado_camino);
  ListBox_ruta.ItemIndex := 0;

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

procedure llenarcomboeditRutas();
var
  consulta: String;
begin
  consulta := 'SELECT Etiqueta FROM rutas';
  listado_rutas := TStringList.Create;
  if not formPrincipal.ZConnection1.Connected then
    ShowMessage('Error de carga de base de datos.')
  else // si se conecto
  begin
    ConsultaSQL(ventanaRutas.ZReadOnlyQuery1, consulta);

    ventanaRutas.ZReadOnlyQuery1.First; // muevete al primer elemento

    while not ventanaRutas.ZReadOnlyQuery1.Eof do
    begin
      listado_rutas.Add(ventanaRutas.ZReadOnlyQuery1.FieldByName('Etiqueta')
        .AsString);
      // agrego el nombre de la maquina al combobox
      ventanaRutas.ZReadOnlyQuery1.Next; // pasa al siguiente
    end;

  end;
end;

procedure actualizarListaCamino(etiqueta: String);
var
  camino: String;
  i: String;
  arrayAux: TArray<String>;
  tamArra: Integer;
begin
  listado_camino := TStringList.Create;

  ConsultaSQL(ventanaRutas.ZReadOnlyQuery1,
    'SELECT Camino FROM rutas WHERE Etiqueta="' + etiqueta + '"');
  // si no esta vacia la consulta
  if not ventanaRutas.ZReadOnlyQuery1.IsEmpty then
  begin
    camino := trim(ventanaRutas.ZReadOnlyQuery1.FieldByName('Camino').AsString);

    // elimina las comas al principio y al final si las tiene

    if camino.Length > 1 then
    begin
      if camino[camino.Length] = ',' then
        Delete(camino, camino.Length, 1);
      if camino[1] = ',' then
        Delete(camino, 1, 1);

      arrayAux := SplitString(camino, ','); // array divido por comas;

      for i in arrayAux do
      begin
        listado_camino.Add(i);
      end;
    end;

  end;

end;

end.
