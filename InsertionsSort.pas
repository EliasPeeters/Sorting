unit InsertionsSort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types;

  procedure InsertionsSortProcedure(Image: TImage; Bitmap: TBitmap; Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);

  var Steps: Integer;
implementation

uses DrawDiagram, MainUnit;


procedure InsertionsSortProcedure(Image: TImage; Bitmap: TBitmap; Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);
var
  sortInt, j, i: Integer;
begin
  Steps:= 0;
  for i := 1 to high(Content) do
  begin
    j:= i;
    sortInt:= Content[i];
    Inc(DA);
    if MainUnit.AbortBoolean then
    begin
      //DrawDiagramProcedure(Bitmap, Content, MainUnit.ColorMode, MainUnit.HeightMode, -1, MainUnit.MaxNum, MainUnit.DiagramStyle);
      Exit;
    end;
    DAPanel.Caption:= IntToStr(DA);
    while (j > 0) and (Content[j-1] > sortInt )do
    begin
      if MainUnit.AbortBoolean then
      begin
        //DrawDiagramProcedure(Bitmap, Content, MainUnit.ColorMode, MainUnit.HeightMode, -1, MainUnit.MaxNum, MainUnit.DiagramStyle);
        Exit;
      end;
      Inc(DA);
      DAPanel.Caption:= IntToStr(DA);
      Content[j]:= Content[j-1];
      Inc(DA);
      DAPanel.Caption:= IntToStr(DA);
      Dec(j);
      sleep(MainUnit.Speed);
      Inc(Steps);
        TThread.Synchronize(nil,
      procedure
      begin
        DrawDiagramProcedure(Bitmap, Content, MainUnit.HeightMode, MainUnit.ColorMode, j, MainUnit.MaxNum, MainUnit.DiagramStyle);
        Image.Picture.Bitmap:= Bitmap;
        StepsPanel.Caption:= IntToStr(Steps);
      end);
    end;
    Content[j]:= sortInt;
  end;
end;

end.

