unit LAMM.Logs.Forms.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ActnList, IniPropStorage, StdCtrls, ComCtrls, ExtCtrls, StdActns, LCLType,
  LAMM.Logs.Frames.Members, LAMM.Logs.Frames.Laser;

{ TfrmMain }

type
  TfrmMain = class(TForm)
    actSectionsMembers: TAction;
    actSectionsLaser: TAction;
    actlMain: TActionList;
    actFileExit: TFileExit;
    iniAppStorage: TIniPropStorage;
    mnuFileExit: TMenuItem;
    mnuFile: TMenuItem;
    mmnuMain: TMainMenu;
    panMain: TPanel;
    sbMain: TStatusBar;
    tbarMain: TToolBar;
    tbtnLaser: TToolButton;
    tbtnFileExit: TToolButton;
    tbtnSectionsMembers: TToolButton;
    tbtnSeparator1: TToolButton;
    procedure actSectionsLaserExecute(Sender: TObject);
    procedure actSectionsMembersExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FStorageFileName: String;

    FFrameLast: TFrame;
    FFrameMembers: TfrmMembers;
    FFrameLaser: TfrmLaser;

    procedure InitShortCuts;
    procedure InitStorage;
    procedure InitFrames;
    procedure SwitchFrame(const aFrame: TFrame);
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitShortCuts;
  InitStorage;
  InitFrames;
end;

procedure TfrmMain.InitStorage;
begin
  FStorageFileName := ExtractFileDir(ParamStr(0)) + DirectorySeparator +
    'LAMMLogs.ini';
  iniAppStorage.IniFileName := FStorageFileName;
end;

procedure TfrmMain.InitShortCuts;
begin
{$IFDEF LINUX}
  actFileExit.ShortCut := KeyToShortCut(VK_Q, [ssCtrl]);
{$ENDIF}
{$IFDEF WINDOWS}
  actFileExit.ShortCut := KeyToShortCut(VK_X, [ssAlt]);
{$ENDIF}
end;

procedure TfrmMain.InitFrames;
begin
  FFrameMembers := TfrmMembers.Create(panMain);
  FFrameMembers.Parent := panMain;
  FFrameMembers.Visible := True;
  FFrameLast := FFrameMembers;

  FFrameLaser := TfrmLaser.Create(panMain);
  FFrameLaser.Parent := panMain;
  FFrameLaser.Visible := False;
end;

procedure TfrmMain.SwitchFrame(const aFrame: TFrame);
begin
  if Assigned(FFrameLast) then
  begin
    FFrameLast.Visible := False;
  end;
  FFrameLast := aFrame;
  FFrameLast.Visible := True;
  FFrameLast.BringToFront;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := True;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TfrmMain.actSectionsMembersExecute(Sender: TObject);
begin
  SwitchFrame(FFrameMembers);
end;

procedure TfrmMain.actSectionsLaserExecute(Sender: TObject);
begin
  SwitchFrame(FFrameLaser);
end;

end.
