object dmSecurity: TdmSecurity
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 250
  Top = 220
  Height = 200
  Width = 300
  object qryAuth: TADOQuery
    Parameters = <>
    Left = 40
    Top = 20
  end
  object qryPerm: TADOQuery
    Parameters = <>
    Left = 110
    Top = 20
  end
  object qryAudit: TADOQuery
    Parameters = <>
    Left = 180
    Top = 20
  end
end
