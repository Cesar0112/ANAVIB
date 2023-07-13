unit Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, principal, UASUtilesDB,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ComboEdit, Data.DB,
  ZAbstractRODataset, ZDataset, ZAbstractConnection, ZConnection,
  ZAbstractDataset;

type
  TformLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditPassword: TEdit;
    btnIngresar: TButton;
    ComboEditUser: TComboEdit;
    lblErrorContrasenia: TLabel;
    lblErrorUsuario: TLabel;
    procedure btnIngresarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditPasswordKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure ComboEditUserKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
    isValido: Boolean;
  end;

function existeUsuario(const usuario: String): Boolean;

procedure cargarConfiguracion();

var
  formLogin: TformLogin;
  Database, Protocol, LibraryLocation: String;

implementation

{$R *.fmx}

procedure TformLogin.btnIngresarClick(Sender: TObject);
var
  usuario: String;
  contrasenia: String;
begin
  {
    Por ahora no hay encriptacion pq no esta terminado
  }
  { TODO 1 -oCesar -cSecurity : Hacer la encriptacion de la contraseña }
  // comprobacion para ver si es correcta la contraseña
  usuario := ComboEditUser.Text; // obtengo el usuario
  contrasenia := EditPassword.Text; // la contrasenia
  isValido := False;
  if (usuario = 'admin') and (contrasenia = 'admin') then
    isValido := True;
  if isValido then
  begin
    ShowMessage('Usuario ' + usuario + ' autenticado correctamente');
    cargarConfiguracion;
    formPrincipal.ZConnection1.Database := Database;
    formPrincipal.ZConnection1.Protocol := Protocol;
    formPrincipal.ZConnection1.LibraryLocation := LibraryLocation;
    formPrincipal.ZConnection1.Connect; // conectarse a la base de datos

    formPrincipal.Visible := True;
    Visible := False;
  end
  else
  begin

  end;

end;

procedure TformLogin.ComboEditUserKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if KeyChar = #13 then
  begin
    btnIngresarClick(Sender);

  end;

end;

procedure TformLogin.EditPasswordKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if KeyChar = #13 then
  begin
    btnIngresarClick(Sender);

  end;
end;

procedure TformLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not isValido then
    Halt; // cierra la aplicación
end;

function existeUsuario(const usuario: String): Boolean;
var
  consulta: String;
begin
  cargarConfiguracion();

  consulta := 'SELECT COUNT(*) FROM usuarios WHERE nombre="' + usuario + '"';

end;

procedure cargarConfiguracion();
var
  archivo: TextFile;
  linea, clave, valor: string;

begin
  try
    AssignFile(archivo, 'Config.cfg');

    // Leer datos del archivo .cfg
    Reset(archivo);
    while not Eof(archivo) do // lee hasta el final del archivo
    begin
      Readln(archivo, linea);

      // Separar la clave y el valor en cada línea
      // asumiendo que están separados por el caracter '='
      clave := Copy(linea, 1, Pos('=', linea) - 1);
      valor := Copy(linea, Pos('=', linea) + 1, Length(linea));

      // Utilizar las claves y valores para configurar la aplicación
      if clave = 'Database' then
      begin;
        Database := valor;
      end
      else if clave = 'LibraryLocation' then
      begin
        // Valor correspondiente a 'LibraryLocation'
        LibraryLocation := valor;
      end
      else if clave = 'Protocol' then
      begin
        // Valor correspondiente a 'Protocol'
        Protocol := valor;
      end
      else if clave = 'Frecuencia de muestreo' then
      begin
        FrecMuestreo := StrToInt(valor);
      end;
    end;

    // Cerrar el archivo después de leer
    CloseFile(archivo);
  except
    on E: Exception do
      Writeln('Error: ' + E.Message);
  end;
end;

end.
