unit LC_FULLLib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2011-10-12 14:35:37 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\SYSTEM32\LC_FULL.dll (1)
// LIBID: {C98D37B4-CD82-45B3-9240-94633B41C598}
// LCID: 0
// Helpfile: 
// HelpString: LC_FULL 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Hint: Parameter 'type' of ILCFULL.Passwd changed to 'type_'
//   Hint: Parameter 'type' of ILCFULL.Set_passwd changed to 'type_'
//   Hint: Parameter 'type' of ILCFULL.Get_hardware_info changed to 'type_'
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  LC_FULLLibMajorVersion = 1;
  LC_FULLLibMinorVersion = 0;

  LIBID_LC_FULLLib: TGUID = '{C98D37B4-CD82-45B3-9240-94633B41C598}';

  DIID__ILCFULLEvents: TGUID = '{6017010B-0903-49AF-8C11-9A323AEF4F3E}';
  IID_ILCFULL: TGUID = '{CF794F4B-9B10-4487-906E-BCDE81903455}';
  CLASS_LCFULL: TGUID = '{EEFB0056-0E92-44A4-8B10-0C0BD75C56A8}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _ILCFULLEvents = dispinterface;
  ILCFULL = interface;
  ILCFULLDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  LCFULL = ILCFULL;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PByte1 = ^Byte; {*}


// *********************************************************************//
// DispIntf:  _ILCFULLEvents
// Flags:     (4096) Dispatchable
// GUID:      {6017010B-0903-49AF-8C11-9A323AEF4F3E}
// *********************************************************************//
  _ILCFULLEvents = dispinterface
    ['{6017010B-0903-49AF-8C11-9A323AEF4F3E}']
  end;

// *********************************************************************//
// Interface: ILCFULL
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CF794F4B-9B10-4487-906E-BCDE81903455}
// *********************************************************************//
  ILCFULL = interface(IDispatch)
    ['{CF794F4B-9B10-4487-906E-BCDE81903455}']
    procedure Open(index: Integer); safecall;
    procedure Close; safecall;
    procedure Passwd(type_: Integer; var Passwd: Byte); safecall;
    procedure Set_passwd(type_: Integer; var Passwd: Byte; retries: Integer); safecall;
    procedure Change_passwd(var oldpasswd: Byte; var newpasswd: Byte); safecall;
    procedure Get_hardware_info(type_: Integer; out info: Byte); safecall;
    procedure Hmac(var text: Byte; textlen: Integer; out digest: Byte); safecall;
    procedure Hmac_software(var text: Byte; textlen: Integer; var key: Byte; out digest: Byte); safecall;
    procedure Set_key(var key: Byte); safecall;
  end;

// *********************************************************************//
// DispIntf:  ILCFULLDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {CF794F4B-9B10-4487-906E-BCDE81903455}
// *********************************************************************//
  ILCFULLDisp = dispinterface
    ['{CF794F4B-9B10-4487-906E-BCDE81903455}']
    procedure Open(index: Integer); dispid 1;
    procedure Close; dispid 2;
    procedure Passwd(type_: Integer; var Passwd: Byte); dispid 3;
    procedure Set_passwd(type_: Integer; var Passwd: Byte; retries: Integer); dispid 4;
    procedure Change_passwd(var oldpasswd: Byte; var newpasswd: Byte); dispid 5;
    procedure Get_hardware_info(type_: Integer; out info: Byte); dispid 6;
    procedure Hmac(var text: Byte; textlen: Integer; out digest: Byte); dispid 7;
    procedure Hmac_software(var text: Byte; textlen: Integer; var key: Byte; out digest: Byte); dispid 8;
    procedure Set_key(var key: Byte); dispid 9;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TLCFULL
// Help String      : LCFULL Class
// Default Interface: ILCFULL
// Def. Intf. DISP? : No
// Event   Interface: _ILCFULLEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TLCFULL = class(TOleControl)
  private
    FIntf: ILCFULL;
    function  GetControlInterface: ILCFULL;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Open(index: Integer);
    procedure Close;
    procedure Passwd(type_: Integer; var Passwd: Byte);
    procedure Set_passwd(type_: Integer; var Passwd: Byte; retries: Integer);
    procedure Change_passwd(var oldpasswd: Byte; var newpasswd: Byte);
    procedure Get_hardware_info(type_: Integer; out info: Byte);
    procedure Hmac(var text: Byte; textlen: Integer; out digest: Byte);
    procedure Hmac_software(var text: Byte; textlen: Integer; var key: Byte; out digest: Byte);
    procedure Set_key(var key: Byte);
    property  ControlInterface: ILCFULL read GetControlInterface;
    property  DefaultInterface: ILCFULL read GetControlInterface;
  published
    property Anchors;
    property  TabStop;
    property  Align;
    property  DragCursor;
    property  DragMode;
    property  ParentShowHint;
    property  PopupMenu;
    property  ShowHint;
    property  TabOrder;
    property  Visible;
    property  OnDragDrop;
    property  OnDragOver;
    property  OnEndDrag;
    property  OnEnter;
    property  OnExit;
    property  OnStartDrag;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Standard';

  dtlOcxPage = 'Standard';

implementation

uses ComObj;

procedure TLCFULL.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{EEFB0056-0E92-44A4-8B10-0C0BD75C56A8}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TLCFULL.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as ILCFULL;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TLCFULL.GetControlInterface: ILCFULL;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TLCFULL.Open(index: Integer);
begin
  DefaultInterface.Open(index);
end;

procedure TLCFULL.Close;
begin
  DefaultInterface.Close;
end;

procedure TLCFULL.Passwd(type_: Integer; var Passwd: Byte);
begin
  DefaultInterface.Passwd(type_, Passwd);
end;

procedure TLCFULL.Set_passwd(type_: Integer; var Passwd: Byte; retries: Integer);
begin
  DefaultInterface.Set_passwd(type_, Passwd, retries);
end;

procedure TLCFULL.Change_passwd(var oldpasswd: Byte; var newpasswd: Byte);
begin
  DefaultInterface.Change_passwd(oldpasswd, newpasswd);
end;

procedure TLCFULL.Get_hardware_info(type_: Integer; out info: Byte);
begin
  DefaultInterface.Get_hardware_info(type_, info);
end;

procedure TLCFULL.Hmac(var text: Byte; textlen: Integer; out digest: Byte);
begin
  DefaultInterface.Hmac(text, textlen, digest);
end;

procedure TLCFULL.Hmac_software(var text: Byte; textlen: Integer; var key: Byte; out digest: Byte);
begin
  DefaultInterface.Hmac_software(text, textlen, key, digest);
end;

procedure TLCFULL.Set_key(var key: Byte);
begin
  DefaultInterface.Set_key(key);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TLCFULL]);
end;

end.
