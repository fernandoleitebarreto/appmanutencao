unit Streams;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TfStreams = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FPath: string;
    S: TStream;
    function LoadStream: TMemoryStream;
  public
  end;

var
  fStreams: TfStreams;

implementation

{$R *.dfm}

procedure TfStreams.Button1Click(Sender: TObject);
begin
  S := LoadStream;
  try
    Label1.Caption := 'Size: ' + (S.Size div 1024).ToString + ' MB';
  finally
    FreeAndNil(S);
  end;
end;

procedure TfStreams.Button2Click(Sender: TObject);
var
  i, SizeInc: Integer;
begin
  S := LoadStream;
  try
    ProgressBar1.Position := 0;
    ProgressBar1.Max := 100;
    SizeInc := 0;

    for i := 0 to 99 do
    begin
      SizeInc := SizeInc + S.Size;
      ProgressBar1.Position := ProgressBar1.Position + 1;
    end;

    Label2.Caption := 'Size: ' + (SizeInc div 1024).ToString + ' MB';
  finally
    Application.ProcessMessages;
    FreeAndNil(S);
  end;

end;

procedure TfStreams.FormCreate(Sender: TObject);
begin
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'pdf.pdf';
end;

function TfStreams.LoadStream: TMemoryStream;
begin
  Result := TMemoryStream.Create;
  if FileExists(FPath) then
  begin
    Result.LoadFromFile(FPath);
  end;
end;

end.
