unit uFormUnderwriting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls, ExtCtrls,
  uDataConnection, uSecurityModule, uInsuranceModule, uAppConst, uFormatUtils;

type
  TfrmUnderwriting = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblCheckerStatus: TLabel;
    pnlClient: TPanel;
    splUW: TSplitter;
    pnlQueue: TPanel;
    pnlQueueHeader: TPanel;
    lblQueueTitle: TLabel;
    btnRefreshQueue: TButton;
    dbgQueue: TDBGrid;
    pnlReview: TPanel;
    pnlWarningSOD: TPanel;
    pnlFormReview: TPanel;
    lblSPAJNum: TLabel;
    lblTertanggungName: TLabel;
    lblJobClass: TLabel;
    lblProductChosen: TLabel;
    lblTotalSumInsured: TLabel;
    lblBasePrem: TLabel;
    lblMakerBranch: TLabel;
    lblLoading: TLabel;
    lblAssessmentNotes: TLabel;
    edtSPAJNum: TEdit;
    edtTertanggungName: TEdit;
    edtJobClass: TEdit;
    edtProductChosen: TEdit;
    edtTotalSumInsured: TEdit;
    edtBasePrem: TEdit;
    edtMakerBranch: TEdit;
    edtLoading: TEdit;
    memAssessmentNotes: TMemo;
    btnApprove: TButton;
    btnReject: TButton;
    dsQueue: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRefreshQueueClick(Sender: TObject);
    procedure dbgQueueCellClick(Column: TColumn);
    procedure btnApproveClick(Sender: TObject);
    procedure btnRejectClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FSelectedPolisID: Integer;
    FMakerUserID: Integer;
    procedure SyncSelectedQueue;
    procedure EvaluateDualControlRules;
    procedure AdjustLayout;
  public
  end;

var
  frmUnderwriting: TfrmUnderwriting;

implementation

{$R *.dfm}

procedure TfrmUnderwriting.FormCreate(Sender: TObject);
begin
  dsQueue.DataSet := dmInsurance.qryUnderwritingQueue;
  FSelectedPolisID := 0;
  FMakerUserID := 0;
end;

procedure TfrmUnderwriting.FormShow(Sender: TObject);
begin
  lblCheckerStatus.Caption := Format('Petugas: %s (%s) | Role: %s',
    [dmSecurity.CurrentFullName, dmSecurity.CurrentUserName, dmSecurity.ActiveRoleName]);
  btnRefreshQueueClick(nil);
  AdjustLayout;
end;

procedure TfrmUnderwriting.FormResize(Sender: TObject);
begin
  AdjustLayout;
end;

procedure TfrmUnderwriting.AdjustLayout;
var
  InputW, BtnW, AvailH, DesiredQueueW: Integer;
begin
  // Badge posisi petugas di pojok kanan atas
  lblCheckerStatus.Left := pnlHeader.ClientWidth - lblCheckerStatus.Width - 16;

  // Lebar antrean proporsional saat maximize (sekitar 48% dari lebar layar, min 420, max 780)
  DesiredQueueW := (pnlClient.ClientWidth * 48) div 100;
  if DesiredQueueW < 420 then DesiredQueueW := 420;
  if DesiredQueueW > 780 then DesiredQueueW := 780;
  pnlQueue.Width := DesiredQueueW;

  // Tombol refresh selalu di kanan header antrean
  btnRefreshQueue.Left := pnlQueueHeader.ClientWidth - btnRefreshQueue.Width - 12;

  // Kolom input formulir review risiko
  InputW := pnlFormReview.ClientWidth - edtSPAJNum.Left - 30;
  if InputW < 220 then InputW := 220;
  if InputW > 600 then InputW := 600;

  edtSPAJNum.Width         := InputW;
  edtTertanggungName.Width := InputW;
  edtJobClass.Width        := InputW;
  edtProductChosen.Width   := InputW;
  edtTotalSumInsured.Width := InputW;
  edtBasePrem.Width        := InputW;
  edtMakerBranch.Width     := InputW;
  edtLoading.Width         := InputW;

  // Lebar memo catatan analisa
  memAssessmentNotes.Left  := 16;
  memAssessmentNotes.Width := edtSPAJNum.Left + InputW - 16;

  // Tinggi memo dan penempatan tombol aksi otorisasi
  AvailH := pnlFormReview.ClientHeight - memAssessmentNotes.Top - 70;
  if AvailH > 80 then
  begin
    if AvailH > 220 then AvailH := 220;
    memAssessmentNotes.Height := AvailH;
  end;

  btnApprove.Top := memAssessmentNotes.Top + memAssessmentNotes.Height + 16;
  btnReject.Top  := btnApprove.Top;

  BtnW := (memAssessmentNotes.Width - 16) div 2;
  if BtnW < 140 then BtnW := 140;
  if BtnW > 280 then BtnW := 280;

  btnApprove.Left  := 16;
  btnApprove.Width := BtnW;

  btnReject.Left   := 16 + BtnW + 16;
  btnReject.Width  := BtnW;
end;

procedure TfrmUnderwriting.btnRefreshQueueClick(Sender: TObject);
begin
  dmInsurance.RefreshUWQueue;
  SyncSelectedQueue;
end;

procedure TfrmUnderwriting.dbgQueueCellClick(Column: TColumn);
begin
  SyncSelectedQueue;
end;

procedure TfrmUnderwriting.SyncSelectedQueue;
begin
  if not dmInsurance.qryUnderwritingQueue.IsEmpty then
  begin
    FSelectedPolisID := dmInsurance.qryUnderwritingQueue.FieldByName('id').AsInteger;
    FMakerUserID     := dmInsurance.qryUnderwritingQueue.FieldByName('maker_user_id').AsInteger;

    edtSPAJNum.Text         := dmInsurance.qryUnderwritingQueue.FieldByName('no_spaj').AsString;
    edtTertanggungName.Text := dmInsurance.qryUnderwritingQueue.FieldByName('tertanggung_nama').AsString;
    edtJobClass.Text        := dmInsurance.qryUnderwritingQueue.FieldByName('tertanggung_pekerjaan').AsString +
                               ' (Kelas ' + dmInsurance.qryUnderwritingQueue.FieldByName('tertanggung_kelas_pekerjaan').AsString + ')';
    edtProductChosen.Text   := dmInsurance.qryUnderwritingQueue.FieldByName('nama_produk').AsString;
    edtTotalSumInsured.Text := FormatRupiah(dmInsurance.qryUnderwritingQueue.FieldByName('uang_pertanggungan').AsFloat);
    edtBasePrem.Text        := FormatRupiah(dmInsurance.qryUnderwritingQueue.FieldByName('premi_dasar').AsFloat);
    edtMakerBranch.Text     := dmInsurance.qryUnderwritingQueue.FieldByName('maker_fullname').AsString +
                               ' (' + dmInsurance.qryUnderwritingQueue.FieldByName('maker_username').AsString + ')';
    edtLoading.Text         := '0';
  end
  else
  begin
    FSelectedPolisID := 0;
    FMakerUserID     := 0;
    edtSPAJNum.Text         := '-';
    edtTertanggungName.Text := '-';
    edtJobClass.Text        := '-';
    edtProductChosen.Text   := '-';
    edtTotalSumInsured.Text := '-';
    edtBasePrem.Text        := '-';
    edtMakerBranch.Text     := '-';
    edtLoading.Text         := '0';
  end;

  EvaluateDualControlRules;
end;

procedure TfrmUnderwriting.EvaluateDualControlRules;
var
  IsSameUserSOD: Boolean;
  CanApprove, CanReject: Boolean;
begin
  if FSelectedPolisID <= 0 then
  begin
    pnlWarningSOD.Visible := False;
    btnApprove.Enabled := False;
    btnReject.Enabled := False;
    Exit;
  end;

  // Segregation of Duties Check: Maker cannot approve own submission
  IsSameUserSOD := (FMakerUserID = dmSecurity.CurrentUserID) and (dmSecurity.ActiveRoleCode <> ROLE_CODE_ADMIN);

  CanApprove := dmSecurity.HasPermission(PERM_UW_APPROVE) and (not IsSameUserSOD);
  CanReject  := dmSecurity.HasPermission(PERM_UW_REJECT) and (not IsSameUserSOD);

  btnApprove.Enabled := CanApprove;
  btnReject.Enabled  := CanReject;

  if IsSameUserSOD then
  begin
    pnlWarningSOD.Caption :=
      'RESTRIKSI MAKER-CHECKER: Anda adalah Maker pembuat SPAJ ini!'#13#10 +
      'Sistem menonaktifkan tombol persetujuan demi mematuhi regulasi Dual Control perbankan.';
    pnlWarningSOD.Visible := True;
  end
  else if not dmSecurity.HasPermission(PERM_UW_APPROVE) then
  begin
    pnlWarningSOD.Caption := 'Peran aktif Anda tidak memiliki izin otorisasi Underwriting (UW_APPROVE).';
    pnlWarningSOD.Visible := True;
  end
  else
  begin
    pnlWarningSOD.Visible := False;
  end;
end;

procedure TfrmUnderwriting.btnApproveClick(Sender: TObject);
var
  LoadingVal: Double;
  Notes: string;
begin
  if FSelectedPolisID <= 0 then Exit;

  LoadingVal := StrToFloatDef(edtLoading.Text, 0);
  Notes := Trim(memAssessmentNotes.Text);

  if Notes = '' then
  begin
    ShowMessage('Catatan asesmen risiko Underwriter wajib diisi sebelum memberikan persetujuan!');
    memAssessmentNotes.SetFocus;
    Exit;
  end;

  if MessageDlg(
    Format('Anda akan menyetujui SPAJ %s menjadi Polis Aktif (INFORCE).'#13#10 +
           'Extra Risk Loading: %s'#13#10 +
           'Lanjutkan proses otorisasi?', [edtSPAJNum.Text, FormatRupiah(LoadingVal)]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if dmInsurance.ApprovePolicy(FSelectedPolisID, Notes, LoadingVal) then
    begin
      ShowMessage(Format('SPAJ %s telah BERHASIL DISETUJUI menjadi POLIS INFORCE!', [edtSPAJNum.Text]));
      btnRefreshQueueClick(nil);
    end;
  end;
end;

procedure TfrmUnderwriting.btnRejectClick(Sender: TObject);
var
  Notes: string;
begin
  if FSelectedPolisID <= 0 then Exit;

  Notes := Trim(memAssessmentNotes.Text);
  if Notes = '' then
  begin
    ShowMessage('Alasan penolakan polis wajib dicantumkan pada catatan Underwriter!');
    memAssessmentNotes.SetFocus;
    Exit;
  end;

  if MessageDlg(
    Format('Yakin ingin MENOLAK permohonan asuransi SPAJ %s (REJECTED)?', [edtSPAJNum.Text]),
    mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    if dmInsurance.RejectPolicy(FSelectedPolisID, Notes) then
    begin
      ShowMessage(Format('SPAJ %s telah DITOLAK (REJECTED).', [edtSPAJNum.Text]));
      btnRefreshQueueClick(nil);
    end;
  end;
end;

end.
