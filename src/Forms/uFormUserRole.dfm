object frmUserRole: TfrmUserRole
  Left = 280
  Top = 140
  Width = 920
  Height = 620
  Caption = 'Manajemen Keamanan Sistem & RBAC (Role-Based Access Control)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 904
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 14
      Width = 359
      Height = 16
      Caption = 'Pusat Konfigurasi Hak Akses & Matriks Izin Pengguna'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pcSecurity: TPageControl
    Left = 0
    Top = 45
    Width = 904
    Height = 536
    ActivePage = tsMatrix
    Align = alClient
    TabOrder = 1
    object tsMatrix: TTabSheet
      Caption = '  Matriks Hak Akses Peran & CRUD Role  '
      object pnlRolesLeft: TPanel
        Left = 0
        Top = 0
        Width = 270
        Height = 508
        Align = alLeft
        BevelOuter = bvNone
        Color = 16315132
        TabOrder = 0
        object lblRoleList: TLabel
          Left = 12
          Top = 12
          Width = 123
          Height = 13
          Caption = 'Pilih Jabatan / Peran :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbRoles: TListBox
          Left = 12
          Top = 32
          Width = 246
          Height = 380
          Anchors = [akLeft, akTop, akRight, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnClick = lbRolesClick
        end
        object pnlRoleButtons: TPanel
          Left = 0
          Top = 422
          Width = 270
          Height = 86
          Align = alBottom
          BevelOuter = bvNone
          Color = 16315132
          TabOrder = 1
          object btnAddRole: TButton
            Left = 12
            Top = 8
            Width = 118
            Height = 30
            Caption = '+ Tambah Role'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = btnAddRoleClick
          end
          object btnEditRole: TButton
            Left = 138
            Top = 8
            Width = 120
            Height = 30
            Caption = 'Ubah Nama'
            TabOrder = 1
            OnClick = btnEditRoleClick
          end
          object btnDeleteRole: TButton
            Left = 12
            Top = 44
            Width = 246
            Height = 30
            Caption = 'Hapus Role Terpilih'
            TabOrder = 2
            OnClick = btnDeleteRoleClick
          end
        end
      end
      object pnlTreeRight: TPanel
        Left = 270
        Top = 0
        Width = 626
        Height = 508
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pnlPermTop: TPanel
          Left = 0
          Top = 0
          Width = 626
          Height = 50
          Align = alTop
          BevelOuter = bvNone
          Color = 16315132
          TabOrder = 0
          object lblRoleActiveTitle: TLabel
            Left = 12
            Top = 16
            Width = 220
            Height = 13
            Caption = 'Mengatur Izin Peran : [Pilih Role]'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 988970
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object btnSavePerms: TButton
            Left = 270
            Top = 10
            Width = 165
            Height = 30
            Caption = 'Simpan Izin Peran'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = btnSavePermsClick
          end
          object btnSelectAll: TButton
            Left = 445
            Top = 10
            Width = 85
            Height = 30
            Caption = 'Pilih Semua'
            TabOrder = 1
            OnClick = btnSelectAllClick
          end
          object btnClearAll: TButton
            Left = 538
            Top = 10
            Width = 80
            Height = 30
            Caption = 'Kosongkan'
            TabOrder = 2
            OnClick = btnClearAllClick
          end
        end
        object clbPermissions: TCheckListBox
          Left = 0
          Top = 50
          Width = 626
          Height = 458
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 20
          ParentFont = False
          TabOrder = 1
        end
      end
    end
    object tsUsers: TTabSheet
      Caption = '  Daftar Akun Pengguna  '
      ImageIndex = 1
      object dbgUsers: TDBGrid
        Left = 0
        Top = 0
        Width = 896
        Height = 508
        Align = alClient
        DataSource = dsUsers
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = [fsBold]
      end
    end
    object tsAudit: TTabSheet
      Caption = '  Catatan Audit Trail Forensik  '
      ImageIndex = 2
      object pnlAuditTop: TPanel
        Left = 0
        Top = 0
        Width = 896
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        Color = 16315132
        TabOrder = 0
        object btnRefreshAudit: TButton
          Left = 12
          Top = 6
          Width = 120
          Height = 24
          Caption = 'Refresh Audit Log'
          TabOrder = 0
          OnClick = btnRefreshAuditClick
        end
      end
      object dbgAudit: TDBGrid
        Left = 0
        Top = 36
        Width = 896
        Height = 472
        Align = alClient
        DataSource = dsAudit
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = [fsBold]
      end
    end
  end
  object qryUsers: TADOQuery
    Parameters = <>
    Left = 128
    Top = 200
  end
  object dsUsers: TDataSource
    DataSet = qryUsers
    Left = 192
    Top = 200
  end
  object qryAudit: TADOQuery
    Parameters = <>
    Left = 128
    Top = 264
  end
  object dsAudit: TDataSource
    DataSet = qryAudit
    Left = 192
    Top = 264
  end
  object qryRolePerms: TADOQuery
    Parameters = <>
    Left = 128
    Top = 328
  end
end
