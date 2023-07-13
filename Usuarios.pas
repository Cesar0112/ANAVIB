unit Usuarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, principal,
  UASUtilesDB,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListBox, Data.DB,
  ZAbstractRODataset, ZDataset;

type
  TformUsuarios = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    editUsuario: TEdit;
    editPass: TEdit;
    CheckBox1: TCheckBox;
    btnCrearUsuario: TButton;
    ComboBoxUsuarios: TComboBox;
    Label3: TLabel;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure btnCrearUsuarioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure llenarUsuarios();
procedure actualizarUsuarios();

var
  formUsuarios: TformUsuarios;
  listaUsuarios: TStringList;

implementation

{$R *.fmx}

procedure TformUsuarios.btnCrearUsuarioClick(Sender: TObject);
var
  contrasenia: String;
begin
  contrasenia := encriptarSHA256(editUsuario.Text);
  if insertarSQL(formPrincipal.ZQuery1,
    'INSERT INTO usuarios (Nombre,Contraseña) VALUES ("admin",' + '"' +
    contrasenia + '"' + ')') then
    ShowMessage('Bien')
  else
    ShowMessage('Mal');
end;

procedure llenarUsuarios();
var
  consulta: String;
begin
  consulta := 'SELECT Nombre FROM usuarios';

  if not formPrincipal.ZQuery1.Connection.Connected then
    ShowMessage('Error de carga de base de datos.')
  else // si se conecto
  begin
    ConsultaSQL(formUsuarios.ZReadOnlyQuery1, consulta);
    listaUsuarios := TStringList.Create;
    formUsuarios.ZReadOnlyQuery1.First; // muevete al primer elemento

    while not formUsuarios.ZReadOnlyQuery1.Eof do
    begin
      listaUsuarios.Add(formUsuarios.ZReadOnlyQuery1.FieldByName('Nombre')
        .AsString);
      // agrego el nombre de la maquina al combobox
      formUsuarios.ZReadOnlyQuery1.Next; // pasa al siguiente
    end;

  end;
end;

procedure TformUsuarios.CheckBox1Change(Sender: TObject);
begin
  editPass.Password:=not editPass.Password; //cambia el estado de el editPass
end;

procedure TformUsuarios.FormShow(Sender: TObject);
begin
  actualizarUsuarios;
end;

procedure actualizarUsuarios();
begin
  llenarUsuarios;
  formUsuarios.ComboBoxUsuarios.Assign(listaUsuarios);
end;

end.
