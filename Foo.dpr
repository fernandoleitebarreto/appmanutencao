program Foo;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fMain} ,
  DatasetCopy in 'DatasetCopy.pas' {fDatasetCopy} ,
  DatasetLoop in 'DatasetLoop.pas' {fDatasetLoop} ,
  Streams in 'Streams.pas' {fStreams} ,
  Exceptions in 'Exceptions.pas' {fExceptions} ,
  UBiblioDataSet in 'UBiblioDataSet.pas',
  TrataException in 'TrataException.pas',
  uThread in 'uThread.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.Run;

end.
