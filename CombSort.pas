unit CombSort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types, Math;

procedure CombSortProcedure(Image: TImage; Bitmap: TBitmap; Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);
//procedure CombSortQuick(var Content: TArrayOfInt);

  var Steps: Integer = 0;

implementation

uses Swoop, MainUnit;

procedure CombSortProcedure(Image: TImage; Bitmap: TBitmap; Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);
var
  shrink: Real;
  sorted: Boolean;
  gap, i: Integer;
begin
  Steps:= 0;
  shrink:= 1.3;
  sorted:= false;
  gap:= length(Content);

  while not(sorted) do
  begin
    gap:= floor(gap/shrink);
    if gap <= 1 then
    begin
      gap := 1;
      sorted:= true;
    end;
    if MainUnit.AbortBoolean then Exit;
    i:= 0;
    while i + gap < length(Content) do
    begin
      if MainUnit.AbortBoolean then Exit;
      if Access(Content, I, DA, DAPanel) > Access(Content, I+gap, DA, DAPanel) then
      begin
        Swoop.SwoopProcedure(i, i+gap, Content, Image, Bitmap, StepsPanel, Steps);
        sorted:= false;
      end;

      i:= i+1;

    end;

  end;

end;

{
procedure CombSortQuick(var Content: TArrayOfInt);
var
  shrink: Real;
  sorted: Boolean;
  gap, i: Integer;
  Storage: String;
begin
  Steps:= 0;
  shrink:= 1.3;
  sorted:= false;
  gap:= length(Content);

  while not(sorted) do
  begin
    gap:= floor(gap/shrink);
    if gap <= 1 then
    begin
      gap := 1;
      sorted:= true;
    end;
    if MainUnit.AbortBoolean then Exit;
    i:= 0;
    while i + gap < length(Content) do
    begin
      if MainUnit.AbortBoolean then Exit;
      if Content[i] > Content[i+gap] then
      begin
        Storage:= Content[i];
        Content[i]:= Content[i+gap];
        Content[i+gap]:= Storage;
        sorted:= false;
      end;

      i:= i+1;

    end;

  end;

end; }

end.

