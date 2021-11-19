unit CfopController;

interface

uses mvcframework, mvcframework.Commons,
     System.SysUtils, MVCFramework.SystemJSONUtils;

type

  [MVCDoc('CRUD Empresa')]
  [MVCPath('/empresa')]
  TCfopController = class(TMVCController)
  private

  public

    [MVCDoc('Retorna uma lista de objetos')]
    [MVCPath('/($filtro)')]
    [MVCHTTPMethod([httpGET])]
    procedure ConsultarLista(Context: TWebContext);

    [MVCDoc('Retorna um objeto com base no codigo')]
    [MVCPath('/($codigo)')]
    [MVCHTTPMethod([httpGET])]
    procedure ConsultarObjeto(codigo: Integer);

    [MVCDoc('Altera um objeto com base no codigo')]
    [MVCPath('/($codigo)')]
    [MVCHTTPMethod([httpPUT])]
    procedure Alterar(codigo: Integer);

    [MVCDoc('Exclui um objeto com base no Codigo')]
    [MVCPath('/($codigo)')]
    [MVCHTTPMethod([httpDelete])]
    procedure Excluir(Codigo: Integer);

  end;


implementation

uses CfopService, Cfop, Commons, Filtro, Constantes;

procedure TCfopController.ConsultarLista(Context: TWebContext);
var
  FiltroUrl, FilterWhere: string;
  FiltroObj: TFiltro;
begin
  FiltroUrl := Context.Request.Params['filtro'];
  if FiltroUrl <> '' then
  begin
    ConsultarObjeto(StrToInt(FiltroUrl));
    exit;
  end;

  FilterWhere := Context.Request.Params['filter'];
  try
    if FilterWhere = '' then
    begin
      Render<TCfop>(TCfopService.ConsultarLista);
    end
    else begin
      // define o objeto filtro
      FiltroObj := TFiltro.Create(FilterWhere);
      Render<TCfop>(TCfopService.ConsultarListaFiltro(FiltroObj.Where));
    end;
  except
    on E: EServiceException do
    begin
      raise EMVCException.Create
        ('Erro no Servidor [Consultar Lista Cfop] - Exceção: ' + E.Message,
        E.StackTrace, 0, 500);
    end
    else
      raise;
  end;
end;

procedure TCfopController.ConsultarObjeto(codigo: Integer);
var
  Cfop: TCfop;
begin
  try
    Cfop := TCfopService.ConsultarObjeto(codigo);

    if Assigned(Cfop) then
      Render(Cfop)
    else
      raise EMVCException.Create
        ('Registro não localizado [Consultar Objeto Cfop]', '', 0, 404);
  except
    on E: EServiceException do
    begin
      raise EMVCException.Create
        ('Erro no Servidor [Consultar Objeto Cfop] - Exceção: ' + E.Message,
        E.StackTrace, 0, 500);
    end
    else
      raise;
  end;
end;

procedure TCfopController.Alterar(codigo: Integer);
var
  Cfop, CfopDB: TCfop;
begin
  try
    Cfop := Context.Request.BodyAs<TCfop>;
  except
    on E: EServiceException do
    begin
      raise EMVCException.Create('Objeto inválido [Alterar Cfop] - Exceção: ' +
        E.Message, E.StackTrace, 0, 400);
    end
    else
      raise;
  end;

  if Cfop.Codigo <> codigo then
    raise EMVCException.Create('Objeto inválido [Alterar Cfop] - Codigo do objeto difere do Codigo da URL.',
      '', 0, 400);

  CfopDB := TCfopService.ConsultarObjeto(Cfop.Codigo);

  if not Assigned(CfopDB) then
    raise EMVCException.Create('Objeto com Código inválido [Alterar Cfop]',
      '', 0, 400);

  try
    if TCfopService.Alterar(Cfop) > 0 then
      Render(TCfopService.ConsultarObjeto(Cfop.Codigo))
    else
      raise EMVCException.Create('Nenhum registro foi alterado [Alterar Cfop]',
        '', 0, 500);
  finally
    FreeAndNil(EmpresaDB);
  end;
end;

procedure TCfopController.Excluir(Codigo: Integer);
var
  Cfop: TCfop;
begin
  Cfop := TCfopService.ConsultarObjeto(Codigo);

  if not Assigned(Cfop) then
    raise EMVCException.Create('Objeto com Código inválido [Excluir Cfop]',
      '', 0, 400);

  try
    if TCfopService.Excluir(Cfop) > 0 then
      Render(200, 'Objeto excluído com sucesso.')
    else
      raise EMVCException.Create('Nenhum registro foi excluído [Excluir Cfop]',
        '', 0, 500);
  finally
    FreeAndNil(Cfop);
  end;
end;

end.
