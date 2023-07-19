unit Usuarios;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.StrUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  UASUtilesDB, Seguridad,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.ListBox, Data.DB,
  ZAbstractRODataset, ZDataset, ZAbstractDataset;

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
    ZQuery1: TZQuery;
    btnEliminar: TButton;
    btnEditar: TButton;
    btnCancelarEdicion: TButton;
    Label4: TLabel;
    ComboBox1: TComboBox;
    procedure btnCrearUsuarioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure btnEliminarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarEdicionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure llenarUsuarios;

procedure actualizarUsuarios;

var
  formUsuarios: TformUsuarios;
  listaRoles, listaUsuarios: TStringList;
  idUsuarioAEditar: Integer;

implementation

{$R *.fmx}

procedure TformUsuarios.btnCancelarEdicionClick(Sender: TObject);
begin
  btnEditar.Text := 'Editar';
  btnCancelarEdicion.Visible := not btnCancelarEdicion.Visible;
  editUsuario.Text := '';
  editPass.Text:='';
end;

procedure TformUsuarios.btnCrearUsuarioClick(Sender: TObject);
var
  contrasenia: String;
  id_role: Integer;
begin
  if not((editUsuario.Text = '') or ContainsText(editUsuario.Text, ' ') or
    (editPass.Text = '') or (editPass.Text = ' ')) then
  begin
    contrasenia := encriptarSHA256(editPass.Text);
    ConsultaSQL(ZReadOnlyQuery1, 'SELECT id_role FROM Role WHERE role = "' +
      ComboBox1.Items[ComboBox1.ItemIndex] + '"');
    id_role := ZReadOnlyQuery1.FieldByName('id_role').AsInteger;
    try
      if insertarSQL(ZQuery1,
        'INSERT INTO usuarios (Nombre,Contraseña,fk_id_role) VALUES ("' +
        editUsuario.Text + '",' + '"' + contrasenia + '",' + '"' +
        IntToStr(id_role) + '")') then
      begin
        MessageDlg('Usuario ' + editUsuario.Text + ' creado correctamente',
          TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
        llenarUsuarios;
        if SizeOf(listaUsuarios) > 0 then
        begin
          ComboBoxUsuarios.Items.Assign(listaUsuarios);
          ComboBoxUsuarios.ItemIndex := 0;
        end;
      end
      else
      begin
        ConsultaSQL(ZReadOnlyQuery1,
          'SELECT count(nombre) cantd_usuarios FROM usuarios WHERE usuarios.nombre="'
          + editUsuario.Text + '"');
        if ZReadOnlyQuery1.FieldByName('cantd_usuarios').AsInteger > 0 then
          MessageDlg('Existe un usuario con ese nombre', TMsgDlgType.mtError,
            [TMsgDlgBtn.mbOK], 0);

      end;

    except
      on E: Exception do
        MessageDlg(E.Message, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
    end;

  end
  else
  begin
    MessageDlg('Usuario ' + editUsuario.Text + ' no fue creado',
        TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
  end;

  if ContainsText(editUsuario.Text, ' ') then
    MessageDlg('ERROR: El campo usuario no puede tener espacios en blanco.',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);

  if editUsuario.Text = '' then
    MessageDlg('ERROR:El campo usuario no puede estar vacío.',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  if editPass.Text = '' then
    MessageDlg('ERROR:El campo contraseña no puede estar vacío.',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  if editPass.Text = ' ' then
    MessageDlg('ERROR:El campo contraseña no puede estar en blanco.',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
end;

procedure llenarUsuarios();
var
  nombre, consulta: String;

begin
  consulta := 'SELECT Nombre FROM usuarios';

  if not formUsuarios.ZQuery1.Connection.Connected then
    ShowMessage('Error de carga de base de datos.')
  else // si se conecto
  begin
    ConsultaSQL(formUsuarios.ZReadOnlyQuery1, consulta);
    listaUsuarios := TStringList.Create;
    formUsuarios.ZReadOnlyQuery1.First; // muevete al primer elemento

    while not formUsuarios.ZReadOnlyQuery1.Eof do
    begin
      nombre := formUsuarios.ZReadOnlyQuery1.FieldByName('Nombre').AsString;
      listaUsuarios.Add(nombre);
      // agrego el nombre de la maquina al combobox
      formUsuarios.ZReadOnlyQuery1.Next; // pasa al siguiente
    end;

  end;
end;

procedure llenarPrivilegios();
var
  role: String;
begin
  if not formUsuarios.ZQuery1.Connection.Connected then
    ShowMessage('Error de carga de base de datos.')
  else // si se conecto
  begin
    // obtengo los roles q puede tener un usuario
    ConsultaSQL(formUsuarios.ZReadOnlyQuery1, 'SELECT role FROM Role');
    listaRoles := TStringList.Create;
    formUsuarios.ZReadOnlyQuery1.First; // muevete al primer elemento

    while not formUsuarios.ZReadOnlyQuery1.Eof do
    begin
      role := formUsuarios.ZReadOnlyQuery1.FieldByName('role').AsString;
      listaRoles.Add(role);
      // agrego el role al combobox
      formUsuarios.ZReadOnlyQuery1.Next; // pasa al siguiente
    end;

  end;
end;

procedure TformUsuarios.btnEditarClick(Sender: TObject);
var
  usuarioSeleccionado, Editar, Confirmar: String;
  indiceSeleccionado: Integer;
begin
  Editar := 'Editar';
  Confirmar := 'Confirmar edición';

  // si esta en editar
  if btnEditar.Text = Editar then
  begin
    btnEditar.Text := Confirmar; // cambia el nombre del boton
    indiceSeleccionado := ComboBoxUsuarios.ItemIndex;
    editPass.Text := ''; // vacia
    if indiceSeleccionado <> -1 then
    begin
      // captura el nombre del usuario
      usuarioSeleccionado := ComboBoxUsuarios.Items[indiceSeleccionado];
      btnCancelarEdicion.Visible := not btnCancelarEdicion.Visible;
      // muestra el boton de cancelacion
      // ejecuta la consulta para obtener el id
      ConsultaSQL(ZReadOnlyQuery1,
        'SELECT ID_usuario FROM usuarios WHERE Nombre="' +
        usuarioSeleccionado + '"');
      // si capturo el id
      if not ZReadOnlyQuery1.IsEmpty then
      begin
        // almacenalo
        idUsuarioAEditar := ZReadOnlyQuery1.FieldByName('ID_usuario').AsInteger;
      end;
      // escribo en el edit el nombre del usuario
      editUsuario.Text := usuarioSeleccionado;

    end;
  end
  else // si el boton esta en confirmar
  begin

    btnEditar.Text := Editar;
    btnCancelarEdicion.Visible := not btnCancelarEdicion.Visible;
    // muestra el boton de cancelacion
    { if not((Pos(' ', editUsuario.Text) > 0) or (SizeOf(editUsuario.Text) > 0))
      then
      close; }
    ActualizarSQL(ZQuery1, 'UPDATE usuarios SET Nombre="' +
      trim(editUsuario.Text) + '", Contraseña="' +
      encriptarSHA256(trim(editPass.Text)) + '" WHERE ID_usuario=' +
      IntToStr(idUsuarioAEditar));

    editUsuario.Text := '';
    editPass.Text := '';
    llenarUsuarios;
    if SizeOf(listaUsuarios) > 0 then
    begin
      ComboBoxUsuarios.Items.Assign(listaUsuarios);
    end;
  end;

end;

procedure TformUsuarios.btnEliminarClick(Sender: TObject);
var
  usuarioSeleccionado: String;
  indiceSeleccionado: Integer;
  idUsuario: Integer;
begin
  indiceSeleccionado := ComboBoxUsuarios.ItemIndex;

  if indiceSeleccionado <> -1 then
  begin
    usuarioSeleccionado := ComboBoxUsuarios.Items[indiceSeleccionado];

    if MessageDlg('¿Está seguro que desea eliminar al usuario: ' +
      usuarioSeleccionado + '?', TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
    begin
      ConsultaSQL(ZReadOnlyQuery1,
        'SELECT ID_usuario FROM usuarios WHERE Nombre="' +
        usuarioSeleccionado + '"');
      if not ZReadOnlyQuery1.IsEmpty then
        idUsuario := ZReadOnlyQuery1.FieldByName('ID_usuario').AsInteger;

      EliminarSQL(ZQuery1, 'DELETE FROM usuarios WHERE ID_usuario=' +
        IntToStr(idUsuario));

      llenarUsuarios;
      if SizeOf(listaUsuarios) > 0 then
      begin
        ComboBoxUsuarios.Items.Assign(listaUsuarios);
        ComboBoxUsuarios.ItemIndex := 0;
      end;
      MessageDlg('Usuario eliminado', TMsgDlgType.mtInformation,
        [TMsgDlgBtn.mbOK], 0);
    end
    else
    begin
      MessageDlg('Usuario no eliminado', TMsgDlgType.mtInformation,
        [TMsgDlgBtn.mbOK], 0);
    end;

  end;

end;

procedure TformUsuarios.CheckBox1Change(Sender: TObject);
begin
  editPass.Password := not editPass.Password; // cambia el estado de el editPass
end;

procedure TformUsuarios.FormShow(Sender: TObject);
begin
  llenarUsuarios;
  if SizeOf(listaUsuarios) > 0 then
  begin
    ComboBoxUsuarios.Items.Assign(listaUsuarios);
    ComboBoxUsuarios.ItemIndex := 0;
  end;
  llenarPrivilegios;
  if SizeOf(listaRoles) > 0 then
  begin
    ComboBox1.Items.Assign(listaRoles);
    ComboBox1.ItemIndex := 0;
  end;
  editUsuario.SetFocus;
end;

// no me funciona no se pq
procedure actualizarUsuarios;
begin
  llenarUsuarios;
  if SizeOf(listaUsuarios) > 0 then
  begin
    formUsuarios.ComboBoxUsuarios.Items.Assign(listaUsuarios);
    formUsuarios.ComboBoxUsuarios.Index := 0;
  end;

end;

end.
