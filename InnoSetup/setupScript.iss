; Script Made By Eric Q. and modified by Ben C.
; Please consult the documentation if you plan to modify :)
; http://www.jrsoftware.org/ishelp/

#define MyAppName "TowerRush"
#define MyAppPublisher "Fewdpew Games"
#define MyAppURL "https://fewdpew.me/"
#define MyAppExeName "TowerRush.exe"

; Please remember to change the variable below if you are building from a different setup!
#define ResourceFolder "C:\Users\BenCu\Documents\TowerRushInstaller\Resources"

; Installer version naming: First 3 digits are the app version. Last digit is for installer revision (increment by 1 every time this script changes)
#define InstallerVersion "1.3.0.1"
#define MyAppVersion "1.3.0a"  
                               
[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{BAAE0580-B099-4D47-93E7-2665041D85B1}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppComments=This app will update and/or install the latest version of {#MyAppName} (v{#MyAppVersion})
VersionInfoVersion= {#InstallerVersion}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName= {#MyAppPublisher}
DirExistsWarning=auto
DisableDirPage=auto
AllowNoIcons=yes
CloseApplications=yes
LicenseFile={#ResourceFolder}\license.txt
OutputBaseFilename={#MyAppName} {#MyAppVersion} Setup
SetupIconFile={#ResourceFolder}\Logo.ico
UninstallDisplayIcon={app}\TowerRush.exe
UninstallDisplayName={#MyAppName} {#MyAppVersion}
Compression=lzma2/ultra
SolidCompression=yes
MinVersion=0,5.01

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; OnlyBelowVersion: 0,6.1

[Files]
Source: "{#ResourceFolder}\TowerRush.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#ResourceFolder}\TowerRush_Data\*"; DestDir: "{app}\TowerRush_Data\"; Flags: ignoreversion createallsubdirs recursesubdirs
Source: "{#ResourceFolder}\Levels\*"; DestDir: "{app}\TowerRush_Data\"; Flags: ignoreversion createallsubdirs recursesubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: dirifempty; Name: "{app}\"

[Code]
//This script is made by Eric Q. and modified for release by Ben C.
function InitializeSetup(): Boolean;  

 begin
  Result := MsgBox('This is an Alpha Build' + #13#10 + 'Some features might not work as intended' + #13#10 + 'Please report all bugs to support@fewdpew.me' + #13#10 + 'Thanks for being a valuable Beta Tester!' + #13#10 + 'Continue Installation?', mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES;
  if Result = False then
    MsgBox('Ok. Exiting Setup.', mbInformation, MB_OK);
end;

/////////////////////////////////////////////////////////////////////

//I got these from stackoverflow. Checks for previous versions installed.
//If found, it uninstalls them.
//http://stackoverflow.com/questions/2000296/innosetup-how-to-automatically-uninstall-previous-installed-version
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;


/////////////////////////////////////////////////////////////////////
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;


/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

/////////////////////////////////////////////////////////////////////
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;
end;
