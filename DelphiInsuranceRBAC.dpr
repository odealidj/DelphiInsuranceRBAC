program DelphiInsuranceRBAC;

uses
  Forms,
  uDataConnection in 'src\Data\uDataConnection.pas' {dmConnection: TDataModule},
  uSecurityModule in 'src\Data\uSecurityModule.pas' {dmSecurity: TDataModule},
  uInsuranceModule in 'src\Data\uInsuranceModule.pas' {dmInsurance: TDataModule},
  uAppConst in 'src\Utils\uAppConst.pas',
  uFormatUtils in 'src\Utils\uFormatUtils.pas',
  uMD5 in 'src\Utils\uMD5.pas',
  uFormMain in 'src\Forms\uFormMain.pas' {frmMain},
  uFormLogin in 'src\Forms\uFormLogin.pas' {frmLogin},
  uFormPolicy in 'src\Forms\uFormPolicy.pas' {frmPolicy},
  uFormUnderwriting in 'src\Forms\uFormUnderwriting.pas' {frmUnderwriting},
  uFormUserRole in 'src\Forms\uFormUserRole.pas' {frmUserRole},
  uFormCustomer in 'src\Forms\uFormCustomer.pas' {frmCustomer};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DelphiInsuranceRBAC: Core Bancassurance System';
  Application.CreateForm(TdmConnection, dmConnection);
  Application.CreateForm(TdmSecurity, dmSecurity);
  Application.CreateForm(TdmInsurance, dmInsurance);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
