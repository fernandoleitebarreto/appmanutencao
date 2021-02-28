unit TrataException;

interface

uses
  SysUtils, Forms, System.Classes, Vcl.StdCtrls;

type
  IException = interface
    ['{69C683A9-6388-40F1-9282-42C0DE5ABB70}']
    procedure TrataException(Sender: TObject; E: Exception; var Memo: TMemo);
    procedure GravarLog(Value: String);
    procedure GravarMsg(Value: String);
  end;

  TException = class(TInterfacedObject, IException)
  private
    FLogFile: String;
    FMsg: TStringList;
    FMessage: String;
    procedure SetLogFile(const Value: String);
    procedure SetMessage(const Value: String);
    procedure SetMsg(const Value: TStringList);
    function GetMessage: String;
  public
    constructor Create;
    destructor Destroy; override;

    procedure TrataException(Sender: TObject; E: Exception;
      var Memo: TMemo); overload;
    procedure TrataException(Sender: TObject; E: Exception); overload;
    procedure GravarLog(Value: String);
    procedure GravarMsg(Value: String);

    property LogFile: String read FLogFile write SetLogFile;
    property Msg: TStringList read FMsg write SetMsg;
    property Message: String read GetMessage write SetMessage;
  end;

  // Exception	      Exce��o gen�rica, usada apenas como ancestral de todas as outras exce��es
  // EAbort	          Exce��o silenciosa, pode ser gerada pelo procedimento Abort e n�o mostra nenhuma mensagem
  // EAccessViolation	Acesso inv�lido � mem�ria, geralmente ocorre com objetos n�o inicializados
  // EConvertError	  Erro de convers�o de tipos
  // EDivByZero	      Divis�o de inteiro por zero
  // EInOutError	    Erro de Entrada ou Sa�da reportado pelo sistema operacional
  // EIntOverFlow	    Resultado de um c�lculo inteiro excedeu o limite
  // EInvalidCast	    TypeCast inv�lido com o operador as
  // EInvalidOp	      Opera��o inv�lida com n�mero de ponto flutuante
  // EOutOfMemory	    Mem�ria insuficiente
  // EOverflow	      Resultado de um c�lculo com n�mero real excedeu o limite
  // ERangeError	    Valor excede o limite do tipo inteiro ao qual foi atribu�da
  // EUnderflow	      Resultado de um c�lculo com n�mero real � menor que a faixa v�lida
  // EVariantError	  Erro em opera��o com variant
  // EZeroDivide	    Divis�o de real por zero
  // EDatabaseError	  Erro gen�rico de banco de dados, geralmente n�o � usado diretamente
  // EDBEngineError	  Erro da BDE, descende de EDatabaseError e traz dados que podem identificar o erro
  //
  //
  // Read more: http://www.linhadecodigo.com.br/artigo/1258/delphi-tratamento-de-execucoes-robustas.aspx#ixzz6VPojzMWJ

  TExceptions = (EUnknown = 0, EException, EEAbort, EEConvertError);

  TExceptionsHelper = record helper for TExceptions
    function ToString: string;
    class function Parse(Value: string): TExceptions; static;
  end;

implementation

uses
  Vcl.Dialogs;

{ TException }

constructor TException.Create;
begin
  FLogFile := ChangeFileExt(ParamStr(0), '.log');
  FMsg := TStringList.Create;
  Application.OnException := TrataException;
end;

destructor TException.Destroy;
begin
  FreeAndNil(FMsg);
end;

function TException.GetMessage: String;
begin

end;

procedure TException.GravarLog(Value: String);
var
  txtLog: TextFile;
begin
  AssignFile(txtLog, FLogFile);
  if FileExists(FLogFile) then
    Append(txtLog)
  else
    Rewrite(txtLog);
  Writeln(txtLog, FormatDateTime('dd/mm/YY hh:nn:ss - ', Now) + Value);
  CloseFile(txtLog);
end;

procedure TException.GravarMsg(Value: String);
begin
  FMsg.Add(Value);
end;

procedure TException.SetLogFile(const Value: String);
begin
  FLogFile := Value;
end;

procedure TException.SetMsg(const Value: TStringList);
begin
  FMsg := Value;
end;

procedure TException.SetMessage(const Value: String);
begin
  FMessage := Value;
end;

procedure TException.TrataException(Sender: TObject; E: Exception;
  var Memo: TMemo);
begin
  TrataException(Sender, E);

  Memo.Lines := FMsg;
end;

procedure TException.TrataException(Sender: TObject; E: Exception);
begin
  FMessage := TExceptions.Parse(E.ClassName).ToString;

  GravarMsg('=================');
  GravarMsg('ClassName: ' + E.ClassName);
  GravarMsg('Messagem: ' + E.Message);
end;

{ TExceptionsHelper }

class function TExceptionsHelper.Parse(Value: string): TExceptions;
begin
  if Value = 'Exception' then
    Result := EException
  else if Value = 'EAbort' then
    Result := EEAbort
  else if Value = 'EConvertError' then
    Result := EEConvertError
  else
    Result := EUnknown;
end;

function TExceptionsHelper.ToString: string;
begin
  case self of
    EException:
      Result := 'Exce��o Gen�rica';
    EEAbort:
      Result := 'Exce��o Abortada';
    EEConvertError:
      Result := 'Erro de convers�o de tipos';
  else
    Result := '';
  end;
end;

var
  MinhaException: TException;

initialization

MinhaException := TException.Create;

finalization

MinhaException.Free;

end.
