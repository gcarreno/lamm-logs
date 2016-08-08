unit LAMM.Logs.Frames.Members;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, DbCtrls, RxDBGrid,
  LAMM.Logs.DataModules.Main;

{ TfrmMembers }

type
  TfrmMembers = class(TFrame)
    dbnavMembers: TDBNavigator;
    panTitle: TPanel;
    rxdbgridMembers: TRxDBGrid;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

end.

