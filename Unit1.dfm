object Form1: TForm1
  Left = 402
  Top = 113
  Width = 954
  Height = 567
  Caption = 'Sokoban'
  Color = clBtnFace
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object LabelControl: TLabel
    Left = 264
    Top = 20
    Width = 204
    Height = 13
    Caption = 'Controls: W=Up, S=Down, A=Left, D=Right'
    Visible = False
  end
  object LabelMoves: TLabel
    Left = 552
    Top = 20
    Width = 35
    Height = 13
    Caption = 'Moves:'
    Visible = False
  end
  object LabelNoOfMoves: TLabel
    Left = 600
    Top = 20
    Width = 3
    Height = 13
  end
  object LabelHighScore: TLabel
    Left = 632
    Top = 12
    Width = 59
    Height = 13
    Caption = 'High Score: '
  end
  object LabelPlayer: TLabel
    Left = 632
    Top = 28
    Width = 3
    Height = 13
  end
  object LabelHighMoves: TLabel
    Left = 744
    Top = 28
    Width = 35
    Height = 13
    Caption = 'Moves:'
  end
  object LabelHighMovesNumber: TLabel
    Left = 787
    Top = 28
    Width = 3
    Height = 13
  end
  object ComboBoxLevelSelect: TComboBox
    Left = 24
    Top = 16
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Items.Strings = (
      '')
  end
  object ButtonStart: TButton
    Left = 176
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = ButtonStartClick
  end
  object ButtonClose: TButton
    Left = 824
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = ButtonCloseClick
  end
  object EditName: TEdit
    Left = 264
    Top = 16
    Width = 273
    Height = 21
    TabOrder = 3
    Visible = False
    OnClick = EditNameClick
    OnKeyPress = EditNameKeyPress
  end
end
