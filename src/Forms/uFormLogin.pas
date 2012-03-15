unit uFormLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uSecurityModule;

type
  TfrmLogin = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    pnlBody: TPanel;
    lblUser: TLabel;
    lblPass: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    lblQuick: TLabel;
    btnMaker: TButton;
    btnChecker: TButton;
    btnCS: TButton;
    btnAdmin: TButton;
    btnLogin: TButton;
    btnCancel: TButton;
    lblStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnMakerClick(Sender: TObject);
    procedure btnCheckerClick(Sender: TObject);
    procedure btnCSClick(Sender: TObject);
    procedure btnAdminClick(Sender: TObject);
  private
  public
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  edtUsername.Text := 'maker';
  edtPassword.Text := 'maker123';
  lblStatus.Caption := '';
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  UName, PWord: string;
begin
  UName := Trim(edtUsername.Text);
  PWord := Trim(edtPassword.Text);

  if UName = '' then
  begin
    lblStatus.Caption := 'Silakan isi username!';
    edtUsername.SetFocus;
    Exit;
  end;

  if PWord = '' then
  begin
    lblStatus.Caption := 'Silakan isi password!';
    edtPassword.SetFocus;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    if dmSecurity.Authenticate(UName, PWord) then
    begin
      ModalResult := mrOk;
    end
    else
    begin
      lblStatus.Caption := 'Username atau password salah / akun tidak aktif!';
      edtPassword.SelectAll;
      edtPassword.SetFocus;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.btnMakerClick(Sender: TObject);
begin
  edtUsername.Text := 'maker';
  edtPassword.Text := 'maker123';
  lblStatus.Caption := 'Akun Bancassurance Officer (Maker) dipilih.';
end;

procedure TfrmLogin.btnCheckerClick(Sender: TObject);
begin
  edtUsername.Text := 'checker';
  edtPassword.Text := 'checker123';
  lblStatus.Caption := 'Akun Underwriting Officer (Checker) dipilih.';
end;

procedure TfrmLogin.btnCSClick(Sender: TObject);
begin
  edtUsername.Text := 'cs';
  edtPassword.Text := 'cs123';
  lblStatus.Caption := 'Akun Customer Service (Inquiry) dipilih.';
end;

procedure TfrmLogin.btnAdminClick(Sender: TObject);
begin
  edtUsername.Text := 'admin';
  edtPassword.Text := 'admin123';
  lblStatus.Caption := 'Akun IT Security Admin dipilih.';
end;

end.
