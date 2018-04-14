unit uFrmFaturamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.ListBox, FMX.Layouts, FMX.TabControl, FMX.Edit, FMX.SearchBox,
  System.Actions, FMX.ActnList, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, FireDAC.Phys.MongoDBWrapper;

type
  TfrmFaturamento = class(TForm)
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    Label1: TLabel;
    TabControl1: TTabControl;
    tabFaturamento: TTabItem;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    lblCliente: TLabel;
    ListBoxItem2: TListBoxItem;
    Label3: TLabel;
    lblProfissional: TLabel;
    SpeedButton2: TSpeedButton;
    ListBoxItem3: TListBoxItem;
    Label4: TLabel;
    SpeedButton3: TSpeedButton;
    Layout1: TLayout;
    tabCliente: TTabItem;
    tabProfissional: TTabItem;
    tabServico: TTabItem;
    lbCliente: TListBox;
    SearchBox1: TSearchBox;
    lbProfissional: TListBox;
    SearchBox2: TSearchBox;
    lbServico: TListBox;
    SearchBox3: TSearchBox;
    lblValorTotal: TLabel;
    ActionList1: TActionList;
    changeCliente: TChangeTabAction;
    changeFaturamento: TChangeTabAction;
    changeProfissional: TChangeTabAction;
    changeServico: TChangeTabAction;
    SpeedButton4: TSpeedButton;
    dsMongoGenerico: TFDMongoDataSet;
    TabControl2: TTabControl;
    TabItem1: TTabItem;
    tabPagamentos: TTabItem;
    lbServicoFatura: TListBox;
    ListBoxItem4: TListBoxItem;
    ListBoxHeader1: TListBoxHeader;
    Label5: TLabel;
    Layout2: TLayout;
    lbPagamentos: TListBox;
    ListBoxItem5: TListBoxItem;
    ListBoxHeader2: TListBoxHeader;
    Label7: TLabel;
    ListBox3: TListBox;
    ListBoxItem6: TListBoxItem;
    edtValorPago: TEdit;
    SpeedButton5: TSpeedButton;
    Layout3: TLayout;
    ListBox4: TListBox;
    ListBoxHeader3: TListBoxHeader;
    Label8: TLabel;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxItem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lbTextTrocoFalta: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lbTrocoFalta: TLabel;
    lbPagamentoEfetuado: TListBox;
    ListBoxHeader4: TListBoxHeader;
    Label17: TLabel;
    btnPagamentos: TSpeedButton;
    ChangeTabPagamentos: TChangeTabAction;
    btnFinalizar: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure lbClienteItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbProfissionalItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure lbServicoItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure SpeedButton4Click(Sender: TObject);
    procedure btnPagamentosClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
  private
    FCodCliente: Integer;
    FCodProfissional: Integer;
    procedure SetCodCliente(const Value: Integer);
    procedure SetCodProfissional(const Value: Integer);
    procedure addItemFaturado;
    function GetValorTotal: Currency;
    procedure fnc_exibirTrocoFalta;
    function GetPagamentosEfetuados: Currency;
    procedure GravarVenda;
    procedure fnc_PreencheMongoDoc(MongoDoc : TMongoDocument);
    { Private declarations }
  public
    { Public declarations }
    property CodCliente : Integer read FCodCliente write SetCodCliente;
    property CodProfissional : Integer read FCodProfissional write SetCodProfissional;
    property ValorTotal : Currency read GetValorTotal;
    property PagamentosEfetuados : Currency read GetPagamentosEfetuados;
  end;

var
  frmFaturamento: TfrmFaturamento;

implementation

{$R *.fmx}

uses ufrmPrincipal, Classes.Utils.View, uDmDados;

procedure TfrmFaturamento.addItemFaturado;
begin
  lbServicoFatura.AddObject(lbServico.ItemDown);
  lblValorTotal.Text := FormatCurr('R$ #,##0.00', ValorTotal);
end;

procedure TfrmFaturamento.btnFinalizarClick(Sender: TObject);
begin
  GravarVenda;
end;

procedure TfrmFaturamento.btnPagamentosClick(Sender: TObject);
begin
  TUtilsView.fnc_carregarDataSet('SALAO', 'PAGAMENTOS', dsMongoGenerico);
  TUtilsView.fnc_montarGrid(lbPagamentos, dsMongoGenerico, 'CODIGO', 'DESCRICAO');

  ChangeTabPagamentos.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.fnc_exibirTrocoFalta;
var
  ValorRestante : Currency;
begin
  ValorRestante := ValorTotal - PagamentosEfetuados;
  Layout2.Visible:= not (PagamentosEfetuados >= ValorTotal);

  if ValorRestante <= 0 then
  begin
    lbTextTrocoFalta.Text := 'Troco';
    ValorRestante := ValorRestante * -1;
    lbTrocoFalta.FontColor := TAlphaColors.Greenyellow;
  end
  else
  begin
    lbTextTrocoFalta.Text := 'Falta';
    lbTrocoFalta.FontColor := TAlphaColors.Red;
  end;

  lbTrocoFalta.Text := FormatCurr('R$ #,##0.00', ValorRestante);
end;

procedure TfrmFaturamento.fnc_PreencheMongoDoc(MongoDoc: TMongoDocument);
var
  Doc : TMongoDocument;
  I : Integer;
  iCursor : iMongoCursor;
begin
  //Adicionando Cliente
  TUtilsView.buscarRegistroUnico('SALAO', 'CLIENTES', 'CODIGO', FCodCliente, iCursor);
  MongoDoc.BeginObject('CLIENTE').Append(iCursor.Doc).EndObject;

  //Adicionando Profissional
  TUtilsView.buscarRegistroUnico('SALAO', 'PROFISSIONAIS', 'CODIGO', FCodProfissional, iCursor);
  MongoDoc.BeginObject('PROFISSIONAL').Append(iCursor.Doc).EndObject;

  //Adicionando Servicos Faturados
  Doc := TMongoDocument.Create(dmDados.FConMongo.Env);
  try
    for I := 0 to Pred(lbServicoFatura.Items.Count) do
    begin
      TUtilsView.buscarRegistroUnico('SALAO', 'SERVICOS', 'CODIGO', StrToInt(lbServicoFatura.ItemByIndex(I).StylesData['key'].ToString), iCursor);
      Doc.BeginObject(IntToStr(I)).Append(iCursor.Doc).EndObject;
    end;
    MongoDoc.BeginObject('Itens').Append(Doc).EndObject;
  finally
    Doc.Free;
  end;

  //Adicionando Pagamentos
  Doc := TMongoDocument.Create(dmDados.FConMongo.Env);
  try
    for I := 0 to Pred(lbPagamentoEfetuado.Items.Count) do
    begin
      Doc
        .BeginObject(IntToStr(I))
          .Add(lbPagamentoEfetuado.ItemByIndex(I).StylesData['descricao'].ToString,
               TUtilsView.listToCurr(lbPagamentoEfetuado.ItemByIndex(I).StylesData['valor'].ToString))
        .EndObject;
    end;
    MongoDoc.BeginObject('Pagamentos').Append(Doc).EndObject;
  finally
    Doc.Free;
  end;

  MongoDoc.Add('VALOR_TOTAL', ValorTotal);
end;

procedure TfrmFaturamento.FormCreate(Sender: TObject);
begin
  //Seta a primeira tab e esconde as abas
  TabControl1.TabIndex := 0;
  TabControl1.TabPosition := TabControl1.TabPosition.tpNone;
  lbServicoFatura.Items.Clear;
end;

function TfrmFaturamento.GetPagamentosEfetuados: Currency;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Pred(lbPagamentoEfetuado.Items.Count) do
    Result := Result + TUtilsView.listToCurr(lbPagamentoEfetuado.ItemByIndex(I).StylesData['valor'].ToString);
end;

function TfrmFaturamento.GetValorTotal: Currency;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Pred(lbServicoFatura.Items.Count) do
    Result := Result + TUtilsView.listToCurr(lbServicoFatura.ItemByIndex(I).StylesData['valor'].ToString);
end;

procedure TfrmFaturamento.GravarVenda;
var
   MongoDoc : TMongoDocument;
begin
  with dmDados do
  begin
    MongoDoc := TMongoDocument.Create(dmDados.FConMongo.Env);
    try
      fnc_PreencheMongoDoc(MongoDoc);
      FConMongo['SALAO']['VENDAS'].Insert(MongoDoc);
      //fnc_ExibirMensagem('Vendas Realizada com Sucesso', 'Obrigado e Volte Sempre', tpSucesso);
    finally
      MongoDoc.Free;
    end;
  end;
end;

procedure TfrmFaturamento.lbClienteItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  changeFaturamento.ExecuteTarget(Self);
  lblCliente.Text := lbCliente.Items[lbCliente.ItemIndex];
  CodCliente := Integer(lbCliente.Items.Objects[lbCliente.ItemIndex]);
end;

procedure TfrmFaturamento.lbProfissionalItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  lblProfissional.Text := lbProfissional.Items[lbProfissional.ItemIndex];
  CodProfissional := Integer(lbProfissional.Items.Objects[lbProfissional.ItemIndex]);
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.lbServicoItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  addItemFaturado;
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem1Click(Sender: TObject);
begin
  TUtilsView.fnc_carregarDataSet('SALAO', 'CLIENTES', dsMongoGenerico);
  TUtilsView.fnc_montarGrid(lbCliente, dsMongoGenerico, 'CODIGO', 'NOME');
  changeCliente.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem2Click(Sender: TObject);
begin
  TUtilsView.fnc_carregarDataSet('SALAO', 'PROFISSIONAIS', dsMongoGenerico);
  TUtilsView.fnc_montarGrid(lbProfissional, dsMongoGenerico, 'CODIGO', 'NOME');
  changeProfissional.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem3Click(Sender: TObject);
begin
  TUtilsView.fnc_carregarDataSet('SALAO', 'SERVICOS', dsMongoGenerico);
  TUtilsView.fnc_montarGrid(lbServico, dsMongoGenerico, 'DESCRICAO', 'CODIGO', 'VALOR');
  changeServico.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.SetCodCliente(const Value: Integer);
begin
  FCodCliente := Value;
end;

procedure TfrmFaturamento.SetCodProfissional(const Value: Integer);
begin
  FCodProfissional := Value;
end;

procedure TfrmFaturamento.SpeedButton4Click(Sender: TObject);
begin
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.SpeedButton5Click(Sender: TObject);
var
  lbItem : TListBoxItem;
begin
  try
    lbItem := TListBoxItem.Create(nil);
    lbItem.StyleLookup := 'ListBoxItemServico';
    lbItem.StylesData['descricao'] := lbPagamentos.Items[lbPagamentos.ItemIndex];
    lbItem.StylesData['valor'] := FormatCurr('R$ #,##0.00', StrToCurr(edtValorPago.Text));
    lbItem.StylesData['key'] := Integer(lbPagamentos.Items.Objects[lbPagamentos.ItemIndex]);
    lbPagamentoEfetuado.AddObject(lbItem);
    fnc_exibirTrocoFalta;
  except
    raise Exception.Create('Não foi possível adicionar o pagamento');
  end;

end;

end.
