object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'TCpfCnpjDBEdit - Demo'
  ClientHeight = 309
  ClientWidth = 645
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
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 109
    Height = 13
    Caption = 'Digite um CPF ou CNPJ'
  end
  object CpfCnpjDBEdit1: TCpfCnpjDBEdit
    Left = 8
    Top = 64
    Width = 121
    Height = 21
    DataField = 'CPF_CNPJ'
    DataSource = DataSource1
    TabOrder = 0
    Required = False
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 106
    Width = 645
    Height = 203
    Align = alBottom
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 0
    Top = 0
    Width = 645
    Height = 25
    DataSource = DataSource1
    VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost]
    Align = alTop
    TabOrder = 2
    ExplicitLeft = 192
    ExplicitTop = 32
    ExplicitWidth = 240
  end
  object CpfCnpjDBEdit2: TCpfCnpjDBEdit
    Left = 131
    Top = 64
    Width = 371
    Height = 21
    DataField = 'Nome'
    DataSource = DataSource1
    TabOrder = 3
    Required = False
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 400
    Top = 32
    object ClientDataSet1CPF_CNPJ: TStringField
      FieldName = 'CPF_CNPJ'
      Size = 14
    end
    object ClientDataSet1Nome: TStringField
      FieldName = 'Nome'
      Size = 30
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 360
    Top = 32
  end
end
