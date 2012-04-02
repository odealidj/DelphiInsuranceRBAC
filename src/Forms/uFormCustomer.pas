unit uFormCustomer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, ExtCtrls, ComCtrls,
  uDataConnection, uSecurityModule, uAppConst;

type
  TfrmCustomer = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    pnlClient: TPanel;
    splCustomer: TSplitter;
    pnlLeft: TPanel;
    dbgNasabah: TDBGrid;
    pnlSearch: TPanel;
    lblSearch: TLabel;
    edtSearch: TEdit;
    btnRefresh: TButton;
    pnlRight: TPanel;
    lblCIF: TLabel;
    lblNama: TLabel;
    lblKTP: TLabel;
    lblTglLahir: TLabel;
    lblGender: TLabel;
    lblPekerjaan: TLabel;
    lblKelas: TLabel;
    lblTelepon: TLabel;
    lblAlamat: TLabel;
    edtCIF: TEdit;
    edtNama: TEdit;
    edtKTP: TEdit;
    dtpTglLahir: TDateTimePicker;
    cmbGender: TComboBox;
    edtPekerjaan: TEdit;
    cmbKelas: TComboBox;
    edtTelepon: TEdit;
    memAlamat: TMemo;
    btnNew: TButton;
    btnSave: TButton;
    btnClose: TButton;
    lblMsg: TLabel;
    qryNasabah: TADOQuery;
    dsNasabah: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure dbgNasabahCellClick(Column: TColumn);
    procedure btnNewClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FSelectedID: Integer;
    FIsNewMode: Boolean;
    procedure LoadNasabah(const AKeyword: string);
    procedure SyncFormFields;
    procedure ClearFields;
    procedure ApplySecurity;
    procedure AdjustLayout;
  public
  end;

var
  frmCustomer: TfrmCustomer;

implementation

{$R *.dfm}

procedure TfrmCustomer.FormCreate(Sender: TObject);
begin
  qryNasabah.Connection := dmConnection.Connection;
  FSelectedID := 0;
  FIsNewMode  := False;
end;

procedure TfrmCustomer.FormShow(Sender: TObject);
begin
  ApplySecurity;
  LoadNasabah('');
  AdjustLayout;
end;

procedure TfrmCustomer.FormResize(Sender: TObject);
begin
  AdjustLayout;
end;

procedure TfrmCustomer.AdjustLayout;
var
  DesiredLeftW, InputW, AvailH: Integer;
begin
  // Lebar panel tabel nasabah proporsional saat maximize (sekitar 52%, min 420, max 850)
  DesiredLeftW := (pnlClient.ClientWidth * 52) div 100;
  if DesiredLeftW < 420 then DesiredLeftW := 420;
  if DesiredLeftW > 850 then DesiredLeftW := 850;
  pnlLeft.Width := DesiredLeftW;

  // Search box dan refresh button
  btnRefresh.Left := pnlSearch.ClientWidth - btnRefresh.Width - 10;
  edtSearch.Width := btnRefresh.Left - edtSearch.Left - 10;

  // Lebar kolom input CIF & data nasabah
  InputW := pnlRight.ClientWidth - edtCIF.Left - 30;
  if InputW < 220 then InputW := 220;
  if InputW > 550 then InputW := 550;

  edtCIF.Width       := InputW;
  edtNama.Width      := InputW;
  edtKTP.Width       := InputW;
  dtpTglLahir.Width  := InputW;
  cmbGender.Width    := InputW;
  edtPekerjaan.Width := InputW;
  cmbKelas.Width     := InputW;
  edtTelepon.Width   := InputW;
  memAlamat.Width    := InputW;

  // Ketinggian memo alamat dan penempatan tombol
  AvailH := pnlRight.ClientHeight - memAlamat.Top - 65;
  if AvailH > 60 then
  begin
    if AvailH > 160 then AvailH := 160;
    memAlamat.Height := AvailH;
  end;

  btnNew.Top   := memAlamat.Top + memAlamat.Height + 16;
  btnSave.Top  := btnNew.Top;
  btnClose.Top := btnNew.Top;
  lblMsg.Top   := btnNew.Top + btnNew.Height + 8;
end;

procedure TfrmCustomer.ApplySecurity;
var
  CanManage: Boolean;
begin
  CanManage := dmSecurity.HasPermission(PERM_CUST_MANAGE);
  btnNew.Enabled  := CanManage;
  btnSave.Enabled := CanManage;

  if not CanManage then
    lblMsg.Caption := 'Akses Read-Only: Anda hanya memiliki izin melihat data nasabah.'
  else
    lblMsg.Caption := 'Mode Kelola Nasabah aktif.';
end;

procedure TfrmCustomer.LoadNasabah(const AKeyword: string);
begin
  qryNasabah.Close;
  if Trim(AKeyword) = '' then
  begin
    qryNasabah.SQL.Text :=
      'SELECT id, no_cif, nama_lengkap, no_identitas, tgl_lahir, jenis_kelamin, ' +
      '       pekerjaan, kelas_pekerjaan, no_telepon, alamat ' +
      'FROM nasabah ORDER BY id DESC';
  end
  else
  begin
    qryNasabah.SQL.Text :=
      'SELECT id, no_cif, nama_lengkap, no_identitas, tgl_lahir, jenis_kelamin, ' +
      '       pekerjaan, kelas_pekerjaan, no_telepon, alamat ' +
      'FROM nasabah ' +
      'WHERE nama_lengkap LIKE :kw OR no_cif LIKE :kw OR no_identitas LIKE :kw ' +
      'ORDER BY id DESC';
    qryNasabah.Parameters.ParamByName('kw').Value := '%' + Trim(AKeyword) + '%';
  end;
  qryNasabah.Open;

  SyncFormFields;
end;

procedure TfrmCustomer.SyncFormFields;
begin
  if not qryNasabah.IsEmpty then
  begin
    FSelectedID := qryNasabah.FieldByName('id').AsInteger;
    FIsNewMode  := False;

    edtCIF.Text       := qryNasabah.FieldByName('no_cif').AsString;
    edtNama.Text      := qryNasabah.FieldByName('nama_lengkap').AsString;
    edtKTP.Text       := qryNasabah.FieldByName('no_identitas').AsString;
    dtpTglLahir.Date  := qryNasabah.FieldByName('tgl_lahir').AsDateTime;

    if qryNasabah.FieldByName('jenis_kelamin').AsString = 'P' then
      cmbGender.ItemIndex := 1
    else
      cmbGender.ItemIndex := 0;

    edtPekerjaan.Text := qryNasabah.FieldByName('pekerjaan').AsString;

    case qryNasabah.FieldByName('kelas_pekerjaan').AsInteger of
      2: cmbKelas.ItemIndex := 1;
      3: cmbKelas.ItemIndex := 2;
      4: cmbKelas.ItemIndex := 3;
      else cmbKelas.ItemIndex := 0;
    end;

    edtTelepon.Text   := qryNasabah.FieldByName('no_telepon').AsString;
    memAlamat.Text    := qryNasabah.FieldByName('alamat').AsString;
  end
  else
  begin
    ClearFields;
  end;
end;

procedure TfrmCustomer.ClearFields;
var
  RandCIF: Integer;
begin
  FSelectedID := 0;
  FIsNewMode  := True;

  Randomize;
  RandCIF := Random(900000) + 100000;
  edtCIF.Text       := Format('CIF-00%d', [RandCIF]);
  edtNama.Text      := '';
  edtKTP.Text       := '';
  dtpTglLahir.Date  := EncodeDate(1990, 1, 1);
  cmbGender.ItemIndex := 0;
  edtPekerjaan.Text := '';
  cmbKelas.ItemIndex  := 0;
  edtTelepon.Text   := '';
  memAlamat.Text    := '';
  edtNama.SetFocus;
end;

procedure TfrmCustomer.btnRefreshClick(Sender: TObject);
begin
  LoadNasabah(edtSearch.Text);
end;

procedure TfrmCustomer.edtSearchChange(Sender: TObject);
begin
  LoadNasabah(edtSearch.Text);
end;

procedure TfrmCustomer.dbgNasabahCellClick(Column: TColumn);
begin
  SyncFormFields;
end;

procedure TfrmCustomer.btnNewClick(Sender: TObject);
begin
  if not dmSecurity.HasPermission(PERM_CUST_MANAGE) then Exit;
  ClearFields;
  lblMsg.Caption := 'Mode Input Nasabah Baru. Silakan lengkapi formulir lalu klik Simpan.';
end;

procedure TfrmCustomer.btnSaveClick(Sender: TObject);
var
  QryExec: TADOQuery;
  GenderCode: string;
  RiskClass: Integer;
begin
  if not dmSecurity.HasPermission(PERM_CUST_MANAGE) then
  begin
    ShowMessage('Anda tidak memiliki izin menyimpan data nasabah!');
    Exit;
  end;

  if Trim(edtNama.Text) = '' then
  begin
    ShowMessage('Nama lengkap nasabah wajib diisi!');
    edtNama.SetFocus;
    Exit;
  end;

  if Trim(edtKTP.Text) = '' then
  begin
    ShowMessage('Nomor identitas KTP wajib diisi!');
    edtKTP.SetFocus;
    Exit;
  end;

  if cmbGender.ItemIndex = 1 then
    GenderCode := 'P'
  else
    GenderCode := 'L';

  RiskClass := cmbKelas.ItemIndex + 1;

  QryExec := TADOQuery.Create(nil);
  try
    QryExec.Connection := dmConnection.Connection;

    if FIsNewMode then
    begin
      QryExec.SQL.Text :=
        'INSERT INTO nasabah (no_cif, nama_lengkap, no_identitas, tgl_lahir, jenis_kelamin, ' +
        '                     pekerjaan, kelas_pekerjaan, no_telepon, alamat, created_at) ' +
        'VALUES (:cif, :nama, :ktp, :tgl, :jk, :job, :kelas, :telp, :alamat, GETDATE())';
    end
    else
    begin
      QryExec.SQL.Text :=
        'UPDATE nasabah SET ' +
        '  no_cif = :cif, nama_lengkap = :nama, no_identitas = :ktp, ' +
        '  tgl_lahir = :tgl, jenis_kelamin = :jk, pekerjaan = :job, ' +
        '  kelas_pekerjaan = :kelas, no_telepon = :telp, alamat = :alamat ' +
        'WHERE id = :id';
      QryExec.Parameters.ParamByName('id').Value := FSelectedID;
    end;

    QryExec.Parameters.ParamByName('cif').Value    := Trim(edtCIF.Text);
    QryExec.Parameters.ParamByName('nama').Value   := Trim(edtNama.Text);
    QryExec.Parameters.ParamByName('ktp').Value    := Trim(edtKTP.Text);
    QryExec.Parameters.ParamByName('tgl').Value    := dtpTglLahir.Date;
    QryExec.Parameters.ParamByName('jk').Value     := GenderCode;
    QryExec.Parameters.ParamByName('job').Value    := Trim(edtPekerjaan.Text);
    QryExec.Parameters.ParamByName('kelas').Value  := RiskClass;
    QryExec.Parameters.ParamByName('telp').Value   := Trim(edtTelepon.Text);
    QryExec.Parameters.ParamByName('alamat').Value := Trim(memAlamat.Text);

    QryExec.ExecSQL;

    dmSecurity.LogAudit('SAVE_CUSTOMER', 'nasabah', edtCIF.Text,
      Format('Penyimpanan data nasabah %s (%s)', [edtNama.Text, edtCIF.Text]));

    lblMsg.Caption := 'Data nasabah berhasil disimpan!';
    LoadNasabah('');
  finally
    QryExec.Free;
  end;
end;

procedure TfrmCustomer.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
