unit BogoSort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types, Math;

  procedure BogoSortProcedure(Content: TArrayOfInt; Image: TImage; Bitmap: TBitmap; StepsPanel, DAPanel: TPanel; DA: Integer);

  var Steps: Integer = 0;

implementation

uses DrawDiagram, MainUnit, Swoop;

procedure FastPermuteArray(A: TArrayOfInt);
  procedure Swap(n, m: integer);
  var
    tmp: integer;
  begin
    Randomize;
    tmp := A[n];
    A[n] := A[m];
    A[m] := tmp;
  end;
var
  i: Integer;
begin
  for i := High(A) downto 1 do
    Swap(i, RandomRange(0, i));
end;

function CheckIfSorted(Content: TArrayOfInt;var DA: Integer; DAPanel: TPanel): Boolean;
var
  I, Helper: Integer;
begin
  Result := True;
  for i := 0 to High(Content)-1 do
    if Content[i] > Content[i+1] then
      Exit(False);
end;

procedure ThreadHelper(Content: TArrayOfInt; Image: TImage; Bitmap: TBitmap; StepsPanel: TPanel; Steps: Integer);
begin
  TThread.Synchronize(nil,
      procedure
      begin
        DrawDiagramProcedure(Bitmap, Content, MainUnit.HeightMode, MainUnit.ColorMode, -1, MainUnit.MaxNum, MainUnit.DiagramStyle);
        Image.Picture.Bitmap:= Bitmap;
        StepsPanel.Caption:= IntToStr(Steps);
      end);
end;

procedure BogoSortProcedure(Content: TArrayOfInt; Image: TImage; Bitmap: TBitmap; StepsPanel, DAPanel: TPanel; DA: Integer);
begin
  while not(CheckIfSorted(Content, DA, DAPanel)) do
  begin
    if MainUnit.AbortBoolean then Exit;
    FastPermuteArray(Content);
    Steps:= Steps+1;
    ThreadHelper(Content, Image, Bitmap, StepsPanel, Steps);
    sleep(MainUnit.Speed);
  end;
end;

end.

