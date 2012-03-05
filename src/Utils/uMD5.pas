unit uMD5;

interface

uses
  Windows, SysUtils;

function MD5String(const S: string): string;

implementation

const
  PROV_RSA_FULL       = 1;
  CRYPT_VERIFYCONTEXT = $F0000000;
  HP_HASHVAL          = 2;
  ALG_CLASS_HASH      = (4 shl 13);
  ALG_TYPE_ANY        = 0;
  ALG_SID_MD5         = 3;
  CALG_MD5            = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD5);

function CryptAcquireContext(var phProv: THandle; pszContainer: PChar; pszProvider: PChar;
  dwProvType: DWORD; dwFlags: DWORD): BOOL; stdcall; external 'advapi32.dll' name 'CryptAcquireContextA';
function CryptCreateHash(hProv: THandle; Algid: DWORD; hKey: THandle; dwFlags: DWORD;
  var phHash: THandle): BOOL; stdcall; external 'advapi32.dll' name 'CryptCreateHash';
function CryptHashData(hHash: THandle; pbData: PByte; dwDataLen: DWORD; dwFlags: DWORD): BOOL; stdcall; external 'advapi32.dll' name 'CryptHashData';
function CryptGetHashParam(hHash: THandle; dwParam: DWORD; pbData: PByte; var pdwDataLen: DWORD;
  dwFlags: DWORD): BOOL; stdcall; external 'advapi32.dll' name 'CryptGetHashParam';
function CryptDestroyHash(hHash: THandle): BOOL; stdcall; external 'advapi32.dll' name 'CryptDestroyHash';
function CryptReleaseContext(hProv: THandle; dwFlags: DWORD): BOOL; stdcall; external 'advapi32.dll' name 'CryptReleaseContext';

function MD5String(const S: string): string;
var
  hProv: THandle;
  hHash: THandle;
  HashBytes: array[0..15] of Byte;
  HashLen: DWORD;
  i: Integer;
begin
  Result := '';
  if CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then
  begin
    try
      if CryptCreateHash(hProv, CALG_MD5, 0, 0, hHash) then
      begin
        try
          if Length(S) > 0 then
            CryptHashData(hHash, PByte(PChar(S)), Length(S), 0);
          HashLen := SizeOf(HashBytes);
          if CryptGetHashParam(hHash, HP_HASHVAL, @HashBytes[0], HashLen, 0) then
          begin
            for i := 0 to 15 do
              Result := Result + LowerCase(IntToHex(HashBytes[i], 2));
          end;
        finally
          CryptDestroyHash(hHash);
        end;
      end;
    finally
      CryptReleaseContext(hProv, 0);
    end;
  end;
end;

end.
