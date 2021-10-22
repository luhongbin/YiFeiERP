*!* vfp9 ДњТы
Declare Long FindFirstUrlCacheEntry in wininet String, String @, Long @
Declare Long FindNextUrlCacheEntry in wininet Long, String @, Long @
Declare Long FindCloseUrlCache in wininet Long
Declare Long GetLastError in win32api
 
Clear
 
nn = 0
FindFirstUrlCacheEntry(Null, Null, @ nn)
cc = Replicate(Chr(0), nn)
hh = FindFirstUrlCacheEntry(Null, @ cc, @ nn)
If 0 == hh
    ? 'Error: ' + Transform(GetLastError(), '@0')
    Return .f.
EndIf
 
Create Cursor ttt (locfile V(250), url V(250))
 
*!*    typedef struct _INTERNET_CACHE_ENTRY_INFO {
*!*      DWORD    dwStructSize;
*!*      LPTSTR   lpszSourceUrlName;
*!*      LPTSTR   lpszLocalFileName;
*!*      DWORD    CacheEntryType;
*!*      DWORD    dwUseCount;
*!*      DWORD    dwHitRate;
*!*      DWORD    dwSizeLow;
*!*      DWORD    dwSizeHigh;
*!*      FILETIME LastModifiedTime;
*!*      FILETIME ExpireTime;
*!*      FILETIME LastAccessTime;
*!*      FILETIME LastSyncTime;
*!*      LPTSTR   lpHeaderInfo;
*!*      DWORD    dwHeaderInfoSize;
*!*      LPTSTR   lpszFileExtension;
*!*      union {
*!*        DWORD dwReserved;
*!*        DWORD dwExemptDelta;
*!*      };
*!*    } INTERNET_CACHE_ENTRY_INFO
c1 = GetString(Sys(2600, CToBin(Substr(cc, 9, 4), 'rs'), 260))
c2 = GetString(Sys(2600, CToBin(Substr(cc, 5, 4), 'rs'), 260))
Insert into ttt (locfile, url) values (c1, c2)
 
Do while .t.
    nn = 0
    FindNextUrlCacheEntry(hh, Null, @ nn)
    cc = Replicate(Chr(0), nn)
    If 0 == FindNextUrlCacheEntry(hh, @ cc, @ nn)
        Exit
    EndIf
    Try
        c1 = GetString(Sys(2600, CToBin(Substr(cc, 9, 4), 'rs'), 260))
        c2 = GetString(Sys(2600, CToBin(Substr(cc, 5, 4), 'rs'), 260))
        Insert into ttt (locfile, url) values (c1, c2)
    Catch
    EndTry
EndDo
 
FindCloseUrlCache(hh)
 
Goto top
Browse
 
Function GetString(tcc)
    Local ii
    ii = At(Chr(0), tcc)
    Return Iif(ii > 0, Left(tcc, ii-1), tcc)
EndFunc