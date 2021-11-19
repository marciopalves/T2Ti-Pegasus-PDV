unit Cfop;

interface
uses
  MVCFramework.Serializer.Commons, ModelBase;

type

  [MVCNameCase(ncLowerCase)]
  TCFOP = class(TModelBase)
  private
    FDescricao: String;
    FCodigo: Integer;

  public
    [MVCColumnAttribute('Codigo', True)]
    [MVCNameAsAttribute('Codigo')]
    property Codigo: Integer read FCodigo write FCodigo;
    [MVCColumnAttribute('Descricao', True)]
    [MVCNameAsAttribute('Descricao')]
    property Descricao: String read FDescricao write FDescricao;
  end;

implementation

end.
