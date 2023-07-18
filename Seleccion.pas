unit Seleccion;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.ListBox, FMX.StdCtrls,
  Winapi.Windows, System.IOUtils;
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
  TformSeleccion = class(TForm)
    DriverListBox: TListBox;
    LoadDriverButton: TButton;
    procedure LoadDriverButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FDriverLoader: TDriverLoader;
    procedure InitializeComponents;
  public
    { Public declarations }
  end;
var
  ventanaSeleccion: TformSeleccion;
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
  DriverFiles: TArray<string>;
  DriverFile: string;
begin
  DriverFiles := TDirectory.GetFiles('PathToDrivers', '*.dll');
  for DriverFile in DriverFiles do
    DriverListBox.Items.Add(ExtractFileName(DriverFile));
end;
procedure TDriverLoader.LoadDriver(const DriverName: string);
begin
  FDriverHandle := LoadLibrary(PChar('PathToDrivers\' + DriverName));
  if FDriverHandle <> 0 then
    ShowMessage('Driver loaded successfully.')
  else
    ShowMessage('Failed to load driver.');
end;
procedure TformSeleccion.FormCreate(Sender: TObject);
begin
  InitializeComponents;
  FDriverLoader := TDriverLoader.Create;
  FDriverLoader.LoadDrivers(DriverListBox);
end;
procedure TformSeleccion.FormDestroy(Sender: TObject);
begin
  FDriverLoader.Free;
end;
procedure TformSeleccion.InitializeComponents;
begin
  DriverListBox := TListBox.Create(Self);
  DriverListBox.Parent := Self;
  DriverListBox.Align := TAlignLayout.Client;
  LoadDriverButton := TButton.Create(Self);
  LoadDriverButton.Parent := Self;
  LoadDriverButton.Align := TAlignLayout.Bottom;
  LoadDriverButton.Text := 'Load Driver';
  LoadDriverButton.OnClick := LoadDriverButtonClick;
end;
procedure TformSeleccion.LoadDriverButtonClick(Sender: TObject);
var
  SelectedDriver: string;
begin
  SelectedDriver := DriverListBox.Selected.Text;
  FDriverLoader.LoadDriver(SelectedDriver);
end;
end.

