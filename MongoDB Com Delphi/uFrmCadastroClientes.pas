unit uFrmCadastroClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uFrmCadastroPadrao, System.Actions, FMX.ActnList, FMX.Controls.Presentation,
  FMX.Layouts, FMX.Edit, FMX.SearchBox, FMX.ListBox, FMX.TabControl,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MongoDBDataSet, mongo.FMX.Edit;

type
  TfrmClientes = class(TfrmCadastroPadrao)
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
  frmClientes: TfrmClientes;

implementation

{$R *.fmx}

uses Classes.Utils.View;


procedure TfrmClientes.fnc_montarGrid;
begin
  TUtilsView.fnc_montarGrid(ListBox1, dsMongo, 'Codigo', 'Nome');
  inherited;
end;


procedure TfrmClientes.FormCreate(Sender: TObject);
begin
  Self.Banco := 'SALAO';
  Self.Collection := 'CLIENTES';
  inherited;
end;

end.
