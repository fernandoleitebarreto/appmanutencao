unit DatasetLoop;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TfDatasetLoop = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button1: TButton;
    DBNavigator1: TDBNavigator;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    ClientDataSet1: TClientDataSet;
  public

  end;

var
  fDatasetLoop: TfDatasetLoop;

implementation

uses UBiblioDataSet;

{$R *.dfm}

procedure TfDatasetLoop.Button1Click(Sender: TObject);
begin
  ClientDataSet1.First;

  while not ClientDataSet1.Eof do
  begin
    if ClientDataSet1.FieldByName('Field2').AsInteger mod 2 = 0 then
      ClientDataSet1.Delete
    else
      ClientDataSet1.Next;
  end;
end;

procedure TfDatasetLoop.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(ClientDataSet1) then
    FreeAndNil(ClientDataSet1);

end;

procedure TfDatasetLoop.FormCreate(Sender: TObject);
begin
  ClientDataSet1 := TClientDataSet.Create(nil);
  DataSource1.DataSet := ClientDataSet1;
  DBNavigator1.DataSource := DataSource1;

  InitDataset(ClientDataSet1);
  AddDataSet(ClientDataSet1, ['Field1', 'Field2', 'Field3', 'Field4', 'Field5',
    'Field6', 'Field7', 'Field8', 'Field9', 'Field10'],
    [1, 2, 2, 1, 2, 2, 2, 1, 2, 1]);

end;

end.
