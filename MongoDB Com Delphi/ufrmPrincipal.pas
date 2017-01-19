unit ufrmPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Actions,
  FMX.ActnList, FMX.Menus, FMX.ListBox, FMX.Layouts, FMX.Controls.Presentation,
  FMX.MultiView, FMX.StdCtrls, FMX.Objects, uFrmFaturamento;

type
  TfrmPrincipal = class(TForm)
    ActionList1: TActionList;
    Action1: TAction;
    MultiView1: TMultiView;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Layout1: TLayout;
    ToolBar1: TToolBar;
    layoutPrincipal: TLayout;
    StyleBook1: TStyleBook;
    Layout2: TLayout;
    Image1: TImage;
    ListBoxItem4: TListBoxItem;
    layoutMensagem: TLayout;
    Timer1: TTimer;
    ListBoxItem5: TListBoxItem;
    procedure Action1Execute(Sender: TObject);
    procedure ListBoxItem2Click(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
    procedure ListBoxItem4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBoxItem3Click(Sender: TObject);
    procedure ListBoxItem5Click(Sender: TObject);
  private
    FFormAtual: TCommonCustomForm;
    { Private declarations }
  public
    { Public declarations }
    procedure exibirMensagem(Layout : TLayout);
  published
    property FormAtual : TCommonCustomForm read FFormAtual write FFormAtual;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses uFrmCadastroServicos, uFrmCadastroClientes, uFrmCadastroProfissionais;

procedure TfrmPrincipal.Action1Execute(Sender: TObject);
var
  Form : TfrmCadastroServico;
begin
  Form := TfrmCadastroServico.Create(Self);
  try
    Form.ShowModal;
  finally
    Form.Free;
  end;

end;

procedure TfrmPrincipal.exibirMensagem(Layout: TLayout);
begin
  Timer1.Enabled := true;
  frmPrincipal.layoutMensagem.Visible := true;
  frmPrincipal.layoutMensagem.RemoveObject(0);
  frmPrincipal.layoutMensagem.AddObject(Layout);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  layoutMensagem.Visible := false;
end;

procedure TfrmPrincipal.ListBoxItem1Click(Sender: TObject);
var
  FormCliente : TfrmClientes;
begin

  if not Assigned(FormCliente) then
    FormCliente := TfrmClientes.Create(Self);

  Self.layoutPrincipal.RemoveObject(0);
  Self.layoutPrincipal.AddObject(FormCliente.Layout1);


end;

procedure TfrmPrincipal.ListBoxItem2Click(Sender: TObject);
var
  FormServico : TfrmCadastroServico;
begin

  if not Assigned(FormServico) then
    FormServico := TfrmCadastroServico.Create(Self);

  Self.layoutPrincipal.RemoveObject(0);
  Self.layoutPrincipal.AddObject(FormServico.Layout1);
end;

procedure TfrmPrincipal.ListBoxItem3Click(Sender: TObject);
var
  FormFaturamento : TfrmFaturamento;
begin

  if not Assigned(FormFaturamento) then
    FormFaturamento := TfrmFaturamento.Create(Self);

  Self.layoutPrincipal.RemoveObject(0);
  Self.layoutPrincipal.AddObject(FormFaturamento.Layout1);

end;

procedure TfrmPrincipal.ListBoxItem4Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.ListBoxItem5Click(Sender: TObject);
var
  FormProfissionais : TfrmCadastroProfissionais;
begin

  if not Assigned(FormProfissionais) then
    FormProfissionais := TfrmCadastroProfissionais.Create(Self);

  Self.layoutPrincipal.RemoveObject(0);
  Self.layoutPrincipal.AddObject(FormProfissionais.Layout1);

end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  if layoutMensagem.Visible then
    layoutMensagem.Visible := false;

  Timer1.Enabled := false;
end;

end.
