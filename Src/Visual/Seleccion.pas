unit Seleccion;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, System.IOUtils, Winapi.Windows;
type
  TDriverLoader = class
  private
    FDriverHandle: HMODULE;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadDrivers(DriverListBox: TListBox);
    procedure LoadDriver(const DriverName: string);
  end;
  TventanaSeleccion = class(TForm)
    DriverListBox: TListBox;
    LoadDriverButton: TButton;
    Label1: TLabel;
    StyleBook1: TStyleBook;
    procedure LoadDriverButtonClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDriverLoader: TDriverLoader;
  public
    procedure LoadDrivers;
  end;
var
  ventanaSeleccion: TventanaSeleccion;
implementation
{$R *.fmx}
constructor TDriverLoader.Create;
begin
  inherited Create;
  FDriverHandle := 0;
end;
destructor TDriverLoader.Destroy;
begin
  if FDriverHandle <> 0 then
    FreeLibrary(FDriverHandle);
  inherited Destroy;
end;
procedure TDriverLoader.LoadDrivers(DriverListBox: TListBox);
var
  DriverFiles: TStringDynArray;
  DriverFile: string;
begin
  DriverFiles := TDirectory.GetFiles('C:\Users\César\Documents\GitHub\ANAVIB\DLL\', '*.dll');
  for DriverFile in DriverFiles do
    DriverListBox.Items.Add(TPath.GetFileName(DriverFile));
end;
procedure TDriverLoader.LoadDriver(const DriverName: string);
begin
  FDriverHandle := LoadLibrary(PChar('C:\Users\César\Documents\GitHub\ANAVIB\DLL\' + DriverName));
  if FDriverHandle <> 0 then
    ShowMessage('Driver cargado satisfactoriamente.')
  else
    ShowMessage('Fallo al cargar el Driver.');
end;
procedure TventanaSeleccion.LoadDrivers;
var
  DriverFiles: TStringDynArray;
  DriverFile: string;
begin
  DriverFiles := TDirectory.GetFiles('C:\Users\César\Documents\GitHub\ANAVIB\DLL\', '*.dll');
  for DriverFile in DriverFiles do
    DriverListBox.Items.Add(TPath.GetFileName(DriverFile));
end;

procedure TventanaSeleccion.LoadDriverButtonClick(Sender: TObject);
var
  SelectedDriver: string;
begin
  ventanaSeleccion.LoadDrivers;
  SelectedDriver := DriverListBox.Selected.Text;
  FDriverLoader.LoadDriver(SelectedDriver);
end;
procedure TventanaSeleccion.CancelClick(Sender: TObject);
begin
  Close;
end;
procedure TventanaSeleccion.FormCreate(Sender: TObject);
begin
  FDriverLoader := TDriverLoader.Create;
  LoadDrivers;
end;
procedure TventanaSeleccion.FormDestroy(Sender: TObject);
begin
  FDriverLoader.Free;
end;
end.

