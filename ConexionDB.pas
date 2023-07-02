unit ConexionDB;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Datasnap.Provider;

type
  TDM = class(TDataModule)
    DataSetProvider1: TDataSetProvider;
    Conn: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;
  FileNameConfig: String;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
var
  tsConfig: TStrings;
  tmp: String;

begin

  FileNameConfig := 'Config.cfg';
  begin
    try
      tsConfig := TStringlist.Create;
      try
        tsConfig.LoadFromFile(FileNameConfig);
      except
        Begin

        end;

      end;
      DM.Conn.Protocol := tsConfig.Values[ProtocolDBConst];
      DM.Conn.HostName := tsConfig.Values[HostDBConst];
      DM.Conn.Port := StrToIntDef(tsConfig.Values[PortDBConst], 0);
      DM.Conn.Database := tsConfig.Values[DataBaseConst];
      DM.Conn.User := tsConfig.Values[UserDBConst];
      DM.Conn.Password := tsConfig.Values[PasswordDBConst];

      try
        DM.Conn.Connected := true;
      except
        Begin
          DM.Conn.Connected := false;
        end;
      end; // try

      if DM.Conn.Connected then
      Begin
        // DM.tbSoundIdeas.Active:=true;
        // DM.ztbBioLife.Active:=true;
        // DM.ZQuery1.Active:=true;
        DataBaseInitError := AS_DB_Connected;
      end
      else
      Begin
        Showmessage(msgSinDBConxionVar);
        DataBaseInitError := AS_DB_NoConnected; // No  Conectado
        // Application.Terminate;
      End;

    finally
      tsConfig.free;
    end;

  end;

end.
