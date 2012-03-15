object frmLogin: TfrmLogin
  Left = 450
  Top = 220
  BorderStyle = bsDialog
  Caption = 'Login Sistem - Bancassurance Core'
  ClientHeight = 330
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object lblTitle: TLabel
      Left = 20
      Top = 14
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
    object lblSubtitle: TLabel
      Left = 20
      Top = 38
      Width = 328
      Height = 13
      Caption = 'Core Bancassurance System - Kepatuhan OJK Dual Control'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6583371
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnlBody: TPanel
    Left = 0
    Top = 72
    Width = 450
    Height = 258
    Align = alClient
    BevelOuter = bvNone
    Color = 16315132
    TabOrder = 1
    object lblUser: TLabel
      Left = 32
      Top = 22
      Width = 63
      Height = 13
      Caption = 'Username :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1978939
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPass: TLabel
      Left = 32
      Top = 54
      Width = 60
      Height = 13
      Caption = 'Password :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1978939
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblQuick: TLabel
      Left = 32
      Top = 90
      Width = 143
      Height = 13
      Caption = 'Pilih Cepat Akun Pengujian :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6583371
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtUsername: TEdit
      Left = 112
      Top = 18
      Width = 296
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtPassword: TEdit
      Left = 112
      Top = 50
      Width = 296
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 1
    end
    object btnMaker: TButton
      Left = 32
      Top = 110
      Width = 86
      Height = 26
      Caption = 'Maker'
      TabOrder = 2
      OnClick = btnMakerClick
    end
    object btnChecker: TButton
      Left = 126
      Top = 110
      Width = 86
      Height = 26
      Caption = 'Checker'
      TabOrder = 3
      OnClick = btnCheckerClick
    end
    object btnCS: TButton
      Left = 220
      Top = 110
      Width = 96
      Height = 26
      Caption = 'Cust. Service'
      TabOrder = 4
      OnClick = btnCSClick
    end
    object btnAdmin: TButton
      Left = 324
      Top = 110
      Width = 84
      Height = 26
      Caption = 'Admin'
      TabOrder = 5
      OnClick = btnAdminClick
    end
    object btnLogin: TButton
      Left = 216
      Top = 180
      Width = 100
      Height = 32
      Caption = 'Login'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = btnLoginClick
    end
    object btnCancel: TButton
      Left = 324
      Top = 180
      Width = 84
      Height = 32
      Cancel = True
      Caption = 'Batal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = btnCancelClick
    end
    object lblStatus: TLabel
      Left = 32
      Top = 150
      Width = 376
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2500316
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
