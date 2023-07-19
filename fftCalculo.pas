unit fftCalculo;

interface

uses
  System.Math;

type
  Complex = record
    re, im: Double;
  end;

  ComplexArray = array of Complex;

procedure FFT(var x: ComplexArray);
function DoubleArrayToComplexArray(const data: TArray<Double>): ComplexArray;
function CalculateFFTSpectrum(const data: TArray<Double>): TArray<Double>;

implementation

procedure FFT(var x: ComplexArray);
var
  n, i, j, k, n1, n2: Integer;
  c, t: Complex;
begin
  n := Length(x);
  j := 0;
  for i := 0 to n - 1 do
  begin
    if j > i then
    begin
      t := x[j];
      x[j] := x[i];
      x[i] := t;
    end;
    k := n div 2;
    while (k >= 1) and (j >= k) do
    begin
      Dec(j, k);
      k := k div 2;
    end;
    Inc(j, k);
  end;

  n1 := 0;
  n2 := 1;
  for i := 0 to Trunc(Log2(n)) - 1 do
  begin
    n1 := n2;
    n2 := n2 + n2;
    for j := 0 to n1 - 1 do
    begin
      c.re := Cos(-Pi * j / n1);
      c.im := Sin(-Pi * j / n1);
      k := j;
      while k < n do
      begin
        t.re := c.re * x[k + n1].re - c.im * x[k + n1].im;
        t.im := c.im * x[k + n1].re + c.re * x[k + n1].im;
        x[k + n1].re := x[k].re - t.re;
        x[k + n1].im := x[k].im - t.im;
        x[k].re := x[k].re + t.re;
        x[k].im := x[k].im + t.im;
        Inc(k, n2);
      end;
    end;
  end;

end;

function DoubleArrayToComplexArray(const data: TArray<Double>): ComplexArray;
var
  i: Integer;
begin
  SetLength(Result, Length(data));
  for i := Low(data) to High(data) do
  begin
    Result[i].re := data[i];
    Result[i].im := 0.0;
  end;
end;

function CalculateFFTSpectrum(const data: TArray<Double>): TArray<Double>;
var
  i: Integer;
  complexData: ComplexArray;
begin
  // Convertir el arreglo de entrada en un arreglo de números complejos
  complexData := DoubleArrayToComplexArray(data);

  // Calcular la FFT del arreglo de números complejos
  FFT(complexData);

  // Calcular el espectro de la FFT (magnitud de cada número complejo)
  SetLength(Result, Length(complexData));
  for i := Low(complexData) to High(complexData) do
    Result[i] := Sqrt(Sqr(complexData[i].re) + Sqr(complexData[i].im));
end;
end.
