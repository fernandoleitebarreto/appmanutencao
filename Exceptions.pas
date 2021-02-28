unit Exceptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, TrataException, System.Threading, uThread;

type
  TfExceptions = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Memo2: TMemo;
    Label2: TLabel;
    Button2: TButton;
    Memo3: TMemo;
    Label1: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FPath: string;
    FException: TException;
    tempo: Word;

    function LoadNumbers(AIgnore: Integer): Boolean;
    procedure AfterExecute;
  public
  end;

var
  fExceptions: TfExceptions;

implementation

{$R *.dfm}

procedure TfExceptions.FormCreate(Sender: TObject);
begin
  FException := TException.Create;
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'text.txt';
end;

procedure TfExceptions.Button1Click(Sender: TObject);
var
  Task: iTask;
begin
  try
    Memo1.Lines.Clear;
    Memo2.Lines.Clear;
    tempo := GetTickCount;

    Task := TTask.Create(
      procedure
      begin
        TProcessaThread.Create(
          procedure
          begin
            LoadNumbers(1);

          end, AfterExecute);
      end);

    Task.Start;

  except
    on E: Exception do
    begin
      FException.TrataException(Sender, E, Memo1);
    end;
  end;
end;

procedure TfExceptions.Button2Click(Sender: TObject);
var
  Task: iTask;
begin

  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  tempo := GetTickCount;

  Task := TTask.Create(
    procedure
    begin
      TProcessaThread.Create(
        procedure
        var
          I: Integer;
        begin
          for I := 0 to 7 do
          begin
            try
              raise Exception.Create(Format('Erro no item %d', [I]));
              LoadNumbers(I);
            except
              on E: Exception do
              begin
                FException.TrataException(Sender, E, Memo1);
              end;
            end;
          end;
        end, AfterExecute);

    end);

  Task.Start;
end;

procedure TfExceptions.AfterExecute;
begin
  tempo := GetTickCount - tempo;
  Label1.Caption := 'Tempo de processamento: ' + tempo.ToString + ' ms';
end;

function TfExceptions.LoadNumbers(AIgnore: Integer): Boolean;
var
  st: TStringList;
  I, J: Integer;
  s: String;
  Tasks: array of iTask;
  INumRegPerTask: Integer;
  iNumTotal: Integer;
  ICountTasks: Integer;
  FIni, FFim: Integer;
begin
  st := TStringList.Create;
  st.LoadFromFile(FPath);
  Result := True;

  try
    ICountTasks := 100;
    INumRegPerTask := Trunc(st.Count / ICountTasks);

    SetLength(Tasks, ICountTasks);
    FIni := 0;

    //Exemplo
    //iNumTotal := 100.000 registros
    //ICountTasks := 100 Tasks; FIXO

    //INumRegPerTask := 1.000 registros por Task;

    //Task 1
    //FIni = 0 FFim = 1000

    //Task 2
    //FIni = 1000 FFim = 2000

    //Task 3
    //FIni = 3000 FFim = 4000

    for J := 0 to ICountTasks - 1 do
    begin
      try
        FIni := (INumRegPerTask * (J + 1)) - INumRegPerTask;
        FFim := (INumRegPerTask * (J + 1));
        Tasks[J] := TTask.Create(
          procedure
          var
            y: Integer;
          begin
            for I := FIni to FFim do
            begin
              s := st[I];
              for y := 0 to Length(s) do
                if not(s[y] = AIgnore.ToString) then
                begin
                  Memo2.Lines.Add(s[y]);
                  Sleep(1);
                end;
            end;
          end);

        Tasks[I].Start;
      except
        on E: Exception do
        begin
          FException.TrataException(nil, E, Memo1);
        end;
      end;
    end;
    TTask.WaitForAll(Tasks);

    // for I := 0 to 10 do // st.Count
    // begin
    // s := st[I];
    // for y := 0 to Length(s) do
    // if not(s[y] = AIgnore.ToString) then
    // begin
    // // Aux := s[y] + #1310;
    // Memo2.Lines.Add(s[y]);
    // end;
    // end;
  except
    Result := False;

  end;

  FreeAndNil(st);
end;

procedure TfExceptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FException) then
    FreeAndNil(FException);
  Action := caFree;
end;

end.
