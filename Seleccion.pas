unit Seleccion;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox, Winapi.Windows,System.IOUtils;

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
    procedure LoadDriverButtonClick(Sender: TObject);

  private
     FDriverLoader: TDriverLoader;
  public
    { Public declarations }
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


procedure TventanaSeleccion.LoadDriverButtonClick(Sender: TObject);
var
  SelectedDriver: string;
begin
  SelectedDriver := DriverListBox.Selected.Text;
  FDriverLoader.LoadDriver(SelectedDriver);
end;
end.

procedure TventanaSeleccion.CancelClick(Sender: TObject);
begin

end;
end;



procedure TventanaSeleccion.FormCreate(Sender: TObject);
begin
  LoadDrivers;
end;

procedure TventanaSeleccion.FormDestroy(Sender: TObject);
begin
  if FDriverHandle <> 0 then
    FreeLibrary(FDriverHandle);
end;

procedure TventanaSeleccion.LoadDrivers;
var
  SearchRec: TSearchRec;
  DriverPath: string;
begin
  if FindFirst('D:\Universidad\3ro\Prácticas Profesionales 1\Proyecto\ANAVIB\DriverCapturaDatosFichero\*.dll', faAnyFile, SearchRec) = 0 then
  begin
    repeat
      DriverListBox.Items.Add(SearchRec.Name);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

procedure TventanaSeleccion.LoadDriverButtonClick(Sender: TObject);
var
  SelectedDriver: string;
begin
  SelectedDriver := DriverListBox.Selected.Text;
  FDriverHandle := LoadLibrary(PChar('PathToDrivers\' + SelectedDriver));
  if FDriverHandle <> 0 then
    ShowMessage('Driver loaded successfully.')
  else
    ShowMessage('Failed to load driver.');
end;

procedure TventanaSeleccion.CancelClick(Sender: TObject);
begin

end;

procedure TventanaSeleccion.Label1Click(Sender: TObject);
begin

end;

end.
