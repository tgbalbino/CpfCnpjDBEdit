{
 TCpfCnpjDBEdit Component Feito para o Delphi 10.3 não testado em outras versões
 Componente para Mascarar e Gravar em campo de Dataset/Query automaticament um CPF OU CNPJ apos digitar informação
 Atenção o componente salva no Cliente ou Query somente os valores sem a formatação ou seja a mesma é só visual
 First Version: 2023
 by: Thiago Balbino
 Data: 10/03/2013

 Possiveis futuras implementaões
   * Isvalid ( validar se o documento informado é válido)
   * Type ( tdCpf, tdCPNJ, tdCpfCnpj) propriedade só aceite digitar um CPF ou CNPJ com padrão tdCpfCnpj
   * Validar ao Colar(Ctrl + V) um conteudo e aceitar somente números.

   Sugestoes e melhorias são bem vindas: tecnologiaminas@gmail.com
}

unit CpfCnpjDBEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Db, Windows, Messages,  Variants,  Graphics, Forms,
  Dialogs, Clipbrd;

type
  TCpfCnpjDBEdit = class(TDBEdit)
   procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMKEYUP(var Message: TWMPaint); message WM_KEYUP;
  private
    FDocValidar: String;
    FIsUnMask: Boolean;
    FFirst: Boolean;
    FRaiseExcepOnValidade: Boolean;
    FPaintedRed: Boolean;
    FRequired: Boolean;
    procedure CheckForInvalidate;
    function HasLinked: Boolean;
    procedure Mask;
    function hasMask: Boolean;
    procedure unMaskIfNeed;
    procedure removeMask;

    function ValidarCNPJouCPF: boolean;
    function ValidarCPF: boolean ;
    function ValidarCNPJ: boolean ;
    { Private declarations }
  protected
    procedure WMPaste(var Msg: TWMPaste); message WM_PASTE;
    procedure Change; override;
    procedure DoExit; override;
    procedure DoEnter; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
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

function CharIsNum(const C: Char): Boolean;
begin
  Result := CharInSet( C, ['0'..'9'] ) ;
end ;

function OnlyNumber(const AValue: String): String;
Var
  I : Integer ;
  LenValue : Integer;
begin
  Result   := '' ;
  LenValue := Length( AValue ) ;
  For I := 1 to LenValue  do
  begin
    if CharIsNum( AValue[I] ) then
        Result := Result + AValue[I];
  end;
end;

function StrIsNumber(const S: String): Boolean;
Var
  A, LenStr : Integer ;
begin
  LenStr := Length( S ) ;
  Result := (LenStr > 0) ;
  A      := 1 ;
  while Result and ( A <= LenStr )  do
  begin
     Result := CharIsNum( S[A] ) ;
     Inc(A) ;
  end;
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
  if (not ValidarCNPJouCPF)  then
  begin
    if (FRaiseExcepOnValidade) then
    raise Exception.Create('CPF ou CNPJ Inválido.')
    else
    Result := False;
  end;
end;

procedure TCpfCnpjDBEdit.KeyDown(var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if ((ssCtrl in Shift) AND (Key = ord('V'))) then
  begin
    //if Clipboard.HasFormat(CF_TEXT) then ClipBoard.Clear;
    //if ( Clipboard.ToString) then


   // Edit1.SelText := '"Colar" DESATIVADO!';
  end;
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

function TCpfCnpjDBEdit.ValidarCNPJ: boolean ;
Var DV1, DV2, fsDocto, fsMsgErro: String ;
begin
  fsDocto:= Self.Text;
  Result := False;

  if (Length( fsDocto ) <> 14) or ( not StrIsNumber( fsDocto ) ) then
  begin
    fsMsgErro := 'CNPJ deve ter 14 dígitos. (Apenas números)' ;
    exit;
  end ;

  if fsDocto = StringOfChar('0',14) then  // Prevenção contra 00000000000000
  begin
    fsMsgErro := 'CNPJ inválido.' ;
    exit;
  end;

  {Modulo.CalculoPadrao ;
  Modulo.Documento := copy(fsDocto, 1, 12) ;
  Modulo.Calcular ;
  DV1 := IntToStr( Modulo.DigitoFinal ) ;

  Modulo.Documento := copy(fsDocto, 1, 12)+DV1 ;
  Modulo.Calcular ;
  DV2 := IntToStr( Modulo.DigitoFinal ) ;

  fsDigitoCalculado := DV1+DV2 ;

  if (DV1 <> fsDocto[13]) or (DV2 <> fsDocto[14]) then
  begin
     fsMsgErro := 'CNPJ inválido.' ;
  end
  else
   Result := True;    }

end;

function TCpfCnpjDBEdit.ValidarCNPJouCPF;
Var
  NumDocto : String ;
begin
   FDocValidar := OnlyNumber(Self.Text) ;
   if Length(NumDocto) < 12 then
      Result := ValidarCPF
   else
      Result := ValidarCNPJ;
end;

function TCpfCnpjDBEdit.ValidarCPF: Boolean;
Var DV1, DV2, fsDocto, fsMsgErro: String;
begin
  fsDocto:= FDocValidar;
  Result := False;

  if (Length( fsDocto ) <> 11) or ( not StrIsNumber( fsDocto ) ) then
  begin
    fsMsgErro := 'CPF deve ter 11 dígitos. (Apenas números)' ;
    exit
  end ;

  if pos(fsDocto,'11111111111.22222222222.33333333333.44444444444.55555555555.'+
         '66666666666.77777777777.88888888888.99999999999.00000000000') > 0 then
  begin
    fsMsgErro := 'CPF inválido !' ;
    exit ;
  end ;


  {Modulo.MultiplicadorInicial := 2  ;
  Modulo.MultiplicadorFinal   := 11 ;
  Modulo.FormulaDigito        := frModulo11 ;
  Modulo.Documento := copy(fsDocto, 1, 9) ;
  Modulo.Calcular ;
  DV1 := IntToStr( Modulo.DigitoFinal ) ;

  Modulo.Documento := copy(fsDocto, 1, 9)+DV1 ;
  Modulo.Calcular ;
  DV2 := IntToStr( Modulo.DigitoFinal ) ;

  fsDigitoCalculado := DV1+DV2 ;

  if (DV1 <> fsDocto[10]) or (DV2 <> fsDocto[11]) then
  begin
     fsMsgErro := 'CPF inválido.' ;

     if fsExibeDigitoCorreto then
        fsMsgErro := fsMsgErro + '.. Dígito calculado: '+fsDigitoCalculado ;
  end ;  }

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

procedure TCpfCnpjDBEdit.WMPaste(var Msg: TWMPaste);
begin
  OutputDebugString(Pchar('TCpfCnpjDBEdit.WMPaste'));
 // if True then
 // else
  inherited;
end;

end.
