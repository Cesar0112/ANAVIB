unit Seguridad;

interface

uses
  Hash, System.SysUtils, FMX.Dialogs;



 var
 usuario: String;
function encriptarSHA256(const pass: string): String;

implementation

function encriptarSHA256(const pass: string): String;
var
  hashSHA: THashSHA2;
begin

  try
    hashSHA := THashSHA2.Create;
    Result := LowerCase(hashSHA.GetHashString(pass,
      THashSHA2.TSHA2Version.SHA256));

  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

end.
