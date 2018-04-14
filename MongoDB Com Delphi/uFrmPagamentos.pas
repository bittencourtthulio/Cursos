unit uFrmPagamentos;

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
  TfrmCadastroPagamentos = class(TfrmCadastroPadrao)
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    Label3: TLabel;
    EditMongo1: TMongoEdit;
    Label2: TLabel;
    MongoEdit1: TMongoEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure fnc_montarGrid; override;
  public
    { Public declarations }
  end;

var
  frmCadastroPagamentos: TfrmCadastroPagamentos;

implementation

uses
  Classes.Utils.View;

{$R *.fmx}

procedure TfrmCadastroPagamentos.fnc_montarGrid;
begin
   TUtilsView.fnc_montarGrid(ListBox1, dsMongo, 'Codigo', 'Descricao');
  inherited;
end;

procedure TfrmCadastroPagamentos.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection := 'PAGAMENTOS';
  inherited;

end;

end.
