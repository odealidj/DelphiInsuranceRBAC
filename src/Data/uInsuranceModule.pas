unit uInsuranceModule;

interface

uses
  SysUtils, Classes, DB, ADODB, Variants, DateUtils,
  uDataConnection, uSecurityModule, uAppConst, uFormatUtils;

type
  TdmInsurance = class(TDataModule)
    qryPolisHeader: TADOQuery;
    dsPolisHeader: TDataSource;
    qryPolisRider: TADOQuery;
    dsPolisRider: TDataSource;
    qryLookupNasabah: TADOQuery;
    dsLookupNasabah: TDataSource;
    qryLookupProduk: TADOQuery;
    dsLookupProduk: TDataSource;
    qryLookupRider: TADOQuery;
    dsLookupRider: TDataSource;
    qryUnderwritingQueue: TADOQuery;
    dsUnderwritingQueue: TDataSource;
    qryExecute: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  public
    procedure RefreshPolisList;
    procedure RefreshRiderDetail(APolisID: Integer);
    procedure RefreshLookups;
    procedure RefreshUWQueue;

    function CreateDraftPolicy(
      APemegangID, ATertanggungID, AProdukID: Integer;
      const ACaraBayar: string;
      AUangPertanggungan, APremiDasar: Double;
      out ANewPolisID: Integer;
      out ANewNoSPAJ, ANewNoPolis: string
    ): Boolean;

    function AddRiderToPolicy(
      APolisID, ARiderID: Integer;
      AUangPertanggunganRider, ARatePremi, APremiRider: Double
    ): Boolean;

    function RemoveRiderFromPolicy(ADetailID, APolisID: Integer): Boolean;
    procedure RecalculatePolicyTotals(APolisID: Integer);

    function SubmitToUnderwriting(APolisID: Integer): Boolean;
    function ApprovePolicy(APolisID: Integer; const ANotes: string; AExtraLoading: Double): Boolean;
    function RejectPolicy(APolisID: Integer; const ANotes: string): Boolean;
  end;

var
  dmInsurance: TdmInsurance;

implementation

{$R *.dfm}

procedure TdmInsurance.DataModuleCreate(Sender: TObject);
begin
  qryPolisHeader.Connection        := dmConnection.Connection;
  qryPolisRider.Connection         := dmConnection.Connection;
  qryLookupNasabah.Connection      := dmConnection.Connection;
  qryLookupProduk.Connection       := dmConnection.Connection;
  qryLookupRider.Connection        := dmConnection.Connection;
  qryUnderwritingQueue.Connection  := dmConnection.Connection;
  qryExecute.Connection            := dmConnection.Connection;
end;

procedure TdmInsurance.RefreshPolisList;
begin
  qryPolisHeader.Close;
  qryPolisHeader.SQL.Text :=
    'SELECT h.id, h.no_polis, h.no_spaj, h.tgl_pengajuan, h.tgl_mulai_berlaku, h.tgl_berakhir, ' +
    '       h.status_polis, h.cara_bayar, h.uang_pertanggungan, h.premi_dasar, ' +
    '       h.total_premi_rider, h.extra_loading_premi, h.total_premi_berkala, ' +
    '       np.nama_lengkap AS pemegang_nama, nt.nama_lengkap AS tertanggung_nama, ' +
    '       p.nama_produk, p.kategori AS kategori_produk, ' +
    '       um.username AS maker_username, um.full_name AS maker_fullname, ' +
    '       uc.username AS checker_username, uc.full_name AS checker_fullname, ' +
    '       h.underwriting_decision, h.underwriting_notes, h.maker_user_id, h.checker_user_id ' +
    'FROM polis_header h ' +
    'INNER JOIN nasabah np ON h.pemegang_polis_id = np.id ' +
    'INNER JOIN nasabah nt ON h.tertanggung_id = nt.id ' +
    'INNER JOIN produk_asuransi p ON h.produk_id = p.id ' +
    'INNER JOIN users um ON h.maker_user_id = um.id ' +
    'LEFT JOIN users uc ON h.checker_user_id = uc.id ' +
    'ORDER BY h.id DESC';
  qryPolisHeader.Open;
end;

procedure TdmInsurance.RefreshRiderDetail(APolisID: Integer);
begin
  qryPolisRider.Close;
  qryPolisRider.SQL.Text :=
    'SELECT d.id, d.polis_header_id, d.rider_id, r.kode_rider, r.nama_rider, r.kategori_manfaat, ' +
    '       d.uang_pertanggungan_rider, d.rate_premi, d.premi_rider ' +
    'FROM polis_rider_detail d ' +
    'INNER JOIN rider r ON d.rider_id = r.id ' +
    'WHERE d.polis_header_id = :pid ' +
    'ORDER BY d.id ASC';
  qryPolisRider.Parameters.ParamByName('pid').Value := APolisID;
  qryPolisRider.Open;
end;

procedure TdmInsurance.RefreshLookups;
begin
  // Lookup Nasabah
  qryLookupNasabah.Close;
  qryLookupNasabah.SQL.Text :=
    'SELECT id, no_cif, nama_lengkap, no_identitas, tgl_lahir, pekerjaan, kelas_pekerjaan ' +
    'FROM nasabah ORDER BY nama_lengkap';
  qryLookupNasabah.Open;

  // Lookup Produk
  qryLookupProduk.Close;
  qryLookupProduk.SQL.Text :=
    'SELECT id, kode_produk, nama_produk, kategori, rate_premi_dasar, min_uang_pertanggungan, max_uang_pertanggungan ' +
    'FROM produk_asuransi WHERE is_active = 1 ORDER BY nama_produk';
  qryLookupProduk.Open;

  // Lookup Rider
  qryLookupRider.Close;
  qryLookupRider.SQL.Text :=
    'SELECT id, kode_rider, nama_rider, kategori_manfaat, rate_premi_rider ' +
    'FROM rider WHERE is_active = 1 ORDER BY nama_rider';
  qryLookupRider.Open;
end;

procedure TdmInsurance.RefreshUWQueue;
begin
  qryUnderwritingQueue.Close;
  qryUnderwritingQueue.SQL.Text :=
    'SELECT h.id, h.no_polis, h.no_spaj, h.tgl_pengajuan, h.status_polis, ' +
    '       h.cara_bayar, h.uang_pertanggungan, h.premi_dasar, h.total_premi_rider, ' +
    '       h.extra_loading_premi, h.total_premi_berkala, ' +
    '       np.nama_lengkap AS pemegang_nama, nt.nama_lengkap AS tertanggung_nama, ' +
    '       nt.tgl_lahir AS tertanggung_tgl_lahir, nt.pekerjaan AS tertanggung_pekerjaan, ' +
    '       nt.kelas_pekerjaan AS tertanggung_kelas_pekerjaan, ' +
    '       p.nama_produk, p.kategori AS kategori_produk, ' +
    '       um.username AS maker_username, um.full_name AS maker_fullname, ' +
    '       h.maker_user_id, h.submitted_at ' +
    'FROM polis_header h ' +
    'INNER JOIN nasabah np ON h.pemegang_polis_id = np.id ' +
    'INNER JOIN nasabah nt ON h.tertanggung_id = nt.id ' +
    'INNER JOIN produk_asuransi p ON h.produk_id = p.id ' +
    'INNER JOIN users um ON h.maker_user_id = um.id ' +
    'WHERE h.status_polis = ' + QuotedStr(POL_STATUS_SUBMITTED) + ' ' +
    'ORDER BY h.submitted_at ASC';
  qryUnderwritingQueue.Open;
end;

function TdmInsurance.CreateDraftPolicy(
  APemegangID, ATertanggungID, AProdukID: Integer;
  const ACaraBayar: string;
  AUangPertanggungan, APremiDasar: Double;
  out ANewPolisID: Integer;
  out ANewNoSPAJ, ANewNoPolis: string
): Boolean;
var
  TotalBerkala: Double;
begin
  Result := False;
  if not dmSecurity.HasPermission(PERM_POL_CREATE_DRAFT) then
    raise Exception.Create('Hak akses ditolak: Anda tidak memiliki izin membuat draft SPAJ baru.');

  ANewNoSPAJ  := GenerateNomorSPAJ;
  ANewNoPolis := GenerateNomorPolis;
  TotalBerkala := APremiDasar;

  dmConnection.BeginTrans;
  try
    qryExecute.Close;
    qryExecute.SQL.Text :=
      'INSERT INTO polis_header (' +
      '  no_polis, no_spaj, tgl_pengajuan, tgl_mulai_berlaku, tgl_berakhir, ' +
      '  pemegang_polis_id, tertanggung_id, produk_id, cara_bayar, ' +
      '  uang_pertanggungan, premi_dasar, total_premi_rider, extra_loading_premi, total_premi_berkala, ' +
      '  status_polis, maker_user_id, created_at' +
      ') VALUES (' +
      '  :nopol, :nospaj, :tglaju, :tglmulai, :tglakhir, ' +
      '  :pemegang, :tertanggung, :produk, :carabayar, ' +
      '  :up, :premidasar, 0, 0, :totalberkala, ' +
      '  :status, :makerid, GETDATE()' +
      '); SELECT SCOPE_IDENTITY() AS NewID;';

    qryExecute.Parameters.ParamByName('nopol').Value        := ANewNoPolis;
    qryExecute.Parameters.ParamByName('nospaj').Value       := ANewNoSPAJ;
    qryExecute.Parameters.ParamByName('tglaju').Value       := Date;
    qryExecute.Parameters.ParamByName('tglmulai').Value     := Date;
    qryExecute.Parameters.ParamByName('tglakhir').Value     := IncYear(Date, 10);
    qryExecute.Parameters.ParamByName('pemegang').Value     := APemegangID;
    qryExecute.Parameters.ParamByName('tertanggung').Value  := ATertanggungID;
    qryExecute.Parameters.ParamByName('produk').Value       := AProdukID;
    qryExecute.Parameters.ParamByName('carabayar').Value    := ACaraBayar;
    qryExecute.Parameters.ParamByName('up').Value           := AUangPertanggungan;
    qryExecute.Parameters.ParamByName('premidasar').Value   := APremiDasar;
    qryExecute.Parameters.ParamByName('totalberkala').Value := TotalBerkala;
    qryExecute.Parameters.ParamByName('status').Value       := POL_STATUS_DRAFT;
    qryExecute.Parameters.ParamByName('makerid').Value      := dmSecurity.CurrentUserID;

    qryExecute.Open;
    ANewPolisID := qryExecute.FieldByName('NewID').AsInteger;
    qryExecute.Close;

    dmSecurity.LogAudit('CREATE_DRAFT_SPAJ', 'polis_header', IntToStr(ANewPolisID),
      Format('Draft SPAJ %s (%s) dibuat oleh %s', [ANewNoSPAJ, ANewNoPolis, dmSecurity.CurrentUserName]));

    dmConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      dmConnection.RollbackTrans;
      raise Exception.Create('Gagal membuat draft SPAJ: ' + E.Message);
    end;
  end;
end;

function TdmInsurance.AddRiderToPolicy(
  APolisID, ARiderID: Integer;
  AUangPertanggunganRider, ARatePremi, APremiRider: Double
): Boolean;
begin
  Result := False;
  if not dmSecurity.HasPermission(PERM_POL_EDIT_DRAFT) then
    raise Exception.Create('Hak akses ditolak: Anda tidak memiliki izin mengubah komposisi rider.');

  dmConnection.BeginTrans;
  try
    qryExecute.Close;
    qryExecute.SQL.Text :=
      'INSERT INTO polis_rider_detail (polis_header_id, rider_id, uang_pertanggungan_rider, rate_premi, premi_rider) ' +
      'VALUES (:pid, :rid, :up, :rate, :premi)';
    qryExecute.Parameters.ParamByName('pid').Value   := APolisID;
    qryExecute.Parameters.ParamByName('rid').Value   := ARiderID;
    qryExecute.Parameters.ParamByName('up').Value    := AUangPertanggunganRider;
    qryExecute.Parameters.ParamByName('rate').Value  := ARatePremi;
    qryExecute.Parameters.ParamByName('premi').Value := APremiRider;
    qryExecute.ExecSQL;

    dmConnection.CommitTrans;
    RecalculatePolicyTotals(APolisID);
    Result := True;
  except
    on E: Exception do
    begin
      dmConnection.RollbackTrans;
      raise Exception.Create('Gagal menambahkan rider: ' + E.Message);
    end;
  end;
end;

function TdmInsurance.RemoveRiderFromPolicy(ADetailID, APolisID: Integer): Boolean;
begin
  Result := False;
  if not dmSecurity.HasPermission(PERM_POL_EDIT_DRAFT) then
    raise Exception.Create('Hak akses ditolak: Anda tidak memiliki izin menghapus rider.');

  dmConnection.BeginTrans;
  try
    qryExecute.Close;
    qryExecute.SQL.Text := 'DELETE FROM polis_rider_detail WHERE id = :did AND polis_header_id = :pid';
    qryExecute.Parameters.ParamByName('did').Value := ADetailID;
    qryExecute.Parameters.ParamByName('pid').Value := APolisID;
    qryExecute.ExecSQL;

    dmConnection.CommitTrans;
    RecalculatePolicyTotals(APolisID);
    Result := True;
  except
    on E: Exception do
    begin
      dmConnection.RollbackTrans;
      raise Exception.Create('Gagal menghapus rider: ' + E.Message);
    end;
  end;
end;

procedure TdmInsurance.RecalculatePolicyTotals(APolisID: Integer);
var
  TotalRider: Double;
begin
  // Hitung sum rider
  qryExecute.Close;
  qryExecute.SQL.Text :=
    'SELECT ISNULL(SUM(premi_rider), 0) AS sum_rider FROM polis_rider_detail WHERE polis_header_id = :pid';
  qryExecute.Parameters.ParamByName('pid').Value := APolisID;
  qryExecute.Open;
  TotalRider := qryExecute.FieldByName('sum_rider').AsFloat;
  qryExecute.Close;

  // Update header polis
  qryExecute.SQL.Text :=
    'UPDATE polis_header SET ' +
    '  total_premi_rider = :trider, ' +
    '  total_premi_berkala = (premi_dasar + :trider + extra_loading_premi) ' +
    'WHERE id = :pid';
  qryExecute.Parameters.ParamByName('trider').Value := TotalRider;
  qryExecute.Parameters.ParamByName('pid').Value    := APolisID;
  qryExecute.ExecSQL;
end;

function TdmInsurance.SubmitToUnderwriting(APolisID: Integer): Boolean;
begin
  Result := False;
  if not dmSecurity.HasPermission(PERM_POL_SUBMIT_UW) then
    raise Exception.Create('Hak akses ditolak: Anda tidak memiliki izin mengajukan SPAJ ke Underwriting.');

  dmConnection.BeginTrans;
  try
    qryExecute.Close;
    qryExecute.SQL.Text :=
      'UPDATE polis_header SET ' +
      '  status_polis = ' + QuotedStr(POL_STATUS_SUBMITTED) + ', ' +
      '  submitted_at = GETDATE() ' +
      'WHERE id = :pid AND status_polis = ' + QuotedStr(POL_STATUS_DRAFT);
    qryExecute.Parameters.ParamByName('pid').Value := APolisID;
    qryExecute.ExecSQL;

    dmSecurity.LogAudit('SUBMIT_TO_UW', 'polis_header', IntToStr(APolisID),
      Format('SPAJ ID %d diajukan ke antrean Underwriting oleh %s', [APolisID, dmSecurity.CurrentUserName]));

    dmConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      dmConnection.RollbackTrans;
      raise Exception.Create('Gagal mengajukan polis ke Underwriting: ' + E.Message);
    end;
  end;
end;

function TdmInsurance.ApprovePolicy(APolisID: Integer; const ANotes: string; AExtraLoading: Double): Boolean;
var
  MakerID: Integer;
begin
  Result := False;
  if not dmSecurity.HasPermission(PERM_UW_APPROVE) then
    raise Exception.Create('Hak akses ditolak: Anda tidak memiliki izin otorisasi Underwriting (UW_APPROVE).');

  // Segregation of Duties Check
  qryExecute.Close;
  qryExecute.SQL.Text := 'SELECT maker_user_id, no_polis, no_spaj FROM polis_header WHERE id = :pid';
  qryExecute.Parameters.ParamByName('pid').Value := APolisID;
  qryExecute.Open;
  if qryExecute.IsEmpty then
    raise Exception.Create('Polis dengan ID tersebut tidak ditemukan.');

  MakerID := qryExecute.FieldByName('maker_user_id').AsInteger;
  qryExecute.Close;

  if (MakerID = dmSecurity.CurrentUserID) and (dmSecurity.ActiveRoleCode <> ROLE_CODE_ADMIN) then
    raise Exception.Create(
      'PELANGGARAN MAKER-CHECKER (Segregation of Duties):'#13#10 +
      'Petugas yang membuat pengajuan (Maker) dilarang meng-approve polisnya sendiri!'#13#10 +
      'Persetujuan wajib dilakukan oleh Underwriter / Checker independen.'
    );

  dmConnection.BeginTrans;
  try
    qryExecute.SQL.Text :=
      'UPDATE polis_header SET ' +
      '  status_polis = ' + QuotedStr(POL_STATUS_INFORCE) + ', ' +
      '  checker_user_id = :cid, ' +
      '  underwriting_decision = ' + QuotedStr(UW_DECISION_APPROVED) + ', ' +
      '  underwriting_notes = :notes, ' +
      '  extra_loading_premi = :loading, ' +
      '  total_premi_berkala = (premi_dasar + total_premi_rider + :loading), ' +
      '  approved_at = GETDATE() ' +
      'WHERE id = :pid AND status_polis = ' + QuotedStr(POL_STATUS_SUBMITTED);
    qryExecute.Parameters.ParamByName('cid').Value     := dmSecurity.CurrentUserID;
    qryExecute.Parameters.ParamByName('notes').Value   := ANotes;
    qryExecute.Parameters.ParamByName('loading').Value := AExtraLoading;
    qryExecute.Parameters.ParamByName('pid').Value     := APolisID;
    qryExecute.ExecSQL;

    dmSecurity.LogAudit('APPROVE_POLICY', 'polis_header', IntToStr(APolisID),
      Format('Polis ID %d disetujui (INFORCE) oleh Underwriter %s. Loading: %m, Catatan: %s',
        [APolisID, dmSecurity.CurrentUserName, AExtraLoading, ANotes]));

    dmConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      dmConnection.RollbackTrans;
      raise Exception.Create('Gagal memproses persetujuan Underwriting: ' + E.Message);
    end;
  end;
end;

function TdmInsurance.RejectPolicy(APolisID: Integer; const ANotes: string): Boolean;
begin
  Result := False;
  if not dmSecurity.HasPermission(PERM_UW_REJECT) then
    raise Exception.Create('Hak akses ditolak: Anda tidak memiliki izin menolak pengajuan (UW_REJECT).');

  dmConnection.BeginTrans;
  try
    qryExecute.Close;
    qryExecute.SQL.Text :=
      'UPDATE polis_header SET ' +
      '  status_polis = ' + QuotedStr(POL_STATUS_REJECTED) + ', ' +
      '  checker_user_id = :cid, ' +
      '  underwriting_decision = ' + QuotedStr(UW_DECISION_REJECTED) + ', ' +
      '  underwriting_notes = :notes, ' +
      '  approved_at = GETDATE() ' +
      'WHERE id = :pid AND status_polis = ' + QuotedStr(POL_STATUS_SUBMITTED);
    qryExecute.Parameters.ParamByName('cid').Value   := dmSecurity.CurrentUserID;
    qryExecute.Parameters.ParamByName('notes').Value := ANotes;
    qryExecute.Parameters.ParamByName('pid').Value   := APolisID;
    qryExecute.ExecSQL;

    dmSecurity.LogAudit('REJECT_POLICY', 'polis_header', IntToStr(APolisID),
      Format('Polis ID %d ditolak (REJECTED) oleh Underwriter %s. Alasan: %s',
        [APolisID, dmSecurity.CurrentUserName, ANotes]));

    dmConnection.CommitTrans;
    Result := True;
  except
    on E: Exception do
    begin
      dmConnection.RollbackTrans;
      raise Exception.Create('Gagal menolak pengajuan polis: ' + E.Message);
    end;
  end;
end;

end.
