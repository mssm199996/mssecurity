{/**************************************************************************
* Copyright (C) 2008-2012, Senselock Software Technology Co.,Ltd
* All rights reserved.
*
* Description:  Test application for LC device
*
* History:
* 11/08/2011   LiLiang     create
**************************************************************************/}
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, comobj, StrUtils, LCMod, ComCtrls,
  LC_FULLLib_TLB;

type
  TMainForm = class(TForm)
    TokenIndexEdit: TEdit;
    Label3: TLabel;
    MemoText: TMemo;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    TokenAuthPwdEdit: TEdit;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    AuthorizeKeyEdit: TEdit;
    BtnTokenOpen: TButton;
    BtnTokenClose: TButton;
    BtnHmac: TButton;
    BtnClear: TButton;
    Label8: TLabel;
    BtnSetAuthKey: TButton;
    TokenAdminPwdEdit: TEdit;
    BtnExit: TButton;
    LC: TLCFULL;
    procedure BtnTokenOpenClick(Sender: TObject);
    procedure BtnTokenCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnHmacClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnSetAuthKeyClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PrintStr(Msg:string);
    procedure PrintStrLn(Msg:string);
    procedure PrintStart(Msg:string);
    procedure PrintEnd(Msg:string);
    function  ErrToStr(ErrCode:integer):string;
    procedure PrintErr(ErrCode:integer);
    procedure StrToByteArray(str:string; var ByteArray:array of byte);
    procedure StrToHexByteArray(str:string; var HexByteArray:array of byte);
    function HexStrToInt(hexnum:string):integer;
    function ByteArrayToStr(var ByteArray:array of byte; len:integer):string;
    function ByteArrayCmp(var ByteArray1,ByteArray2:array of byte;len:integer):Boolean;
    procedure GetDeviceInfo();
    function IsHexString(HexString:string; iSize:integer):boolean;
    procedure PrintByteArray(var ByteArray:array of byte; len:integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.PrintStr(Msg:string);
begin
      MemoText.Lines[MemoText.Lines.Count-1] := MemoText.Lines[MemoText.Lines.Count-1] + Msg;
end;

procedure TMainForm.PrintStrLn(Msg:string);
begin
    PrintStr(Msg);
    MemoText.Lines.Add(' ');
end;

procedure TMainForm.PrintStart(Msg:string);
begin
  PrintStrLn('============       ' + Msg + ' Start    ===========');
end;

procedure TMainForm.PrintEnd(Msg:string);
begin
  PrintStrLn('============       ' + Msg + ' Complete    ===========');
  PrintStrLn('');
end;

function  TMainForm.ErrToStr(ErrCode:integer):string;
begin
    if LC_SUCCESS = ErrCode Then
      result := 'LC_SUCCESS'
    else if LC_OPEN_DEVICE_FAILED = ErrCode Then
      result := 'LC_OPEN_DEVICE_FAILED'
    else if LC_FIND_DEVICE_FAILED = ErrCode Then
      result := 'LC_FIND_DEVICE_FAILED'
    else if LC_INVALID_PARAMETER = ErrCode Then
      result := 'LC_INVALID_PARAMETER'
    else if LC_INVALID_BLOCK_NUMBER = ErrCode Then
      result := 'LC_INVALID_BLOCK_NUMBER'
    else if LC_HARDWARE_COMMUNICATE_ERROR = ErrCode Then
      result := 'LC_HARDWARE_COMMUNICATE_ERROR'
    else if LC_INVALID_PASSWORD = ErrCode Then
      result := 'LC_INVALID_PASSWORD'
    else if LC_ACCESS_DENIED = ErrCode Then
      result := 'LC_ACCESS_DENIED'
    else if LC_ALREADY_OPENED = ErrCode Then
      result := 'LC_ALREADY_OPENED'
    else if LC_ALLOCATE_MEMORY_FAILED = ErrCode Then
      result := 'LC_ALLOCATE_MEMORY_FAILED'
    else if LC_INVALID_UPDATE_PACKAGE = ErrCode Then
      result := 'LC_INVALID_UPDATE_PACKAGE'
    else if LC_SYN_ERROR = ErrCode Then
      result := 'LC_SYN_ERROR'
    else if LC_ALREADY_CLOSED = ErrCode Then
      result := 'LC_ALREADY_CLOSED'
    else
      result := 'LC_OTHER_ERROR'
end;


procedure TMainForm.PrintErr(ErrCode:integer);
var
  str:string;
begin
      ErrCode :=  ErrCode and $ffff;
      str := 'Failed,  Error code: ' + ErrToStr(ErrCode);
      PrintStr(str);
end;


procedure TMainForm.StrToByteArray(str:string; var ByteArray:array of byte);
var
    i:integer;
begin
    for i := 1 to length(str) do
      begin
        ByteArray[i-1] := ord(str[i]);
      end;
end;


procedure TMainForm.StrToHexByteArray(str:string; var HexByteArray:array of byte);
var
    i: integer;
    s1: string;
    s2: string;
begin
    s1 := str;
    for i := 0 to (length(str) div 2)-1 do
        If length(s1) <> 0 Then
        begin
          s2 := LeftStr(s1, 2);
          HexByteArray[i] := HexStrToInt(s2);
          s1 := RightStr(s1, Length(s1)-2);
        end;
end;


function TMainForm.HexStrToInt(hexnum:string):integer;
var
 s:char;
 s_ord:integer;
 i, j:integer;
 hnum:integer;
 sixteen: integer;
begin
     result:=0; hnum:=0;
     for i:=length(hexnum) downto 1 do begin
         s:=hexnum[i]; s_ord:=ord(s);
         case s_ord of
              ord('0') : hnum:=0;
              ord('1') : hnum:=1;
              ord('2') : hnum:=2;
              ord('3') : hnum:=3;
              ord('4') : hnum:=4;
              ord('5') : hnum:=5;
              ord('6') : hnum:=6;
              ord('7') : hnum:=7;
              ord('8') : hnum:=8;
              ord('9') : hnum:=9;
              ord('A') : hnum:=10;
              ord('a') : hnum:=10;
              ord('B') : hnum:=11;
              ord('b') : hnum:=11;
              ord('C') : hnum:=12;
              ord('c') : hnum:=12;
              ord('D') : hnum:=13;
              ord('d') : hnum:=13;
              ord('E') : hnum:=14;
              ord('e') : hnum:=14;
              ord('F') : hnum:=15;
              ord('f') : hnum:=15;
         end; {case}
         if i=length(hexnum) then result:=hnum  {simulate exponential function}
         else begin
             sixteen:=1;
             for j := length(hexnum)-i downto 1 do
             sixteen := sixteen * 16;
             result := result + (hnum * sixteen);
         end;
      end;  {for loop}
end; {hext to int function}


function TMainForm.ByteArrayToStr(var ByteArray:array of byte; len:integer):string;
var
  i: integer;
  info: string;
begin
    info := '';
    for i := 0 to len-1 do
    begin
      info := info + IntToStr(ByteArray[i]);
    end;
    result := info;
end;

function TMainForm.ByteArrayCmp(var ByteArray1,ByteArray2:array of byte;len:integer):Boolean;
var
i: integer;
begin
  Result := True;
  for i := 0 to len - 1 do
  begin
    if(ByteArray1[i] <> ByteArray2[i]) then
      Result := False;
  end;
end;

function TMainForm.IsHexString(HexString:string; iSize:integer):boolean;
var
i:integer;
str:string;
begin
  str := '0123456789abcdef';
  for i := 1 to iSize do
  begin
    if 0 = Pos(HexString[i], str) Then
    begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

procedure TMainForm.PrintByteArray(var ByteArray:array of byte; len:integer);
var
info:string;
i:integer;
begin
  info := '';

  for i := 0 to len - 1 do
  begin
    info := info + IntToHex(ByteArray[i], 2) + ' ';
  end;
  PrintStrLn(info);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin

      PrintStrLn('===========================================');
      PrintStrLn('                               Delphi demo for iToken LC full control');
      PrintStrLn('                                Create by SenseLock, 2010-05');
      PrintStrLn('                        Copyright (C) 2008-2012, Senselock Software Technology Co.,Ltd');
      PrintStrLn('===========================================');
      PrintStrLn('');
      PrintStrLn('');
end;

procedure TMainForm.GetDeviceInfo();
var
  info: string;
  temp: string;
  TokenSN: array [0..7] of byte;
  TokenDate: array [0..7] of byte;
  i: integer;
begin
    try
        LC.Get_hardware_info(0, TokenSN[0]);
        LC.Get_hardware_info(1, TokenDate[0]);

        PrintStrLn('Successful to get hardware information.');

        info := 'SN:   ';
        temp := '';
        for i := 0 to 7 do
        begin
          info := info + Chr(TokenSN[i]);
        end;
        PrintStrLn(info);

        info := 'Producation date:   ';
        for i := 0 to 7 do
        begin
          temp := temp + Chr(TokenDate[i]);
        end;
        info := info + IntToStr(HexStrToInt(temp));
        PrintStrLn(info);

     except
          on e:EOleSysError do
          begin
              PrintErr(e.ErrorCode);
          end;
     end;
end;

procedure TMainForm.BtnTokenOpenClick(Sender: TObject);
Var
  LCIndex: Integer;
begin
     Try
        if  TokenIndexEdit.Text = '' Then
        begin
          Application.MessageBox('The index of input is null!', 'warning');
          Exit;
        end;

        PrintStart ('Open device');
        LCIndex := StrToInt(TokenIndexEdit.Text);
        
        LC.Open(LCIndex);
        PrintStrLn('Successful to open device!');
        GetDeviceInfo();

        BtnTokenOpen.Enabled :=  False;
        BtnTokenClose.Enabled := True;
        BtnHmac.Enabled := True;
        BtnSetAuthKey.Enabled := True;

        PrintEnd ('Open device');
        PrintStrLn('');

     Except
          on e:EOleSysError do
          Begin
              PrintErr(e.ErrorCode);
              PrintStrLn('');
              PrintEnd ('Open device');
              PrintStrLn('');
          End;
     End;
end;

procedure TMainForm.BtnTokenCloseClick(Sender: TObject);
begin
     Try
        TokenIndexEdit.Enabled := True;

        PrintStart ('Close device');
        LC.Close();
        PrintStrLn('Successful to close device!');

        BtnTokenOpen.Enabled := True;
        BtnTokenClose.Enabled := False;
        BtnTokenOpen.Enabled := True;
        BtnHmac.Enabled := False;
        BtnSetAuthKey.Enabled := False;

        PrintEnd ('Close device');
        PrintStrLn('');
     Except
        on e:EOleSysError do
        Begin
          PrintErr(e.ErrorCode);
          PrintStrLn('');
          PrintEnd ('Close device');
          PrintStrLn('');
        End;
     End;
end;

//Hmac
procedure TMainForm.BtnHmacClick(Sender: TObject);
var
  LCIndex: array [0..7] of byte;
  text: string;
  textByte: array of byte;
  key: array [0..19] of byte;
  digest_device: array [0..19] of byte;
  digest_software: array [0..19] of byte;
  len: integer;
begin
     try
     if Length(TokenAuthPwdEdit.Text) <> 8 Then
        begin
          Application.MessageBox('Incorrect authentication password!', 'Warning');
          Exit;
        end;

        if Length(AuthorizeKeyEdit.Text) <> 40 Then
        begin
          Application.MessageBox('Incorrect length of authentication key!', 'Warning');
          Exit;
        end;

        if IsHexString(AuthorizeKeyEdit.Text, 40) = False Then
        begin
          Application.MessageBox('Incorrect authentication key', 'Warning');
          Exit;
        end;

        PrintStart ('Hmac');
        text := 'Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC Hi iToken LC';
        len := length(text);
        SetLength(textByte, len);
        StrToByteArray(text, textByte[0]);

        StrToHexByteArray(AuthorizeKeyEdit.Text, key[0]);
        StrToByteArray(TokenAuthPwdEdit.Text, LCIndex[0]);

        LC.Passwd(2, LCIndex[0]);

        LC.Hmac(textByte[0], len, digest_device[0]);
        PrintStrLn('Hardware Hmac:');
        PrintByteArray(digest_device[0], 20);


        LC.Hmac_software(textByte[0], len, key[0], digest_software[0]);
        PrintStrLn('Software Hmac:');
        PrintByteArray(digest_software[0], 20);

        if ByteArrayCmp(digest_device[0], digest_software[0], 20) then
          PrintStrLn('Successful to verify')
        else
          PrintStrLn('Failed to verify');


        PrintEnd ('Hmac');
     except
          on e:EOleSysError do
          begin
              PrintErr(e.ErrorCode);
              PrintStrLn('');
              PrintEnd ('Hmac');
              PrintStrLn('');
          end;
     end;
end;

procedure TMainForm.BtnClearClick(Sender: TObject);
begin
  MemoText.Text := '';
end;

procedure TMainForm.BtnSetAuthKeyClick(Sender: TObject);
var
  AdminPwd: array [0..7] of byte;
  AuthKey: array [0..19] of byte;
begin
try
     if Length(TokenAdminPwdEdit.Text) <> 8 Then
        begin
          Application.MessageBox('Incorrect length of admin password!', 'warning');
          Exit;
        end;

        if Length(AuthorizeKeyEdit.Text) <> 40 Then
        begin
          Application.MessageBox('Incorrect length of authentication key!', 'warning');
          Exit;
        end;

        if IsHexString(AuthorizeKeyEdit.Text, 40) = False Then
        begin
          Application.MessageBox('Incorrect authentication key!', 'warning');
          Exit;
        end;

        PrintStart ('Set authentication Key');

        StrToByteArray(TokenAdminPwdEdit.Text, AdminPwd[0]);
        StrToHexByteArray(AuthorizeKeyEdit.Text, AuthKey[0]);

        LC.Passwd(0, AdminPwd[0]);

        LC.Set_key(AuthKey[0]);
        PrintStrLn('Successful to set authentication Key');

        PrintEnd ('Set authentication Key');

except
      on e:EOleSysError do
      begin
        PrintErr(e.ErrorCode);
        PrintStrLn('');
        PrintEnd ('Set authentication Key');
        PrintStrLn('');
      end;
end;
end;

procedure TMainForm.BtnExitClick(Sender: TObject);
begin
application.Terminate();
end;

end.



