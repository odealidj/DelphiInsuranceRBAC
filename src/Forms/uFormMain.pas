unit uFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Buttons, StdCtrls, ExtCtrls, DB, ADODB,
  uDataConnection, uSecurityModule, uInsuranceModule, uAppConst, uFormatUtils;

type
  TfrmMain = class(TForm)
    pnlSidebar: TPanel;
    pnlCodinaStrip: TPanel;
    pnlBrand: TPanel;
    lblBrandName: TLabel;
    lblBrandApp: TLabel;
    lblBrandSub: TLabel;
    pnlProfile: TPanel;
    lblProfileHeader: TLabel;
    lblProfileName: TLabel;
    lblBranch: TLabel;
    pnlRoleBadge: TPanel;
    pnlNavButtons: TPanel;
    lblNavCat1: TLabel;
    lblNavCat2: TLabel;
    btnNavDash: TSpeedButton;
    btnNavPolicy: TSpeedButton;
    btnNavUW: TSpeedButton;
    btnNavCustomer: TSpeedButton;
    btnNavRBAC: TSpeedButton;
    btnNavAudit: TSpeedButton;
    pnlBottomNav: TPanel;
    pnlBottomBorder: TPanel;
    btnNavSwitch: TSpeedButton;
    btnNavExit: TSpeedButton;
    pnlSidebarBorder: TPanel;
    pnlContentArea: TPanel;
    pnlTopBar: TPanel;
    pnlTopBarBorder: TPanel;
    lblPageTitle: TLabel;
    lblBreadcrumb: TLabel;
    pnlStatusPill: TPanel;
    lblDBStatus: TLabel;
    pnlEmbedHost: TPanel;
    pnlDashboardHome: TPanel;
    pnlKPIHeader: TPanel;
    pnlCardDraft: TPanel;
    pnlCardDraftStrip: TPanel;
    lblCard1Title: TLabel;
    lblCountDraft: TLabel;
    lblCard1Sub: TLabel;
    pnlCardUW: TPanel;
    pnlCardUWStrip: TPanel;
    lblCard2Title: TLabel;
    lblCountSubmitted: TLabel;
    lblCard2Sub: TLabel;
    pnlCardInforce: TPanel;
    pnlCardInforceStrip: TPanel;
    lblCard3Title: TLabel;
    lblCountInforce: TLabel;
    lblCard3Sub: TLabel;
    pnlCardReject: TPanel;
    pnlCardRejectStrip: TPanel;
    lblCard4Title: TLabel;
    lblCountRejected: TLabel;
    lblCard4Sub: TLabel;
    pnlQuickActions: TPanel;
    pnlQuickBorder: TPanel;
    btnQuickNewSPAJ: TButton;
    btnQuickUW: TButton;
    btnQuickCust: TButton;
    btnQuickRefresh: TButton;
    pnlDashCards: TPanel;
    pnlCardOJK: TPanel;
    pnlCardOJKTitle: TPanel;
    lblCardOJKTitle: TLabel;
    lblOJKRule1: TLabel;
    lblOJKRule2: TLabel;
    lblOJKRule3: TLabel;
    lblPermHeader: TLabel;
    memPermList: TMemo;
    pnlCardSysInfo: TPanel;
    pnlCardSysTitle: TPanel;
    lblCardSysTitle: TLabel;
    lblInfoUser: TLabel;
    lblInfoNIP: TLabel;
    lblInfoRole: TLabel;
    lblInfoServer: TLabel;
    lblInfoOJKNotice: TLabel;
    memQuickWorkflow: TMemo;
    mmMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuSwitchUser: TMenuItem;
    mnuSep1: TMenuItem;
    mnuExit: TMenuItem;
    mnuTransaksi: TMenuItem;
    mnuCust: TMenuItem;
    mnuPolicy: TMenuItem;
    mnuUnderwriting: TMenuItem;
    mnuUWQueue: TMenuItem;
    mnuSistem: TMenuItem;
    mnuRBAC: TMenuItem;
    mnuAudit: TMenuItem;
    mnuBantuan: TMenuItem;
    mnuOJKGuide: TMenuItem;
    mnuAbout: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnNavDashClick(Sender: TObject);
    procedure btnNavPolicyClick(Sender: TObject);
    procedure btnNavUWClick(Sender: TObject);
    procedure btnNavCustomerClick(Sender: TObject);
    procedure btnNavRBACClick(Sender: TObject);
    procedure btnNavAuditClick(Sender: TObject);
    procedure btnNavSwitchClick(Sender: TObject);
    procedure btnNavExitClick(Sender: TObject);
    procedure btnQuickNewSPAJClick(Sender: TObject);
    procedure btnQuickUWClick(Sender: TObject);
    procedure btnQuickCustClick(Sender: TObject);
    procedure btnQuickRefreshClick(Sender: TObject);
    procedure mnuOJKGuideClick(Sender: TObject);
    procedure mnuAboutClick(Sender: TObject);
    procedure pnlKPIHeaderResize(Sender: TObject);
    procedure pnlDashCardsResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FActiveEmbeddedForm: TForm;
    procedure ShowEmbeddedForm(AForm: TForm; const ATitle, ABreadcrumb: string);
    procedure ShowDashboardHome;
    procedure RefreshSessionState;
    procedure RealignNavButtons;
    procedure UpdateDashboardKPIs;
    procedure UpdateSysInfoCard;
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uFormLogin, uFormPolicy, uFormUnderwriting, uFormCustomer, uFormUserRole;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FActiveEmbeddedForm := nil;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;

  if not dmSecurity.IsLoggedIn then
  begin
    frmLogin := TfrmLogin.Create(Self);
    try
      if frmLogin.ShowModal <> mrOk then
      begin
        Application.Terminate;
        Exit;
      end;
    finally
      frmLogin.Free;
    end;
  end;

  RefreshSessionState;
end;

procedure TfrmMain.ShowDashboardHome;
begin
  if FActiveEmbeddedForm <> nil then
  begin
    FActiveEmbeddedForm.Hide;
    FActiveEmbeddedForm := nil;
  end;

  pnlDashboardHome.BringToFront;
  pnlDashboardHome.Show;
  lblPageTitle.Caption := 'Ringkasan & Metrik Operasional';
  lblBreadcrumb.Caption := 'Beranda / Bancassurance / Dashboard Operasional';
  btnNavDash.Down := True;
  UpdateDashboardKPIs;
  UpdateSysInfoCard;
  pnlKPIHeaderResize(nil);
  pnlDashCardsResize(nil);
end;

procedure TfrmMain.pnlKPIHeaderResize(Sender: TObject);
var
  TotalW, CardW, Gap, SideMargin: Integer;
begin
  SideMargin := 16;
  Gap := 16;
  TotalW := pnlKPIHeader.ClientWidth - (SideMargin * 2) - (Gap * 3);
  if TotalW < 400 then Exit;
  CardW := TotalW div 4;

  pnlCardDraft.Left   := SideMargin;
  pnlCardDraft.Width  := CardW;

  pnlCardUW.Left      := SideMargin + CardW + Gap;
  pnlCardUW.Width     := CardW;

  pnlCardInforce.Left := SideMargin + (CardW + Gap) * 2;
  pnlCardInforce.Width := CardW;

  pnlCardReject.Left  := SideMargin + (CardW + Gap) * 3;
  pnlCardReject.Width := pnlKPIHeader.ClientWidth - SideMargin - pnlCardReject.Left;
end;

procedure TfrmMain.pnlDashCardsResize(Sender: TObject);
var
  SideMargin, Gap, CardW, CardH: Integer;
begin
  SideMargin := 16;
  Gap := 16;
  CardH := pnlDashCards.ClientHeight - 28;
  if CardH < 220 then CardH := 220;

  CardW := (pnlDashCards.ClientWidth - (SideMargin * 2) - Gap) div 2;
  if CardW < 250 then Exit;

  pnlCardOJK.Left   := SideMargin;
  pnlCardOJK.Top    := 14;
  pnlCardOJK.Width  := CardW;
  pnlCardOJK.Height := CardH;

  pnlCardSysInfo.Left   := SideMargin + CardW + Gap;
  pnlCardSysInfo.Top    := 14;
  pnlCardSysInfo.Width  := pnlDashCards.ClientWidth - SideMargin - pnlCardSysInfo.Left;
  pnlCardSysInfo.Height := CardH;

  // Sesuaikan lebar & tinggi kontrol di dalam Card OJK
  memPermList.Width  := pnlCardOJK.ClientWidth - 32;
  if pnlCardOJK.ClientHeight - memPermList.Top - 16 > 100 then
    memPermList.Height := pnlCardOJK.ClientHeight - memPermList.Top - 16;

  lblOJKRule1.Width := pnlCardOJK.ClientWidth - 32;
  lblOJKRule2.Width := pnlCardOJK.ClientWidth - 32;
  lblOJKRule3.Width := pnlCardOJK.ClientWidth - 32;

  // Sesuaikan lebar & tinggi kontrol di dalam Card Informasi Sesi
  memQuickWorkflow.Width := pnlCardSysInfo.ClientWidth - 32;
  if pnlCardSysInfo.ClientHeight - memQuickWorkflow.Top - 16 > 100 then
    memQuickWorkflow.Height := pnlCardSysInfo.ClientHeight - memQuickWorkflow.Top - 16;

  lblInfoUser.Width   := pnlCardSysInfo.ClientWidth - 32;
  lblInfoNIP.Width    := pnlCardSysInfo.ClientWidth - 32;
  lblInfoRole.Width   := pnlCardSysInfo.ClientWidth - 32;
  lblInfoServer.Width := pnlCardSysInfo.ClientWidth - 32;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  if pnlDashboardHome.Visible then
  begin
    pnlKPIHeaderResize(nil);
    pnlDashCardsResize(nil);
  end;
end;

procedure TfrmMain.ShowEmbeddedForm(AForm: TForm; const ATitle, ABreadcrumb: string);
begin
  if AForm = nil then Exit;

  if FActiveEmbeddedForm <> nil then
    FActiveEmbeddedForm.Hide;

  pnlDashboardHome.Hide;

  AForm.Parent := pnlEmbedHost;
  AForm.BorderStyle := bsNone;
  AForm.Align := alClient;
  AForm.Show;
  AForm.BringToFront;
  AForm.Realign;

  FActiveEmbeddedForm := AForm;
  lblPageTitle.Caption := ATitle;
  lblBreadcrumb.Caption := ABreadcrumb;
end;

procedure TfrmMain.RealignNavButtons;
var
  Y: Integer;
begin
  Y := 10;
  lblNavCat1.Top := Y;
  Inc(Y, 16);

  btnNavDash.Top := Y;
  Inc(Y, btnNavDash.Height + 4);

  if btnNavPolicy.Visible then
  begin
    btnNavPolicy.Top := Y;
    Inc(Y, btnNavPolicy.Height + 4);
  end;

  if btnNavUW.Visible then
  begin
    btnNavUW.Top := Y;
    Inc(Y, btnNavUW.Height + 4);
  end;

  if btnNavCustomer.Visible then
  begin
    btnNavCustomer.Top := Y;
    Inc(Y, btnNavCustomer.Height + 4);
  end;

  if lblNavCat2.Visible then
  begin
    Inc(Y, 12);
    lblNavCat2.Top := Y;
    Inc(Y, 16);

    if btnNavRBAC.Visible then
    begin
      btnNavRBAC.Top := Y;
      Inc(Y, btnNavRBAC.Height + 4);
    end;

    if btnNavAudit.Visible then
    begin
      btnNavAudit.Top := Y;
      Inc(Y, btnNavAudit.Height + 4);
    end;
  end;
end;

procedure TfrmMain.RefreshSessionState;
var
  IsAdmin: Boolean;
  CanViewPolicy, CanViewUW, CanViewCust: Boolean;
begin
  // Update Profile Card
  lblProfileName.Caption := dmSecurity.CurrentFullName;
  lblBranch.Caption := 'KCU Jakarta Senayan [001]';

  // Role Badge Corporate Colors (Codina Palette)
  if dmSecurity.ActiveRoleCode = ROLE_CODE_MAKER then
  begin
    pnlRoleBadge.Caption := 'MAKER (BANCASS)';
    pnlRoleBadge.Color   := $0016A34A; // Clean Green
  end
  else if dmSecurity.ActiveRoleCode = ROLE_CODE_CHECKER then
  begin
    pnlRoleBadge.Caption := 'CHECKER (UW)';
    pnlRoleBadge.Color   := $002563EB; // Corporate Blue
  end
  else if dmSecurity.ActiveRoleCode = ROLE_CODE_ADMIN then
  begin
    pnlRoleBadge.Caption := 'ADMINISTRATOR';
    pnlRoleBadge.Color   := $007C3AED; // Royal Purple
  end
  else
  begin
    pnlRoleBadge.Caption := 'CUST. SERVICE';
    pnlRoleBadge.Color   := $000284C7; // Light Blue
  end;

  lblDBStatus.Caption := '● SQL Server: ' + dmConnection.GetServerInfo;

  IsAdmin := (dmSecurity.ActiveRoleCode = ROLE_CODE_ADMIN) or
             dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES);

  if IsAdmin then
  begin
    // =========================================================================
    // PERAN ADMINISTRATOR: KHUSUS ROLE & KEAMANAN SISTEM (NON-TRANSAKSI)
    // =========================================================================
    lblNavCat1.Caption := 'ADMINISTRASI KEAMANAN & RBAC';

    // Sembunyikan seluruh menu transaksi perbankan
    btnNavDash.Visible     := False;
    btnNavPolicy.Visible   := False;
    btnNavUW.Visible       := False;
    btnNavCustomer.Visible := False;

    // Tampilkan khusus menu keamanan & role
    lblNavCat2.Visible     := False;
    btnNavRBAC.Visible     := True;
    btnNavAudit.Visible    := True;

    // Menu Bar sync: Sembunyikan transaksi, tampilkan sistem/keamanan
    mnuTransaksi.Visible    := False;
    mnuUnderwriting.Visible := False;
    mnuSistem.Visible       := True;
    mnuRBAC.Visible         := True;
    mnuAudit.Visible        := True;

    // Realign buttons
    RealignNavButtons;

    // Langsung buka form Manajemen Role & RBAC untuk Admin
    btnNavRBACClick(nil);
  end
  else
  begin
    // =========================================================================
    // PERAN OPERASIONAL BISNIS: KHUSUS TRANSAKSI (NON-ROLE/KEAMANAN)
    // =========================================================================
    lblNavCat1.Caption := 'TRANSAKSI OPERASIONAL';

    CanViewPolicy := dmSecurity.HasPermission(PERM_POL_VIEW);
    CanViewUW     := dmSecurity.HasPermission(PERM_UW_ACCESS_QUEUE);
    CanViewCust   := dmSecurity.HasPermission(PERM_CUST_VIEW);

    // Tampilkan menu dashboard & transaksi sesuai hak akses operasional
    btnNavDash.Visible     := True;
    btnNavPolicy.Visible   := CanViewPolicy;
    btnNavUW.Visible       := CanViewUW;
    btnNavCustomer.Visible := CanViewCust;

    // Sembunyikan total menu role & keamanan sistem
    lblNavCat2.Visible     := False;
    btnNavRBAC.Visible     := False;
    btnNavAudit.Visible    := False;

    // Menu Bar sync: Tampilkan transaksi, sembunyikan sistem/keamanan
    mnuTransaksi.Visible    := CanViewPolicy or CanViewCust;
    mnuPolicy.Visible       := CanViewPolicy;
    mnuCust.Visible         := CanViewCust;

    mnuUnderwriting.Visible := CanViewUW;
    mnuUWQueue.Visible      := CanViewUW;

    mnuSistem.Visible       := False;
    mnuRBAC.Visible         := False;
    mnuAudit.Visible        := False;

    // Quick action buttons on Home Dashboard
    btnQuickNewSPAJ.Enabled := dmSecurity.HasPermission(PERM_POL_CREATE_DRAFT);
    btnQuickUW.Enabled      := CanViewUW;
    btnQuickCust.Enabled    := dmSecurity.HasPermission(PERM_CUST_MANAGE);

    // Realign buttons
    RealignNavButtons;

    // Buka Dashboard Operasional untuk non-admin
    ShowDashboardHome;
  end;
end;

procedure TfrmMain.UpdateDashboardKPIs;
var
  Qry: TADOQuery;
begin
  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := dmConnection.Connection;
    Qry.SQL.Text :=
      'SELECT status_polis, COUNT(*) AS jml ' +
      'FROM polis_header ' +
      'GROUP BY status_polis';
    Qry.Open;

    lblCountDraft.Caption     := '0';
    lblCountSubmitted.Caption := '0';
    lblCountInforce.Caption   := '0';
    lblCountRejected.Caption  := '0';

    while not Qry.Eof do
    begin
      if Qry.FieldByName('status_polis').AsString = POL_STATUS_DRAFT then
        lblCountDraft.Caption := Qry.FieldByName('jml').AsString
      else if Qry.FieldByName('status_polis').AsString = POL_STATUS_SUBMITTED then
        lblCountSubmitted.Caption := Qry.FieldByName('jml').AsString
      else if Qry.FieldByName('status_polis').AsString = POL_STATUS_INFORCE then
        lblCountInforce.Caption := Qry.FieldByName('jml').AsString
      else if Qry.FieldByName('status_polis').AsString = POL_STATUS_REJECTED then
        lblCountRejected.Caption := Qry.FieldByName('jml').AsString;
      Qry.Next;
    end;
  finally
    Qry.Free;
  end;
end;

procedure TfrmMain.UpdateSysInfoCard;
var
  Lines: TStringList;
begin
  lblInfoUser.Caption   := Format('Petugas Login : %s (%s)', [dmSecurity.CurrentFullName, dmSecurity.CurrentUserName]);
  lblInfoNIP.Caption    := Format('Nomor Induk Pegawai (NIP) : %s', [dmSecurity.CurrentNIP]);
  lblInfoRole.Caption   := Format('Peran Otorisasi (RBAC) : %s [%s]', [dmSecurity.ActiveRoleName, dmSecurity.ActiveRoleCode]);
  lblInfoServer.Caption := Format('Koneksi Database : Microsoft SQL Server (%s)', [dmConnection.GetServerInfo]);

  // Card Left: Active Permissions
  Lines := TStringList.Create;
  try
    Lines.Add('Daftar Hak Akses Sesi Ini:');
    Lines.Add('----------------------------------------------------');
    if dmSecurity.HasPermission(PERM_POL_CREATE_DRAFT) then
      Lines.Add('[✓] Diizinkan membuat draft SPAJ baru & memilih rider.')
    else
      Lines.Add('[✗] Dibatasi: Tidak memiliki izin buat SPAJ baru.');

    if dmSecurity.HasPermission(PERM_POL_SUBMIT_UW) then
      Lines.Add('[✓] Diizinkan mengajukan SPAJ ke Underwriting.')
    else
      Lines.Add('[✗] Dibatasi: Pengajuan SPAJ ke Underwriting ditutup.');

    if dmSecurity.HasPermission(PERM_UW_APPROVE) then
      Lines.Add('[✓] Diizinkan otorisasi persetujuan polis (INFORCE).')
    else
      Lines.Add('[✗] Dibatasi: Tidak memiliki izin persetujuan polis.');

    if dmSecurity.HasPermission(PERM_UW_REJECT) then
      Lines.Add('[✓] Diizinkan menolak permohonan asuransi (REJECT).')
    else
      Lines.Add('[✗] Dibatasi: Tidak memiliki izin penolakan polis.');

    if dmSecurity.HasPermission(PERM_CUST_MANAGE) then
      Lines.Add('[✓] Diizinkan mengelola data nasabah CIF Bank Codina.')
    else
      Lines.Add('[✗] Dibatasi: Akses edit nasabah CIF dibatasi.');

    if dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES) then
      Lines.Add('[✓] Akses penuh ke Matriks Hak Akses RBAC.')
    else
      Lines.Add('[✗] Dibatasi: Konfigurasi RBAC hanya untuk Admin.');

    if dmSecurity.HasPermission(PERM_SEC_VIEW_AUDIT) then
      Lines.Add('[✓] Diizinkan memeriksa Audit Trail Forensik.')
    else
      Lines.Add('[✗] Dibatasi: Audit trail hanya untuk Auditor/Admin.');

    memPermList.Lines.Assign(Lines);
  finally
    Lines.Free;
  end;

  // Card Right: Workflow Guide
  Lines := TStringList.Create;
  try
    Lines.Add('Tahapan Uji Coba Maker-Checker OJK:');
    Lines.Add('----------------------------------------------------');
    Lines.Add('1. BERALIH KE PERAN MAKER:');
    Lines.Add('   - Klik [Ganti Sesi Pengguna]');
    Lines.Add('   - Login: maker1  |  Password: password123');
    Lines.Add('   - Buka menu Administrasi Polis -> [+ Buat SPAJ Baru]');
    Lines.Add('   - Simpan draft dan klik [Ajukan ke Underwriting]');
    Lines.Add('');
    Lines.Add('2. UJI COBA BLOKIR DUAL CONTROL:');
    Lines.Add('   - Tetap sebagai maker1, coba buka antrean Underwriting.');
    Lines.Add('   - Tombol persetujuan (Approve) terkunci/dinonaktifkan.');
    Lines.Add('   - Sistem mencegah Maker menyetujui SPAJ-nya sendiri!');
    Lines.Add('');
    Lines.Add('3. BERALIH KE PERAN CHECKER:');
    Lines.Add('   - Klik [Ganti Sesi Pengguna]');
    Lines.Add('   - Login: checker1  |  Password: password123');
    Lines.Add('   - Buka menu Antrean Underwriting.');
    Lines.Add('   - Pilih permohonan SPAJ dan klik [Setujui Polis].');
    Lines.Add('   - Status otomatis berubah menjadi INFORCE!');
    Lines.Add('   - Nomor Polis resmi diterbitkan Bank Codina.');
    memQuickWorkflow.Lines.Assign(Lines);
  finally
    Lines.Free;
  end;
end;

procedure TfrmMain.btnNavDashClick(Sender: TObject);
begin
  if (dmSecurity.ActiveRoleCode = ROLE_CODE_ADMIN) or
     dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES) then
  begin
    btnNavRBACClick(nil);
    Exit;
  end;
  ShowDashboardHome;
end;

procedure TfrmMain.btnNavPolicyClick(Sender: TObject);
begin
  if not dmSecurity.HasPermission(PERM_POL_VIEW) then Exit;
  if frmPolicy = nil then
    frmPolicy := TfrmPolicy.Create(Self);
  ShowEmbeddedForm(frmPolicy, 'Administrasi Polis & SPAJ (Master-Detail)', 'Beranda / Bancassurance / Administrasi Polis');
  btnNavPolicy.Down := True;
end;

procedure TfrmMain.btnNavUWClick(Sender: TObject);
begin
  if not dmSecurity.HasPermission(PERM_UW_ACCESS_QUEUE) then Exit;
  if frmUnderwriting = nil then
    frmUnderwriting := TfrmUnderwriting.Create(Self);
  ShowEmbeddedForm(frmUnderwriting, 'Antrean Evaluasi Underwriting (Checker / Dual Control)', 'Beranda / Underwriting / Evaluasi Risiko & Otorisasi');
  btnNavUW.Down := True;
end;

procedure TfrmMain.btnNavCustomerClick(Sender: TObject);
begin
  if not dmSecurity.HasPermission(PERM_CUST_VIEW) then Exit;
  if frmCustomer = nil then
    frmCustomer := TfrmCustomer.Create(Self);
  ShowEmbeddedForm(frmCustomer, 'Database Master Data Nasabah (CIF)', 'Beranda / Master Data / Nasabah CIF Bancassurance');
  btnNavCustomer.Down := True;
end;

procedure TfrmMain.btnNavRBACClick(Sender: TObject);
begin
  if not dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES) then Exit;
  if frmUserRole = nil then
    frmUserRole := TfrmUserRole.Create(Self);
  frmUserRole.pcSecurity.ActivePage := frmUserRole.tsMatrix;
  ShowEmbeddedForm(frmUserRole, 'Pusat Keamanan & Matriks Hak Akses RBAC', 'Beranda / Pengaturan / Matriks Akses RBAC');
  btnNavRBAC.Down := True;
end;

procedure TfrmMain.btnNavAuditClick(Sender: TObject);
begin
  if not dmSecurity.HasPermission(PERM_SEC_VIEW_AUDIT) then Exit;
  if frmUserRole = nil then
    frmUserRole := TfrmUserRole.Create(Self);
  frmUserRole.pcSecurity.ActivePage := frmUserRole.tsAudit;
  ShowEmbeddedForm(frmUserRole, 'Pencatatan Audit Trail Forensik', 'Beranda / Audit / Jejak Rekam Transaksi & Forensik');
  btnNavAudit.Down := True;
end;

procedure TfrmMain.btnNavSwitchClick(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(Self);
  try
    if frmLogin.ShowModal = mrOk then
    begin
      RefreshSessionState;
      ShowMessage(Format('Berhasil beralih sesi ke: %s (%s)',
        [dmSecurity.CurrentFullName, dmSecurity.ActiveRoleName]));
    end;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain.btnNavExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnQuickNewSPAJClick(Sender: TObject);
begin
  btnNavPolicyClick(nil);
  if frmPolicy <> nil then
    frmPolicy.btnNewSPAJClick(nil);
end;

procedure TfrmMain.btnQuickUWClick(Sender: TObject);
begin
  btnNavUWClick(nil);
end;

procedure TfrmMain.btnQuickCustClick(Sender: TObject);
begin
  btnNavCustomerClick(nil);
end;

procedure TfrmMain.btnQuickRefreshClick(Sender: TObject);
begin
  UpdateDashboardKPIs;
  UpdateSysInfoCard;
  ShowMessage('Data metrik dashboard berhasil disegarkan!');
end;

procedure TfrmMain.mnuOJKGuideClick(Sender: TObject);
begin
  ShowMessage(
    'PANDUAN KEPATUHAN OJK DUAL CONTROL (FOUR-EYES PRINCIPLE)' + #13#10#13#10 +
    '1. Maker (Petugas Cabang Bancassurance):' + #13#10 +
    '   - Menginput SPAJ calon tertanggung nasabah CIF.' + #13#10 +
    '   - Memilih produk dasar dan rider proteksi.' + #13#10 +
    '   - Mengajukan permohonan ke antrean Underwriting.' + #13#10 +
    '   - DILARANG menyetujui SPAJ yang dibuatnya sendiri.' + #13#10#13#10 +
    '2. Checker (Underwriter Kantor Pusat):' + #13#10 +
    '   - Menganalisis riwayat medis, okupasi, dan risiko finansial.' + #13#10 +
    '   - Menentukan status penerimaan (Approve / Reject).' + #13#10 +
    '   - DILARANG membuat draft SPAJ baru.' + #13#10#13#10 +
    '3. Audit Trail:' + #13#10 +
    '   - Seluruh mutasi terekam forensik pada tabel audit_logs.'
  );
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  ShowMessage(
    'DelphiInsuranceRBAC v1.0.0' + #13#10 +
    'Core Bancassurance Administration System' + #13#10 +
    'Bank Codina - Life Insurance Division' + #13#10#13#10 +
    'Arsitektur: Borland Delphi 7 Native Win32' + #13#10 +
    'Database: Microsoft SQL Server via ADO/dbGo' + #13#10 +
    'Kepatuhan: OJK Dual Control (Maker-Checker) & RBAC'
  );
end;

end.
