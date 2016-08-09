unit LAMM.Logs.DataModules.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Dialogs, ZConnection, ZDataset;

{ TdmMain }

type
  TTableList = (tlNone, tlMembers, tlLaser);
  TdmMain = class(TDataModule)
    dsMembersCopy: TDataSource;
    dsLaser: TDataSource;
    dsMembers: TDataSource;
    ztableMembersCopy: TZTable;
    ztableLasername: TStringField;
    zconnMain: TZConnection;
    zqueryMain: TZQuery;
    ztableLasercreated: TDateTimeField;
    ztableLaserid: TLargeintField;
    ztableLasermember_id: TLongintField;
    ztableLasermodified: TDateTimeField;
    ztableLaserusage: TTimeField;
    ztableMembers: TZTable;
    ztableLaser: TZTable;
    ztableMembersCopycreated: TDateTimeField;
    ztableMembersCopyid: TLargeintField;
    ztableMembersCopymodified: TDateTimeField;
    ztableMembersCopyname: TStringField;
    ztableMembersCopyphysical_id: TStringField;
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

    function TableType(const aTable: String): TTableList;
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
  cGetTable = 'SELECT name FROM sqlite_master ' +
    'WHERE type=''table'' AND ' +
    'name = ''%s''' +
    ';';
  //cGetFields = 'PRAGMA table_info(%s)';
  cTableMembers = 'members';
	cTableMembersSQL = 'CREATE TABLE members (' +
    '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  name VARCHAR(100) NOT NULL,' +
    '  physical_id VARCHAR(255),' +
    '  created DATETIME NOT NULL,' +
    '  modified DATETIME NOT NULL' +
    ')';
  cTableLaser = 'laser';
	cTableLaserSQL = 'CREATE TABLE laser (' +
    '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
    '  member_id INTEGER NT NULL,' +
    '  usage TIME NOT NULL DEFAULT 0,' +
    '  created DATETIME NOT NULL,' +
    '  modified DATETIME NOT NULL' +
    ')';
  cTableList : array [0..1] of String = (
  	cTableMembers,
    cTableLaser
    );

{$R *.lfm}

{ TdmMain }

procedure TdmMain.ztableMembersNewRecord(DataSet: TDataSet);
begin
  ztableMemberscreated.Value := Now;
  ztableMembersmodified.Value := Now;
end;

function TdmMain.TableType(const aTable: String): TTableList;
begin
  Result := tlNone;
  if cTableMembers = aTable then Result := tlMembers;
  if cTableLaser = aTable then Result := tlLaser;
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
      zqueryMain.SQL.Text := cTableMembersSQL;
    end;
    tlLaser:begin
      zqueryMain.SQL.Text := cTableLaserSQL;
    end;
  end;
  zqueryMain.ExecSQL;
end;

procedure TdmMain.CheckDataBaseFile;
var
  sTable: String;
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
            zqueryMain.Active := False;
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
          zqueryMain.Active := False;
          for sTable in cTableList do
          begin
            zqueryMain.SQL.Clear;
            zqueryMain.SQL.Add(Format(cGetTable, [sTable]));
            zqueryMain.Active := True;
            if zqueryMain.RecordCount = 0 then
            begin
              CreateTable(TableType(sTable));
            end;
            zqueryMain.Active := False;
          end;
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
      ztableMembersCopy.Active := True;
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

