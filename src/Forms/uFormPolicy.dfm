object frmPolicy: TfrmPolicy
  Left = 240
  Top = 110
  Width = 980
  Height = 650
  Caption = 'Administrasi Polis Asuransi Jiwa (Master-Detail SPAJ)'
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
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 964
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object lblHeaderTitle: TLabel
      Left = 16
      Top = 12
      Width = 338
      Height = 16
      Caption = 'Siklus Hidup Permohonan & Penerbitan Polis Asuransi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblActiveUser: TLabel
      Left = 600
      Top = 14
      Width = 345
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Petugas Aktif : -'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6583371
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlTopGrid: TPanel
    Left = 0
    Top = 45
    Width = 964
    Height = 180
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object pnlFilter: TPanel
      Left = 0
      Top = 0
      Width = 964
      Height = 36
      Align = alTop
      BevelOuter = bvNone
      Color = 16315132
      TabOrder = 0
      object lblFilter: TLabel
        Left = 16
        Top = 10
        Width = 71
        Height = 13
        Caption = 'Daftar Polis :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnRefresh: TButton
        Left = 100
        Top = 6
        Width = 75
        Height = 24
        Caption = 'Refresh'
        TabOrder = 0
        OnClick = btnRefreshClick
      end
      object btnNewSPAJ: TButton
        Left = 185
        Top = 6
        Width = 115
        Height = 24
        Caption = '+ Buat SPAJ Baru'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = btnNewSPAJClick
      end
      object btnSubmitUW: TButton
        Left = 310
        Top = 6
        Width = 160
        Height = 24
        Caption = 'Ajukan ke Underwriting'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = btnSubmitUWClick
      end
      object btnPrintCert: TButton
        Left = 480
        Top = 6
        Width = 145
        Height = 24
        Caption = 'Cetak Ringkasan Polis'
        TabOrder = 3
        OnClick = btnPrintCertClick
      end
    end
    object dbgPolis: TDBGrid
      Left = 0
      Top = 36
      Width = 964
      Height = 144
      Align = alClient
      DataSource = dsPolis
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = [fsBold]
      OnCellClick = dbgPolisCellClick
    end
  end
  object splPolicy: TSplitter
    Left = 0
    Top = 225
    Width = 964
    Height = 5
    Cursor = crVSplit
    Align = alTop
    Color = 14868720
  end
  object pnlDetail: TPanel
    Left = 0
    Top = 230
    Width = 964
    Height = 381
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pcDetail: TPageControl
      Left = 0
      Top = 0
      Width = 964
      Height = 381
      ActivePage = tsHeader
      Align = alClient
      TabOrder = 0
      OnChange = pcDetailChange
      object tsHeader: TTabSheet
        Caption = '  1. Formulir SPAJ & Produk Dasar  '
        object lblNoSPAJ: TLabel
          Left = 24
          Top = 20
          Width = 49
          Height = 13
          Caption = 'No SPAJ :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblNoPolis: TLabel
          Left = 24
          Top = 52
          Width = 46
          Height = 13
          Caption = 'No Polis :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblPemegang: TLabel
          Left = 24
          Top = 84
          Width = 84
          Height = 13
          Caption = 'Pemegang Polis :'
        end
        object lblTertanggung: TLabel
          Left = 24
          Top = 116
          Width = 71
          Height = 13
          Caption = 'Tertanggung :'
        end
        object lblProduk: TLabel
          Left = 24
          Top = 148
          Width = 86
          Height = 13
          Caption = 'Produk Asuransi :'
        end
        object lblCaraBayar: TLabel
          Left = 24
          Top = 180
          Width = 62
          Height = 13
          Caption = 'Cara Bayar :'
        end
        object lblUP: TLabel
          Left = 480
          Top = 20
          Width = 140
          Height = 13
          Caption = 'Uang Pertanggungan (UP) :'
        end
        object lblPremiDasar: TLabel
          Left = 480
          Top = 52
          Width = 69
          Height = 13
          Caption = 'Premi Dasar :'
        end
        object lblTotalRider: TLabel
          Left = 480
          Top = 84
          Width = 94
          Height = 13
          Caption = 'Total Premi Rider :'
        end
        object lblExtraLoading: TLabel
          Left = 480
          Top = 116
          Width = 104
          Height = 13
          Caption = 'Extra Risk Loading :'
        end
        object lblTotalPremi: TLabel
          Left = 480
          Top = 152
          Width = 113
          Height = 16
          Caption = 'Total Premi/Thn :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1483594
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblStatusPolis: TLabel
          Left = 480
          Top = 190
          Width = 97
          Height = 13
          Caption = 'Status Workflow :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtNoSPAJ: TEdit
          Left = 130
          Top = 16
          Width = 280
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 0
        end
        object edtNoPolis: TEdit
          Left = 130
          Top = 48
          Width = 280
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 1
        end
        object cmbPemegang: TComboBox
          Left = 130
          Top = 80
          Width = 280
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
        end
        object cmbTertanggung: TComboBox
          Left = 130
          Top = 112
          Width = 280
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
        end
        object cmbProduk: TComboBox
          Left = 130
          Top = 144
          Width = 280
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          OnChange = cmbProdukChange
        end
        object cmbCaraBayar: TComboBox
          Left = 130
          Top = 176
          Width = 280
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 3
          TabOrder = 5
          Text = 'TAHUNAN'
          Items.Strings = (
            'BULANAN'
            'KUARTALAN'
            'SEMESTERAN'
            'TAHUNAN')
        end
        object edtUP: TEdit
          Left = 620
          Top = 16
          Width = 250
          Height = 21
          TabOrder = 6
          Text = '200000000'
          OnChange = edtUPChange
        end
        object edtPremiDasar: TEdit
          Left = 620
          Top = 48
          Width = 250
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 7
        end
        object edtTotalRider: TEdit
          Left = 620
          Top = 80
          Width = 250
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 8
        end
        object edtExtraLoading: TEdit
          Left = 620
          Top = 112
          Width = 250
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 9
        end
        object edtTotalPremi: TEdit
          Left = 620
          Top = 148
          Width = 250
          Height = 24
          Color = 15003622
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1483594
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 10
        end
        object pnlStatusBadge: TPanel
          Left = 620
          Top = 184
          Width = 250
          Height = 28
          BevelOuter = bvNone
          Color = clSilver
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 11
        end
        object btnSavePolicy: TButton
          Left = 130
          Top = 220
          Width = 140
          Height = 30
          Caption = 'Simpan SPAJ Draft'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 12
          OnClick = btnSavePolicyClick
        end
      end
      object tsRiders: TTabSheet
        Caption = '  2. Rincian Rider / Manfaat Tambahan (Detail)  '
        ImageIndex = 1
        object pnlRiderInput: TPanel
          Left = 0
          Top = 0
          Width = 956
          Height = 50
          Align = alTop
          BevelOuter = bvNone
          Color = 16315132
          TabOrder = 0
          object lblRiderSelect: TLabel
            Left = 16
            Top = 16
            Width = 55
            Height = 13
            Caption = 'Pilih Rider :'
          end
          object lblRiderUP: TLabel
            Left = 360
            Top = 16
            Width = 48
            Height = 13
            Caption = 'UP Rider :'
          end
          object cmbRider: TComboBox
            Left = 85
            Top = 12
            Width = 260
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
          end
          object edtRiderUP: TEdit
            Left = 420
            Top = 12
            Width = 140
            Height = 21
            TabOrder = 1
            Text = '100000000'
          end
          object btnAddRider: TButton
            Left = 575
            Top = 10
            Width = 110
            Height = 26
            Caption = '+ Tambah Rider'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = btnAddRiderClick
          end
          object btnDeleteRider: TButton
            Left = 695
            Top = 10
            Width = 95
            Height = 26
            Caption = 'Hapus Rider'
            TabOrder = 3
            OnClick = btnDeleteRiderClick
          end
        end
        object dbgRiderDetail: TDBGrid
          Left = 0
          Top = 50
          Width = 956
          Height = 308
          Align = alClient
          DataSource = dsRider
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
      object tsWorkflowInfo: TTabSheet
        Caption = '  3. Status & Jejak Audit Maker-Checker  '
        ImageIndex = 2
        object lblMakerInfo: TLabel
          Left = 24
          Top = 20
          Width = 104
          Height = 13
          Caption = 'Maker (Penginput) :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSubmittedAt: TLabel
          Left = 24
          Top = 50
          Width = 84
          Height = 13
          Caption = 'Waktu Diajukan :'
        end
        object lblCheckerInfo: TLabel
          Left = 24
          Top = 80
          Width = 122
          Height = 13
          Caption = 'Checker (Underwriter) :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblDecInfo: TLabel
          Left = 24
          Top = 110
          Width = 59
          Height = 13
          Caption = 'Keputusan :'
        end
        object lblNotesInfo: TLabel
          Left = 24
          Top = 140
          Width = 108
          Height = 13
          Caption = 'Catatan Underwriter :'
        end
        object edtMakerName: TEdit
          Left = 160
          Top = 16
          Width = 350
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 0
        end
        object edtSubmittedAt: TEdit
          Left = 160
          Top = 46
          Width = 350
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 1
        end
        object edtCheckerName: TEdit
          Left = 160
          Top = 76
          Width = 350
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 2
        end
        object edtDecInfo: TEdit
          Left = 160
          Top = 106
          Width = 350
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 3
        end
        object memNotesInfo: TMemo
          Left = 160
          Top = 136
          Width = 450
          Height = 80
          Color = 16315132
          ReadOnly = True
          TabOrder = 4
        end
      end
    end
  end
  object dsPolis: TDataSource
    DataSet = dmInsurance.qryPolisHeader
    Left = 768
    Top = 80
  end
  object dsRider: TDataSource
    DataSet = dmInsurance.qryPolisRider
    Left = 840
    Top = 80
  end
end
