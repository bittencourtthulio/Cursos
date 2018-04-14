unit uFrmCadastroPadrao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListBox, FMX.Edit, FMX.SearchBox, FMX.TabControl, FireDAC.Phys.MongoDBWrapper,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, FireDAC.Stan.Async, FireDAC.DApt,
  uFrmMensagensPadrao, mongo.FMX.Edit, Classes.Utils.View;

type
		TAcao = (tpInsert, tpUpdate, tpLista);

type
  TfrmCadastroPadrao = class(TForm)
    Panel2: TPanel;
    btnNovo: TButton;
    ActionList1: TActionList;
    acSalvar: TAction;
    acExcluir: TAction;
    acSair: TAction;
    acNovo: TAction;
    acEditar: TAction;
    btnSalvar: TButton;
    btnExcluir: TButton;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    TabControl1: TTabControl;
    tabLista: TTabItem;
    tabCadastro: TTabItem;
    ListBox1: TListBox;
    SearchBox1: TSearchBox;
    ListBoxItem1: TListBoxItem;
    changeTabLista: TChangeTabAction;
    changeTabCadastro: TChangeTabAction;
    ListBox2: TListBox;
    dsMongo: TFDMongoDataSet;
    btnVoltar: TButton;
    acVoltar: TAction;
    procedure acNovoExecute(Sender: TObject);
    procedure acEditarExecute(Sender: TObject);
    procedure acSalvarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormDestroy(Sender: TObject);
    procedure acExcluirExecute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure acVoltarExecute(Sender: TObject);
  private
    FBanco: String;
    FAcao: TAcao;
    FCollection: String;
    FUtils: TUtilsView;
    procedure fnc_PreencheMongoDoc(var MongoDoc : TMongoDocument);
    procedure fnc_PreencherMongoUpd(var MongoUpd : TMongoUpdate);
    procedure fnc_limparCampos;
    procedure fnc_atualizaLista;
    procedure fnc_gerenciarForms;
    procedure fnc_buscarCampoChave(var i: Integer; const Item: TListBoxItem);
    procedure fnc_PreencherRegistros;
    procedure fnc_excluirRegistro;
    procedure fnc_ExibirMensagem(Tit, Msg : String; tpMsg : TTipoMensagem);
    procedure fnc_exibirBotoes;
    procedure SetUtils(const Value: TUtilsView);
    { Private declarations }
  public
    { Public declarations }
    procedure fnc_montarGrid; virtual; abstract;
  published
    property Acao : TAcao read FAcao write FAcao;
    property Banco : String read FBanco write FBanco;
    property Collection : String read FCollection write FCollection;
    property Utils : TUtilsView read FUtils write SetUtils;
  end;

var
  frmCadastroPadrao: TfrmCadastroPadrao;

implementation

{$R *.fmx}

uses uDmDados, ufrmPrincipal, mongo.Types;

procedure TfrmCadastroPadrao.acEditarExecute(Sender: TObject);
begin
  changeTabCadastro.ExecuteTarget(Self);
  fnc_exibirBotoes;
end;

procedure TfrmCadastroPadrao.acExcluirExecute(Sender: TObject);
begin
  fnc_excluirRegistro;
  fnc_ExibirMensagem('Excluir Registro', 'Registro Excluido com Sucesso', tpErro);
  fnc_atualizaLista;
  changeTabLista.ExecuteTarget(Self);
  fnc_exibirBotoes;
end;

procedure TfrmCadastroPadrao.acNovoExecute(Sender: TObject);
begin
  Self.FAcao := tpInsert;
  fnc_limparCampos;
  changeTabCadastro.ExecuteTarget(Self);
  fnc_exibirBotoes;
end;

procedure TfrmCadastroPadrao.acSalvarExecute(Sender: TObject);
var
 MongoDoc : TMongoDocument;
 MongoUpd : TMongoUpdate;
begin
  try
    case FAcao of

      tpInsert:
      begin
        with dmDados do
        begin
          MongoDoc := TMongoDocument.Create(dmDados.FConMongo.Env);
          try
            fnc_PreencheMongoDoc(MongoDoc);
            FConMongo[FBanco][FCollection].Insert(MongoDoc);
            fnc_ExibirMensagem('Inserir Registro', 'Registro Inserido com Sucesso', tpSucesso);
          finally
            MongoDoc.Free;
          end;
        end;
      end;

      tpUpdate:
      begin
        MongoUpd := TMongoUpdate.Create(dmDados.FConMongo.Env);
        try
          with dmDados do
          begin
            fnc_PreencherMongoUpd(MongoUpd);
            FConMongo[FBanco][FCollection].Update(MongoUpd);
            fnc_ExibirMensagem('Atualizar Registro', 'Registro Atualizado com Sucesso', tpInfo);
          end;
        finally
          MongoUpd.Free;
        end;

      end;
    end;
  finally
    fnc_atualizaLista;
    changeTabLista.ExecuteTarget(Self);
    fnc_exibirBotoes;
  end;
end;

procedure TfrmCadastroPadrao.acVoltarExecute(Sender: TObject);
begin
  FAcao := tpLista;
  changeTabLista.ExecuteTarget(Self);
  fnc_exibirBotoes;
end;

procedure TfrmCadastroPadrao.Button2Click(Sender: TObject);
begin
  fnc_ExibirMensagem('Teste de Mensagem', 'Sua Mensagem foi Exibida com Sucesso', tpAlerta);
end;

procedure TfrmCadastroPadrao.fnc_atualizaLista;
begin
  Utils.fnc_carregarDataSet(FBanco, FCollection, dsMongo);
  fnc_montarGrid;
end;

procedure TfrmCadastroPadrao.fnc_gerenciarForms;
begin
  if Assigned(frmPrincipal.FormAtual) then
    frmPrincipal.FormAtual.Free;
  frmPrincipal.FormAtual := Self;
end;

procedure TfrmCadastroPadrao.fnc_buscarCampoChave(var i: Integer; const Item: TListBoxItem);
var
  Local_i: Integer;
begin
  //Pesquisar por Campo Chave e Colocar como Somente Leitura
  for Local_i := Self.ComponentCount - 1 downto 0 do
  begin
    if (Self.Components[Local_i] is TMongoEdit) then
    begin
      if TMongoEdit(Self.Components[Local_i]).CampoChave then
      begin
        dsMongo.Locate(TMongoEdit(Self.Components[Local_i]).MongoCampo, Integer(Item.Data));

        if FAcao <> tpInsert then
          TMongoEdit(Self.Components[Local_i]).ReadOnly := true;
      end;
    end;
  end;
end;

procedure TfrmCadastroPadrao.fnc_PreencherRegistros;
var
  i: Integer;
begin
  //Buscar os Demais Campos e Preencher o Seu Valor
  for i := Self.ComponentCount - 1 downto 0 do
  begin
    if (Self.Components[i] is TMongoEdit) then
    begin
      TMongoEdit(Self.Components[i]).Text := dsMongo.FieldByName(TMongoEdit(Self.Components[i]).MongoCampo).AsString;
    end;
  end;
end;

procedure TfrmCadastroPadrao.fnc_excluirRegistro;
var
  i: Integer;
begin
  //Pesquisar por Campo Chave e Colocar como Somente Leitura
  for i := Self.ComponentCount - 1 downto 0 do
  begin
    if (Self.Components[i] is TMongoEdit) then
    begin
      if TMongoEdit(Self.Components[i]).CampoChave then
      begin
        dmDados.FConMongo[FBanco][FCollection].Remove.Match.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico).&End.Exec;
      end;
    end;
  end;
end;

procedure TfrmCadastroPadrao.fnc_ExibirMensagem(Tit, Msg : String; tpMsg : TTipoMensagem);
var
  FormMensagem : TfrmMensagemPadrao;
begin
  FormMensagem := TfrmMensagemPadrao.Create(Self);
  FormMensagem.fnc_atualizarMensagem(Tit, Msg, tpMsg);
  frmPrincipal.exibirMensagem(FormMensagem.layoutMensagem);
end;

procedure TfrmCadastroPadrao.fnc_exibirBotoes;
begin
  btnSalvar.Align := TAlignLayout(2);
  case TabControl1.TabIndex of
    0 :
      begin
          btnSalvar.Visible := false;
          btnExcluir.Visible := false;
          btnVoltar.Visible := false;
          btnNovo.Visible := true;
      end;
    1 :
      begin
          btnSalvar.Visible := true;
          btnExcluir.Visible := true;
          btnVoltar.Visible := true;
          btnNovo.Visible := false;
      end;
  end;
  btnSalvar.Align := TAlignLayout(3);
end;

procedure TfrmCadastroPadrao.fnc_limparCampos;
var
  i: Integer;
begin
  for i := Self.ComponentCount - 1 downto 0 do
    begin
    if (Self.Components[i] is TMongoEdit) then
    begin
        TMongoEdit(Self.Components[i]).Text := '';
    end;
  end;
end;

procedure TfrmCadastroPadrao.fnc_PreencheMongoDoc(var MongoDoc: TMongoDocument);
var
  i: Integer;
begin
  for i := Self.ComponentCount - 1 downto 0 do
  begin
  if (Self.Components[i] is TMongoEdit) then
  begin
    case TMongoEdit(Self.Components[i]).MongoTipoCampo of
    Texto:
      begin
        MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).Text);
      end;
    Numerico:
      begin
        MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico);
      end;
    Moeda:
      begin
        MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toMoeda);
      end;
    DataHora:
      begin
       MongoDoc.Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toDataHora);
      end;
    end;
  end;
  end;
end;

procedure TfrmCadastroPadrao.fnc_PreencherMongoUpd(var MongoUpd : TMongoUpdate);
var
  i: Integer;
begin
  for i := Self.ComponentCount - 1 downto 0 do
  begin
    if (Self.Components[i] is TMongoEdit) then
    begin

      //Verificando se é o CampoChave
      if TMongoEdit(Self.Components[i]).CampoChave then
        MongoUpd.Match().Add(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico);
      
      //Percorre os Campos para Preencher o Set
      case TMongoEdit(Self.Components[i]).MongoTipoCampo of
      Texto:
        begin
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).Text);
        end;
      Numerico:
        begin
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toNumerico);
        end;
      Moeda:
        begin
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toMoeda);
        end;
      DataHora:
        begin
          MongoUpd.Modify().&Set().Field(TMongoEdit(Self.Components[i]).MongoCampo, TMongoEdit(Self.Components[i]).toDataHora);
        end;
      end;
    end;
  end;
end;

procedure TfrmCadastroPadrao.FormCreate(Sender: TObject);
begin
  FUtils := TUtilsView.Create;
  fnc_gerenciarForms;

  TabControl1.TabIndex := 0;
  TabControl1.TabPosition := TabControl1.TabPosition.tpNone;

  fnc_atualizaLista;
  fnc_exibirBotoes;
end;

procedure TfrmCadastroPadrao.FormDestroy(Sender: TObject);
begin
  FUtils.Free;
  dsMongo.Close;
end;

procedure TfrmCadastroPadrao.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  i : integer;
begin
  Self.Acao := tpUpdate;
  fnc_buscarCampoChave(i, Item);
  fnc_PreencherRegistros;
  changeTabCadastro.ExecuteTarget(Self);
  fnc_exibirBotoes;
end;

procedure TfrmCadastroPadrao.SetUtils(const Value: TUtilsView);
begin
  FUtils := Value;
end;

end.
