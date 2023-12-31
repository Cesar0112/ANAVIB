unit Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, principal, UASUtilesDB, Seguridad,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ComboEdit, Data.DB,
  ZAbstractRODataset, ZDataset, ZAbstractConnection, ZConnection,
  MetodoConfiguracion,
  ZAbstractDataset;

type
  TformLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditPassword: TEdit;
    btnIngresar: TButton;
    EditUser: TEdit;
    lblErrorUsuarioContraseña: TLabel;
    PasswordEditButton1: TPasswordEditButton;
    ZReadOnlyQuery1: TZReadOnlyQuery;
    procedure btnIngresarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditPasswordKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure ComboEditUserKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure EditUserKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure EditUserChangeTracking(Sender: TObject);
    procedure btnIngresarMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);


  private
    { Private declarations }
  public
    { Public declarations }
    isValido: Boolean;
  end;

function existeUsuario(const usuario: String): Boolean;
function compruebaContrasenia(passIngresada, usuario: String): Boolean;
procedure mostrarBtnAutenticar();
procedure cargarEstilo(var Ventana: TformLogin);
var
  formLogin: TformLogin;

implementation

{$R *.fmx}

procedure mostrarBtnAutenticar();
begin
  if (formLogin.EditUser.Text <> '') and
    (not formLogin.EditUser.Text.Contains(' ')) and
    (formLogin.EditPassword.Text <> '') and
    (sizeOf(formLogin.EditPassword.Text) > 0) and
    (sizeOf(formLogin.EditUser.Text) > 0) then
  begin

    formLogin.btnIngresar.Enabled := True;

  end
  else
  begin
    formLogin.btnIngresar.Enabled := False;
  end;

end;

procedure TformLogin.btnIngresarClick(Sender: TObject);
var
  contrasenia: String;
begin
  { TODO 2 -oCésar -cBase de datos : Deberia de agregar comprobacion a la conexion a la BD }
  if btnIngresar.Enabled then
  begin
    // comprobacion para ver si es correcta la contraseña
    usuario := EditUser.Text; // obtengo el usuario
    contrasenia := encriptarSHA256(EditPassword.Text);
    // la contrasenia encriptada
    isValido := False;
    // verificar usuario
    if existeUsuario(usuario) then
    begin
      isValido := compruebaContrasenia(contrasenia, usuario);
      // si la contraseña es valida y es la del usuario
      if isValido then
      begin
        ConsultaSQL(ZReadOnlyQuery1,
          'SELECT id_role,id_usuario FROM Role JOIN usuarios ON Role.id_role = usuarios.fk_id_role WHERE usuarios.Nombre="'
          + usuario + '"');
        // obtengo el Role del usuario para saber sus privilegios
        if not ZReadOnlyQuery1.IsEmpty then
        begin
          formPrincipal.id_RoleActual := ZReadOnlyQuery1.FieldByName('id_role')
            .AsInteger;
          formPrincipal.id_UsuarioActual := ZReadOnlyQuery1.FieldByName
            ('id_usuario').AsInteger;
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
//      ShowMessage('Usuario ' + usuario + ' autenticado correctamente');
      formPrincipal.Visible := True;
      formLogin.Visible := False;
    end
    else
    begin
      lblErrorUsuarioContraseña.Visible := True;
    end;

  end;

end;

procedure TformLogin.btnIngresarMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  { TODO 2 -oCesar -cMejoras :
    aqui voy a implementar la funcionalidad que permita
    que cuando el mouse pase por encima del btn ingresar este aqunque este inhabilitado
    muestre el mensaje de que sus datos son incorrectos }

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
    btnIngresarClick(Sender);
end;

procedure TformLogin.EditUserChangeTracking(Sender: TObject);
begin
  mostrarBtnAutenticar;
  // Si no tiene texto oculta el visualizador de contraseñas
  if EditPassword.Text.Length < 1 then
    PasswordEditButton1.Visible := False
  else
    PasswordEditButton1.Visible := True;
end;

procedure TformLogin.EditUserKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    btnIngresarClick(Sender);
  end;

end;

procedure TformLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not isValido then
    Halt; // cierra la aplicación
end;

procedure TformLogin.FormShow(Sender: TObject);
begin
  cargarConfiguracion;
  formPrincipal.ZConnection1.Database := Database;
  formPrincipal.ZConnection1.LibraryLocation := LibraryLocation;
  formPrincipal.ZConnection1.Protocol := Protocol;
  formPrincipal.ZConnection1.Connect;

  if (modo <> '') or (modo <> ' ') then
    cargarEstilo(Self);
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
      result := True;
  end;
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
      result := True;
  end;
end;

procedure cargarEstilo(var Ventana: TformLogin);
begin
  if modo = 'claro' then
    Ventana.StyleBook := formPrincipal.StyleClaro
  else
    Ventana.StyleBook := formPrincipal.StyleOscuro
end;

end.
