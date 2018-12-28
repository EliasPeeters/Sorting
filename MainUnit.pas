unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, Vcl.ExtCtrls,
  Vcl.Samples.Spin, types, DrawDiagram;

type
  TForm1 = class(TForm)
    BtnCreateArray: TButton;
    Diagram1: TImage;
    Diagram2: TImage;
    Diagram3: TImage;
    Diagram1Swaps: TPanel;
    Diagram2Swaps: TPanel;
    Diagram3Swaps: TPanel;
    Diagram1Access: TPanel;
    Diagram3Access: TPanel;
    Diagram2Access: TPanel;
    Diagram1Selector: TComboBox;
    Diagram2Selector: TComboBox;
    Diagram3Selector: TComboBox;
    EditMaxNum: TSpinEdit;
    EditArrayLength: TSpinEdit;
    SelectorDiagramTyp: TComboBox;
    EditSpeed: TSpinEdit;
    BtnSort: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    SelectorArrayType: TComboBox;
    File1: TMenuItem;
    ExportResults1: TMenuItem;
    Export1: TMenuItem;
    ImportArray1: TMenuItem;

    procedure DrawAllDiagrams();
    procedure ArrayTransfer();
    procedure DisableUI();
    procedure ThreadFinished;
    procedure Sort(Image: TImage; Bitmap: TBitmap; ComboBox: TComboBox; var Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);


    procedure FormCreate(Sender: TObject);
    procedure BtnCreateArrayClick(Sender: TObject);
    procedure EditMaxNumChange(Sender: TObject);
    procedure EditArrayLengthChange(Sender: TObject);
    procedure EditSpeedChange(Sender: TObject);
    procedure BtnSortClick(Sender: TObject);
    procedure SelectorDiagramTypChange(Sender: TObject);
    procedure Diagram2SelectorChange(Sender: TObject);
    procedure Diagram1SelectorChange(Sender: TObject);
    procedure Diagram3SelectorChange(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure ExportResults1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;
  MaxNum, ArrayLength, DiagramStyle, Speed: Integer;
  MainArray: TArrayOfInt;
  ColorMode, HeightMode: Boolean;
  Diagram1Bitmap, Diagram2Bitmap, Diagram3Bitmap: TBitmap;
  Diagram1Array, Diagram2Array, Diagram3Array: TArrayOfInt;
  clBoxColor: TColor = clBtnFace;
  clDiagramColor: TColor;
  ArrayForWriting: Array[0..100] of String;
  Algo1, Algo2, Algo3, ArrayType: String;
  AbortBoolean: Boolean = false;
  FinishedThreads: Integer;

implementation

{$R *.dfm}

uses  UsefullProcedure, FileLoaderUnit, Bubblesort, InsertionsSort, GnomeSort,
      CombSort, BogoSort, CSVSaver, StoogeSort;


procedure TForm1.ArrayTransfer();
var
  I: Integer;
begin
  setlength(Diagram1Array, ArrayLength);
  setlength(Diagram2Array, ArrayLength);
  setlength(Diagram3Array, ArrayLength);
  for I := 0 to length(MainArray)-1 do
  begin
    Diagram1Array[i] := MainArray[i];
    Diagram2Array[i] := MainArray[i];
    Diagram3Array[i] := MainArray[i];
  end;
end;

procedure TForm1.BtnCreateArrayClick(Sender: TObject);
begin
  fillArray(MainArray, SelectorArrayType.Text);
  ArrayTransfer;
  DrawAllDiagrams;
end;

procedure TForm1.ThreadFinished;
begin
  Inc(FinishedThreads);
  if FinishedThreads = 3 then
  begin
    DisableUI;
  end;
end;

procedure TForm1.Sort(Image: TImage; Bitmap: TBitmap; ComboBox: TComboBox; var Content: TArrayOfInt; StepsPanel, DAPanel: TPanel; DA: Integer);
begin
  //Diagram1
  if ComboBox.Text = 'QuickSort' then
  begin

  end
  else if ComboBox.Text = 'BubbleSort' then
  begin
    BubbleSortProcedure(Image, Bitmap, Content, StepsPanel, DAPanel, DA);
  end
  else if ComboBox.Text = 'BogoSort' then
  begin
    BogoSortProcedure(Content, Image, Bitmap, StepsPanel, DAPanel, DA);
  end
  else if ComboBox.Text = 'Stoogesort' then
  begin
    StoogeSortProcedure(Content, 0, length(Content), Image, Bitmap, StepsPanel, DAPanel, DA);
  end
  else if ComboBox.Text = 'CombSort' then
  begin
    CombSortProcedure(Image, Bitmap, Content, StepsPanel, DAPanel, DA);
  end
  else if ComboBox.Text = 'GnomeSort' then
  begin
    gnomesortSortProcedure(Image, Bitmap, Content, StepsPanel, DAPanel, DA);
  end
  else if ComboBox.Text = 'Gravitysort' then
  begin
    //GravitysortProcedure(Image,Bitmap, Content, StepsPanel, DAPanel, 0);
  end
  else if ComboBox.Text = 'Insertionsort' then
  begin
    InsertionsSortProcedure(Image, Bitmap, Content, StepsPanel, DAPanel, 0);
  end
  else if ComboBox.Text = 'QuickSort' then
  begin
    //QuicksortProcedure(Content, 0, length(Content)-1, Image, Bitmap, StepsPanel, DAPanel, 0);
  end
  else if ComboBox.Text = 'UtilitySort' then
  begin
    //UtilitySortProcedure(Image, Bitmap, Content, StepsPanel, DAPanel, 0);
  end
  else
  begin
    //InsertionsSortProcedure(Image, Bitmap, Content, StepsPanel, DAPanel, 0);
  end;
end;

procedure TForm1.BtnSortClick(Sender: TObject);
begin
  DisableUI;
  FinishedThreads:= 0;

  //1
  TThread.CreateAnonymousThread(
    procedure
  var
    I: Integer;
  begin
    Sort(Diagram1, Diagram1Bitmap, Diagram1Selector, Diagram1Array, Diagram1Swaps, Diagram1Access, 0);
    ThreadFinished;
    TThread.Synchronize(nil,
      procedure
      begin
        DrawDiagramProcedure(Diagram1Bitmap, Diagram1Array, HeightMode, ColorMode, -1, MaxNum, DiagramStyle);
        Diagram1.Picture.Bitmap:= Diagram1Bitmap;
      end);
  end
  ).Start();

  //2
  TThread.CreateAnonymousThread(
    procedure
  var
    I: Integer;
  begin
    Sort(Diagram2, Diagram2Bitmap, Diagram2Selector, Diagram2Array, Diagram2Swaps, Diagram2Access, 0);
    ThreadFinished;
    TThread.Synchronize(nil,
      procedure
      begin
        DrawDiagramProcedure(Diagram2Bitmap, Diagram2Array, HeightMode, ColorMode, -1, MaxNum, DiagramStyle);
        Diagram2.Picture.Bitmap:= Diagram2Bitmap;
      end);
  end
  ).Start();

  //3
  TThread.CreateAnonymousThread(
    procedure
  var
    I: Integer;
  begin
    Sort(Diagram3, Diagram3Bitmap, Diagram3Selector, Diagram3Array, Diagram3Swaps, Diagram3Access, 0);
    ThreadFinished;
    TThread.Synchronize(nil,
      procedure
      begin
        DrawDiagramProcedure(Diagram3Bitmap, Diagram3Array, HeightMode, ColorMode, -1, MaxNum, DiagramStyle);
        Diagram3.Picture.Bitmap:= Diagram3Bitmap;
      end);
  end
  ).Start();
end;

procedure TForm1.DrawAllDiagrams();
var
  I: Integer;
begin
  MaxNum:= EditMaxNum.Value;
  I:= length(MainArray);

  DrawDiagramProcedure(Diagram1Bitmap, Diagram1Array, ColorMode, HeightMode, -1, MaxNum, DiagramStyle);
  Diagram1.Picture.Bitmap:= Diagram1Bitmap;

  DrawDiagramProcedure(Diagram2Bitmap, Diagram2Array, ColorMode, HeightMode, -1, MaxNum, DiagramStyle);
  Diagram2.Picture.Bitmap:= Diagram2Bitmap;

  DrawDiagramProcedure(Diagram3Bitmap, Diagram3Array, ColorMode, HeightMode, -1, MaxNum, DiagramStyle);
  Diagram3.Picture.Bitmap:= Diagram3Bitmap;
end;

procedure TForm1.EditArrayLengthChange(Sender: TObject);
begin
  ArrayLength:= EditArrayLength.Value;
  ChangeConfig(ArrayForWriting, 'array-length', IntToStr(EditArrayLength.Value));
end;

procedure TForm1.EditMaxNumChange(Sender: TObject);
begin
  MaxNum:= EditMaxNum.Value;
  ChangeConfig(ArrayForWriting, 'maxnum', IntToStr(EditMaxNum.Value));
end;

procedure TForm1.EditSpeedChange(Sender: TObject);
begin
  Speed:= EditSpeed.Value;
end;

procedure TForm1.Export1Click(Sender: TObject);
var
  CSVFile: TCSV;
  I: Integer;
begin
  if SaveDialog1.Execute then
  begin
    CSVFile.name:= SaveDialog1.FileName;
    CreateCSV(CSVFile, CSVFile.name);
    setLength(CSVFile.Lines, ArrayLength+1);
    setLength(CSVFile.Lines[0], 1);
    CSVFile.Lines[0][0]:= 'Generated Array';
    for I := 1 to ArrayLength do
    begin
      setLength(CSVFile.Lines[i], 1);
      CSVFile.Lines[i][0]:= IntToStr(MainArray[i-1]);
    end;
    SaveCSV(CSVFile);
  end;

  //CSVFile.name:=  inputbox('Export Array as CSV', 'FileName', '');


end;

procedure TForm1.ExportResults1Click(Sender: TObject);
  var
  CSVFile: TCSV;
  I: Integer;
  today: TDateTime;
begin
  if SaveDialog1.Execute then
  begin
    CSVFile.name:= SaveDialog1.FileName;
    CreateCSV(CSVFile, CSVFile.name);
    setLength(CSVFile.Lines, length(MainArray));
    setLength(CSVFile.Lines[0], 6);
    today:= Now;
    CSVFile.Lines[0][0]:= 'Speed Results';
    CSVFile.Lines[0][1]:= DateToStr(today);
    CSVFile.Lines[0][2]:= TimeToStr(today);
    CSVFile.Lines[0][5]:= 'Sorted Array';

    setLength(CSVFile.Lines[1], 3);
    CSVFile.Lines[1][0]:= ' ';
    CSVFile.Lines[1][1]:= ' ';
    CSVFile.Lines[1][2]:= ' ';

    setLength(CSVFile.Lines[2], 3);
    CSVFile.Lines[2][0]:= 'Sorting Algorythm';
    CSVFile.Lines[2][1]:= 'Swaps';
    CSVFile.Lines[2][2]:= 'Accesses';

    for I := 3 to 5 do
    begin
      setLength(CSVFile.Lines[i], 3);
      //CSVFile.Lines[i][0]:= IntToStr(MainArray[i-1]);
    end;
    CSVFile.Lines[3][0]:= Diagram1Selector.Text;
    CSVFile.Lines[3][1]:= Diagram1Swaps.Caption;
    CSVFile.Lines[3][2]:= Diagram1Access.Caption;

    CSVFile.Lines[4][0]:= Diagram2Selector.Text;
    CSVFile.Lines[4][1]:= Diagram2Swaps.Caption;
    CSVFile.Lines[4][2]:= Diagram2Access.Caption;

    CSVFile.Lines[5][0]:= Diagram3Selector.Text;
    CSVFile.Lines[5][1]:= Diagram3Swaps.Caption;
    CSVFile.Lines[5][2]:= Diagram3Access.Caption;

    for I := 1 to ArrayLength do
    begin
      setLength(CSVFile.Lines[i], 6);
      CSVFile.Lines[i][5]:= IntToStr(MainArray[i-1]);
    end;


    SaveCSV(CSVFile);
  end;

end;

procedure CreateBitmap(var Bitmap: TBitmap; Image: TImage);
begin
  Bitmap:= TBitmap.Create;
  Bitmap.Width:= Image.Width;
  Bitmap.Height:= Image.Height;
end;

procedure TForm1.Diagram1SelectorChange(Sender: TObject);
begin
  ChangeConfig(ArrayForWriting, 'algo1', Diagram1Selector.Text);
end;

procedure TForm1.Diagram2SelectorChange(Sender: TObject);
begin
  ChangeConfig(ArrayForWriting, 'algo2', Diagram2Selector.Text);
end;

procedure TForm1.Diagram3SelectorChange(Sender: TObject);
begin
  ChangeConfig(ArrayForWriting, 'algo3', Diagram3Selector.Text);
end;

procedure TForm1.DisableUI();
begin
  if EditMaxNum.Enabled then
  begin
    EditMaxNum.Enabled:= false;
    EditArrayLength.Enabled:= false;
    SelectorArrayType.Enabled:= false;
    SelectorDiagramTyp.Enabled:= false;
    BtnCreateArray.Enabled:= false;
    Diagram1Selector.Enabled:= false;
    Diagram2Selector.Enabled:= false;
    Diagram3Selector.Enabled:= false;
  end
  else
  begin
    EditMaxNum.Enabled:= true;
    EditArrayLength.Enabled:= true;
    SelectorArrayType.Enabled:= true;
    SelectorDiagramTyp.Enabled:= true;
    BtnCreateArray.Enabled:= true;
    Diagram1Selector.Enabled:= true;
    Diagram2Selector.Enabled:= true;
    Diagram3Selector.Enabled:= true;
  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  ReadConfig;
  Diagram1Selector.Text:= Algo1;
  Diagram2Selector.Text:= Algo2;
  Diagram3Selector.Text:= Algo3;
  if DiagramStyle = 0 then
  begin
    SelectorDiagramTyp.Text:= 'Bar Chart';
  end
  else if DiagramStyle = 1 then
  begin
    SelectorDiagramTyp.Text:= 'Circle Chart';
  end;

  SelectorArrayType.Text:= ArrayType;
  EditMaxNum.Value:= MaxNum;
  EditArrayLength.Value:= MaxNum;
  EditSpeed.Value:= Speed;

  CreateBitmap(Diagram1Bitmap, Diagram1);
  CreateBitmap(Diagram2Bitmap, Diagram2);
  CreateBitmap(Diagram3Bitmap, Diagram3);

  FillSortingDropDown(Diagram1Selector);
  FillSortingDropDown(Diagram2Selector);
  FillSortingDropDown(Diagram3Selector);
  FillPresetsDropDown(SelectorArrayType);
  FillDiagramStyleDropDown(SelectorDiagramTyp);
  BtnCreateArrayClick(BtnCreateArray);
end;

procedure TForm1.SelectorDiagramTypChange(Sender: TObject);
begin
  if SelectorDiagramTyp.Text = 'Circle Chart' then
  begin
    DiagramStyle:= 1;
  end
  else
  if SelectorDiagramTyp.Text = 'Bar Chart' then
  begin
    DiagramStyle:= 0;
  end
  else
  begin
    SelectorDiagramTyp.Text := 'Bar Chart';
    DiagramStyle:= 0;
  end;
  ChangeConfig(ArrayForWriting, 'diagramstyle', IntToStr(DiagramStyle));
  DrawAllDiagrams;
end;

end.
