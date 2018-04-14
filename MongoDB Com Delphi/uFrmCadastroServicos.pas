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

uses uDmDados, Classes.Utils.View;

procedure TfrmCadastroServico.fnc_montarGrid;
begin
  TUtilsView.fnc_montarGrid(ListBox1, dsMongo, 'Codigo', 'Descricao');
  inherited;
end;

procedure TfrmCadastroServico.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection := 'SERVICOS';
  inherited;
end;

end.
