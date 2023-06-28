unit Configuracion;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.EditBox, FMX.SpinBox;

type
  TformConfiguracion = class(TForm)
    btnSalvar: TButton;
    btnCancelar: TButton;
    Label1: TLabel;
    SpinBox1: TSpinBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formConfiguracion: TformConfiguracion;

implementation

{$R *.fmx}

end.
