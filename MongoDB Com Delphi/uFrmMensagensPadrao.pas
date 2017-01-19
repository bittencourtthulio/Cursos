unit uFrmMensagensPadrao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Edit, ufrmPrincipal;

type
  TTipoMensagem = (tpSucesso, tpErro, tpAlerta, tpInfo);

type
  TfrmMensagemPadrao = class(TForm)
    layoutMensagem: TLayout;
    Panel1: TPanel;
    lbTitulo: TLabel;
    lbMensagem: TLabel;
  private
    FMensagem: String;
    FTitulo: String;
    { Private declarations }
  public
    { Public declarations }
    procedure fnc_atualizarMensagem(Titulo, Mensagem : String; tpMsg : TTipoMensagem);
  published
    property Titulo : String read FTitulo write FTitulo;
    property Mensagem : String read FMensagem write FMensagem;
  end;

var
  frmMensagemPadrao: TfrmMensagemPadrao;

implementation

{$R *.fmx}


procedure TfrmMensagemPadrao.fnc_atualizarMensagem(Titulo, Mensagem : String; tpMsg : TTipoMensagem);
begin
  case tpMsg of
    tpSucesso: Panel1.StyleLookup := 'panelstylesucesso';
    tpErro:    Panel1.StyleLookup := 'panelstyleerro';
    tpAlerta:  Panel1.StyleLookup := 'panelstylealerta';
    tpInfo:    Panel1.StyleLookup := 'panelstyleinfo';
  end;
  lbTitulo.Text := Titulo;
  lbMensagem.Text := Mensagem;
end;

end.
