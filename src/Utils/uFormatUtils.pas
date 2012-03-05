unit uFormatUtils;

interface

uses
  Windows, SysUtils, DateUtils;

function FormatRupiah(const AAmount: Double): string;
function ParseRupiah(const AText: string): Double;
function FormatDateIndo(const ADate: TDateTime): string;
function GenerateNomorSPAJ: string;
function GenerateNomorPolis: string;
function MaskNomorIdentitas(const AIdentitas: string): string;

implementation

function FormatRupiah(const AAmount: Double): string;
var
  SavedThousand, SavedDecimal: Char;
begin
  SavedThousand := ThousandSeparator;
  SavedDecimal  := DecimalSeparator;
  try
    ThousandSeparator := '.';
    DecimalSeparator  := ',';
    Result := 'Rp ' + FormatFloat('#,##0.00', AAmount);
  finally
    ThousandSeparator := SavedThousand;
    DecimalSeparator  := SavedDecimal;
  end;
end;

function ParseRupiah(const AText: string): Double;
var
  CleanStr: string;
  i: Integer;
begin
  CleanStr := '';
  for i := 1 to Length(AText) do
  begin
    if AText[i] in ['0'..'9'] then
      CleanStr := CleanStr + AText[i]
    else if AText[i] in [',', '.'] then
      CleanStr := CleanStr + DecimalSeparator;
  end;
  if CleanStr = '' then
    Result := 0.0
  else
  begin
    try
      Result := StrToFloat(CleanStr);
    except
      Result := 0.0;
    end;
  end;
end;

function FormatDateIndo(const ADate: TDateTime): string;
const
  NamaBulan: array[1..12] of string = (
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  );
var
  Y, M, D: Word;
begin
  if ADate = 0 then
  begin
    Result := '-';
    Exit;
  end;
  DecodeDate(ADate, Y, M, D);
  Result := Format('%.2d %s %d', [D, NamaBulan[M], Y]);
end;

function GenerateNomorSPAJ: string;
var
  YearStr, MonthStr, RandStr: string;
begin
  YearStr := FormatDateTime('yyyy', Now);
  MonthStr := FormatDateTime('mm', Now);
  Randomize;
  RandStr := Format('%.5d', [Random(90000) + 10000]);
  Result := Format('SPAJ-%s%s-%s', [YearStr, MonthStr, RandStr]);
end;

function GenerateNomorPolis: string;
var
  YearStr, MonthStr, RandStr: string;
begin
  YearStr := FormatDateTime('yyyy', Now);
  MonthStr := FormatDateTime('mm', Now);
  Randomize;
  RandStr := Format('%.5d', [Random(90000) + 10000]);
  Result := Format('POL-%s%s-%s', [YearStr, MonthStr, RandStr]);
end;

function MaskNomorIdentitas(const AIdentitas: string): string;
var
  Len: Integer;
begin
  Len := Length(AIdentitas);
  if Len <= 6 then
    Result := AIdentitas
  else
    Result := Copy(AIdentitas, 1, 4) + StringOfChar('*', Len - 8) + Copy(AIdentitas, Len - 3, 4);
end;

end.
