program Salao;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmPrincipal in 'ufrmPrincipal.pas' {frmPrincipal},
  uFrmCadastroPadrao in 'uFrmCadastroPadrao.pas' {frmCadastroPadrao},
  uFrmCadastroServicos in 'uFrmCadastroServicos.pas' {frmCadastroServico},
  uDmDados in 'uDmDados.pas' {dmDados: TDataModule},
  uFrmCadastroClientes in 'uFrmCadastroClientes.pas' {frmClientes},
  uFrmMensagensPadrao in 'uFrmMensagensPadrao.pas' {frmMensagemPadrao},
  uFrmFaturamento in 'uFrmFaturamento.pas' {frmFaturamento},
  uFrmCadastroProfissionais in 'uFrmCadastroProfissionais.pas' {frmCadastroProfissionais},
  Classes.Utils.View in 'Classes\Classes.Utils.View.pas',
  uFrmPagamentos in 'uFrmPagamentos.pas' {frmCadastroPagamentos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmDados, dmDados);
  Application.Run;
end.
