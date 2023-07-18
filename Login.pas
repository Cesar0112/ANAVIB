unit Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, principal, UASUtilesDB, Seguridad,
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
    ZReadOnlyQuery1: TZReadOnlyQuery;
    EditUser: TEdit;
    lblErrorUsuarioContraseña: TLabel;
    procedure btnIngresarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditPasswordKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure ComboEditUserKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure EditUserKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
    isValido: Boolean;
  end;

function existeUsuario(const usuario: String): Boolean;
function compruebaContrasenia(passIngresada, usuario: String): Boolean;

procedure cargarConfiguracion();

var
  formLogin: TformLogin;
  Database, Protocol, LibraryLocation: String;

implementation

{$R *.fmx}

procedure TformLogin.btnIngresarClick(Sender: TObject);
var

  contrasenia: String;
begin
  // comprobacion para ver si es correcta la contraseña
  usuario := EditUser.Text; // obtengo el usuario
  contrasenia := encriptarSHA256(EditPassword.Text);
  // la contrasenia encriptada
  isValido := False;
  // verificar usuario
  if existeUsuario(usuario) then
  begin
     isValido:= compruebaContrasenia(contrasenia, usuario);
    // si la contraseña es valida y es la del usuario
    if isValido then
    begin
      ConsultaSQL(ZReadOnlyQuery1,
        'SELECT id_role FROM Role JOIN usuarios ON Role.id_role = usuarios.fk_id_role WHERE usuarios.Nombre="'
        + usuario + '"');
      // obtengo el Role del usuario para saber sus privilegios
      if not ZReadOnlyQuery1.IsEmpty then
      begin
        formPrincipal.RoleActual := ZReadOnlyQuery1.FieldByName('id_role')
          .AsInteger;

      end
      else
      begin
        ShowMessage
          ('Hubo un error en la consulta a la base de datos en el intento de obtener el Role del usuario');
      end;
    end;

  end;

  // si todo esta correcto
  if isValido then
  begin
    lblErrorUsuarioContraseña.Visible := False;
    ShowMessage('Usuario ' + usuario + ' autenticado correctamente');
    formPrincipal.Visible := true;
    Visible := False;
  end
  else
  begin
    lblErrorUsuarioContraseña.Visible := true;
  end;

end;

procedure TformLogin.ComboEditUserKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    btnIngresarClick(Sender);

  end;

end;

procedure TformLogin.EditPasswordKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    btnIngresarClick(Sender);

  end;
end;

procedure TformLogin.EditUserKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    btnIngresarClick(Sender);
end;

procedure TformLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not isValido then
    Halt; // cierra la aplicación
end;

procedure TformLogin.FormShow(Sender: TObject);
begin
  cargarConfiguracion;
  EditUser.SetFocus;
end;

function existeUsuario(const usuario: String): Boolean;
var
  consulta: String;
begin
  result := False;
  consulta := 'SELECT COUNT(*) as cantdUsuarios FROM usuarios WHERE nombre="' +
    usuario + '"';
  ConsultaSQL(formLogin.ZReadOnlyQuery1, consulta);
  // verificar que devuelva resultados
  if not formLogin.ZReadOnlyQuery1.IsEmpty then
  begin
    // si hay un solo usuario con ese nombre de usuario
    if formLogin.ZReadOnlyQuery1.FieldByName('cantdUsuarios').AsInteger = 1 then
      result := true;
  end;
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
  formPrincipal.ZConnection1.Database := Database;
  formPrincipal.ZConnection1.LibraryLocation := LibraryLocation;
  formPrincipal.ZConnection1.Protocol := Protocol;
  formPrincipal.ZConnection1.Connect;

end;

function compruebaContrasenia(passIngresada, usuario: String): Boolean;
var
  consulta: String;
  passBDEncriptada: String;
begin
  result := False;
  consulta := 'SELECT Contraseña FROM usuarios WHERE nombre="' + usuario + '"';
  ConsultaSQL(formLogin.ZReadOnlyQuery1, consulta);
  // verificar que devuelva resultados
  if not formLogin.ZReadOnlyQuery1.IsEmpty then
  begin
    passBDEncriptada := formLogin.ZReadOnlyQuery1.FieldByName
      ('Contraseña').AsString;
    // si las contraseñas son iguales
    if passBDEncriptada = passIngresada then
      result := true;
  end;
end;

end.
