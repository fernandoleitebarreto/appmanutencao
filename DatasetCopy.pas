unit DatasetCopy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TfDatasetCopy = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FDataset1, FDataset2: TClientDataset;
    FDataSource1, FDataSource2: TDataSource;
  public
  end;

var
  fDatasetCopy: TfDatasetCopy;

implementation

uses UBiblioDataSet;

{$R *.dfm}

procedure TfDatasetCopy.FormCreate(Sender: TObject);
begin
  inherited;
  FDataset1 := TClientDataset.Create(nil);
  FDataset2 := TClientDataset.Create(nil);
  FDataSource1 := TDataSource.Create(nil);
  FDataSource2 := TDataSource.Create(nil);

  FDataSource1.DataSet := FDataset1;
  FDataSource2.DataSet := FDataset2;

  DBGrid1.DataSource := FDataSource1;
  DBGrid2.DataSource := FDataSource2;

  DBNavigator1.DataSource := FDataSource1;

  InitDataset([FDataset1, FDataset2]);
  AddDataset(FDataset1, ['Field1Value1', 'Field1Value2', 'Field1Value3'],
    [1, 2, 3]);

  FDataset2.Data := FDataset1.Data;

end;

procedure TfDatasetCopy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FDataset1) then
    FreeAndNil(FDataset1);

  if Assigned(FDataset2) then
    FreeAndNil(FDataset2);

  if Assigned(FDataSource1) then
    FreeAndNil(FDataSource1);

  if Assigned(FDataSource2) then
    FreeAndNil(FDataSource2);

  Action := caFree;
end;

end.
