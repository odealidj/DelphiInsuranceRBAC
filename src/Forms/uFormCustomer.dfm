object frmCustomer: TfrmCustomer
  Left = 320
  Top = 150
  Width = 850
  Height = 560
  Caption = 'Master Data Nasabah (CIF Bancassurance)'
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
    Width = 834
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 14
      Width = 267
      Height = 16
      Caption = 'Database Nasabah & Calon Tertanggung'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlClient: TPanel
    Left = 0
    Top = 45
    Width = 834
    Height = 476
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object splCustomer: TSplitter
      Left = 460
      Top = 0
      Width = 6
      Height = 476
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 460
      Height = 476
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object dbgNasabah: TDBGrid
        Left = 0
        Top = 36
        Width = 460
        Height = 440
        Align = alClient
        DataSource = dsNasabah
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = [fsBold]
        OnCellClick = dbgNasabahCellClick
      end
      object pnlSearch: TPanel
        Left = 0
        Top = 0
        Width = 460
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        Color = 16315132
        TabOrder = 1
        object lblSearch: TLabel
          Left = 8
          Top = 10
          Width = 58
          Height = 13
          Caption = 'Cari Nama :'
        end
        object edtSearch: TEdit
          Left = 72
          Top = 6
          Width = 260
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = edtSearchChange
        end
        object btnRefresh: TButton
          Left = 344
          Top = 5
          Width = 75
          Height = 23
          Anchors = [akTop, akRight]
          Caption = 'Refresh'
          TabOrder = 1
          OnClick = btnRefreshClick
        end
      end
    end
    object pnlRight: TPanel
      Left = 466
      Top = 0
      Width = 368
      Height = 476
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblCIF: TLabel
        Left = 16
        Top = 16
        Width = 43
        Height = 13
        Caption = 'No CIF :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblNama: TLabel
        Left = 16
        Top = 48
        Width = 84
        Height = 13
        Caption = 'Nama Lengkap :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1978939
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblKTP: TLabel
        Left = 16
        Top = 80
        Width = 84
        Height = 13
        Caption = 'No KTP/Paspor :'
      end
      object lblTglLahir: TLabel
        Left = 16
        Top = 112
        Width = 73
        Height = 13
        Caption = 'Tanggal Lahir :'
      end
      object lblGender: TLabel
        Left = 16
        Top = 144
        Width = 71
        Height = 13
        Caption = 'Jenis Kelamin :'
      end
      object lblPekerjaan: TLabel
        Left = 16
        Top = 176
        Width = 55
        Height = 13
        Caption = 'Pekerjaan :'
      end
      object lblKelas: TLabel
        Left = 16
        Top = 208
        Width = 91
        Height = 13
        Caption = 'Kelas Risiko (1-4) :'
      end
      object lblTelepon: TLabel
        Left = 16
        Top = 240
        Width = 62
        Height = 13
        Caption = 'No Telepon :'
      end
      object lblAlamat: TLabel
        Left = 16
        Top = 272
        Width = 40
        Height = 13
        Caption = 'Alamat :'
      end
      object edtCIF: TEdit
        Left = 120
        Top = 12
        Width = 230
        Height = 21
        Color = 16315132
        ReadOnly = True
        TabOrder = 0
      end
      object edtNama: TEdit
        Left = 120
        Top = 44
        Width = 230
        Height = 21
        TabOrder = 1
      end
      object edtKTP: TEdit
        Left = 120
        Top = 76
        Width = 230
        Height = 21
        TabOrder = 2
      end
      object dtpTglLahir: TDateTimePicker
        Left = 120
        Top = 108
        Width = 230
        Height = 21
        Date = 29221.000000000000000000
        Time = 29221.000000000000000000
        TabOrder = 3
      end
      object cmbGender: TComboBox
        Left = 120
        Top = 140
        Width = 230
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 4
        Text = 'Laki-laki (L)'
        Items.Strings = (
          'Laki-laki (L)'
          'Perempuan (P)')
      end
      object edtPekerjaan: TEdit
        Left = 120
        Top = 172
        Width = 230
        Height = 21
        TabOrder = 5
      end
      object cmbKelas: TComboBox
        Left = 120
        Top = 204
        Width = 230
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 6
        Text = '1 - Pekerjaan Kantor / Risiko Rendah'
        Items.Strings = (
          '1 - Pekerjaan Kantor / Risiko Rendah'
          '2 - Supervisi Lapangan / Risiko Sedang'
          '3 - Tenaga Teknis / Risiko Cukup Tinggi'
          '4 - Operasional Berat / Risiko Tinggi')
      end
      object edtTelepon: TEdit
        Left = 120
        Top = 236
        Width = 230
        Height = 21
        TabOrder = 7
      end
      object memAlamat: TMemo
        Left = 120
        Top = 268
        Width = 230
        Height = 60
        TabOrder = 8
      end
      object btnNew: TButton
        Left = 16
        Top = 345
        Width = 75
        Height = 28
        Caption = 'Tambah Baru'
        TabOrder = 9
        OnClick = btnNewClick
      end
      object btnSave: TButton
        Left = 104
        Top = 345
        Width = 75
        Height = 28
        Caption = 'Simpan'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        OnClick = btnSaveClick
      end
      object btnClose: TButton
        Left = 275
        Top = 345
        Width = 75
        Height = 28
        Caption = 'Tutup'
        TabOrder = 11
        OnClick = btnCloseClick
      end
      object lblMsg: TLabel
        Left = 16
        Top = 390
        Width = 330
        Height = 30
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1483594
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
    end
  end
  object qryNasabah: TADOQuery
    Parameters = <>
    Left = 64
    Top = 160
  end
  object dsNasabah: TDataSource
    DataSet = qryNasabah
    Left = 136
    Top = 160
  end
end
