unit BubbleSort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types;

  procedure BubbleSortProcedure(Image: TImage; Bitmap: TBitmap; Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);

  var Steps: Integer = 0;

implementation

uses MainUnit, DrawDiagram, Swoop;


procedure BubbleSortProcedure(Image: TImage; Bitmap: TBitmap; Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);
var
  I, Counter, CurrentSteps: Integer;
  unsorted: Boolean ;
begin
  CurrentSteps:= 0;
  unsorted:= true;
  steps:= 0;
  while unsorted do
  begin
    Counter:= 0;
    if MainUnit.AbortBoolean then Exit;
    for I := 0 to length(Content)-2 do
    begin
      //if AbortBoolean then Abort;
      if MainUnit.AbortBoolean then Exit;

      if Access(Content, I, DA, DAPanel) > Access(Content, I+1, DA, DAPanel) then
      begin
        SwoopProcedure(I, I+1, Content, Image, Bitmap, StepsPanel, Steps);

        //StatusInt:= (CurrentSteps*100 div TotalStep);
        //CurrentSteps:= CurrentSteps+1;
      end
      else
        Counter:= Counter+1;

    end;
    if Counter = length(Content)-1 then unsorted:= false;

  end;
end;

end.

