#define MyAppName "Whiplash"
#define MyAppDir "whiplash"
#define ExportsDir "exports"
#define GraphicsDir "assets"

[Setup]
AppName={#MyAppName}
AppVersion=1.0
AppPublisher="Kedar Panchal"
ArchitecturesInstallIn64BitMode=x64compatible
DefaultDirName="{commoncf}\VST3"
UninstallFilesDir="{app}"
LicenseFile="./LICENSE"
OutputBaseFilename="WhiplashInstaller"
OutputDir="{#ExportsDir}"
Compression=lzma
SolidCompression=yes
ChangesEnvironment=yes
ShowLanguageDialog=no
UsePreviousAppDir=no

[Components]
Name: "main"; Description: "Whiplash Installation"; Types: full custom; Flags: fixed;
Name: "csound"; Description: "Installs CSound (skip if you have CSound 6.17 or later already installed)"; Types: full;

[Dirs]
Name: "{app}\{#MyAppDir}"; Permissions: users-full;
Name: "{app}\{#MyAppDir}\{#GraphicsDir}"; Permissions: users-full;

[Files]
Source: "kaos.csd"; DestDir: "{app}\{#MyAppDir}"; Components: main; Flags: ignoreversion; Permissions: users-full;
Source: "{#GraphicsDir}\gooey.png"; DestDir: "{app}\{#MyAppDir}\{#GraphicsDir}"; Components: main; Flags: ignoreversion; Permissions: users-full;
Source: "{#GraphicsDir}\knob.png"; DestDir: "{app}\{#MyAppDir}\{#GraphicsDir}"; Components: main; Flags: ignoreversion; Permissions: users-full;
Source: "{#GraphicsDir}\knob2.png"; DestDir: "{app}\{#MyAppDir}\{#GraphicsDir}"; Components: main; Flags: ignoreversion; Permissions: users-full;
Source: "{#ExportsDir}\csound64.dll"; DestDir: "{app}\{#MyAppDir}"; Components: main; Flags: ignoreversion; Permissions: users-full;
Source: "{#ExportsDir}\whiplash.vst3"; DestDir: "{app}\{#MyAppDir}"; Components: main; Flags: ignoreversion; Permissions: users-full;

Source: "C:\Program Files\Csound6_x64\*"; DestDir: "C:\Program Files\Csound6_x64\"; Flags: ignoreversion recursesubdirs; Components: csound; Permissions: users-full;

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType:string; ValueName:"OPCODE6DIR64"; ValueData:"C:\Program Files\Csound6_x64\plugins64\"; Flags: preservestringtype uninsdeletevalue; Components: csound
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};C:\Program Files\Csound6_x64\bin"; Components: csound; Check: NeedsAddPath('C:\Program Files\Csound6_x64\bin')

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  { look for the path with leading and trailing semicolon }
  { Pos() returns 0 if not found }
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;