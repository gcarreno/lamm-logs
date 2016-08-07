unit LAMM.Logs.Frames.Members;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, DbCtrls, RxDBGrid,
  LAMM.Logs.DataModules.Main;

{ TfrmMembers }

type
  TfrmMembers = class(TFrame)
    DBNavigator1: TDBNavigator;
    panTitle: TPanel;
    RxDBGrid1: TRxDBGrid;
  private
    { private declarations }
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

end.

