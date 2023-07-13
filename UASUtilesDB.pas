unit UASUtilesDB;

interface

uses Windows, SysUtils, Classes, ZAbstractRODataset, ZDataset, ZAbstractDataset,
  ZSqlUpdate;

// Funciones Genericas para Insertar, Modificar, Eliminar, Consultar
function ConsultaSQL(var Qry: TZReadOnlyQuery; SQLCmd: WideString): boolean;
function insertarSQL(var Qry: TZQuery; SQLCmd: WideString): boolean;
function ActualizarSQL(var Qry: TZQuery; SQLCmd: WideString): boolean;
function EliminarSQL(var Qry: TZQuery; SQLCmd: WideString): boolean;

// function RecortarGUIDSTR(strGuid: STring) : String;

implementation

(* Para crear un Guid
  var
  stmp : String;
  GuidTMP : TGuid;
  begin
  CreateGUID(GuidTMP);

  stmp:=GUIDToString(GuidTMP);


  function RecortarGUIDSTR(strGuid: STring) : String;
  var
  strRmp : String;
  Begin
  strRmp := AnsiReplaceStr(strGuid, '{', '');
  result := AnsiReplaceStr(strRmp, '}', '');
  End;
*)

// Funciones Genericas para Insertar, Modificar, Eliminar, Consultar
function EliminarSQL(var Qry: TZQuery; SQLCmd: WideString): boolean;
var
  ErrorMsg: String;
Begin
  result := true;
  try
    if Qry.Active then
      Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add(SQLCmd);
    Qry.ExecSQL;
  except
    on E: Exception do
    Begin
      result := false;
      ErrorMsg := E.Message;
    End; // except on E: Exception do Begin
  end; // try
End;

function ActualizarSQL(var Qry: TZQuery; SQLCmd: WideString): boolean;
var
  ErrorMsg: String;
Begin
  result := true;

  try
    if Qry.Active then
      Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add(SQLCmd);
    Qry.ExecSQL;
  except
    on E: Exception do
    Begin
      result := false;
      ErrorMsg := E.Message;
    End; // except on E: Exception do Begin
  end; // try

End;

function insertarSQL(var Qry: TZQuery; SQLCmd: WideString): boolean;
var
  ErrorMsg: String;
Begin
  result := true;
  try
    if Qry.Active then
      Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add(SQLCmd);
    Qry.ExecSQL;
  except
    on E: Exception do
    Begin
      result := false;
      ErrorMsg := E.Message;
    End; // except on E: Exception do Begin
  end; // try
end;

function ConsultaSQL(var Qry: TZReadOnlyQuery; SQLCmd: WideString): boolean;
var
  ErrorMsg: String;
Begin
  try
    if Qry.Active then
      Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add(SQLCmd);
    Qry.Active := true;
  except
    on E: Exception do
    Begin
      result := false;
      ErrorMsg := E.Message;
    End; // except on E: Exception do Begin
  end; // try
end;

end.
