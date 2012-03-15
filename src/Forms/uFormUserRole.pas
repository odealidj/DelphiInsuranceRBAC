unit uFormUserRole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, ExtCtrls, ComCtrls, CheckLst,
  uDataConnection, uSecurityModule, uAppConst;

type
  TfrmUserRole = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pcSecurity: TPageControl;
    tsMatrix: TTabSheet;
    pnlRolesLeft: TPanel;
    lblRoleList: TLabel;
    lbRoles: TListBox;
    pnlRoleButtons: TPanel;
    btnAddRole: TButton;
    btnEditRole: TButton;
    btnDeleteRole: TButton;
    pnlTreeRight: TPanel;
    pnlPermTop: TPanel;
    lblRoleActiveTitle: TLabel;
    btnSavePerms: TButton;
    btnSelectAll: TButton;
    btnClearAll: TButton;
    clbPermissions: TCheckListBox;
    tsUsers: TTabSheet;
    dbgUsers: TDBGrid;
    tsAudit: TTabSheet;
    pnlAuditTop: TPanel;
    btnRefreshAudit: TButton;
    dbgAudit: TDBGrid;
    qryUsers: TADOQuery;
    dsUsers: TDataSource;
    qryAudit: TADOQuery;
    dsAudit: TDataSource;
    qryRolePerms: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbRolesClick(Sender: TObject);
    procedure btnAddRoleClick(Sender: TObject);
    procedure btnEditRoleClick(Sender: TObject);
    procedure btnDeleteRoleClick(Sender: TObject);
    procedure btnSavePermsClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnRefreshAuditClick(Sender: TObject);
  private
    FSelectedRoleCode: string;
    procedure LoadRoles;
    procedure LoadRolePermissionsList(ARoleID: Integer);
    procedure LoadUsers;
    procedure LoadAuditTrail;
  public
  end;

var
  frmUserRole: TfrmUserRole;

implementation

{$R *.dfm}

procedure TfrmUserRole.FormCreate(Sender: TObject);
begin
  qryUsers.Connection     := dmConnection.Connection;
  qryAudit.Connection     := dmConnection.Connection;
  qryRolePerms.Connection := dmConnection.Connection;
  FSelectedRoleCode       := '';
end;

procedure TfrmUserRole.FormShow(Sender: TObject);
var
  CanManageRoles, CanViewAudit: Boolean;
begin
  CanManageRoles := dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES);
  CanViewAudit   := dmSecurity.HasPermission(PERM_SEC_VIEW_AUDIT);

  // Tab Visibility & Permissions
  tsMatrix.TabVisible := CanManageRoles;
  tsUsers.TabVisible  := CanManageRoles;
  tsAudit.TabVisible  := CanViewAudit;

  if CanManageRoles then
  begin
    pcSecurity.ActivePage := tsMatrix;
    LoadRoles;
    LoadUsers;
  end
  else if CanViewAudit then
  begin
    pcSecurity.ActivePage := tsAudit;
  end
  else
  begin
    ShowMessage('AKSES DITOLAK: Anda tidak memiliki wewenang pada modul keamanan.');
    Close;
    Exit;
  end;

  if CanViewAudit then
    LoadAuditTrail;
end;

procedure TfrmUserRole.LoadRoles;
var
  Qry: TADOQuery;
  RoleID: Integer;
  RoleCode, RoleName: string;
begin
  lbRoles.Items.BeginUpdate;
  try
    lbRoles.Clear;
    Qry := TADOQuery.Create(nil);
    try
      Qry.Connection := dmConnection.Connection;
      Qry.SQL.Text := 'SELECT id, role_code, role_name, description FROM roles ORDER BY id';
      Qry.Open;
      while not Qry.Eof do
      begin
        RoleID   := Qry.FieldByName('id').AsInteger;
        RoleCode := Qry.FieldByName('role_code').AsString;
        RoleName := Qry.FieldByName('role_name').AsString;

        lbRoles.Items.AddObject(
          Format('%s [%s]', [RoleName, RoleCode]),
          TObject(RoleID)
        );
        Qry.Next;
      end;
    finally
      Qry.Free;
    end;
  finally
    lbRoles.Items.EndUpdate;
  end;

  if lbRoles.Items.Count > 0 then
  begin
    lbRoles.ItemIndex := 0;
    lbRolesClick(nil);
  end
  else
  begin
    clbPermissions.Clear;
    lblRoleActiveTitle.Caption := 'Tidak ada peran yang dipilih';
  end;
end;

procedure TfrmUserRole.lbRolesClick(Sender: TObject);
var
  SelectedRoleID: Integer;
  RoleText: string;
  PosOpen, PosClose: Integer;
begin
  if lbRoles.ItemIndex >= 0 then
  begin
    SelectedRoleID := Integer(lbRoles.Items.Objects[lbRoles.ItemIndex]);
    RoleText := lbRoles.Items[lbRoles.ItemIndex];
    lblRoleActiveTitle.Caption := 'Mengatur Hak Akses: ' + RoleText;

    // Parse role_code from "Role Name [ROLE_CODE]"
    PosOpen  := Pos('[', RoleText);
    PosClose := Pos(']', RoleText);
    if (PosOpen > 0) and (PosClose > PosOpen) then
      FSelectedRoleCode := Copy(RoleText, PosOpen + 1, PosClose - PosOpen - 1)
    else
      FSelectedRoleCode := '';

    LoadRolePermissionsList(SelectedRoleID);
  end;
end;

procedure TfrmUserRole.LoadRolePermissionsList(ARoleID: Integer);
var
  QryAllPerms, QryActivePerms: TADOQuery;
  ActivePermList: TStringList;
  PermID, Idx: Integer;
  ModuleGroup, PermCode, PermName, ItemStr: string;
begin
  clbPermissions.Items.BeginUpdate;
  try
    clbPermissions.Clear;
    ActivePermList := TStringList.Create;
    QryAllPerms    := TADOQuery.Create(nil);
    QryActivePerms := TADOQuery.Create(nil);
    try
      QryAllPerms.Connection    := dmConnection.Connection;
      QryActivePerms.Connection := dmConnection.Connection;

      // Ambil izin yang saat ini aktif untuk role terpilih
      QryActivePerms.SQL.Text :=
        'SELECT permission_id FROM role_permissions WHERE role_id = :rid';
      QryActivePerms.Parameters.ParamByName('rid').Value := ARoleID;
      QryActivePerms.Open;
      while not QryActivePerms.Eof do
      begin
        ActivePermList.Add(QryActivePerms.FieldByName('permission_id').AsString);
        QryActivePerms.Next;
      end;
      QryActivePerms.Close;

      // Ambil seluruh master permission
      QryAllPerms.SQL.Text :=
        'SELECT id, module_group, perm_code, perm_name, description ' +
        'FROM permissions ' +
        'ORDER BY module_group, perm_code';
      QryAllPerms.Open;

      while not QryAllPerms.Eof do
      begin
        PermID      := QryAllPerms.FieldByName('id').AsInteger;
        ModuleGroup := QryAllPerms.FieldByName('module_group').AsString;
        PermCode    := QryAllPerms.FieldByName('perm_code').AsString;
        PermName    := QryAllPerms.FieldByName('perm_name').AsString;

        ItemStr := Format('[%s]  %s - %s', [ModuleGroup, PermCode, PermName]);
        Idx := clbPermissions.Items.AddObject(ItemStr, TObject(PermID));

        // Centang jika role memiliki izin ini
        clbPermissions.Checked[Idx] := (ActivePermList.IndexOf(IntToStr(PermID)) >= 0);

        QryAllPerms.Next;
      end;
    finally
      QryAllPerms.Free;
      QryActivePerms.Free;
      ActivePermList.Free;
    end;
  finally
    clbPermissions.Items.EndUpdate;
  end;
end;

procedure TfrmUserRole.btnAddRoleClick(Sender: TObject);
var
  NewCode, NewName: string;
  Qry: TADOQuery;
  NewID: Integer;
begin
  if not dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES) then Exit;

  NewCode := UpperCase(Trim(InputBox('Tambah Role Baru', 'Masukkan Kode Role (misal: SUPERVISOR):', '')));
  if NewCode = '' then Exit;

  NewName := Trim(InputBox('Tambah Role Baru', 'Masukkan Nama Lengkap Role (misal: Supervisor Operasional):', ''));
  if NewName = '' then Exit;

  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := dmConnection.Connection;

    // Validasi apakah kode sudah digunakan
    Qry.SQL.Text := 'SELECT COUNT(*) AS cnt FROM roles WHERE role_code = :rcode';
    Qry.Parameters.ParamByName('rcode').Value := NewCode;
    Qry.Open;
    if Qry.FieldByName('cnt').AsInteger > 0 then
    begin
      ShowMessage(Format('Kode Role "%s" sudah ada di database. Silakan gunakan kode lain.', [NewCode]));
      Exit;
    end;
    Qry.Close;

    // Simpan role baru
    Qry.SQL.Text :=
      'INSERT INTO roles (role_code, role_name, description, is_active, created_at) ' +
      'VALUES (:rcode, :rname, :rdesc, 1, GETDATE())';
    Qry.Parameters.ParamByName('rcode').Value := NewCode;
    Qry.Parameters.ParamByName('rname').Value := NewName;
    Qry.Parameters.ParamByName('rdesc').Value := 'Dibuat oleh administrator: ' + dmSecurity.CurrentUserName;
    Qry.ExecSQL;

    // Dapatkan ID
    Qry.SQL.Text := 'SELECT id FROM roles WHERE role_code = :rcode';
    Qry.Parameters.ParamByName('rcode').Value := NewCode;
    Qry.Open;
    NewID := Qry.FieldByName('id').AsInteger;

    dmSecurity.LogAudit('CREATE_ROLE', 'roles', IntToStr(NewID),
      Format('Membuat peran baru: %s [%s]', [NewName, NewCode]));

    ShowMessage(Format('Peran "%s" [%s] berhasil dibuat! Silakan tentukan hak aksesnya.', [NewName, NewCode]));
    LoadRoles;

    // Pilih role baru di ListBox
    lbRoles.ItemIndex := lbRoles.Items.IndexOfObject(TObject(NewID));
    if lbRoles.ItemIndex >= 0 then
      lbRolesClick(nil);
  finally
    Qry.Free;
  end;
end;

procedure TfrmUserRole.btnEditRoleClick(Sender: TObject);
var
  SelectedRoleID: Integer;
  CurName, NewName: string;
  Qry: TADOQuery;
begin
  if not dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES) then Exit;
  if lbRoles.ItemIndex < 0 then Exit;

  SelectedRoleID := Integer(lbRoles.Items.Objects[lbRoles.ItemIndex]);

  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := dmConnection.Connection;
    Qry.SQL.Text := 'SELECT role_name FROM roles WHERE id = :rid';
    Qry.Parameters.ParamByName('rid').Value := SelectedRoleID;
    Qry.Open;
    CurName := Qry.FieldByName('role_name').AsString;
    Qry.Close;

    NewName := Trim(InputBox('Ubah Nama Role', 'Nama Peran / Jabatan:', CurName));
    if (NewName = '') or (NewName = CurName) then Exit;

    Qry.SQL.Text := 'UPDATE roles SET role_name = :rname WHERE id = :rid';
    Qry.Parameters.ParamByName('rname').Value := NewName;
    Qry.Parameters.ParamByName('rid').Value   := SelectedRoleID;
    Qry.ExecSQL;

    dmSecurity.LogAudit('UPDATE_ROLE', 'roles', IntToStr(SelectedRoleID),
      Format('Mengubah nama peran ID %d dari "%s" menjadi "%s"', [SelectedRoleID, CurName, NewName]));

    ShowMessage('Nama peran berhasil diperbarui!');
    LoadRoles;
  finally
    Qry.Free;
  end;
end;

procedure TfrmUserRole.btnDeleteRoleClick(Sender: TObject);
var
  SelectedRoleID, UserCount: Integer;
  RoleName: string;
  Qry: TADOQuery;
begin
  if not dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES) then Exit;
  if lbRoles.ItemIndex < 0 then Exit;

  SelectedRoleID := Integer(lbRoles.Items.Objects[lbRoles.ItemIndex]);
  RoleName       := lbRoles.Items[lbRoles.ItemIndex];

  // 1. Proteksi Sistem: Role inti perbankan tidak boleh dihapus
  if (FSelectedRoleCode = ROLE_CODE_ADMIN) or
     (FSelectedRoleCode = ROLE_CODE_MAKER) or
     (FSelectedRoleCode = ROLE_CODE_CHECKER) then
  begin
    ShowMessage(Format(
      'PERLINDUNGAN SISTEM OJK DUAL CONTROL:'#13#10 +
      'Peran inti [%s] dilindungi dan tidak dapat dihapus!', [FSelectedRoleCode]));
    Exit;
  end;

  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := dmConnection.Connection;

    // 2. Proteksi Integritas: Cek apakah masih ada user yang memakai role ini
    Qry.SQL.Text := 'SELECT COUNT(*) AS cnt FROM user_roles WHERE role_id = :rid';
    Qry.Parameters.ParamByName('rid').Value := SelectedRoleID;
    Qry.Open;
    UserCount := Qry.FieldByName('cnt').AsInteger;
    Qry.Close;

    if UserCount > 0 then
    begin
      ShowMessage(Format(
        'TIDAK DAPAT DIHAPUS:'#13#10 +
        'Peran ini masih ditugaskan kepada %d pengguna aktif.'#13#10 +
        'Silakan alihkan peran pengguna tersebut terlebih dahulu.', [UserCount]));
      Exit;
    end;

    // 3. Konfirmasi penghapusan
    if MessageDlg(Format('Apakah Anda yakin ingin menghapus peran "%s" secara permanen?', [RoleName]),
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

    // Hapus relasi izin & peran
    Qry.SQL.Text := 'DELETE FROM role_permissions WHERE role_id = :rid';
    Qry.Parameters.ParamByName('rid').Value := SelectedRoleID;
    Qry.ExecSQL;

    Qry.SQL.Text := 'DELETE FROM roles WHERE id = :rid';
    Qry.Parameters.ParamByName('rid').Value := SelectedRoleID;
    Qry.ExecSQL;

    dmSecurity.LogAudit('DELETE_ROLE', 'roles', IntToStr(SelectedRoleID),
      Format('Menghapus peran: %s', [RoleName]));

    ShowMessage('Peran berhasil dihapus.');
    LoadRoles;
  finally
    Qry.Free;
  end;
end;

procedure TfrmUserRole.btnSavePermsClick(Sender: TObject);
var
  SelectedRoleID, PermID, i, TotalGranted: Integer;
  Qry: TADOQuery;
begin
  if not dmSecurity.HasPermission(PERM_SEC_MANAGE_ROLES) then Exit;
  if lbRoles.ItemIndex < 0 then Exit;

  SelectedRoleID := Integer(lbRoles.Items.Objects[lbRoles.ItemIndex]);

  Qry := TADOQuery.Create(nil);
  try
    Qry.Connection := dmConnection.Connection;

    dmConnection.Connection.BeginTrans;
    try
      // Hapus izin lama
      Qry.SQL.Text := 'DELETE FROM role_permissions WHERE role_id = :rid';
      Qry.Parameters.ParamByName('rid').Value := SelectedRoleID;
      Qry.ExecSQL;

      // Masukkan seluruh izin yang dicentang
      TotalGranted := 0;
      Qry.SQL.Text :=
        'INSERT INTO role_permissions (role_id, permission_id, granted_at, granted_by) ' +
        'VALUES (:rid, :pid, GETDATE(), :gby)';

      for i := 0 to clbPermissions.Items.Count - 1 do
      begin
        if clbPermissions.Checked[i] then
        begin
          PermID := Integer(clbPermissions.Items.Objects[i]);
          Qry.Parameters.ParamByName('rid').Value := SelectedRoleID;
          Qry.Parameters.ParamByName('pid').Value := PermID;
          Qry.Parameters.ParamByName('gby').Value := dmSecurity.CurrentUserID;
          Qry.ExecSQL;
          Inc(TotalGranted);
        end;
      end;

      dmConnection.Connection.CommitTrans;
    except
      dmConnection.Connection.RollbackTrans;
      raise;
    end;

    dmSecurity.LogAudit('UPDATE_PERMS', 'role_permissions', IntToStr(SelectedRoleID),
      Format('Menetapkan %d izin pada peran ID %d (%s)',
        [TotalGranted, SelectedRoleID, lbRoles.Items[lbRoles.ItemIndex]]));

    // Reload permissions jika admin mengubah role-nya sendiri
    dmSecurity.ReloadCurrentPermissions;

    ShowMessage(Format(
      'Hak akses berhasil diperbarui!'#13#10 +
      'Total %d izin aktif disimpan untuk peran: %s',
      [TotalGranted, lbRoles.Items[lbRoles.ItemIndex]]));
  finally
    Qry.Free;
  end;
end;

procedure TfrmUserRole.btnSelectAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to clbPermissions.Items.Count - 1 do
    clbPermissions.Checked[i] := True;
end;

procedure TfrmUserRole.btnClearAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to clbPermissions.Items.Count - 1 do
    clbPermissions.Checked[i] := False;
end;

procedure TfrmUserRole.LoadUsers;
begin
  qryUsers.Close;
  qryUsers.SQL.Text :=
    'SELECT u.id AS [ID], ' +
    '       u.username AS [Username], ' +
    '       u.full_name AS [Nama Lengkap], ' +
    '       ISNULL(u.nip, ''-'') AS [NIP], ' +
    '       ISNULL(u.email, ''-'') AS [Email], ' +
    '       ISNULL(r.role_name, ''(Belum Ditugaskan)'') AS [Peran Aktif], ' +
    '       CASE WHEN u.is_active = 1 THEN ''Aktif'' ELSE ''Non-Aktif'' END AS [Status], ' +
    '       u.created_at AS [Dibuat Pada] ' +
    'FROM users u ' +
    'LEFT JOIN user_roles ur ON u.id = ur.user_id ' +
    'LEFT JOIN roles r ON ur.role_id = r.id ' +
    'ORDER BY u.id';
  qryUsers.Open;
end;

procedure TfrmUserRole.LoadAuditTrail;
begin
  qryAudit.Close;
  qryAudit.SQL.Text :=
    'SELECT TOP 200 a.id AS [ID], ' +
    '       a.created_at AS [Waktu Audit], ' +
    '       ISNULL(u.username, ''SYSTEM'') AS [Pengguna], ' +
    '       a.action_name AS [Aktivitas], ' +
    '       ISNULL(a.table_name, ''-'') AS [Tabel], ' +
    '       ISNULL(a.record_id, ''-'') AS [ID Record], ' +
    '       a.log_detail AS [Rincian Forensik] ' +
    'FROM audit_logs a ' +
    'LEFT JOIN users u ON a.user_id = u.id ' +
    'ORDER BY a.id DESC';
  qryAudit.Open;
end;

procedure TfrmUserRole.btnRefreshAuditClick(Sender: TObject);
begin
  LoadAuditTrail;
end;

end.
