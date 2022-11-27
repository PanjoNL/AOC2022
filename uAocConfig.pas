unit uAocConfig;

interface

uses
  Registry;

type TAOCConfig = Class
private
  FBaseUrl: string;
  FBaseFilePath: string;

  function SetupRegistry(AAccess: LongWord): TRegistry;
  function GetSessionCookie: String;
  procedure SetSessionCookie(Const aValue: string);
public
  constructor Create;

  property BaseUrl: String read FBaseUrl;
  property BaseFilePath: string read FBaseFilePath;
  property SessionCookie: string read GetSessionCookie write SetSessionCookie;
End;


implementation

uses
  inifiles, System.SysUtils, winapi.Windows;


constructor TAOCConfig.Create;
const Config: string = 'Config';
var Ini: TIniFile;
    Path: string;
begin
  Path := ParamStr(0);
  while (Not FileExists(Path+PathDelim+'AocConfig.ini')) do
  begin
    Path := ExtractFileDir(Path);
    if path = '' then
      Break;
  end;

  Ini := TIniFile.Create(Path+PathDelim+'AocConfig.ini');
  try
    FBaseUrl := Ini.ReadString(Config, 'BaseUrl', '');
    FBaseFilePath := Path;
  finally
    Ini.Free;
  end;
end;

function TAOCConfig.SetupRegistry(AAccess: LongWord): TRegistry;
begin
  Result := TRegistry.Create(AAccess);
  Result.RootKey := HKEY_CURRENT_USER;
  Result.OpenKey('Software\AOC', true);
end;

procedure TAOCConfig.SetSessionCookie(const aValue: string);
begin
 With SetupRegistry(KEY_WRITE) do
  try
    if aValue = '' then
      DeleteKey('AOCSessionCookie')
    else
      WriteString('AOCSessionCookie', aValue);
  finally
    Free;
  end;
end;

function TAOCConfig.GetSessionCookie: String;
begin
  With SetupRegistry(KEY_READ) do
  try
    Result := GetDataAsString('AOCSessionCookie');
  finally
    Free;
  end;
end;

end.
