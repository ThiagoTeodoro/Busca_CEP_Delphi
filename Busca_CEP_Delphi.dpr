program Busca_CEP_Delphi;

uses
  Vcl.Forms,
  UPrincipalConsultarCEP in 'UPrincipalConsultarCEP.pas' {FormPrincipalConsultarCEP},
  UBusca_CEP in 'UBusca_CEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipalConsultarCEP, FormPrincipalConsultarCEP);
  Application.Run;
end.
