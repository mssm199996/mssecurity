{/**************************************************************************
* Copyright (C) 2008-2012, Senselock Software Technology Co.,Ltd
* All rights reserved.
*
* Description:  show how to using library lc.dcu and lc.inc
*
* History:
* 08/22/2008   zhaock   R&D   create
**************************************************************************/}
unit demo_delphi7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Sense_LC, StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  handle :lc_handle_t;
  res,i:Integer;
  msg:AnsiString;
  error:array[0..12] of string;
  softInfo:LC_software_info;
  hardInfo:LC_hardware_info;
  plaintext:array[0..15] of Byte;
  ciphertext:array[0..15] of Byte;
  hmacKey:array[0..19] of Byte;
  text:array[0..1000] of Byte;
  degistLocal:array[0..19] of Byte;
  degistDevice:array[0..19] of Byte;
  indata:array[0..511] of Byte;
  outbuf:array[0..511] of Byte;
begin
  error[0] := 'LC_SUCCESS';
	error[1] := 'LC_OPEN_DEVICE_FAILED';
	error[2] := 'LC_FIND_DEVICE_FAILED';
	error[3] := 'LC_INVALID_PARAMETER';
	error[4] := 'LC_INVALID_BLOCK_NUMBER';
	error[5] := 'LC_HARDWARE_COMMUNICATE_ERROR';
	error[6] := 'LC_INVALID_PASSWORD';
	error[7] := 'LC_ACCESS_DENIED';
	error[8] := 'LC_ALREADY_OPENED';
	error[9] := 'LC_ALLOCATE_MEMORY_FAILED';
	error[10] := 'LC_INVALID_UPDATE_PACKAGE';
  error[11] := 'LC_SYN_ERROR';
	error[12] := 'LC_OTHER_ERROR';
  move(#$00#$11#$22#$33#$44#$55#$66#$77#$88#$99#$aa#$bb#$cc#$dd#$ee#$ff,plaintext,16);
  move(#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b#$0b,hmacKey,20);
  move('LCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLCLC',indata,180);

  // Retrieve the software version
  res := LC_get_software_info(softInfo);
  if res <> LC_SUCCESS then
    msg := 'Retrieve the software version failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')'
  else
    msg := 'Retrieve the software version succeded : ' + IntToStr(softinfo.version);
  ListBox1.Items.Add(msg);

  // Open device
  res := LC_open(0, 0, handle);  // DEMO dongle

  if res <> LC_SUCCESS then
  begin
    msg := 'Open deveice failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Open device succeded';
  ListBox1.Items.Add(msg);

  // Retrieve the hardware information
  res := LC_get_hardware_info(handle,hardInfo);

  if res <> LC_SUCCESS then
  begin
    msg := 'Retrieve the hardware information failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Retrieve the hardware information succeded';
  ListBox1.Items.Add(msg);

  // Verify User Password.
  res := LC_passwd(handle,1,'12345678');

  if res <> LC_SUCCESS then
  begin
    msg := 'Verify User Password failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Verify User Password succeded';
  ListBox1.Items.Add(msg);

  // Encrypte data
  res := LC_encrypt(handle, @plaintext, @ciphertext);

  if res <> LC_SUCCESS then
  begin
    msg := 'Encrypte data failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Encrypted data succeded';
  ListBox1.Items.Add(msg);
  
  // Decrypte data
  res := LC_decrypt(handle, @ciphertext, @plaintext);

  if res <> LC_SUCCESS then
  begin
    msg := 'Decrypte data failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Decrypte data succeded';
  ListBox1.Items.Add(msg);
  
  // Write Block 0
  res := LC_write(handle, 0, @indata);

  if res <> LC_SUCCESS then
  begin
    msg := 'Write Block 0 failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Write Block 0 succeded';
  ListBox1.Items.Add(msg);

  // Read Block 0
  res := LC_read(handle, 0, @outbuf);

  if res <> LC_SUCCESS then
  begin
    msg := 'Read Block 0 failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Read Block 0 succeded';
  ListBox1.Items.Add(msg);
  // Authentication
  ListBox1.Items.Add('Authentication :');

  // 1.Verify Authentication password
  res := LC_passwd(handle,2,'12345678');

  if res <> LC_SUCCESS then
  begin
    msg := '        Verify Authentication password failed. Error code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := '        Verify Authentication password succeed';
  ListBox1.Items.Add(msg);

  // 2.Get digest from device
  move('jlskjdflksjlskjdflksjlskjdflksjlskjdflksjlskjdflksjlskjdflksjlskjdflksjlskjdflksjlskjdflksjlskjdflks',text,100);

  res := LC_hmac(handle, @text, 100, @degistDevice );

  if res <> LC_SUCCESS then
  begin
    msg := '        Get digest from device failed. Error code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := '        Get digest from device succeed';
  ListBox1.Items.Add(msg);

  // 3.Get digest locally
  res := LC_hmac_software(@text, 100, @hmacKey, @degistLocal);

  if res <> LC_SUCCESS then
  begin
    msg := '        Get digest locally failed. Error code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := '        Get digest locally succeed';
  ListBox1.Items.Add(msg);

  // 4.Compare the two digest
  msg := '        authoriz succeed';
  for i:=0 to 19 do
    if (degistDevice[i] <> degistLocal[i]) then
    begin
      msg := '        authoriz failed';
      break
    end;
  ListBox1.Items.Add(msg);
  
  // change authorize user's password
  res :=  LC_change_passwd(handle, 2, '12345678', '12345678'); // just a demo, i do not really change it

  if res <> LC_SUCCESS then
  begin
    msg := 'change authorize user''s password failed. Error code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'change authorize user''s password succeed';
  ListBox1.Items.Add(msg);
  // Verify Admin Password.
  res := LC_passwd(handle,0,'12345678');

  if res <> LC_SUCCESS then
  begin
    msg := 'Verify Admin Password failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Verify Administration Password succeded';
  ListBox1.Items.Add(msg);

  // Reset User Password
  res := LC_set_passwd(handle,1,'12345678',-1);

  if res <> LC_SUCCESS then
  begin
    msg := 'Reset User Password failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')';
    ListBox1.Items.Add(msg);
    exit;
  end
  else
    msg := 'Reset User Password succeded.';
  ListBox1.Items.Add(msg);

  // Close device
  res := LC_close(handle);
  if res <> LC_SUCCESS then
    msg := 'Close device failed. Error Code:' + IntToStr(res) + '(' + error[res] + ')'
  else
    msg := 'Close deveice succeded';
  ListBox1.Items.Add(msg);

  ListBox1.Items.Add('==========================================================');

end;

end.
