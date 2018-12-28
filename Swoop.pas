unit Swoop;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types;

  procedure SwoopProcedure(Object1, Object2: Integer; Content: TArrayOfInt; Image: TImage; Bitmap: TBitmap; StepsPanel: TPanel; var Steps: Integer);
  function Access(Content: TArrayOfInt; Position: Integer;var DA: Integer; DAPanel: TPanel):Integer;

implementation

uses MainUnit, DrawDiagram;

procedure ThreadHelper(Object1, Object2: Integer; Content: TArrayOfInt; Image: TImage; Bitmap: TBitmap; StepsPanel: TPanel; Steps: Integer);
begin
  TThread.Synchronize(nil,
      procedure
      begin
        DrawDiagramProcedure(Bitmap, Content, MainUnit.HeightMode, MainUnit.ColorMode, Object1, MainUnit.MaxNum, MainUnit.DiagramStyle);
        Image.Picture.Bitmap:= Bitmap;
        StepsPanel.Caption:= IntToStr(Steps);
      end);
end;

procedure SwoopProcedure(Object1, Object2: Integer; Content: TArrayOfInt; Image: TImage; Bitmap: TBitmap; StepsPanel: TPanel; var Steps: Integer);
var
  Storage: Integer;
begin
  Storage:= Content[Object1];
  Content[Object1]:= Content[Object2];
  Content[Object2]:= Storage;
  Steps:= Steps+1;

    ThreadHelper(Object1, Object2, Content, Image, Bitmap, StepsPanel, Steps);
  sleep(MainUnit.Speed);
end;

function Access(Content: TArrayOfInt; Position: Integer;var DA: Integer; DAPanel: TPanel):Integer;
var
  Helper: String;
begin
  DA:= DA+1;
  Helper:= IntToStr(DA);
  TThread.Synchronize(nil,
    procedure
    begin

      DAPanel.Caption:= Helper;
    end);

  result:= Content[Position];
end;

end.

