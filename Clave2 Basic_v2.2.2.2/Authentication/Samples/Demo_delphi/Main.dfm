object MainForm: TMainForm
  Left = 236
  Top = 127
  Width = 775
  Height = 454
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'iToken LC Demo - Delphi'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MemoText: TMemo
    Left = 8
    Top = 8
    Width = 361
    Height = 401
    ImeMode = imHanguel
    ReadOnly = True
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 375
    Top = 9
    Width = 361
    Height = 145
    Caption = 'Device information'
    TabOrder = 0
    object Label3: TLabel
      Left = 21
      Top = 32
      Width = 65
      Height = 13
      Caption = 'Device index:'
    end
    object Label7: TLabel
      Left = 21
      Top = 103
      Width = 123
      Height = 13
      Caption = 'Authentication password:'
    end
    object Label8: TLabel
      Left = 21
      Top = 70
      Width = 82
      Height = 13
      Caption = 'Admin password:'
    end
    object TokenIndexEdit: TEdit
      Left = 144
      Top = 24
      Width = 178
      Height = 21
      Hint = 'Device index(0=First'#65292'Deduced by analogy)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '0'
    end
    object TokenAuthPwdEdit: TEdit
      Left = 144
      Top = 100
      Width = 178
      Height = 21
      Hint = '8-byte Authentication password'
      MaxLength = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object TokenAdminPwdEdit: TEdit
      Left = 144
      Top = 67
      Width = 178
      Height = 21
      Hint = '8-byte Admin password'
      MaxLength = 8
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 375
    Top = 160
    Width = 361
    Height = 249
    Caption = 'Normal operation'
    TabOrder = 1
    object Label9: TLabel
      Left = 8
      Top = 39
      Width = 94
      Height = 13
      Caption = 'Authentication key:'
    end
    object AuthorizeKeyEdit: TEdit
      Left = 8
      Top = 61
      Width = 345
      Height = 21
      Hint = 
        '20 bytes,Input with hex.Example:0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a' +
        '0a0a0a0a'
      MaxLength = 40
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object BtnTokenOpen: TButton
      Left = 40
      Top = 104
      Width = 105
      Height = 27
      Caption = 'Open device'
      TabOrder = 2
      OnClick = BtnTokenOpenClick
    end
    object BtnTokenClose: TButton
      Left = 183
      Top = 104
      Width = 122
      Height = 27
      Caption = 'Close device'
      Enabled = False
      TabOrder = 3
      OnClick = BtnTokenCloseClick
    end
    object BtnHmac: TButton
      Left = 38
      Top = 154
      Width = 107
      Height = 27
      Caption = 'Hmac'
      Enabled = False
      TabOrder = 4
      OnClick = BtnHmacClick
    end
    object BtnClear: TButton
      Left = 40
      Top = 200
      Width = 105
      Height = 27
      Caption = 'Clear information'
      TabOrder = 5
      OnClick = BtnClearClick
    end
    object BtnSetAuthKey: TButton
      Left = 184
      Top = 154
      Width = 121
      Height = 27
      Caption = 'Set authentication key'
      Enabled = False
      TabOrder = 1
      OnClick = BtnSetAuthKeyClick
    end
    object BtnExit: TButton
      Left = 184
      Top = 200
      Width = 121
      Height = 27
      Caption = 'Quit'
      TabOrder = 6
      OnClick = BtnExitClick
    end
    object LC: TLCFULL
      Left = 248
      Top = 0
      Width = 32
      Height = 33
      TabOrder = 7
      Visible = False
      ControlData = {000800004F03000069030000}
    end
  end
end
