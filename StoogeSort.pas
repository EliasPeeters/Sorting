unit StoogeSort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types;


  procedure StoogeSortProcedure(var Content: TArrayOfInt; a, b: Integer; Image: TImage; Bitmap: TBitmap; StepsPanel, DAPanel: TPanel;var DA: Integer);

  var Steps: Integer = 0;
implementation

uses MainUnit, DrawDiagram, Swoop;



procedure StoogeSortProcedure(var Content: TArrayOfInt; a, b: Integer; Image: TImage; Bitmap: TBitmap; StepsPanel, DAPanel: TPanel;var DA: Integer);
var
  Helper: Integer;
begin
  if Access(Content, a, DA, DAPanel) > Access(Content, b, DA, DAPanel) then
  begin
    SwoopProcedure(a, b, Content, Image, Bitmap, StepsPanel, Steps);
    if MainUnit.AbortBoolean then
    begin
      //DrawDiagramProcedure(Bitmap, Content, MainUnit.ColorMode, MainUnit.HeightMode, -1, MainUnit.MaxNum, MainUnit.DiagramStyle);
      Exit;
    end;

  end;
  if (b-a+1) > 2 then
  begin
    if MainUnit.AbortBoolean then
    begin
      //DrawDiagramProcedure(Bitmap, Content, MainUnit.ColorMode, MainUnit.HeightMode, -1, MainUnit.MaxNum, MainUnit.DiagramStyle);
      Exit;
    end;
    Helper:= (b - a + 1) div 3;
    StoogeSortProcedure(Content, a, b-Helper, Image, Bitmap, StepsPanel, DAPanel, DA);
    StoogeSortProcedure(Content, a+Helper, b, Image, Bitmap, StepsPanel, DAPanel, DA);
    StoogeSortProcedure(Content, a, b-Helper, Image, Bitmap, StepsPanel, DAPanel, DA);
  end;
end;

end.

