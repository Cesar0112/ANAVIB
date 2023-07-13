unit Rutas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid,
  FMX.StdCtrls, FMX.Edit, FMX.ComboEdit, FMX.Layouts, FMX.ListBox,
  ZAbstractConnection, ZConnection, UASUtilesDB, Data.DB,
  ZAbstractRODataset, ZDataset;

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
    combobox_maquina: TComboBox;
    btn_guardar: TButton;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

  end;

procedure llenarcomboeditRutas();
procedure llenarcomboMaquinas();

var
  ventanaRutas: TventanaRutas;
  listado_rutas, maquinas: TStringList;

implementation

{$R *.fmx}

uses principal;

procedure TventanaRutas.FormShow(Sender: TObject);
begin
  llenarcomboMaquinas;
  combobox_maquina.Items.Assign(maquinas);
  combobox_maquina.ItemIndex:=0;
  llenarcomboeditRutas;
  ComboEdit_etiqueta.Items.Assign(listado_rutas);
  ComboEdit_etiqueta.ItemIndex:=0;
end;

procedure llenarcomboMaquinas();
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

end.
