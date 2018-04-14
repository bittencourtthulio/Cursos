{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit Classes.Utils.View;

interface

uses
  FireDAC.Phys.MongoDBDataSet, FMX.ListBox, FireDAC.Phys.MongoDBWrapper;

type
  TUtilsView = class
    public
      class procedure fnc_carregarDataSet(Banco, Collection : String; var dsMongo : TFDMongoDataSet);
      class procedure fnc_montarGrid(var lv : TListBox; dsMongo : TFDMongoDataSet; Key, Value : String); overload;
      class procedure fnc_montarGrid(var lv : TListBox; dsMongo : TFDMongoDataSet; Descricao, Key, Value : String); overload;
      class function listToCurr(Value : String) : Currency;
      class procedure buscarRegistroUnico(Banco, Collection, Key : String; Value : Integer; var iCursor : iMongoCursor);
  end;

implementation

uses
  uDmDados, System.SysUtils;

{ TUtilsView }

class procedure TUtilsView.buscarRegistroUnico(Banco, Collection, Key : String; Value : Integer; var iCursor : iMongoCursor);
begin
  with dmDados do
  begin
    iCursor := FConMongo[Banco][Collection].Find()
                .Match
                  .Add(Key, Value)
                .&End;
  end;
  iCursor.Next;
end;

class procedure TUtilsView.fnc_carregarDataSet(Banco, Collection : String; var dsMongo : TFDMongoDataSet);
var
  oCrs : IMongoCursor;
begin
  with dmDados do
  begin
    oCrs := FConMongo[Banco][Collection].Find();
    dsMongo.Close;
    dsMongo.Cursor := oCrs;
    dsMongo.Open;
  end;
end;

class procedure TUtilsView.fnc_montarGrid(var lv: TListBox; dsMongo: TFDMongoDataSet;
  Key, Value: String);
var
  LBItem : TListBoxItem;
begin
  inherited;
  with dsMongo do
  begin
    First;
    lv.Items.Clear;
    while not Eof do
    begin
      lv.Items.AddObject(FieldByName(Value).AsString, TObject(FieldByName(Key).AsInteger));
      Next;
    end;
  end;
end;

class procedure TUtilsView.fnc_montarGrid(var lv: TListBox;
  dsMongo: TFDMongoDataSet; Descricao, Key, Value: String);
var
  lbItem : TListBoxItem;
begin
  dsMongo.First;
  lv.Items.Clear;
  while not dsMongo.Eof do
  begin
    lbItem := TListBoxItem.Create(nil);
    lbItem.StyleLookup := 'ListBoxItemServico';
    lbItem.StylesData['descricao'] := dsMongo.FieldByName(Descricao).AsString;
    lbItem.StylesData['valor'] := FormatCurr('R$ #,##0.00',  dsMongo.FieldByName(Value).AsCurrency);
    lbItem.StylesData['key'] := dsMongo.FieldByName(Key).AsString;
    lv.AddObject(lbItem);
    dsMongo.Next;
  end;
end;

class function TUtilsView.listToCurr(Value: String): Currency;
var
  I : Byte;
  Aux : String;
begin
  Aux := '';
  for I := 1 to Length(Value) do
    if (Value [I] in ['0'..'9']) then
      Aux := Aux + Value[I];
  Result := StrToCurr(Aux) / 100;

end;

end.
