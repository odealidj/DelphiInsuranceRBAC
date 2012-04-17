object frmUnderwriting: TfrmUnderwriting
  Left = 260
  Top = 130
  Width = 920
  Height = 620
  Caption = 'Antrean Underwriting & Otorisasi Risiko (Checker / Dual Control)'
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
    Width = 904
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object lblTitle: TLabel
      Left = 16
      Top = 14
      Width = 369
      Height = 16
      Caption = 'Evaluasi Risiko Medis / Finansial & Otorisasi Underwriter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 988970
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCheckerStatus: TLabel
      Left = 550
      Top = 14
      Width = 330
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Underwriter : -'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6583371
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlClient: TPanel
    Left = 0
    Top = 45
    Width = 904
    Height = 536
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object splUW: TSplitter
      Left = 450
      Top = 0
      Width = 6
      Height = 536
    end
    object pnlQueue: TPanel
      Left = 0
      Top = 0
      Width = 450
      Height = 536
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object pnlQueueHeader: TPanel
        Left = 0
        Top = 0
        Width = 450
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        Color = 16315132
        TabOrder = 0
        object lblQueueTitle: TLabel
          Left = 12
          Top = 10
          Width = 196
          Height = 13
          Caption = 'Antrean SPAJ Pending (SUBMITTED) :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object btnRefreshQueue: TButton
          Left = 360
          Top = 6
          Width = 75
          Height = 24
          Anchors = [akTop, akRight]
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = btnRefreshQueueClick
        end
      end
      object dbgQueue: TDBGrid
        Left = 0
        Top = 36
        Width = 450
        Height = 500
        Align = alClient
        DataSource = dsQueue
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = [fsBold]
        OnCellClick = dbgQueueCellClick
      end
    end
    object pnlReview: TPanel
      Left = 456
      Top = 0
      Width = 448
      Height = 536
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pnlWarningSOD: TPanel
        Left = 0
        Top = 0
        Width = 448
        Height = 45
        Align = alTop
        BevelOuter = bvNone
        Color = 2500316
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Visible = False
      end
      object pnlFormReview: TPanel
        Left = 0
        Top = 45
        Width = 448
        Height = 491
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object lblSPAJNum: TLabel
          Left = 16
          Top = 16
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
        object lblTertanggungName: TLabel
          Left = 16
          Top = 44
          Width = 77
          Height = 13
          Caption = 'Tertanggung :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblJobClass: TLabel
          Left = 16
          Top = 72
          Width = 96
          Height = 13
          Caption = 'Pekerjaan / Kelas :'
        end
        object lblProductChosen: TLabel
          Left = 16
          Top = 100
          Width = 86
          Height = 13
          Caption = 'Produk Asuransi :'
        end
        object lblTotalSumInsured: TLabel
          Left = 16
          Top = 128
          Width = 140
          Height = 13
          Caption = 'Uang Pertanggungan (UP) :'
        end
        object lblBasePrem: TLabel
          Left = 16
          Top = 156
          Width = 69
          Height = 13
          Caption = 'Premi Dasar :'
        end
        object lblMakerBranch: TLabel
          Left = 16
          Top = 184
          Width = 86
          Height = 13
          Caption = 'Maker (Cabang) :'
        end
        object lblLoading: TLabel
          Left = 16
          Top = 216
          Width = 128
          Height = 13
          Caption = 'Extra Risk Loading (Rp) :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblAssessmentNotes: TLabel
          Left = 16
          Top = 248
          Width = 153
          Height = 13
          Caption = 'Catatan Analisis Underwriter :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 1978939
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtSPAJNum: TEdit
          Left = 160
          Top = 12
          Width = 260
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 0
        end
        object edtTertanggungName: TEdit
          Left = 160
          Top = 40
          Width = 260
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 1
        end
        object edtJobClass: TEdit
          Left = 160
          Top = 68
          Width = 260
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 2
        end
        object edtProductChosen: TEdit
          Left = 160
          Top = 96
          Width = 260
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 3
        end
        object edtTotalSumInsured: TEdit
          Left = 160
          Top = 124
          Width = 260
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 4
        end
        object edtBasePrem: TEdit
          Left = 160
          Top = 152
          Width = 260
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 5
        end
        object edtMakerBranch: TEdit
          Left = 160
          Top = 180
          Width = 260
          Height = 21
          Color = 16315132
          ReadOnly = True
          TabOrder = 6
        end
        object edtLoading: TEdit
          Left = 160
          Top = 212
          Width = 260
          Height = 21
          TabOrder = 7
          Text = '0'
        end
        object memAssessmentNotes: TMemo
          Left = 16
          Top = 268
          Width = 404
          Height = 100
          Lines.Strings = (
            'Profil risiko medis dan finansial memenuhi syarat aktuaria. Pengajuan disetujui tanpa beban khusus.')
          TabOrder = 8
        end
        object btnApprove: TButton
          Left = 16
          Top = 385
          Width = 190
          Height = 35
          Caption = 'SETUJUI POLIS (INFORCE)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 9
          OnClick = btnApproveClick
        end
        object btnReject: TButton
          Left = 230
          Top = 385
          Width = 190
          Height = 35
          Caption = 'TOLAK POLIS (REJECT)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 10
          OnClick = btnRejectClick
        end
      end
    end
  end
  object dsQueue: TDataSource
    DataSet = dmInsurance.qryUnderwritingQueue
    Left = 184
    Top = 160
  end
end
