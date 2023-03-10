unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, Vcl.Mask,
  CpfCnpjDBEdit;

type
  TForm1 = class(TForm)
    CpfCnpjDBEdit1: TCpfCnpjDBEdit;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ClientDataSet1CPF_CNPJ: TStringField;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    ClientDataSet1Nome: TStringField;
    CpfCnpjDBEdit2: TCpfCnpjDBEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientDataSet1.CreateDataSet;
end;

end.
