object frmMain: TfrmMain
  Left = 140
  Top = 50
  Width = 1160
  Height = 760
  Caption = 'DelphiInsuranceRBAC: Core Bancassurance Administration (Bank Codina)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mmMain
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlSidebar: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 701
    Align = alLeft
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object pnlCodinaStrip: TPanel
      Left = 0
      Top = 0
      Width = 250
      Height = 4
      Align = alTop
      BevelOuter = bvNone
      Color = 2366701
      TabOrder = 0
    end
    object pnlBrand: TPanel
      Left = 0
      Top = 4
      Width = 250
      Height = 76
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 1
      object lblBrandName: TLabel
        Left = 16
        Top = 12
        Width = 115
        Height = 21
        Caption = 'BANK CODINA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2366701
        Font.Height = -17
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblBrandApp: TLabel
        Left = 16
        Top = 36
        Width = 164
        Height = 14
        Caption = 'Bancassurance Core System'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblBrandSub: TLabel
        Left = 16
        Top = 53
        Width = 186
        Height = 12
        Caption = 'OJK Dual Control & Policy Administration'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 6583371
        Font.Height = -10
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object pnlProfile: TPanel
      Left = 0
      Top = 80
      Width = 250
      Height = 98
      Align = alTop
      BevelOuter = bvNone
      Color = 16315132
      TabOrder = 2
      object lblProfileHeader: TLabel
        Left = 16
        Top = 8
        Width = 106
        Height = 11
        Caption = 'SESI PENGGUNA AKTIF :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 6583371
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblProfileName: TLabel
        Left = 16
        Top = 23
        Width = 218
        Height = 16
        AutoSize = False
        Caption = 'Petugas Bancassurance'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 988970
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblBranch: TLabel
        Left = 16
        Top = 72
        Width = 218
        Height = 13
        AutoSize = False
        Caption = 'KCU Jakarta Senayan [001]'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 6583371
        Font.Height = -10
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object pnlRoleBadge: TPanel
        Left = 16
        Top = 44
        Width = 145
        Height = 22
        BevelOuter = bvNone
        Caption = 'MAKER (BANCASS)'
        Color = 1483594
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -10
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object pnlNavButtons: TPanel
      Left = 0
      Top = 178
      Width = 250
      Height = 433
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 3
      object lblNavCat1: TLabel
        Left = 16
        Top = 10
        Width = 70
        Height = 11
        Caption = 'OPERASIONAL'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 9739416
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblNavCat2: TLabel
        Left = 16
        Top = 200
        Width = 117
        Height = 11
        Caption = 'PENGATURAN & AUDIT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 9739416
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnNavDash: TSpeedButton
        Left = 12
        Top = 26
        Width = 226
        Height = 38
        AllowAllUp = True
        GroupIndex = 1
        Down = True
        Caption = '  ❖  Ringkasan & Metrik KPI'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Margin = 10
        ParentFont = False
        OnClick = btnNavDashClick
      end
      object btnNavPolicy: TSpeedButton
        Left = 12
        Top = 68
        Width = 226
        Height = 38
        AllowAllUp = True
        GroupIndex = 1
        Caption = '  📋  Administrasi Polis (SPAJ)'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Margin = 10
        ParentFont = False
        OnClick = btnNavPolicyClick
      end
      object btnNavUW: TSpeedButton
        Left = 12
        Top = 110
        Width = 226
        Height = 38
        AllowAllUp = True
        GroupIndex = 1
        Caption = '  ⚖  Antrean Underwriting'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Margin = 10
        ParentFont = False
        OnClick = btnNavUWClick
      end
      object btnNavCustomer: TSpeedButton
        Left = 12
        Top = 152
        Width = 226
        Height = 38
        AllowAllUp = True
        GroupIndex = 1
        Caption = '  👤  Database Nasabah (CIF)'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Margin = 10
        ParentFont = False
        OnClick = btnNavCustomerClick
      end
      object btnNavRBAC: TSpeedButton
        Left = 12
        Top = 216
        Width = 226
        Height = 38
        AllowAllUp = True
        GroupIndex = 1
        Caption = '  🔐  Matriks Hak Akses RBAC'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Margin = 10
        ParentFont = False
        OnClick = btnNavRBACClick
      end
      object btnNavAudit: TSpeedButton
        Left = 12
        Top = 258
        Width = 226
        Height = 38
        AllowAllUp = True
        GroupIndex = 1
        Caption = '  📜  Audit Trail Forensik'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Margin = 10
        ParentFont = False
        OnClick = btnNavAuditClick
      end
    end
    object pnlBottomNav: TPanel
      Left = 0
      Top = 611
      Width = 250
      Height = 90
      Align = alBottom
      BevelOuter = bvNone
      Color = 16315132
      TabOrder = 4
      object pnlBottomBorder: TPanel
        Left = 0
        Top = 0
        Width = 250
        Height = 1
        Align = alTop
        BevelOuter = bvNone
        Color = 14868720
        TabOrder = 0
      end
      object btnNavSwitch: TSpeedButton
        Left = 12
        Top = 10
        Width = 226
        Height = 34
        Caption = '⇄  Ganti Sesi Pengguna'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 15426347
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnNavSwitchClick
      end
      object btnNavExit: TSpeedButton
        Left = 12
        Top = 48
        Width = 226
        Height = 34
        Caption = '✕  Keluar Sistem'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2500316
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnNavExitClick
      end
    end
  end
  object pnlSidebarBorder: TPanel
    Left = 250
    Top = 0
    Width = 1
    Height = 701
    Align = alLeft
    BevelOuter = bvNone
    Color = 14868720
    TabOrder = 1
  end
  object pnlContentArea: TPanel
    Left = 251
    Top = 0
    Width = 893
    Height = 701
    Align = alClient
    BevelOuter = bvNone
    Color = 15790325
    TabOrder = 2
    object pnlTopBar: TPanel
      Left = 0
      Top = 0
      Width = 893
      Height = 56
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
      object lblPageTitle: TLabel
        Left = 20
        Top = 10
        Width = 265
        Height = 19
        Caption = 'Ringkasan & Metrik Operasional'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 988970
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblBreadcrumb: TLabel
        Left = 20
        Top = 32
        Width = 236
        Height = 12
        Caption = 'Beranda / Bancassurance / Dashboard Operasional'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 6583371
        Font.Height = -10
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object pnlTopBarBorder: TPanel
        Left = 0
        Top = 55
        Width = 893
        Height = 1
        Align = alBottom
        BevelOuter = bvNone
        Color = 14868720
        TabOrder = 0
      end
      object pnlStatusPill: TPanel
        Left = 560
        Top = 12
        Width = 315
        Height = 30
        Anchors = [akTop, akRight]
        BevelOuter = bvNone
        Color = 15003622
        TabOrder = 1
        object lblDBStatus: TLabel
          Left = 12
          Top = 8
          Width = 290
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '● SQL Server : Terhubung'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1409085
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
    object pnlEmbedHost: TPanel
      Left = 0
      Top = 56
      Width = 893
      Height = 645
      Align = alClient
      BevelOuter = bvNone
      Color = 15790325
      TabOrder = 1
      object pnlDashboardHome: TPanel
        Left = 0
        Top = 0
        Width = 893
        Height = 645
        Align = alClient
        BevelOuter = bvNone
        Color = 15790325
        TabOrder = 0
        object pnlKPIHeader: TPanel
          Left = 0
          Top = 0
          Width = 893
          Height = 118
          Align = alTop
          BevelOuter = bvNone
          Color = 15790325
          TabOrder = 0
          OnResize = pnlKPIHeaderResize
          object pnlCardDraft: TPanel
            Left = 16
            Top = 12
            Width = 200
            Height = 94
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            object pnlCardDraftStrip: TPanel
              Left = 0
              Top = 0
              Width = 200
              Height = 4
              Align = alTop
              BevelOuter = bvNone
              Color = 15426347
              TabOrder = 0
            end
            object lblCard1Title: TLabel
              Left = 14
              Top = 12
              Width = 112
              Height = 11
              Caption = 'SPAJ DRAFT (MAKER)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -9
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCountDraft: TLabel
              Left = 14
              Top = 26
              Width = 17
              Height = 33
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -27
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCard1Sub: TLabel
              Left = 14
              Top = 68
              Width = 116
              Height = 12
              Caption = 'Menunggu kelengkapan'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 9739416
              Font.Height = -10
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
          end
          object pnlCardUW: TPanel
            Left = 232
            Top = 12
            Width = 200
            Height = 94
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 1
            object pnlCardUWStrip: TPanel
              Left = 0
              Top = 0
              Width = 200
              Height = 4
              Align = alTop
              BevelOuter = bvNone
              Color = 423691
              TabOrder = 0
            end
            object lblCard2Title: TLabel
              Left = 14
              Top = 12
              Width = 145
              Height = 11
              Caption = 'ANTREAN UNDERWRITING'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -9
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCountSubmitted: TLabel
              Left = 14
              Top = 26
              Width = 17
              Height = 33
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 423691
              Font.Height = -27
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCard2Sub: TLabel
              Left = 14
              Top = 68
              Width = 123
              Height = 12
              Caption = 'Otorisasi risiko (Checker)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 9739416
              Font.Height = -10
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
          end
          object pnlCardInforce: TPanel
            Left = 448
            Top = 12
            Width = 200
            Height = 94
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 2
            object pnlCardInforceStrip: TPanel
              Left = 0
              Top = 0
              Width = 200
              Height = 4
              Align = alTop
              BevelOuter = bvNone
              Color = 4891414
              TabOrder = 0
            end
            object lblCard3Title: TLabel
              Left = 14
              Top = 12
              Width = 127
              Height = 11
              Caption = 'POLIS AKTIF (INFORCE)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -9
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCountInforce: TLabel
              Left = 14
              Top = 26
              Width = 17
              Height = 33
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1483594
              Font.Height = -27
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCard3Sub: TLabel
              Left = 14
              Top = 68
              Width = 125
              Height = 12
              Caption = 'Disetujui & aktif proteksi'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 9739416
              Font.Height = -10
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
          end
          object pnlCardReject: TPanel
            Left = 664
            Top = 12
            Width = 200
            Height = 94
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 3
            object pnlCardRejectStrip: TPanel
              Left = 0
              Top = 0
              Width = 200
              Height = 4
              Align = alTop
              BevelOuter = bvNone
              Color = 2500316
              TabOrder = 0
            end
            object lblCard4Title: TLabel
              Left = 14
              Top = 12
              Width = 135
              Height = 11
              Caption = 'PERMOHONAN DITOLAK'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -9
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCountRejected: TLabel
              Left = 14
              Top = 26
              Width = 17
              Height = 33
              Caption = '0'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 2500316
              Font.Height = -27
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblCard4Sub: TLabel
              Left = 14
              Top = 68
              Width = 128
              Height = 12
              Caption = 'Underwriting rejection'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 9739416
              Font.Height = -10
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
          end
        end
        object pnlQuickActions: TPanel
          Left = 0
          Top = 118
          Width = 893
          Height = 52
          Align = alTop
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 1
          object pnlQuickBorder: TPanel
            Left = 0
            Top = 51
            Width = 893
            Height = 1
            Align = alBottom
            BevelOuter = bvNone
            Color = 14868720
            TabOrder = 0
          end
          object btnQuickNewSPAJ: TButton
            Left = 16
            Top = 8
            Width = 160
            Height = 34
            Caption = '+ Buat SPAJ Baru'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = btnQuickNewSPAJClick
          end
          object btnQuickUW: TButton
            Left = 186
            Top = 8
            Width = 180
            Height = 34
            Caption = 'Evaluasi Underwriting'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = btnQuickUWClick
          end
          object btnQuickCust: TButton
            Left = 376
            Top = 8
            Width = 170
            Height = 34
            Caption = 'Registrasi Nasabah (CIF)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = btnQuickCustClick
          end
          object btnQuickRefresh: TButton
            Left = 737
            Top = 8
            Width = 140
            Height = 34
            Anchors = [akTop, akRight]
            Caption = 'Segarkan Data (F5)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 4
            OnClick = btnQuickRefreshClick
          end
        end
        object pnlDashCards: TPanel
          Left = 0
          Top = 170
          Width = 893
          Height = 475
          Align = alClient
          BevelOuter = bvNone
          Color = 15790325
          TabOrder = 2
          OnResize = pnlDashCardsResize
          object pnlCardOJK: TPanel
            Left = 16
            Top = 14
            Width = 425
            Height = 445
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 0
            object lblOJKRule1: TLabel
              Left = 16
              Top = 50
              Width = 390
              Height = 26
              AutoSize = False
              Caption = '1. Maker (Bancassurance Officer): Menginput permohonan SPAJ dan dilarang menyetujui (approve) polisnya sendiri.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object lblOJKRule2: TLabel
              Left = 16
              Top = 84
              Width = 390
              Height = 26
              AutoSize = False
              Caption = '2. Checker (Underwriter): Menilai risiko kesehatan & finansial, berwenang menyetujui/menolak, dilarang membuat draft SPAJ.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object lblOJKRule3: TLabel
              Left = 16
              Top = 118
              Width = 390
              Height = 26
              AutoSize = False
              Caption = '3. Integritas Data: Setiap perubahan status divalidasi checksum hash forensik pada tabel audit_logs perbankan.'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              WordWrap = True
            end
            object lblPermHeader: TLabel
              Left = 16
              Top = 155
              Width = 246
              Height = 12
              Caption = 'HAK AKSES OPERASIONAL PETUGAS SAAT INI :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -10
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object pnlCardOJKTitle: TPanel
              Left = 0
              Top = 0
              Width = 425
              Height = 38
              Align = alTop
              BevelOuter = bvNone
              Color = 16315132
              TabOrder = 0
              object lblCardOJKTitle: TLabel
                Left = 16
                Top = 12
                Width = 285
                Height = 13
                Caption = 'Prinsip OJK Empat Mata (Dual Control) & Matriks Izin'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 988970
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
              end
            end
            object memPermList: TMemo
              Left = 16
              Top = 175
              Width = 393
              Height = 255
              Color = 16315132
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Lines.Strings = (
                'Memuat izin operasional...')
              ParentFont = False
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 1
            end
          end
          object pnlCardSysInfo: TPanel
            Left = 452
            Top = 14
            Width = 425
            Height = 445
            BevelOuter = bvNone
            Color = clWhite
            TabOrder = 1
            object lblInfoUser: TLabel
              Left = 16
              Top = 50
              Width = 390
              Height = 13
              AutoSize = False
              Caption = 'Petugas Login : -'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblInfoNIP: TLabel
              Left = 16
              Top = 72
              Width = 390
              Height = 13
              AutoSize = False
              Caption = 'Nomor Induk Pegawai (NIP) : -'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblInfoRole: TLabel
              Left = 16
              Top = 94
              Width = 390
              Height = 13
              AutoSize = False
              Caption = 'Peran Otorisasi (RBAC) : -'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object lblInfoServer: TLabel
              Left = 16
              Top = 116
              Width = 390
              Height = 13
              AutoSize = False
              Caption = 'Koneksi Database : Microsoft SQL Server'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblInfoOJKNotice: TLabel
              Left = 16
              Top = 155
              Width = 244
              Height = 12
              Caption = 'PANDUAN ALUR PENGUJIAN MAKER-CHECKER :'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 6583371
              Font.Height = -10
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object pnlCardSysTitle: TPanel
              Left = 0
              Top = 0
              Width = 425
              Height = 38
              Align = alTop
              BevelOuter = bvNone
              Color = 16315132
              TabOrder = 0
              object lblCardSysTitle: TLabel
                Left = 16
                Top = 12
                Width = 265
                Height = 13
                Caption = 'Informasi Operasional & Status Sesi Core Banking'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 988970
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
              end
            end
            object memQuickWorkflow: TMemo
              Left = 16
              Top = 175
              Width = 393
              Height = 255
              Color = 16315132
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 1978939
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Lines.Strings = (
                'Memuat panduan alur...')
              ParentFont = False
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 1
            end
          end
        end
      end
    end
  end
  object mmMain: TMainMenu
    Left = 280
    Top = 16
    object mnuFile: TMenuItem
      Caption = '&File'
      object mnuSwitchUser: TMenuItem
        Caption = '&Ganti Sesi Pengguna...'
        ShortCut = 16460
        OnClick = btnNavSwitchClick
      end
      object mnuSep1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = '&Keluar Sistem'
        ShortCut = 32888
        OnClick = btnNavExitClick
      end
    end
    object mnuTransaksi: TMenuItem
      Caption = '&Transaksi'
      object mnuCust: TMenuItem
        Caption = '&Registrasi Nasabah (CIF)...'
        ShortCut = 16462
        OnClick = btnNavCustomerClick
      end
      object mnuPolicy: TMenuItem
        Caption = '&Administrasi Polis & SPAJ...'
        ShortCut = 16464
        OnClick = btnNavPolicyClick
      end
    end
    object mnuUnderwriting: TMenuItem
      Caption = '&Underwriting'
      object mnuUWQueue: TMenuItem
        Caption = '&Antrean Evaluasi Underwriting...'
        ShortCut = 16469
        OnClick = btnNavUWClick
      end
    end
    object mnuSistem: TMenuItem
      Caption = '&Keamanan & Audit'
      object mnuRBAC: TMenuItem
        Caption = '&Matriks Hak Akses RBAC...'
        ShortCut = 16466
        OnClick = btnNavRBACClick
      end
      object mnuAudit: TMenuItem
        Caption = '&Audit Trail Forensik...'
        ShortCut = 16449
        OnClick = btnNavAuditClick
      end
    end
    object mnuBantuan: TMenuItem
      Caption = '&Bantuan'
      object mnuOJKGuide: TMenuItem
        Caption = '&Panduan Maker-Checker OJK...'
        OnClick = mnuOJKGuideClick
      end
      object mnuAbout: TMenuItem
        Caption = '&Tentang Aplikasi Bancassurance...'
        OnClick = mnuAboutClick
      end
    end
  end
end
