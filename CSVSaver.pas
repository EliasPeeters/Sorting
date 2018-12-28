unit CSVSaver;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, STRUtils;

  type
    TArrayOfString = Array of String;

    TCSV = Record
      Lines: Array of TArrayOfString;
      name: String;
    End;

  procedure CreateCSV(var CSVFile: TCSV; name: String);
  procedure OpenCSV(var CSVFile: TCSV);
  procedure SaveCSV(CSVFile: TCSV);

implementation

procedure TextFileToArray(var ArrayForWriting: TArrayOfString; TextFileName: String);
var
   WorkingFile: TextFile;
   TextFileLength, I: Integer;
   StorageString: String;
begin
  if FileExists(TextFileName) then
  begin
    AssignFile(WorkingFile, TextFileName);
    Reset(WorkingFile);
    TextFileLength:= 0;
    while not eof(WorkingFile) do
    begin
      Readln(WorkingFile, StorageString);
      TextFileLength:= TextFileLength+1;
    end;
    CloseFile(WorkingFile);

    AssignFile(WorkingFile, TextFileName);
    Reset(WorkingFile);

    setLength(ArrayForWriting, TextFileLength);
    //ArrayForWriting[0]:= IntToStr(TextFileLength);

    for I := 0 to TextFileLength-1 do
    begin
      Readln(WorkingFile, StorageString);
      ArrayForWriting[i]:= StorageString;

    end;
    CloseFile(WorkingFile);
  end
  else
  begin
    ShowMessage('Looks like this file does not exist');
  end;
end;

procedure ArrayToTextFile(var ArrayForWriting: TArrayOfString; TextFileName: String);
var
WorkingFile: TextFile;
I: Integer;
Test: String;
begin
    AssignFile(WorkingFile, TextFileName);
    Rewrite(WorkingFile);
    for I := 0 to length(ArrayForWriting)-1 do
    begin
      Test:= ArrayForWriting[i];
      Writeln(WorkingFile, ArrayForWriting[i]);
    end;
    //Writeln(WorkingFile, '}');
    CloseFile(WorkingFile);
end;

procedure CreateCSV(var CSVFile: TCSV;name: String);
var
  WorkingFile: TextFile;
begin
  AssignFile(WorkingFile, name);

  if FileExists(name) then
      Append(WorkingFile)
    else
      Rewrite(WorkingFile);
  CSVFile.name:= name;
   CloseFile(WorkingFile);
end;

procedure OpenCSV(var CSVFile: TCSV);
var
  HelperArray: TArrayOfString;
  i,ii, Storage, NumberOfItemsInLine, Helper, Pointer, NextPointer: Integer;
  HelperString: String;
begin
  TextFileToArray(HelperArray, CSVFile.name);
  setLength(CSVFile.Lines, length(HelperArray));
  for i := 0 to length(CSVFile.Lines)-1 do
  begin
    Helper:= 1;
    Storage:= PosEx(';', HelperArray[i], Helper);
    NumberOfItemsInLine:= 0;
    while PosEx(';', HelperArray[i], Helper) <> 0  do
    begin
      Helper:= PosEx(';', HelperArray[i], Helper)+1;
      Storage:= PosEx(';', HelperArray[i], Helper);
      NumberOfItemsInLine:= NumberOfItemsInLine+1
    end;
    HelperString:= Copy(HelperArray[i], Helper, length(HelperArray[i]));
    if Copy(HelperArray[i], Helper, length(HelperArray[i])) <> ''  then
    begin
      NumberOfItemsInLine:= NumberOfItemsInLine+1;
    end;
    Insert(';', HelperArray[i], 1);
    Insert(';', HelperArray[i], length(HelperArray[i])+1);
    setLength(CSVFile.Lines[i], NumberOfItemsInLine);
    Pointer:= 2;
    NextPointer:= PosEx(';', HelperArray[i], Pointer);
    for II := 0 to NumberOfItemsInLine-1 do
    begin

      CSVFile.Lines[i][ii]:= Copy(HelperArray[i], 2, NextPointer-Pointer);
      Delete(HelperArray[i], 1, length(CSVFile.Lines[i][ii])+1);
      Pointer:= PosEx(';', HelperArray[i], Pointer);
    end;
  end;
end;

procedure SaveCSV(CSVFile: TCSV);
var
  HelperArray: TArrayOfString;
  I: Integer;
  II: Integer;
begin
  setLength(HelperArray, length(CSVFile.Lines));
  for I := 0 to length(CSVFile.Lines)-1 do
  begin
    for II := 0 to length(CSVFile.Lines[i])-1 do
    begin
      HelperArray[i]:= HelperArray[i] + ';' + CSVFile.Lines[i][ii];
    end;
    Delete(HelperArray[i], 1,1);
  end;

  ArrayToTextFile(HelperArray, CSVFile.name);
end;

procedure WriteCSV(Line, Coloum: Integer; CSVFile: TCSV);
begin
  //Sh
end;

end.

