object dmDados: TdmDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 364
  Width = 608
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Server=localhost'
      'DriverID=Mongo')
    LoginPrompt = False
    Left = 32
    Top = 24
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 32
    Top = 72
  end
  object FDPhysMongoDriverLink1: TFDPhysMongoDriverLink
    Left = 32
    Top = 120
  end
  object FDLocalSQL1: TFDLocalSQL
    Connection = FDConLocal
    DataSets = <
      item
        DataSet = FDMongoQuery1
        Name = 'MongoDB'
      end>
    Left = 248
    Top = 80
  end
  object FDConLocal: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 248
    Top = 32
  end
  object FDQuery1: TFDQuery
    Connection = FDConLocal
    SQL.Strings = (
      'Select * From MongoDB')
    Left = 248
    Top = 128
  end
  object FDMongoQuery1: TFDMongoQuery
    FormatOptions.AssignedValues = [fvStrsTrim2Len]
    FormatOptions.StrsTrim2Len = True
    Connection = FDConnection1
    Left = 88
    Top = 24
  end
end
