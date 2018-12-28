unit gnomesort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types;

  procedure gnomesortSortProcedure(Image: TImage; Bitmap: TBitmap; content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);


  var
    Steps: Integer;
implementation

uses swoop;

procedure gnomesortSortProcedure(Image: TImage; Bitmap: TBitmap; content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);
var
pos: Integer;
begin
  pos:= 0;
  steps:= 0;
  while (pos < length(content)) do
  begin
    if (pos = 0) or (Access(Content, pos, DA, DAPanel) >= Access(Content, pos-1, DA, DAPanel)) then
    begin
      pos:= pos + 1;
    end
    else
    begin
      SwoopProcedure(pos, pos-1, content, image, bitmap, stepspanel,steps);
      pos := pos-1;
    end;
  end;

end;


end.


