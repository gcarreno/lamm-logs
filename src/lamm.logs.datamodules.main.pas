unit LAMM.Logs.DataModules.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Dialogs, ZConnection, ZDataset;

{ TdmMain }

type
  TTableList = (tlMembers, tlLaser);
  TdmMain = class(TDataModule)
    dsMembers: TDataSource;
    zconnMain: TZConnection;
    zqueryMain: TZQuery;
    ztableMembers: TZTable;
    ztableMemberscreated: TDateTimeField;
    ztableMembersid: TLargeintField;
    ztableMembersmodified: TDateTimeField;
    ztableMembersname: TStringField;
    ztableMembersphysical_id: TStringField;
    ztableLaser: TZTable;
    ztableLasercreated: TDateTimeField;
    ztableLaserid: TLargeintField;
    ztableLasermember_id: TLargeintField;
    ztableLasermodified: TDateTimeField;
    ztableLasertime: TLargeintField;
  private
    { private declarations }
    {$IFDEF WINDOWS}
    FSQLiteLibrary: String;
    {$ENDIF}
    FDataBaseFileName: String;

    procedure CreateTable(aTable: TTableList);
  public
    { public declarations }
    procedure CheckDataBaseFile;

    property DataBaseFileName: String read FDataBaseFileName write FDataBaseFileName;
  end;

var
  dmMain: TdmMain;

implementation

const
  cGetTables = 'SELECT name FROM sqlite_master ' +
    'WHERE type=''table'' AND ' +
    'name NOT LIKE ''sqlite%''' +
    ';';
  cGetFields = 'PRAGMA table_info(%s)';
	cTableMembers = 'CREATE TABLE members (' +
    '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  name VARCHAR(100),' +
    '  physical_id VARCHAR(255),' +
    '  created TEXT,' +
    '  modified TEXT' +
    ')';
	cTableLaser = 'CREATE TABLE laser (' +
    '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  member_id INTEGER,' +
    '  time INTEGER,' +
    '  created TEXT,' +
    '  modified TEXT' +
    ')';

{$R *.lfm}

{ TdmMain }

procedure TdmMain.CreateTable(aTable: TTableList);
begin
  zqueryMain.SQL.Clear;
  case aTable of
  	tlMembers:begin
      zqueryMain.SQL.Text := cTableMembers;
    end;
    tlLaser:begin
      zqueryMain.SQL.Text := cTableLaser;
    end;
  end;
  zqueryMain.ExecSQL;
end;

procedure TdmMain.CheckDataBaseFile;
begin
  {$IFDEF WINDOWS}
  FSQLiteLibrary := '..' +
    DirectorySeparator +
    'win-dll' +
    DirectorySeparator;
    {$IFDEF WIN32}
  FSQLiteLibrary := FSQLiteLibrary + 'win32' + DirectorySeparator;
    {$ENDIF}
    {$IFDEF WIN64}
  FSQLiteLibrary := FSQLiteLibrary + 'win64' + DirectorySeparator;
    {$ENDIF}
  FSQLiteLibrary := FSQLiteLibrary + 'sqlite3.dll';
  zconnMain.LibraryLocation = FSQLiteLibrary;
  {$ENDIF}
  if Length(FDataBaseFileName) > 0 then
  begin
    try
      zconnMain.Database := FDataBaseFileName;
      zconnMain.Connect;
      try
        zqueryMain.SQL.Clear;
        zqueryMain.SQL.Add(cGetTables);
        zqueryMain.Active := True;
        if zqueryMain.RecordCount = 0 then
        begin
          try
            CreateTable(tlMembers);
            CreateTable(tlLaser);
          except
            on E:Exception do
            begin
              ShowMessage('Error Creating Tables: ' + E.Message);
            end;
          end;
        end
        else
        begin
          // Sort out which tables need to be created
          //ShowMessage('Number of Tables: ' + IntToStr(zqueryMain.RecordCount));
        end;
      except
        on E:Exception do
        begin
          ShowMessage('Error Querying Tables: ' + E.Message);
        end;
      end;
    except
      on E:Exception do
      begin
        ShowMessage('Error Connecting: ' + E.Message);
      end;
    end;
    try
      ztableMembers.Active := True;
      ztableLaser.Active := True;
    except
      on E:Exception do
      begin
        ShowMessage('Error Opening table: ' + E.Message);
      end;
    end;
  end;
end;

end.

