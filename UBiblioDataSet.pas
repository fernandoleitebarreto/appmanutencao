unit UBiblioDataSet;

interface

uses Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls;

procedure InitDataset(pDataSet: TClientDataSet); overload;
procedure InitDataset(pDataSet: Array of TClientDataSet); overload;
procedure AddDataset(pDataSet: TClientDataSet; pFields1: array of string;
  pFields2: array of Integer);

implementation

procedure InitDataset(pDataSet: TClientDataSet);
begin
  InitDataset([pDataSet]);
end;

procedure InitDataset(pDataSet: Array of TClientDataSet);
var
  I: Integer;
begin
  for I := 0 to Length(pDataSet) - 1 do
  begin
    if pDataSet[I].active then
      pDataSet[I].Close;
    pDataSet[I].FieldDefs.Clear;
    pDataSet[I].FieldDefs.Add('Field1', ftString, 20);
    pDataSet[I].FieldDefs.Add('Field2', ftInteger);
    pDataSet[I].CreateDataSet;
  end;
end;

procedure AddDataset(pDataSet: TClientDataSet; pFields1: array of string;
  pFields2: array of Integer);
var
  I: Integer;
begin
  if Length(pFields1) = 0 then
    ShowMessage('Não foi informado nenhum valor para o primeiro campo')
  else if Length(pFields2) = 0 then
    ShowMessage('Não foi informado nenhum valor para o segundo campo')
  else if Length(pFields1) <> Length(pFields2) then
    ShowMessage('Tamanho do Field 1 difere do Field 2')
  else
  begin
    for I := 0 to Length(pFields1) - 1 do
    begin
      pDataSet.Append;
      pDataSet.FieldByName('Field1').AsString := pFields1[I];
      pDataSet.FieldByName('Field2').AsInteger := pFields2[I];
      pDataSet.Post;
    end;
  end;
end;

end.
