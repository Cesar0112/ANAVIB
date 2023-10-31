unit MetodoConfiguracion;

interface

uses System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Controls, FMX.Forms;

var
  Modo, Database, Protocol, LibraryLocation: String;
  FrecMuestreo: Integer;
  StyleClaro: TStyleBook;
  StyleOscuro: TStyleBook;
procedure cargarConfiguracion();
procedure cargarEstilo(var Ventana: TObject);

implementation

procedure cargarConfiguracion();
var
  archivo: TextFile;
  linea, clave, valor: string;

begin
  try
    AssignFile(archivo, 'config.cfg');
    // Deberia verificar que existe primero
    // Leer datos del archivo config.cfg
    Reset(archivo);
    while not Eof(archivo) do // lee hasta el final del archivo
    begin
      Readln(archivo, linea);

      // Separar la clave y el valor en cada línea
      // asumiendo que están separados por el caracter '='
      clave := Copy(linea, 1, Pos('=', linea) - 1);
      valor := Copy(linea, Pos('=', linea) + 1, Length(linea));

      // Utilizar las claves y valores para configurar la aplicación
      if clave = 'Database' then
      begin;
        Database := valor;
      end
      else if clave = 'LibraryLocation' then
      begin
        // Valor correspondiente a 'LibraryLocation'
        LibraryLocation := valor;
      end
      else if clave = 'Protocol' then
      begin
        // Valor correspondiente a 'Protocol'
        Protocol := valor;
      end
      else if clave = 'Frecuencia de Muestreo' then
      begin
        FrecMuestreo := StrToInt(valor);
      end
      else if clave = 'Modo' then
      begin
        Modo := valor;
      end;
    end;

    // Cerrar el archivo después de leer
    CloseFile(archivo);
  except
    on E: Exception do
      Writeln('Error: ' + E.Message);
  end;
end;

procedure cargarEstilo(var Ventana: TObject);
begin
  if Modo = 'claro' then
    Ventana := StyleClaro
  else
    Ventana := StyleOscuro
end;

end.
