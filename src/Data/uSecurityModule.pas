unit uSecurityModule;

interface

uses
  SysUtils, Classes, DB, ADODB, ActnList, Variants, uDataConnection, uMD5, uAppConst;

type
  TdmSecurity = class(TDataModule)
    qryAuth: TADOQuery;
    qryPerm: TADOQuery;
    qryAudit: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FCurrentUserID: Integer;
    FCurrentUserName: string;
    FCurrentFullName: string;
    FCurrentNIP: string;
    FCurrentEmail: string;
    FActiveRoleID: Integer;
    FActiveRoleCode: string;
    FActiveRoleName: string;
    FIsLoggedIn: Boolean;
    FPermissions: TStringList;
    FUserRoles: TStringList; // Objects holds RoleID as Pointer(RoleID)

    procedure LoadUserRoles(AUserID: Integer);
    procedure LoadRolePermissions(ARoleID: Integer);
  public
    function Authenticate(const AUsername, APassword: string): Boolean;
    procedure Logout;
    function HasPermission(const APermCode: string): Boolean;
    procedure SetActiveRole(const ARoleCode: string);
    procedure ReloadCurrentPermissions;
    procedure ApplySecurityToActions(AActionList: TActionList);
    procedure LogAudit(const AActionName, ATableName, ARecordID, ADetail: string);

    property IsLoggedIn: Boolean read FIsLoggedIn;
    property CurrentUserID: Integer read FCurrentUserID;
    property CurrentUserName: string read FCurrentUserName;
    property CurrentFullName: string read FCurrentFullName;
    property CurrentNIP: string read FCurrentNIP;
    property CurrentEmail: string read FCurrentEmail;
    property ActiveRoleID: Integer read FActiveRoleID;
    property ActiveRoleCode: string read FActiveRoleCode;
    property ActiveRoleName: string read FActiveRoleName;
    property UserRoles: TStringList read FUserRoles;
    property Permissions: TStringList read FPermissions;
  end;

var
  dmSecurity: TdmSecurity;

implementation

{$R *.dfm}

procedure TdmSecurity.DataModuleCreate(Sender: TObject);
begin
  FPermissions := TStringList.Create;
  FPermissions.Sorted := True;
  FPermissions.Duplicates := dupIgnore;

  FUserRoles := TStringList.Create;

  qryAuth.Connection := dmConnection.Connection;
  qryPerm.Connection := dmConnection.Connection;
  qryAudit.Connection := dmConnection.Connection;

  FIsLoggedIn := False;
  FCurrentUserID := 0;
end;

procedure TdmSecurity.DataModuleDestroy(Sender: TObject);
begin
  FPermissions.Free;
  FUserRoles.Free;
end;

function TdmSecurity.Authenticate(const AUsername, APassword: string): Boolean;
var
  Hash: string;
begin
  Result := False;
  Hash := MD5String(APassword);

  qryAuth.Close;
  qryAuth.SQL.Text :=
    'SELECT id, username, full_name, nip, email, is_active ' +
    'FROM users ' +
    'WHERE username = :uname AND password_hash = :pwhash AND is_active = 1';
  qryAuth.Parameters.ParamByName('uname').Value := AUsername;
  qryAuth.Parameters.ParamByName('pwhash').Value := Hash;
  qryAuth.Open;

  if not qryAuth.IsEmpty then
  begin
    FCurrentUserID   := qryAuth.FieldByName('id').AsInteger;
    FCurrentUserName := qryAuth.FieldByName('username').AsString;
    FCurrentFullName := qryAuth.FieldByName('full_name').AsString;
    FCurrentNIP      := qryAuth.FieldByName('nip').AsString;
    FCurrentEmail    := qryAuth.FieldByName('email').AsString;
    FIsLoggedIn      := True;

    LoadUserRoles(FCurrentUserID);

    if FUserRoles.Count > 0 then
      SetActiveRole(FUserRoles[0]);

    LogAudit('USER_LOGIN', 'users', IntToStr(FCurrentUserID),
      Format('Login berhasil oleh pengguna %s (%s)', [FCurrentUserName, FCurrentFullName]));
    Result := True;
  end;
  qryAuth.Close;
end;

procedure TdmSecurity.Logout;
begin
  if FIsLoggedIn then
  begin
    LogAudit('USER_LOGOUT', 'users', IntToStr(FCurrentUserID),
      Format('Logout pengguna %s', [FCurrentUserName]));
  end;

  FIsLoggedIn := False;
  FCurrentUserID := 0;
  FCurrentUserName := '';
  FCurrentFullName := '';
  FCurrentNIP := '';
  FCurrentEmail := '';
  FActiveRoleID := 0;
  FActiveRoleCode := '';
  FActiveRoleName := '';
  FPermissions.Clear;
  FUserRoles.Clear;
end;

procedure TdmSecurity.LoadUserRoles(AUserID: Integer);
begin
  FUserRoles.Clear;
  qryAuth.Close;
  qryAuth.SQL.Text :=
    'SELECT r.id, r.role_code, r.role_name ' +
    'FROM user_roles ur ' +
    'INNER JOIN roles r ON ur.role_id = r.id ' +
    'WHERE ur.user_id = :uid AND r.is_active = 1 ' +
    'ORDER BY r.id';
  qryAuth.Parameters.ParamByName('uid').Value := AUserID;
  qryAuth.Open;

  while not qryAuth.Eof do
  begin
    // Store role_code as string, and RoleID as Object integer pointer
    FUserRoles.AddObject(qryAuth.FieldByName('role_code').AsString,
      TObject(qryAuth.FieldByName('id').AsInteger));
    qryAuth.Next;
  end;
  qryAuth.Close;
end;

procedure TdmSecurity.SetActiveRole(const ARoleCode: string);
var
  Idx: Integer;
begin
  Idx := FUserRoles.IndexOf(ARoleCode);
  if Idx >= 0 then
  begin
    FActiveRoleCode := ARoleCode;
    FActiveRoleID   := Integer(FUserRoles.Objects[Idx]);

    // Ambil nama lengkap role
    qryAuth.Close;
    qryAuth.SQL.Text := 'SELECT role_name FROM roles WHERE id = :rid';
    qryAuth.Parameters.ParamByName('rid').Value := FActiveRoleID;
    qryAuth.Open;
    if not qryAuth.IsEmpty then
      FActiveRoleName := qryAuth.FieldByName('role_name').AsString;
    qryAuth.Close;

    LoadRolePermissions(FActiveRoleID);

    LogAudit('SWITCH_ROLE', 'roles', IntToStr(FActiveRoleID),
      Format('Pengguna %s beralih ke sesi peran %s (%s)', [FCurrentUserName, FActiveRoleCode, FActiveRoleName]));
  end;
end;

procedure TdmSecurity.ReloadCurrentPermissions;
begin
  if FIsLoggedIn and (FActiveRoleID > 0) then
    LoadRolePermissions(FActiveRoleID);
end;

procedure TdmSecurity.LoadRolePermissions(ARoleID: Integer);
begin
  FPermissions.Clear;
  qryPerm.Close;
  qryPerm.SQL.Text :=
    'SELECT p.perm_code ' +
    'FROM role_permissions rp ' +
    'INNER JOIN permissions p ON rp.permission_id = p.id ' +
    'WHERE rp.role_id = :rid';
  qryPerm.Parameters.ParamByName('rid').Value := ARoleID;
  qryPerm.Open;

  while not qryPerm.Eof do
  begin
    FPermissions.Add(qryPerm.FieldByName('perm_code').AsString);
    qryPerm.Next;
  end;
  qryPerm.Close;
end;

function TdmSecurity.HasPermission(const APermCode: string): Boolean;
begin
  // Admin selalu memiliki hak akses penuh, atau periksa permission list
  if FActiveRoleCode = ROLE_CODE_ADMIN then
    Result := True
  else
    Result := (FPermissions.IndexOf(APermCode) >= 0);
end;

procedure TdmSecurity.ApplySecurityToActions(AActionList: TActionList);
var
  i: Integer;
  Action: TAction;
  PermCode: string;
  Allowed: Boolean;
begin
  if AActionList = nil then Exit;

  for i := 0 to AActionList.ActionCount - 1 do
  begin
    if AActionList.Actions[i] is TAction then
    begin
      Action := TAction(AActionList.Actions[i]);
      PermCode := Action.Category;
      if PermCode <> '' then
      begin
        Allowed := HasPermission(PermCode);
        Action.Enabled := Allowed;
        Action.Visible := Allowed;
      end;
    end;
  end;
end;

procedure TdmSecurity.LogAudit(const AActionName, ATableName, ARecordID, ADetail: string);
begin
  try
    qryAudit.Close;
    qryAudit.SQL.Text :=
      'INSERT INTO audit_logs (user_id, action_name, table_name, record_id, log_detail, created_at) ' +
      'VALUES (:uid, :act, :tbl, :rec, :det, GETDATE())';
    if FCurrentUserID > 0 then
      qryAudit.Parameters.ParamByName('uid').Value := FCurrentUserID
    else
      qryAudit.Parameters.ParamByName('uid').Value := Null;
    qryAudit.Parameters.ParamByName('act').Value := AActionName;
    qryAudit.Parameters.ParamByName('tbl').Value := ATableName;
    qryAudit.Parameters.ParamByName('rec').Value := ARecordID;
    qryAudit.Parameters.ParamByName('det').Value := ADetail;
    qryAudit.ExecSQL;
  except
    // Log audit fail-safe: tidak menghentikan aplikasi utama jika ada gangguan
  end;
end;

end.
