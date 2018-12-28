unit DrawDiagram;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, types;

  procedure DrawBarChart(Bitmap: TBitmap; Content: TArrayOfInt; Color, Height: Boolean; SelectedItem, MaxNum: Integer);
  procedure DrawDiagramProcedure(Bitmap: TBitmap; Content: TArrayOfInt; Color, Height: Boolean; SelectedItem, MaxNum: Integer; DiagramStyle: Integer);

implementation

uses MainUnit;


function GiveColorBack(NumberofItems, Item: Integer):TColor;
var
  HueWert: Extended;
begin
  HueWert:= (360 / NumberofItems)*Item;
  while HueWert > 360 do Huewert:= Huewert / 360;

  if HueWert <= 60 then result:= rgb(255, Round((255 / 60) * Huewert), 0)
  else if HueWert <= 120 then result:= rgb(Round(255 - (255 / 60 * (Huewert - 60))), 255 , 0)
  else if HueWert <= 180 then result:= rgb(0, 255 , Round(255 / 60 * (Huewert-120)))
  else if HueWert <= 240 then result:= rgb(0, Round(255 - (255 / 60 * (Huewert-180))) , 255)
  else if HueWert <= 300 then result:= rgb(Round(255 / 60 * (Huewert-240)), 0 , 255)
  else if HueWert <= 360 then result:= rgb(255 , 0 , Round(255 - (255 / 60 * Round(Huewert-300))));

end;

procedure DrawBarChart(Bitmap: TBitmap; Content: TArrayOfInt; Color, Height: Boolean; SelectedItem, MaxNum: Integer);
var
  BarHeight, ExtraDistanz, GreyColor, I: Integer;
  BarWidth, x1: Double;
begin
  barWidth:= Bitmap.Width / (length(Content));
  //ExtraDistanz:= BarWidth div length(DiagramBox.Content);
  ExtraDistanz:= 0;
  x1:= 0;
    with Bitmap.Canvas do
    begin
      Brush.Color:= clBoxColor;
      Pen.Color:= clBoxColor;
      Rectangle(0, 0, Bitmap.Width, Bitmap.Height);

      MoveTo(0, Bitmap.Width);
      GreyColor:= 140;
      Pen.Style:= psSolid;
      Pen.Color:= rgb(GreyColor, GreyColor, GreyColor);
      LineTo(Bitmap.Width, Bitmap.Height);

      GreyColor:= 190;
      Pen.Style:= psDot;
      Pen.Color:= rgb(GreyColor, GreyColor, GreyColor);

      MoveTo(0, Round(Bitmap.Height * 1/4));
      LineTo(Bitmap.Width, Round(Bitmap.Height * 1/4));

      MoveTo(0, Round(Bitmap.Height * 2/4));
      LineTo(Bitmap.Width, Round(Bitmap.Height * 2/4));

      MoveTo(0, Round(Bitmap.Height * 3/4));
      LineTo(Bitmap.Width, Round(Bitmap.Height * 3/4));

      if SelectedItem <> -1 then
      begin
        clDiagramColor:= rgb(200, 200, 200);
      end
      else
        clDiagramColor:= rgb(96, 157, 254);

        Pen.Style:= psSolid;
        Pen.Width:= 0;
        Pen.Color:= clBoxColor;
        //Brush.Color:= DiagramColor;

        for I := 0 to length(Content) do
        begin
          if Color then
          begin
            Brush.Color:= GiveColorBack(length(Content), Content[i]);
          end
          else
          begin
            if I = SelectedItem then
              Brush.Color:= rgb(88, 206, 162)
            else
            begin
              Brush.Color:= clDiagramColor;
              //Pen.Color:= clDiagramColor;
            end;
          end;

          BarHeight:= (Bitmap.Height div MaxNum)*Content[i];

          Rectangle(Round(x1), Bitmap.Height,Round(x1+barWidth), Bitmap.Height-BarHeight);
          x1:= x1+BarWidth+ExtraDistanz;
        end;
    end;
end;

procedure DrawPie(Canvas: TCanvas; x1, y1, Height, Width: Integer; Anfangswinkel, Endwinkel: Extended; HeightMode: Boolean; Value: Integer);
var
  Anfangswinkelx, Anfangswinkely: Integer;
  Endwinkelx, Endwinkely: Integer;
  Radius, NewHeight, HelperInt: Integer;
  factor, helperFloat: Double;
begin
  Radius:= Width div 2;
  factor:=  ((real(Value) / real(MainUnit.MaxNum)));
  //Radius:= Round(real(Radius) * factor);

  Anfangswinkely:= Round(sin(Anfangswinkel-pi /2) * Radius + Radius+y1);
  Anfangswinkelx:= Round(cos(Anfangswinkel-pi /2) * Radius + Radius+x1);

  Endwinkely:= Round(sin(Endwinkel-pi /2) *Radius+Radius+y1);
  Endwinkelx:= Round(cos(Endwinkel-pi /2)*Radius+Radius+x1);

  NewHeight:= Round(real(Height)*factor);
  HelperInt:= x1+Height;
  HelperInt:= HelperInt-NewHeight;

    Canvas.Pie(x1, y1, x1+Width, y1+Height, Anfangswinkelx, Anfangswinkely, Endwinkelx, Endwinkely);
  //test
end;

procedure DrawCirleChart(Bitmap: TBitmap; Content: TArrayOfInt; Color, Height: Boolean; SelectedItem, MaxNum: Integer);
var
I: Integer;
HelperForColor: Boolean;
Winkel, LengthInt: Extended;
test: TColor;
begin
  with Bitmap.Canvas do
  begin
    Brush.Color:= clBoxColor;
    Pen.Color:= clBoxColor;
    Rectangle(0, 0, Bitmap.Width, Bitmap.Height);

    Winkel:= 2 * pi / Length(Content);
    for I := 1 to Length(Content) do
    begin
      if Color then
      begin
        if I = SelectedItem then Brush.Color:= rgb(88, 206, 162)
        else
        begin
          if HelperForColor then
          begin
            Brush.Color:= clDiagramColor;
            HelperForColor:= false;
          end
          else
          begin
            Brush.Color:= clRed;
            HelperForColor:= true;
          end;
        end;
      end
      else
      begin
        if I = SelectedItem then
          Brush.Color:= rgb(0, 0, 0)
        else
          Brush.Color:= GiveColorBack(MaxNum, Content[i]);
      end;

      Pen.Color:= Brush.Color;
      DrawPie(Bitmap.Canvas, 0,0, Bitmap.height, Bitmap.Width, Winkel*(i), Winkel*(i-1), height, Content[i]);
    end;
  end;
  //Image.Picture.Bitmap:= Bitmap;
end;

procedure DrawDiagramProcedure(Bitmap: TBitmap; Content: TArrayOfInt; Color, Height: Boolean; SelectedItem, MaxNum: Integer; DiagramStyle: Integer);
begin
if DiagramStyle = 0 then
  DrawBarChart(Bitmap, Content, Color, Height, SelectedItem, MaxNum);

if DiagramStyle = 1 then
  DrawCirleChart(Bitmap, Content, Color, Height, SelectedItem, MaxNum);

end;

end.

