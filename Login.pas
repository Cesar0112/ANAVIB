unit Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.ListBox, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ComboEdit;

type
  TformLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditPassword: TEdit;
    btnIngresar: TButton;
    ComboEditUser: TComboEdit;
    procedure btnIngresarClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    isValido: Boolean;
  end;

var
  formLogin: TformLogin;


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
    ShowMessage('Usuario ' + usuario + 'autenticado correctamente');
    Self.Close;
  end;

end;

end.
