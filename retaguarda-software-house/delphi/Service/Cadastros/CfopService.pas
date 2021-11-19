unit CfopService;

interface

uses
  Cfop,
  System.Classes, System.SysUtils, System.Generics.Collections, ServiceBase,
  MVCFramework.DataSet.Utils, MVCFramework.Logger;

type

  TCfopService = class(TServiceBase)
  private
  public
    class function ConsultarLista: TObjectList<TCfop>;
    class function ConsultarListaFiltro(AWhere: string): TObjectList<TCfop>;
    class function ConsultarObjeto(ACodigo: Integer): TCfop;
    class function ConsultarObjetoFiltro(AWhere: string): TCfop;
    class procedure Inserir(ACfop: TCfop);
    class procedure Atualizar(ACfop: TCfop);
    class procedure Registrar(ACfop: TCfop);
    class function Alterar(ACfop: TCfop): Integer;
    class function Excluir(ACfop: TCfop): Integer;
  end;

implementation

{ TCfopService }

class function TCfopService.ConsultarLista: TObjectList<TCfop>;
begin
  Log('== TCfopService.ConsultarLista [BEGIN]');
  sql := 'SELECT * FROM CFOP ORDER BY CODIGO';
  try
    Result := GetQuery(sql).AsObjectList<TCfop>;
  finally
    Query.Close;
    Query.Free;
  end;
  Log('== TCfopService.ConsultarLista [END]');
end;

class function TCfopService.ConsultarListaFiltro(
  AWhere: string): TObjectList<TCFOP>;
begin
  Log('== TCfopService.ConsultarListaFiltro [BEGIN]');
  sql := 'SELECT * FROM CFOP where ' + AWhere;
  try
    Result := GetQuery(sql).AsObjectList<TCFOP>;

  finally
    Query.Close;
    Query.Free;
  end;
  Log('== TCfopService.ConsultarListaFiltro [END]');
end;

class function TCfopService.ConsultarObjeto(ACodigo: Integer): TCfop;
begin
  Log('== TCfopService.ConsultarObjeto [BEGIN]');
  sql := 'SELECT * FROM CFOP WHERE CODIGO = ' + IntToStr(ACODIGO);
  try
    GetQuery(sql);
    if not Query.Eof then
    begin
      Result := Query.AsObject<TCfop>;
    end
    else
      Result := nil;
  finally
    Query.Close;
    Query.Free;
  end;
  Log('== TCfopService.ConsultarObjeto [END]');
end;

class function TCfopService.ConsultarObjetoFiltro(AWhere: string): TCfop;
begin
  Log('== TCfopService.ConsultarObjetoFiltro [BEGIN]');
  sql := 'SELECT * FROM CFOP where ' + AWhere;
  try
    GetQuery(sql);
    if not Query.Eof then
    begin
      Result := Query.AsObject<TCfop>;
    end
    else
      Result := nil;
  finally
    Query.Close;
    Query.Free;
  end;
  Log('== TCfopService.ConsultarObjetoFiltro [END]');
end;

class procedure TCfopService.Inserir(ACfop: TCfop);
begin
  Log('== TCfopService.Inserir [BEGIN]');
  ACfop.ValidarInsercao;
  ACfop.Codigo := InserirBase(ACfop, 'CFOP');
  Log('== TCfopService.Inserir [END]');
end;

class function TCfopService.Alterar(ACfop: TCfop): Integer;
begin
  Log('== TCfopService.Alterar [BEGIN]');
  ACfop.ValidarAlteracao;
  Result := AlterarBase(ACfop, 'CFOP');
  Log('== TCfopService.Alterar [END]');
end;

class procedure TCfopService.Atualizar(ACfop: TCfop);
var
  Cfop: TCfop;
  Filtro: string;
begin
  Log('== TCfopService.Atualizar [BEGIN]');
  ACfop.Logotipo := '';

  Filtro := 'Codigo = "' + ACfop.Codigo+ '"';
  Cfop := ConsultarObjetoFiltro(filtro);
  if Assigned(Cfop) then
  begin
    ACfop.Codigo := Cfop.Codigo;
    AlterarBase(ACfop, 'CFOP');
  end
  else
  begin
    ACfop.Id := InserirBase(ACfop, 'CFOP');
  end;
  Log('== TCfopService.Atualizar [END]');
end;

class function TCfopService.Excluir(ACfop: TCfop): Integer;
begin
  Log('== TCfopService.Excluir [BEGIN]');
  ACfop.ValidarExclusao;

  Result := ExcluirBase(ACfop.Codigo, 'CFOP');
  Log('== TCfopService.Excluir [END]');
end;

class procedure TCfopService.Registrar(ACfop: TCfop);
begin

end;

end.
