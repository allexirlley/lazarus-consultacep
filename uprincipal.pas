unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, httpsend, fpjson, jsonparser;

type

  { TfrmConsultaCEP }

  TfrmConsultaCEP = class(TForm)
    btnConsultar: TButton;
    edtEstadoAbreviado: TEdit;
    edtLogradouro: TEdit;
    edtBairro: TEdit;
    edtCidade: TEdit;
    edtEstado: TEdit;
    edtCEP: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblCEP: TLabel;
    memoJson: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnConsultarClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmConsultaCEP: TfrmConsultaCEP;

const
  url: String = 'http://api.postmon.com.br/v1/cep/';

implementation

{$R *.lfm}

{ TfrmConsultaCEP }

procedure TfrmConsultaCEP.btnConsultarClick(Sender: TObject);
var
  sl: TStringList;
  jDados: TJSONData;
begin
  if (edtCEP.Text <> '') then
     begin
        sl := TStringList.Create;
        memoJson.Lines.Clear;

        edtLogradouro.Text := '';
        edtBairro.Text := '';
        edtCidade.Text := '';
        edtEstado.Text := '';

        try
          try
            if HttpGetText(url + edtCEP.Text, sl) then
            begin
               memoJson.Lines.Add(sl.Text);

               jDados := GetJSON(sl.Text);

               edtLogradouro.Text := jDados.FindPath('logradouro').AsString;
               edtBairro.Text := jDados.FindPath('bairro').AsString;
               edtCidade.Text := jDados.FindPath('cidade').AsString;
               edtEstado.Text := jDados.FindPath('estado_info.nome').AsString;
               edtEstadoAbreviado.Text := jDados.FindPath('estado').AsString;
            end
            else
            begin
                memoJson.Lines.Add('Nao foi possivel consultar o CEP!');
            end;
          except
            ShowMessage('Nao foi possivel encontrar o CEP!');
          end;
        finally
               sl.Free;
        end;

     end
    else
    begin
      memoJson.Lines.Add('Digitar o CEP no campo.');
      edtCEP.SetFocus;
    end;

end;

end.

