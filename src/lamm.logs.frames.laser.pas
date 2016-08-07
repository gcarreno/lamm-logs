unit LAMM.Logs.Frames.Laser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, ExtCtrls, DbCtrls, RxDBGrid,
  LAMM.Logs.DataModules.Main;

{ TfrmLaser }

type
  TfrmLaser = class(TFrame)
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

