unit uFormPolicy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls, ExtCtrls, ComCtrls,
  uDataConnection, uSecurityModule, uInsuranceModule, uAppConst, uFormatUtils;

type
  TfrmPolicy = class(TForm)
    pnlHeader: TPanel;
    lblHeaderTitle: TLabel;
    lblActiveUser: TLabel;
    pnlTopGrid: TPanel;
    pnlFilter: TPanel;
    lblFilter: TLabel;
    btnRefresh: TButton;
    btnNewSPAJ: TButton;
    btnSubmitUW: TButton;
    btnPrintCert: TButton;
    dbgPolis: TDBGrid;
    splPolicy: TSplitter;
    pnlDetail: TPanel;
    pcDetail: TPageControl;
    tsHeader: TTabSheet;
    lblNoSPAJ: TLabel;
    lblNoPolis: TLabel;
    lblPemegang: TLabel;
    lblTertanggung: TLabel;
    lblProduk: TLabel;
    lblCaraBayar: TLabel;
    lblUP: TLabel;
    lblPremiDasar: TLabel;
    lblTotalRider: TLabel;
    lblExtraLoading: TLabel;
    lblTotalPremi: TLabel;
    lblStatusPolis: TLabel;
    edtNoSPAJ: TEdit;
    edtNoPolis: TEdit;
    cmbPemegang: TComboBox;
    cmbTertanggung: TComboBox;
    cmbProduk: TComboBox;
    cmbCaraBayar: TComboBox;
    edtUP: TEdit;
    edtPremiDasar: TEdit;
    edtTotalRider: TEdit;
    edtExtraLoading: TEdit;
    edtTotalPremi: TEdit;
    pnlStatusBadge: TPanel;
    btnSavePolicy: TButton;
    tsRiders: TTabSheet;
    pnlRiderInput: TPanel;
    lblRiderSelect: TLabel;
    lblRiderUP: TLabel;
    cmbRider: TComboBox;
    edtRiderUP: TEdit;
    btnAddRider: TButton;
    btnDeleteRider: TButton;
    dbgRiderDetail: TDBGrid;
    tsWorkflowInfo: TTabSheet;
    lblMakerInfo: TLabel;
    lblSubmittedAt: TLabel;
    lblCheckerInfo: TLabel;
    lblDecInfo: TLabel;
    lblNotesInfo: TLabel;
    edtMakerName: TEdit;
    edtSubmittedAt: TEdit;
    edtCheckerName: TEdit;
    edtDecInfo: TEdit;
    memNotesInfo: TMemo;
    dsPolis: TDataSource;
    dsRider: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure dbgPolisCellClick(Column: TColumn);
    procedure cmbProdukChange(Sender: TObject);
    procedure edtUPChange(Sender: TObject);
    procedure btnNewSPAJClick(Sender: TObject);
    procedure btnSavePolicyClick(Sender: TObject);
    procedure btnAddRiderClick(Sender: TObject);
    procedure btnDeleteRiderClick(Sender: TObject);
    procedure btnSubmitUWClick(Sender: TObject);
    procedure btnPrintCertClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure pcDetailChange(Sender: TObject);
  private
    FSelectedPolisID: Integer;
    FIsNewDraft: Boolean;
    procedure PopulateLookups;
    procedure SyncPolicyDetail;
    procedure CalculatePremiEstimate;
    procedure ApplySecurityConstraints;
    procedure UpdateBadge(const AStatus: string);
    procedure AdjustLayout;
  public
  end;

var
  frmPolicy: TfrmPolicy;

implementation

{$R *.dfm}

procedure TfrmPolicy.FormCreate(Sender: TObject);
begin
  dsPolis.DataSet := dmInsurance.qryPolisHeader;
  dsRider.DataSet := dmInsurance.qryPolisRider;
  FSelectedPolisID := 0;
  FIsNewDraft := False;
end;

procedure TfrmPolicy.FormShow(Sender: TObject);
begin
  lblActiveUser.Caption := Format('Petugas: %s (%s) | Sesi: %s',
    [dmSecurity.CurrentFullName, dmSecurity.CurrentUserName, dmSecurity.ActiveRoleName]);
  PopulateLookups;
  dmInsurance.RefreshPolisList;
  SyncPolicyDetail;
  ApplySecurityConstraints;

  if (ClientHeight > 550) and (pnlTopGrid.Height < 210) then
    pnlTopGrid.Height := ClientHeight div 3;

  AdjustLayout;
end;

procedure TfrmPolicy.FormResize(Sender: TObject);
begin
  AdjustLayout;
end;

procedure TfrmPolicy.pcDetailChange(Sender: TObject);
begin
  AdjustLayout;
end;

procedure TfrmPolicy.AdjustLayout;
var
  HalfW, Col1InputW, Col2LabelL, Col2InputL, Col2InputW: Integer;
begin
  // Posisi badge user aktif selalu di sisi kanan
  lblActiveUser.Left := pnlHeader.ClientWidth - lblActiveUser.Width - 16;

  // Layout 2 Kolom responsif pada Formulir SPAJ
  HalfW := tsHeader.ClientWidth div 2;
  if HalfW < 380 then HalfW := 380;

  // Kolom 1 (Data SPAJ)
  Col1InputW := HalfW - 130 - 30;
  if Col1InputW < 220 then Col1InputW := 220;
  if Col1InputW > 480 then Col1InputW := 480;

  edtNoSPAJ.Width      := Col1InputW;
  edtNoPolis.Width     := Col1InputW;
  cmbPemegang.Width    := Col1InputW;
  cmbTertanggung.Width := Col1InputW;
  cmbProduk.Width      := Col1InputW;
  cmbCaraBayar.Width   := Col1InputW;

  // Kolom 2 (Nilai Premi & UP)
  Col2LabelL := 130 + Col1InputW + 40;
  lblUP.Left           := Col2LabelL;
  lblPremiDasar.Left   := Col2LabelL;
  lblTotalRider.Left   := Col2LabelL;
  lblExtraLoading.Left := Col2LabelL;
  lblTotalPremi.Left   := Col2LabelL;
  lblStatusPolis.Left  := Col2LabelL;

  Col2InputL := Col2LabelL + 150;
  Col2InputW := tsHeader.ClientWidth - Col2InputL - 30;
  if Col2InputW < 200 then Col2InputW := 200;
  if Col2InputW > 480 then Col2InputW := 480;

  edtUP.Left           := Col2InputL;
  edtUP.Width          := Col2InputW;
  edtPremiDasar.Left   := Col2InputL;
  edtPremiDasar.Width  := Col2InputW;
  edtTotalRider.Left   := Col2InputL;
  edtTotalRider.Width  := Col2InputW;
  edtExtraLoading.Left := Col2InputL;
  edtExtraLoading.Width := Col2InputW;
  edtTotalPremi.Left   := Col2InputL;
  edtTotalPremi.Width  := Col2InputW;
  pnlStatusBadge.Left  := Col2InputL;
  pnlStatusBadge.Width := Col2InputW;

  // Tab 3: Jejak Maker-Checker
  Col1InputW := tsWorkflowInfo.ClientWidth - edtMakerName.Left - 40;
  if Col1InputW < 280 then Col1InputW := 280;
  if Col1InputW > 700 then Col1InputW := 700;

  edtMakerName.Width   := Col1InputW;
  edtSubmittedAt.Width := Col1InputW;
  edtCheckerName.Width := Col1InputW;
  edtDecInfo.Width     := Col1InputW;
  memNotesInfo.Width   := Col1InputW;
  if tsWorkflowInfo.ClientHeight - memNotesInfo.Top - 20 > 80 then
    memNotesInfo.Height := tsWorkflowInfo.ClientHeight - memNotesInfo.Top - 20;
end;

procedure TfrmPolicy.PopulateLookups;
begin
  dmInsurance.RefreshLookups;

  // Isi ComboBox Pemegang & Tertanggung
  cmbPemegang.Clear;
  cmbTertanggung.Clear;
  dmInsurance.qryLookupNasabah.First;
  while not dmInsurance.qryLookupNasabah.Eof do
  begin
    cmbPemegang.Items.AddObject(
      dmInsurance.qryLookupNasabah.FieldByName('nama_lengkap').AsString + ' (' +
      dmInsurance.qryLookupNasabah.FieldByName('no_cif').AsString + ')',
      TObject(dmInsurance.qryLookupNasabah.FieldByName('id').AsInteger)
    );
    cmbTertanggung.Items.AddObject(
      dmInsurance.qryLookupNasabah.FieldByName('nama_lengkap').AsString + ' (' +
      dmInsurance.qryLookupNasabah.FieldByName('no_cif').AsString + ')',
      TObject(dmInsurance.qryLookupNasabah.FieldByName('id').AsInteger)
    );
    dmInsurance.qryLookupNasabah.Next;
  end;
  if cmbPemegang.Items.Count > 0 then cmbPemegang.ItemIndex := 0;
  if cmbTertanggung.Items.Count > 0 then cmbTertanggung.ItemIndex := 0;

  // Isi ComboBox Produk
  cmbProduk.Clear;
  dmInsurance.qryLookupProduk.First;
  while not dmInsurance.qryLookupProduk.Eof do
  begin
    cmbProduk.Items.AddObject(
      dmInsurance.qryLookupProduk.FieldByName('nama_produk').AsString,
      TObject(dmInsurance.qryLookupProduk.FieldByName('id').AsInteger)
    );
    dmInsurance.qryLookupProduk.Next;
  end;
  if cmbProduk.Items.Count > 0 then cmbProduk.ItemIndex := 0;

  // Isi ComboBox Rider
  cmbRider.Clear;
  dmInsurance.qryLookupRider.First;
  while not dmInsurance.qryLookupRider.Eof do
  begin
    cmbRider.Items.AddObject(
      dmInsurance.qryLookupRider.FieldByName('nama_rider').AsString,
      TObject(dmInsurance.qryLookupRider.FieldByName('id').AsInteger)
    );
    dmInsurance.qryLookupRider.Next;
  end;
  if cmbRider.Items.Count > 0 then cmbRider.ItemIndex := 0;
end;

procedure TfrmPolicy.SyncPolicyDetail;
var
  StatusStr: string;
begin
  if not dmInsurance.qryPolisHeader.IsEmpty then
  begin
    FSelectedPolisID := dmInsurance.qryPolisHeader.FieldByName('id').AsInteger;
    FIsNewDraft := False;

    edtNoSPAJ.Text        := dmInsurance.qryPolisHeader.FieldByName('no_spaj').AsString;
    edtNoPolis.Text       := dmInsurance.qryPolisHeader.FieldByName('no_polis').AsString;
    edtUP.Text            := FloatToStr(dmInsurance.qryPolisHeader.FieldByName('uang_pertanggungan').AsFloat);
    edtPremiDasar.Text    := FormatRupiah(dmInsurance.qryPolisHeader.FieldByName('premi_dasar').AsFloat);
    edtTotalRider.Text    := FormatRupiah(dmInsurance.qryPolisHeader.FieldByName('total_premi_rider').AsFloat);
    edtExtraLoading.Text  := FormatRupiah(dmInsurance.qryPolisHeader.FieldByName('extra_loading_premi').AsFloat);
    edtTotalPremi.Text    := FormatRupiah(dmInsurance.qryPolisHeader.FieldByName('total_premi_berkala').AsFloat);

    StatusStr := dmInsurance.qryPolisHeader.FieldByName('status_polis').AsString;
    UpdateBadge(StatusStr);

    // Sync Pemegang & Tertanggung combo text
    cmbPemegang.Text    := dmInsurance.qryPolisHeader.FieldByName('pemegang_nama').AsString;
    cmbTertanggung.Text := dmInsurance.qryPolisHeader.FieldByName('tertanggung_nama').AsString;
    cmbProduk.Text      := dmInsurance.qryPolisHeader.FieldByName('nama_produk').AsString;
    cmbCaraBayar.Text   := dmInsurance.qryPolisHeader.FieldByName('cara_bayar').AsString;

    // Workflow info tab
    edtMakerName.Text   := dmInsurance.qryPolisHeader.FieldByName('maker_fullname').AsString +
                           ' (' + dmInsurance.qryPolisHeader.FieldByName('maker_username').AsString + ')';
    if not dmInsurance.qryPolisHeader.FieldByName('tgl_pengajuan').IsNull then
      edtSubmittedAt.Text := FormatDateIndo(dmInsurance.qryPolisHeader.FieldByName('tgl_pengajuan').AsDateTime)
    else
      edtSubmittedAt.Text := '-';

    edtCheckerName.Text := dmInsurance.qryPolisHeader.FieldByName('checker_fullname').AsString;
    edtDecInfo.Text     := dmInsurance.qryPolisHeader.FieldByName('underwriting_decision').AsString;
    memNotesInfo.Text   := dmInsurance.qryPolisHeader.FieldByName('underwriting_notes').AsString;

    dmInsurance.RefreshRiderDetail(FSelectedPolisID);
  end;

  ApplySecurityConstraints;
end;

procedure TfrmPolicy.UpdateBadge(const AStatus: string);
begin
  pnlStatusBadge.Caption := 'STATUS: ' + AStatus;
  if AStatus = POL_STATUS_DRAFT then
  begin
    pnlStatusBadge.Color := $0045B8FC; // Amber/Gold
    pnlStatusBadge.Font.Color := clBlack;
  end
  else if AStatus = POL_STATUS_SUBMITTED then
  begin
    pnlStatusBadge.Color := $00C08000; // Deep Orange
    pnlStatusBadge.Font.Color := clWhite;
  end
  else if AStatus = POL_STATUS_INFORCE then
  begin
    pnlStatusBadge.Color := $002E8B57; // SeaGreen
    pnlStatusBadge.Font.Color := clWhite;
  end
  else if AStatus = POL_STATUS_REJECTED then
  begin
    pnlStatusBadge.Color := $002A2AA8; // Crimson Red
    pnlStatusBadge.Font.Color := clWhite;
  end
  else
  begin
    pnlStatusBadge.Color := clSilver;
    pnlStatusBadge.Font.Color := clBlack;
  end;
end;

procedure TfrmPolicy.ApplySecurityConstraints;
var
  IsDraft: Boolean;
  CanCreateDraft, CanEditDraft, CanSubmitUW: Boolean;
  CurrentStatus: string;
begin
  CurrentStatus := '';
  if not dmInsurance.qryPolisHeader.IsEmpty then
    CurrentStatus := dmInsurance.qryPolisHeader.FieldByName('status_polis').AsString;

  IsDraft := (CurrentStatus = POL_STATUS_DRAFT) or FIsNewDraft;

  CanCreateDraft := dmSecurity.HasPermission(PERM_POL_CREATE_DRAFT);
  CanEditDraft   := dmSecurity.HasPermission(PERM_POL_EDIT_DRAFT) and IsDraft;
  CanSubmitUW    := dmSecurity.HasPermission(PERM_POL_SUBMIT_UW) and (CurrentStatus = POL_STATUS_DRAFT);

  btnNewSPAJ.Enabled     := CanCreateDraft;
  btnSavePolicy.Enabled  := CanEditDraft or FIsNewDraft;
  btnSubmitUW.Enabled    := CanSubmitUW;
  btnAddRider.Enabled    := CanEditDraft;
  btnDeleteRider.Enabled := CanEditDraft;
  btnPrintCert.Enabled   := dmSecurity.HasPermission(PERM_POL_PRINT_CERT);

  // Field editing only allowed during Draft
  cmbPemegang.Enabled    := IsDraft;
  cmbTertanggung.Enabled := IsDraft;
  cmbProduk.Enabled      := IsDraft;
  cmbCaraBayar.Enabled   := IsDraft;
  edtUP.ReadOnly         := not IsDraft;
end;

procedure TfrmPolicy.CalculatePremiEstimate;
var
  UPVal, RateVal, PremVal: Double;
  ProdID: Integer;
begin
  UPVal := StrToFloatDef(edtUP.Text, 0);
  ProdID := 0;
  if cmbProduk.ItemIndex >= 0 then
    ProdID := Integer(cmbProduk.Items.Objects[cmbProduk.ItemIndex]);

  RateVal := 0.0125; // Default rate
  if ProdID > 0 then
  begin
    dmInsurance.qryLookupProduk.First;
    while not dmInsurance.qryLookupProduk.Eof do
    begin
      if dmInsurance.qryLookupProduk.FieldByName('id').AsInteger = ProdID then
      begin
        RateVal := dmInsurance.qryLookupProduk.FieldByName('rate_premi_dasar').AsFloat;
        Break;
      end;
      dmInsurance.qryLookupProduk.Next;
    end;
  end;

  PremVal := UPVal * RateVal;
  edtPremiDasar.Text := FormatRupiah(PremVal);
  edtTotalPremi.Text := FormatRupiah(PremVal + ParseRupiah(edtTotalRider.Text) + ParseRupiah(edtExtraLoading.Text));
end;

procedure TfrmPolicy.cmbProdukChange(Sender: TObject);
begin
  CalculatePremiEstimate;
end;

procedure TfrmPolicy.edtUPChange(Sender: TObject);
begin
  CalculatePremiEstimate;
end;

procedure TfrmPolicy.btnRefreshClick(Sender: TObject);
begin
  dmInsurance.RefreshPolisList;
  SyncPolicyDetail;
end;

procedure TfrmPolicy.dbgPolisCellClick(Column: TColumn);
begin
  SyncPolicyDetail;
end;

procedure TfrmPolicy.btnNewSPAJClick(Sender: TObject);
begin
  if not dmSecurity.HasPermission(PERM_POL_CREATE_DRAFT) then
  begin
    ShowMessage('Anda tidak memiliki hak akses untuk membuat draft SPAJ baru!');
    Exit;
  end;

  FIsNewDraft := True;
  FSelectedPolisID := 0;

  edtNoSPAJ.Text       := GenerateNomorSPAJ;
  edtNoPolis.Text      := GenerateNomorPolis;
  edtUP.Text           := '200000000';
  edtTotalRider.Text   := FormatRupiah(0);
  edtExtraLoading.Text := FormatRupiah(0);
  UpdateBadge(POL_STATUS_DRAFT);

  CalculatePremiEstimate;
  ApplySecurityConstraints;
  pcDetail.ActivePage := tsHeader;
  ShowMessage('Formulir SPAJ Baru telah disiapkan. Silakan tentukan nasabah, produk, dan nilai UP lalu klik "Simpan SPAJ Draft".');
end;

procedure TfrmPolicy.btnSavePolicyClick(Sender: TObject);
var
  PemegangID, TertanggungID, ProdID, NewID: Integer;
  UPVal, PremVal: Double;
  NoSPAJ, NoPol: string;
begin
  if cmbPemegang.ItemIndex < 0 then
  begin
    ShowMessage('Pilih Pemegang Polis!');
    Exit;
  end;
  if cmbTertanggung.ItemIndex < 0 then
  begin
    ShowMessage('Pilih Tertanggung!');
    Exit;
  end;
  if cmbProduk.ItemIndex < 0 then
  begin
    ShowMessage('Pilih Produk Asuransi!');
    Exit;
  end;

  PemegangID    := Integer(cmbPemegang.Items.Objects[cmbPemegang.ItemIndex]);
  TertanggungID := Integer(cmbTertanggung.Items.Objects[cmbTertanggung.ItemIndex]);
  ProdID        := Integer(cmbProduk.Items.Objects[cmbProduk.ItemIndex]);
  UPVal         := StrToFloatDef(edtUP.Text, 0);
  PremVal       := ParseRupiah(edtPremiDasar.Text);

  if UPVal <= 0 then
  begin
    ShowMessage('Nilai Uang Pertanggungan (UP) harus lebih dari 0!');
    Exit;
  end;

  if FIsNewDraft then
  begin
    if dmInsurance.CreateDraftPolicy(PemegangID, TertanggungID, ProdID,
         cmbCaraBayar.Text, UPVal, PremVal, NewID, NoSPAJ, NoPol) then
    begin
      FIsNewDraft := False;
      FSelectedPolisID := NewID;
      ShowMessage(Format('Draft SPAJ %s berhasil dibuat dan disimpan!', [NoSPAJ]));
      dmInsurance.RefreshPolisList;
      SyncPolicyDetail;
    end;
  end
  else
  begin
    // Update existing draft
    dmConnection.Connection.BeginTrans;
    try
      dmInsurance.qryExecute.Close;
      dmInsurance.qryExecute.SQL.Text :=
        'UPDATE polis_header SET ' +
        '  pemegang_polis_id = :p1, tertanggung_id = :p2, produk_id = :p3, ' +
        '  cara_bayar = :cb, uang_pertanggungan = :up, premi_dasar = :prem, ' +
        '  total_premi_berkala = (:prem + total_premi_rider + extra_loading_premi) ' +
        'WHERE id = :id AND status_polis = ' + QuotedStr(POL_STATUS_DRAFT);
      dmInsurance.qryExecute.Parameters.ParamByName('p1').Value   := PemegangID;
      dmInsurance.qryExecute.Parameters.ParamByName('p2').Value   := TertanggungID;
      dmInsurance.qryExecute.Parameters.ParamByName('p3').Value   := ProdID;
      dmInsurance.qryExecute.Parameters.ParamByName('cb').Value   := cmbCaraBayar.Text;
      dmInsurance.qryExecute.Parameters.ParamByName('up').Value   := UPVal;
      dmInsurance.qryExecute.Parameters.ParamByName('prem').Value := PremVal;
      dmInsurance.qryExecute.Parameters.ParamByName('id').Value   := FSelectedPolisID;
      dmInsurance.qryExecute.ExecSQL;
      dmConnection.Connection.CommitTrans;

      ShowMessage('Perubahan Draft SPAJ berhasil disimpan!');
      dmInsurance.RefreshPolisList;
      SyncPolicyDetail;
    except
      on E: Exception do
      begin
        dmConnection.Connection.RollbackTrans;
        ShowMessage('Gagal update draft: ' + E.Message);
      end;
    end;
  end;
end;

procedure TfrmPolicy.btnAddRiderClick(Sender: TObject);
var
  RiderID: Integer;
  RiderUP, RateVal, PremRider: Double;
begin
  if FSelectedPolisID <= 0 then
  begin
    ShowMessage('Pilih atau simpan polis terlebih dahulu!');
    Exit;
  end;

  if cmbRider.ItemIndex < 0 then
  begin
    ShowMessage('Pilih jenis rider!');
    Exit;
  end;

  RiderID := Integer(cmbRider.Items.Objects[cmbRider.ItemIndex]);
  RiderUP := StrToFloatDef(edtRiderUP.Text, 0);
  if RiderUP <= 0 then
  begin
    ShowMessage('Isi nilai UP Rider!');
    Exit;
  end;

  // Rate rider
  RateVal := 0.005;
  dmInsurance.qryLookupRider.First;
  while not dmInsurance.qryLookupRider.Eof do
  begin
    if dmInsurance.qryLookupRider.FieldByName('id').AsInteger = RiderID then
    begin
      RateVal := dmInsurance.qryLookupRider.FieldByName('rate_premi_rider').AsFloat;
      Break;
    end;
    dmInsurance.qryLookupRider.Next;
  end;

  PremRider := RiderUP * RateVal;

  if dmInsurance.AddRiderToPolicy(FSelectedPolisID, RiderID, RiderUP, RateVal, PremRider) then
  begin
    dmInsurance.RefreshPolisList;
    SyncPolicyDetail;
    ShowMessage('Rider berhasil ditambahkan ke polis!');
  end;
end;

procedure TfrmPolicy.btnDeleteRiderClick(Sender: TObject);
var
  DetailID: Integer;
begin
  if dmInsurance.qryPolisRider.IsEmpty then Exit;

  DetailID := dmInsurance.qryPolisRider.FieldByName('id').AsInteger;
  if MessageDlg('Hapus rider ini dari polis?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if dmInsurance.RemoveRiderFromPolicy(DetailID, FSelectedPolisID) then
    begin
      dmInsurance.RefreshPolisList;
      SyncPolicyDetail;
      ShowMessage('Rider berhasil dihapus.');
    end;
  end;
end;

procedure TfrmPolicy.btnSubmitUWClick(Sender: TObject);
begin
  if FSelectedPolisID <= 0 then Exit;

  if MessageDlg(
    Format('Kirimkan SPAJ %s ke antrean Underwriting (Checker)?'#13#10 +
           'Setelah diajukan, data polis tidak dapat diubah lagi oleh Maker.', [edtNoSPAJ.Text]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if dmInsurance.SubmitToUnderwriting(FSelectedPolisID) then
    begin
      ShowMessage('SPAJ berhasil diajukan ke Underwriting! Status kini SUBMITTED.');
      dmInsurance.RefreshPolisList;
      SyncPolicyDetail;
    end;
  end;
end;

procedure TfrmPolicy.btnPrintCertClick(Sender: TObject);
var
  Cert: string;
begin
  if FSelectedPolisID <= 0 then Exit;

  Cert :=
    '========================================================================'#13#10 +
    '          IKHTISAR SERTIFIKAT POLIS ASURANSI (CORE BANCASSURANCE)       '#13#10 +
    '                    BANK CODINA & ASURANSI JIWA                        '#13#10 +
    '========================================================================'#13#10 +
    'Nomor SPAJ        : ' + edtNoSPAJ.Text + #13#10 +
    'Nomor Polis       : ' + edtNoPolis.Text + #13#10 +
    'Status Polis      : ' + pnlStatusBadge.Caption + #13#10 +
    '------------------------------------------------------------------------'#13#10 +
    'Pemegang Polis    : ' + cmbPemegang.Text + #13#10 +
    'Tertanggung       : ' + cmbTertanggung.Text + #13#10 +
    'Produk Dasar      : ' + cmbProduk.Text + #13#10 +
    'Cara Pembayaran   : ' + cmbCaraBayar.Text + #13#10 +
    'Uang Pertanggungan: ' + FormatRupiah(StrToFloatDef(edtUP.Text, 0)) + #13#10 +
    'Premi Dasar       : ' + edtPremiDasar.Text + #13#10 +
    'Total Premi Rider : ' + edtTotalRider.Text + #13#10 +
    'Extra Risk Loading: ' + edtExtraLoading.Text + #13#10 +
    '------------------------------------------------------------------------'#13#10 +
    'TOTAL PREMI BERKALA: ' + edtTotalPremi.Text + #13#10 +
    '========================================================================'#13#10 +
    'Maker / Cabang    : ' + edtMakerName.Text + #13#10 +
    'Underwriter       : ' + edtCheckerName.Text + ' (' + edtDecInfo.Text + ')'#13#10 +
    '========================================================================'#13#10 +
    'Dokumen ini dicetak secara sah oleh sistem Bancassurance terintegrasi.';

  ShowMessage(Cert);
end;

end.
