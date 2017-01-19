unit uFrmCadastroServicos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmCadastroPadrao, System.Actions, FMX.ActnList, FMX.Controls.Presentation,
  FireDAC.Phys.MongoDBWrapper, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.Edit,
  FMX.SearchBox, FMX.ListBox, FMX.TabControl, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.MongoDBDataSet, FireDAC.Stan.Async,
  FireDAC.DApt, mongo.FMX.Edit;

type
  TfrmCadastroServico = class(TfrmCadastroPadrao)
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Memo1: TMemo;
    ListBoxItem2: TListBoxItem;
    Label2: TLabel;
    EditMongo1: TMongoEdit;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    Label3: TLabel;
    Label4: TLabel;
    EditMongo2: TMongoEdit;
    EditMongo3: TMongoEdit;
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure fnc_montarGrid; override;
  end;

var
  frmCadastroServico: TfrmCadastroServico;

implementation

{$R *.fmx}

uses uDmDados;

procedure TfrmCadastroServico.Button6Click(Sender: TObject);
begin
  inherited;
  with dmDados do
  begin
    try
      FConMongo['SALAO']['VENDA'].Insert()
      .Values()
        .Add('DATA', now())
        .Add('TOTAL', 10.00)
        .BeginArray('ITENS')
                .BeginObject('ITEM01')
                  .add('DESCRICAO', 'MACARRAO')
                  .Add('UNIDADE', 'UND')
                  .Add('PRECO', 5)
                .EndObject
                .BeginObject('ITEM02')
                  .add('DESCRICAO', 'BATATA')
                  .Add('UNIDADE', 'UND')
                  .Add('PRECO', 5)
                .EndObject
        .EndArray
      .&End
      .Exec;
    finally
      ShowMessage('Incluido com Sucesso');
    end;

  end;
end;

procedure TfrmCadastroServico.Button7Click(Sender: TObject);
begin
  inherited;
  with dmDados do
  begin
    try
      FConMongo['SALAO']['VENDA'].Update()
      .Match()
        .Add('TOTAL', 20.00)
      .&End
      .Modify()
        .&Set()
          .Field('TOTAL', 30.00)
        .&End
        .CurrentDate()
          .AsDate('ultAlteracao')
        .&End
        .AddToSet()
          .Field('CURSO', 'To Adorando o Curso')
        .&End
      .&End
    .Exec;
    finally
      ShowMessage('Atualizado com Sucesso');
    end;
  end;
end;

procedure TfrmCadastroServico.Button8Click(Sender: TObject);
begin
  inherited;
   with dmDados do
  begin
    try
      FConMongo['SALAO']['VENDA'].Remove()
      .Match()
        .Add('TOTAL', 30.00)
      .&End
      .&Exec;
    finally
      ShowMessage('Excluido com Sucesso');
    end;
  end;
end;

procedure TfrmCadastroServico.Button9Click(Sender: TObject);
var
  oCrs: IMongoCursor;
begin
  with dmDados do
  begin
    oCrs := FConMongo['SALAO']['VENDA'].Find()
      .Match()
        .Add('TOTAL', 10.0)
      .&End;

    while oCrs.Next do
      Memo1.Lines.Add(oCrs.Doc.AsJSON);
  end;
end;

procedure TfrmCadastroServico.fnc_montarGrid;
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
      ListBox1.Items.AddObject(FieldByName('Descricao').AsString, TObject(FieldByName('Codigo').AsInteger));
      Next;
    end;
  end;
  inherited;
end;

procedure TfrmCadastroServico.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection := 'SERVICOS';
  inherited;
end;

end.
