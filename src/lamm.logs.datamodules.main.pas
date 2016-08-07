unit LAMM.Logs.DataModules.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Dialogs, ZConnection, ZDataset;

{ TdmMain }

type
  TTableList = (tlMembers, tlLaser);
  TdmMain = class(TDataModule)
    dsLaser: TDataSource;
    dsMembers: TDataSource;
    zconnMain: TZConnection;
    zqueryMain: TZQuery;
    ztableLasercreated: TDateTimeField;
    ztableLaserid: TLargeintField;
    ztableLasermember_id: TLongintField;
    ztableLasermodified: TDateTimeField;
    ztableLaserusage: TTimeField;
    ztableMembers: TZTable;
    ztableLaser: TZTable;
    ztableMemberscreated: TDateTimeField;
    ztableMembersid: TLargeintField;
    ztableMembersmodified: TDateTimeField;
    ztableMembersname: TStringField;
    ztableMembersphysical_id: TStringField;
    procedure ztableLaserBeforePost(DataSet: TDataSet);
    procedure ztableLaserNewRecord(DataSet: TDataSet);
    procedure ztableMembersBeforePost(DataSet: TDataSet);
    procedure ztableMembersNewRecord(DataSet: TDataSet);
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
    '  name VARCHAR(100) NOT NULL,' +
    '  physical_id VARCHAR(255),' +
    '  created DATETIME NOT NULL,' +
    '  modified DATETIME NOT NULL' +
    ')';
	cTableLaser = 'CREATE TABLE laser (' +
    '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  member_id INTEGER NT NULL,' +
    '  usage TIME NOT NULL DEFAULT 0,' +
    '  created DATETIME NOT NULL,' +
    '  modified DATETIME NOT NULL' +
    ')';

{$R *.lfm}

{ TdmMain }

procedure TdmMain.ztableMembersNewRecord(DataSet: TDataSet);
begin
  ztableMemberscreated.Value := Now;
  ztableMembersmodified.Value := Now;
end;

procedure TdmMain.ztableMembersBeforePost(DataSet: TDataSet);
begin
  ztableMembersmodified.Value := Now;
end;

procedure TdmMain.ztableLaserNewRecord(DataSet: TDataSet);
begin
  ztableLasercreated.Value := Now;
  ztableLasermodified.Value := Now;
end;

procedure TdmMain.ztableLaserBeforePost(DataSet: TDataSet);
begin
  ztableLasermodified.Value := Now;
end;

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

