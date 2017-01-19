unit uDmDados;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MongoDB,
  FireDAC.Phys.MongoDBDef, System.Rtti, System.JSON.Types, System.JSON.Readers,
  System.JSON.BSON, System.JSON.Builders, FireDAC.Phys.MongoDBWrapper,
  FireDAC.FMXUI.Wait, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.SQLiteVDataSet, FireDAC.Phys.MongoDBDataSet;

type
  TdmDados = class(TDataModule)
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMongoDriverLink1: TFDPhysMongoDriverLink;
    FDLocalSQL1: TFDLocalSQL;
    FDConLocal: TFDConnection;
    FDQuery1: TFDQuery;
    FDMongoQuery1: TFDMongoQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FConMongo : TMongoConnection;
    procedure executaSQL(Banco, Collection, SQL: String);
  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


procedure TdmDados.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.Connected := true;
  FConMongo := TMongoConnection(FDConnection1.CliObj);
  //dmDados.FConMongo.Env.Monitor.Tracing := false;
end;

procedure TdmDados.DataModuleDestroy(Sender: TObject);
begin
  //FConMongo.Env.Monitor.Tracing := false;
end;

procedure TdmDados.executaSQL(Banco, Collection, SQL: String);
begin
  FDConLocal.Connected := False;
  FDLocalSQL1.Active := False;
  FDMongoQuery1.Close;
  FDMongoQuery1.FieldDefs.Clear;

  FDMongoQuery1.DatabaseName := Banco;
  FDMongoQuery1.CollectionName := Collection;
  FDMongoQuery1.Open;

  FDConLocal.Connected := True;
  FDLocalSQL1.Active := True;

  FDQuery1.Close;
  FDQuery1.FieldDefs.Clear();
  FDQuery1.Open(SQL);
end;

end.
