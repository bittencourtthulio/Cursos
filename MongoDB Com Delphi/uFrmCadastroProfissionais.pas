unit uFrmCadastroProfissionais;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmCadastroPadrao, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.Edit, FMX.SearchBox, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation,
  mongo.FMX.Edit;

type
  TfrmCadastroProfissionais = class(TfrmCadastroPadrao)
    ListBoxItem2: TListBoxItem;
    Label3: TLabel;
    EditMongo1: TMongoEdit;
    ListBoxItem3: TListBoxItem;
    Label2: TLabel;
    EditMongo2: TMongoEdit;
    ListBoxItem4: TListBoxItem;
    Label4: TLabel;
    EditMongo3: TMongoEdit;
    ListBoxItem5: TListBoxItem;
    Label5: TLabel;
    EditMongo4: TMongoEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure fnc_montarGrid; override;
  end;

var
  frmCadastroProfissionais: TfrmCadastroProfissionais;

implementation

{$R *.fmx}

procedure TfrmCadastroProfissionais.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection := 'PROFISSIONAIS';
  inherited;
end;

procedure TfrmCadastroProfissionais.fnc_montarGrid;
var
  LBItem    : TListBoxItem;
begin
  inherited;
  with dsMongo do
  begin
    First;
    ListBox1.Items.Clear;
    while not Eof do
    begin
      ListBox1.Items.AddObject(FieldByName('NOME').AsString, TObject(FieldByName('CODIGO').AsInteger));
      Next;
    end;
  end;
  inherited;
end;

end.
