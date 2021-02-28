unit uThread;

interface

uses System.Threading, System.SysUtils, System.Classes;

type

  TProcessaThread = class(TThread)
  private
    { Private declarations }
    FEventoExecute: TProc;
    FEventoAfterExecute: TProc;
  protected
    procedure Execute; override;
  public
    constructor Create(pEventoExecute: TProc; pEventoAfterExecute: TProc = nil);
    destructor Destroy; override;

  end;

implementation

{ TProcessaThread }

constructor TProcessaThread.Create(pEventoExecute, pEventoAfterExecute: TProc);
begin
  inherited Create(False);

  Self.FEventoExecute := pEventoExecute;
  Self.FEventoAfterExecute := pEventoAfterExecute;
  Self.FreeOnTerminate := True;
  // Quando terminar de rodar o Execute, já auto destroi
end;

destructor TProcessaThread.Destroy;
begin

  inherited;
end;

procedure TProcessaThread.Execute;
begin
  inherited;
  FEventoExecute;
  try
    Self.Synchronize(nil,
      procedure
      begin
        if (not Self.Terminated) then
        begin
          if Assigned(FEventoAfterExecute) then
            FEventoAfterExecute;
        end; // if (not Terminated) then
      end);
  except
    on E: Exception do
    begin
      E.Message := 'Erro ao executar o Synchronize: ' + E.Message;
      raise;
    end;
  end;
end;

end.
