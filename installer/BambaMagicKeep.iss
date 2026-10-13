; Inno Setup script for BambaMagicKeep
; Build with: iscc installer\BambaMagicKeep.iss
; Produces: installer\Output\BambaMagicKeepSetup-<version>.exe
;
; Expects the lime Windows build to already be present at
; Export\windows\bin\ (produced by `haxelib run lime build windows -release`).

#define MyAppName "BambaMagicKeep"
; MyAppVersion can be overridden on the command line, e.g. iscc /DMyAppVersion=1.2.3 ...
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#define MyAppPublisher "Company Name"
#define MyAppExeName "BambaMagicKeep.exe"
#define MyBuildDir "..\Export\windows\bin"

[Setup]
AppId={{A3F8E9D2-7B4C-4A1E-9F3D-2C8B5E1D4F7A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
OutputDir=Output
OutputBaseFilename={#MyAppName}Setup-{#MyAppVersion}
SetupIconFile={#MyBuildDir}\icon.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Pull the whole lime build output. _zip_backups\ is excluded — those are the pre-conversion
; source zips kept in the repo for reference and should not ship.
Source: "{#MyBuildDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyBuildDir}\lime.ndll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyBuildDir}\icon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyBuildDir}\manifest\*"; DestDir: "{app}\manifest"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#MyBuildDir}\assets\*"; DestDir: "{app}\assets"; Excludes: "_zip_backups\*,_zip_backups"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent
