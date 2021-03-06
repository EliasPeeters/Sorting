unit FileLoaderUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

  procedure ReadConfig();
  procedure ChangeConfig(var ArrayForWriting: Array of String; Change: String; ChangeInput: String);

implementation

uses MainUnit;

procedure TextFileToArray(var ArrayForWriting: Array of String; TextFileName: String);
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
    //setLength(ArrayForWriting, 10);
    ArrayForWriting[0]:= IntToStr(TextFileLength);

    for I := 1 to TextFileLength do
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

procedure ArrayToTextFile(var ArrayForWriting: Array of String; TextFileName: String);
var
WorkingFile: TextFile;
I: Integer;
Test: String;
begin
    AssignFile(WorkingFile, TextFileName);
    Rewrite(WorkingFile);
    for I := 1 to StrToInt(ArrayForWriting[0]) do
    begin
      Test:= ArrayForWriting[i];
      Writeln(WorkingFile, ArrayForWriting[i]);
    end;
    //Writeln(WorkingFile, '}');
    CloseFile(WorkingFile);
end;

function ReadFileInt(var ArrayForWriting: Array of String; Input: String): Integer;
var
  StorageString: String;
  AnimationSpeedString: String;
  FoundInLine, i, ConfigTXTLength: Integer;
  ConfigTXT: TextFile;
begin

  for I := 1 to StrToInt(ArrayForWriting[0])  do
  begin
    StorageString:= ArrayForWriting[i];
    StorageString:= Copy(StorageString, 1, length(input));
    if StorageString = input then
    begin
      result:= StrToInt(Copy(ArrayForWriting[i], length(input)+3,
      Length(ArrayForWriting[i])-length(input)+1));
      break;
    end;
  end;
end;

function ReadFileString(var ArrayForWriting: Array of String; Input: String): String;
var
  StorageString: String;
  AnimationSpeedString: String;
  FoundInLine, i, ConfigTXTLength: Integer;
  ConfigTXT: TextFile;
begin

  for I := 1 to StrToInt(ArrayForWriting[0])  do
  begin
    StorageString:= ArrayForWriting[i];
    StorageString:= Copy(StorageString, 1, length(input));
    if StorageString = input then
    begin
      result:= Copy(ArrayForWriting[i], length(input)+3,
      Length(ArrayForWriting[i])-length(input)+1);
      break;
    end;
  end;
end;

procedure ChangeConfig(var ArrayForWriting: Array of String; Change: String; ChangeInput: String);
var
  StorageString: String;
  I: Integer;
begin
  for I := 1 to StrToInt(ArrayForWriting[0])  do
  begin
    StorageString:= ArrayForWriting[i];
    StorageString:= Copy(StorageString, 1, length(Change));
    if StorageString = Change then
    begin
      break;
    end;
  end;

  ArrayForWriting[i]:= Change + ': ' + ChangeInput;
  ArrayToTextFile(ArrayForWriting, 'config.txt');
end;

procedure ReadConfig();
begin
  TextFileToArray(ArrayForWriting, 'config.txt');
  Speed:= ReadFileInt(ArrayForWriting, 'diagram-speed');
  Maxnum:= ReadFileInt(ArrayForWriting, 'maxnum');
  ArrayLength:= ReadFileInt(ArrayForWriting, 'arraylength');
  Algo1:= ReadFileString(ArrayForWriting, 'algo1');
  Algo2:= ReadFileString(ArrayForWriting, 'algo2');
  Algo3:= ReadFileString(ArrayForWriting, 'algo3');
  DiagramStyle:= ReadFileInt(ArrayForWriting, 'diagramstyle');
  ArrayType:= ReadFileString(ArrayForWriting, 'array-type');
end;

end.

