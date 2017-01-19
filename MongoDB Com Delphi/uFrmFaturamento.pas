unit uFrmFaturamento;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.ListBox, FMX.Layouts, FMX.TabControl, FMX.Edit, FMX.SearchBox,
  System.Actions, FMX.ActnList;

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
    ListBox2: TListBox;
    ListBoxHeader1: TListBoxHeader;
    Label5: TLabel;
    tabCliente: TTabItem;
    tabProfissional: TTabItem;
    tabServico: TTabItem;
    lbCliente: TListBox;
    SearchBox1: TSearchBox;
    lbProfissional: TListBox;
    SearchBox2: TSearchBox;
    lbServico: TListBox;
    SearchBox3: TSearchBox;
    Label6: TLabel;
    ActionList1: TActionList;
    changeCliente: TChangeTabAction;
    changeFaturamento: TChangeTabAction;
    changeProfissional: TChangeTabAction;
    changeServico: TChangeTabAction;
    SpeedButton4: TSpeedButton;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFaturamento: TfrmFaturamento;

implementation

{$R *.fmx}

uses ufrmPrincipal;

procedure TfrmFaturamento.FormCreate(Sender: TObject);
begin
  //Seta a primeira tab e esconde as abas
  TabControl1.TabIndex := 0;
  TabControl1.TabPosition := TabControl1.TabPosition.tpNone;
end;

procedure TfrmFaturamento.lbClienteItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.lbProfissionalItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.lbServicoItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  changeFaturamento.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem1Click(Sender: TObject);
begin
  changeCliente.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem2Click(Sender: TObject);
begin
  changeProfissional.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.ListBoxItem3Click(Sender: TObject);
begin
  changeServico.ExecuteTarget(Self);
end;

procedure TfrmFaturamento.SpeedButton4Click(Sender: TObject);
begin
  changeFaturamento.ExecuteTarget(Self);
end;

end.
