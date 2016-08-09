unit LAMM.Logs.Frames.Laser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, DbCtrls, PairSplitter,
  ComCtrls, Dialogs, ActnList, StdCtrls, RxDBGrid, LAMM.Logs.DataModules.Main;

{ TfrmLaser }

type
  TfrmLaser = class(TFrame)
    actSectionsLaserDelete: TAction;
    actSectionsLaserAdd: TAction;
    actlLaser: TActionList;
    psLaser: TPairSplitter;
    pssMembers: TPairSplitterSide;
    pssLaser: TPairSplitterSide;
    panTitle: TPanel;
    rxdbgridMembersCopy: TRxDBGrid;
    rxdbgridLaser: TRxDBGrid;
    tbarLaser: TToolBar;
    tbtnAdd: TToolButton;
    tbtnDelete: TToolButton;
    procedure actSectionsLaserDeleteExecute(Sender: TObject);
    procedure actSectionsLaserAddExecute(Sender: TObject);
    procedure lbMembersSelectionChange(Sender: TObject; User: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TfrmLaser }

procedure TfrmLaser.actSectionsLaserAddExecute(Sender: TObject);
var
  sUsage: String;
begin
  if InputQuery('Usage', 'Add usage', sUsage) then
  begin

  end;
end;

procedure TfrmLaser.lbMembersSelectionChange(Sender: TObject; User: boolean);
begin
  //
end;

procedure TfrmLaser.actSectionsLaserDeleteExecute(Sender: TObject);
begin
  //
end;

end.

