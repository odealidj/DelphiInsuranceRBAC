object dmInsurance: TdmInsurance
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 250
  Top = 260
  Height = 350
  Width = 500
  object qryPolisHeader: TADOQuery
    Parameters = <>
    Left = 40
    Top = 20
  end
  object dsPolisHeader: TDataSource
    DataSet = qryPolisHeader
    Left = 140
    Top = 20
  end
  object qryPolisRider: TADOQuery
    Parameters = <>
    Left = 40
    Top = 80
  end
  object dsPolisRider: TDataSource
    DataSet = qryPolisRider
    Left = 140
    Top = 80
  end
  object qryLookupNasabah: TADOQuery
    Parameters = <>
    Left = 40
    Top = 140
  end
  object dsLookupNasabah: TDataSource
    DataSet = qryLookupNasabah
    Left = 140
    Top = 140
  end
  object qryLookupProduk: TADOQuery
    Parameters = <>
    Left = 40
    Top = 200
  end
  object dsLookupProduk: TDataSource
    DataSet = qryLookupProduk
    Left = 140
    Top = 200
  end
  object qryLookupRider: TADOQuery
    Parameters = <>
    Left = 40
    Top = 260
  end
  object dsLookupRider: TDataSource
    DataSet = qryLookupRider
    Left = 140
    Top = 260
  end
  object qryUnderwritingQueue: TADOQuery
    Parameters = <>
    Left = 240
    Top = 20
  end
  object dsUnderwritingQueue: TDataSource
    DataSet = qryUnderwritingQueue
    Left = 360
    Top = 20
  end
  object qryExecute: TADOQuery
    Parameters = <>
    Left = 240
    Top = 80
  end
end
