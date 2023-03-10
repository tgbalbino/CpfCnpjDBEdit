{
 TCpfCnpjDBEdit Component
 First Version (2023) by: Thiago Balbino. (https://specials.rejbrand.se/dev/controls/tageditor/)
 Componente para Mascarar e Gravar em campo de Dataset/Query automaticament um CPF OU CNPJ apos digitar informação
}

unit CpfCnpjDBEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Db, Windows, Messages,  Variants,  Graphics, Forms,
  Dialogs;

type
  TCpfCnpjDBEdit = class(TDBEdit)
   procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMKEYUP(var Message: TWMPaint); message WM_KEYUP;
  private
    FIsUnMask: Boolean;
    FFirst: Boolean;
    FPaintedRed: Boolean;
    FRequired: Boolean;
    procedure CheckForInvalidate;
    function HasLinked: Boolean;
    procedure Mask;
    function hasMask: Boolean;
    procedure unMaskIfNeed;
    procedure removeMask;
    { Private declarations }
  protected
    procedure Change; override;
    procedure DoExit; override;
    procedure DoEnter; override;
    procedure KeyPress(var Key: Char); override;
//   property Mask: String read FMask write FMask;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function IsValid: boolean;
    { Public declarations }
  published
    Property Required: Boolean read FRequired Write FRequired;
    { Published declarations }
  end;

Const
  MascaraCPF_ = '###\.###\.###\-##;0;_';
  MascaraCNPJ_: string = '##\.###\.###\/####\-##;0;_';


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TCpfCnpjDBEdit]);
end;

function RemoveChar(const Texto: string): string;
var
  I: Integer;
  S: string;
begin
  S := '';
  for I := 1 to length(Texto) do
  begin
    if CharInSet(Texto[I], ['0' .. '9']) then
    begin
      S := S + Copy(Texto, I, 1);
    end;
  end;
  Result := S;
end;

{ TCpfCnpjDBEdit }

procedure TCpfCnpjDBEdit.Change;
begin
  OutputDebugString(Pchar('Change'));

  if (FIsUnMask) then
  Exit;

  //if (hasMask) then
  //unMaskIfNeed;

  //Aplicar mascara ao criar Objeto
  if (Self.FFirst) and (RemoveChar(TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).Value) <> '') then
  begin
    Self.FFirst:= False;
    Mask;
  end;

  inherited;
end;

procedure TCpfCnpjDBEdit.CheckForInvalidate;
begin
  if  Required and (Length(Trim(Text)) = 0) then
  begin
    if not FPaintedRed then
      Invalidate;
  end
  else if FPaintedRed then
    Invalidate;
end;

procedure TCpfCnpjDBEdit.CMTextChanged(var Message: TMessage);
begin
  CheckForInvalidate;
end;

constructor TCpfCnpjDBEdit.Create(AOwner: TComponent);
begin
  Self.FFirst:= true;
  Self.FIsUnMask:= False;
  OutputDebugString(Pchar('Create'));

  inherited;
end;

procedure TCpfCnpjDBEdit.DoEnter;
begin
  try
    if (HasLinked) then
    removeMask;
  except
    //no error message
  end;

 inherited;
end;

procedure TCpfCnpjDBEdit.DoExit;
var
  Val: string;
begin
  Mask;

  inherited;
end;

function TCpfCnpjDBEdit.HasLinked: Boolean;
begin
  Result := (Self.DataSource <> nil) and (Self.DataField <> '');
end;

function TCpfCnpjDBEdit.hasMask: Boolean;
begin
  Result := (Self.DataSource <> nil) and
             (Self.DataField <> '')  and
            (TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).EditMask <> '');
end;

function TCpfCnpjDBEdit.IsValid: boolean;
begin

end;

procedure TCpfCnpjDBEdit.KeyPress(var Key: Char);
begin
  if not CharInSet(key, ['0'..'9', #13, #8]) then
  Key := #0;

  inherited;
end;

procedure TCpfCnpjDBEdit.Mask;
var
  val: String;
begin
  try
    if (HasLinked) then
    begin
      Val := RemoveChar(TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).Value);

      if Length(Val) = 11 then
      TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).EditMask := MascaraCPF_
      else if Length(Val) = 14 then
      TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).EditMask := MascaraCNPJ_
      else
      TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).EditMask := '';
    end;
  except
    //no error message
  end;
end;

procedure TCpfCnpjDBEdit.removeMask;
begin
  FIsUnMask := true;
  TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).EditMask := '';
  OutputDebugString(Pchar('removeMask.Mask: ' + TStringField(Self.DataSource.DataSet.FieldByName(Self.DataField)).EditMask));
  FIsUnMask := False;
end;

procedure TCpfCnpjDBEdit.unMaskIfNeed;
begin
  if (hasMask) then
  removeMask;
end;

procedure TCpfCnpjDBEdit.WMKEYUP(var Message: TWMPaint);
begin
  CheckForInvalidate;
end;

procedure TCpfCnpjDBEdit.WMPaint(var Message: TWMPaint);
var
  CC: TControlCanvas;
begin
  inherited;
  if (Required) and (Length(Trim(Text)) = 0) then
  begin
    FPaintedRed := true;
    CC := TControlCanvas.Create;
    try
      CC.Control := Self;
      CC.Pen.Color := clRed;
      CC.Pen.Width := 1;
      CC.Rectangle(ClientRect);
    finally
      CC.Free;
    end;
  end
  else
    FPaintedRed := false;
end;

end.
