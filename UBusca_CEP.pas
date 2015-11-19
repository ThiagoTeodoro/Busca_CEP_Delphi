unit UBusca_CEP;

interface

//Aqui vem as uses
uses
  Vcl.Dialogs, //Use para emitir menssagens
  System.SysUtils, //Classe padrão do Delphi para funções uteis comumente utilizadas como conversões por exemplo.
  System.Classes; //Classe também padrão do Delphi para trabalhar com a TStringList a ExtracStrings também é daqui.
  
type
  TBusca_CEP = class

  private
  {Acesso Privado da Classe}

  //Atributos da Classe
  Rua : string;
  Cidade : string;
  Estado : string;
  Tag_Abertura : string;
  Tag_Fechamento : string;

  public
  {Acesso Publico da Classe}

  //Método Construtor da Classe
  Constructor Create();

  //Métodos de Acesso nesse Caso apenas GET para os atributos da Classe
  function getRua() : string;
  function getCidade() : string;
  function getEstado() : string;

  //Métodos da Classe.
  procedure SepararRuaCidadeEstado(PaginaHTML : string);

  end;


implementation

{ TBusca_CEP }

constructor TBusca_CEP.Create;
begin

  //Inicializando as váriaveis.
  {
    O bom de Inicializar as variáveis assim, é que caso dê erro e os
    atributos não sejam setados pelo método SepararRuaCidadeEstado() quando o
    Form tentar acessar os atributos eles estarão setados com vazio e não
    nulos o que vai minimizar erros com relação a NullPointer,
    Minimizando as dores de cabeça em caso de erros ao encontrar o
    CEP ou erros da Classe. Se der erro o máximo que vai acontecer é
    os campos ficarem com a setagem de inicialização que é vazia
    ou seja não dá erro mais também não dá nada no Form =).
  }
  Self.Rua := '';
  Self.Cidade := '';
  Self.Estado := '';
  Self.Tag_Abertura := '';
  Self.Tag_Fechamento := '';

  //Configurando as Tags de abertura e fechamento que serão procuradas
  Self.Tag_Abertura := '<title>';
  Self.Tag_Fechamento := '</title>';

end;

function TBusca_CEP.getCidade: string;
begin

  //Retornando Cidade
  Result:= Self.Cidade;

end;

function TBusca_CEP.getEstado: string;
begin

  //Retornando Estado
  Result := Self.Estado;

end;

function TBusca_CEP.getRua: string;
begin

  //Retornando Rua
  Result := Rua;

end;

{
  Método que encontra as Tag's <title></title> separa o conteúdo
  entre elas, quebra os dados em vetor, retira as palavras e
  espaços desnecessários e armazena os dados de endereço nos
  atributos da classe.
}
procedure TBusca_CEP.SepararRuaCidadeEstado(PaginaHTML: string);
var
  Posicao_Tag_Abertura : Integer;
  Posicao_Tag_Fechamento : Integer;
  Diferenca_Entre_Posicoes_Tags :Integer;
  Conteudo_Entre_Tags : string;
  Lista_Quebrada_Com_Os_Dados : TStringList;

begin

  //Inicializando as váriaveis.
  Posicao_Tag_Abertura := 0;
  Posicao_Tag_Fechamento := 0;
  Diferenca_Entre_Posicoes_Tags := 0;
  Conteudo_Entre_Tags := '';

  //Instanciando Lista para receber os dados quebrados
  Lista_Quebrada_Com_Os_Dados := TStringList.Create;

  {
    Encontrando a posição da Tag_Abetura na PaginaHTML

    Lembrete :

    No Delphi as posições de uma string começam a contar do 1 e não do 0
  }
  Posicao_Tag_Abertura := Pos(Self.Tag_Abertura, PaginaHTML);

  {
    Checando se a posição da Tag_Abertura foi encontrada. Caso ela não tenha
    "sido" encontrada a variável Posicao_Tag_Abertura receberá o valor 0.
  }
  if (Posicao_Tag_Abertura = 0) then
  begin

    //Informando que a Tag de Abertura não foi encontrada.
    ShowMessage('Tag de abertura : ' + Self.Tag_Abertura + ' não foi encontrada!');

  end
  else
  begin

    {
      Se a Tag de Abertura foi encontrada, eu vou mover o ponteiro para o fim
      da Tag, pois no conteúdo que eu quero trabalhar, eu não quero que a
      Tag apareça então para fazer isso eu vou precisar mover o ponteiro
      da Posição de início da Tag de Abertura que foi obtido para o fim
      dela ou seja eu vou pular a tag. Para fazer isso basta eu adicionar à
      posição de início da Tag de Abertura o seu próprio tamanho.

      Lembrete :

      No Delphi as posições de uma string começam a contar do 1 e não do 0
    }
    Posicao_Tag_Abertura := Posicao_Tag_Abertura + Self.Tag_Abertura.Length;


    //Tag de Abertura encontrada, tentando encontrar a Tag de Fechamento
    Posicao_Tag_Fechamento := Pos(Self.Tag_Fechamento, PaginaHTML);

    {
      Checando se a posição da Tag_Fechamento foi encontrada. Caso ela não tenha
      "sido" encontrada a variável Posicao_Tag_Fechamento receberá o valor 0.
    }
    if (Posicao_Tag_Fechamento = 0) then
    begin

      //Informando que a Tag de Abertura não foi encontrada.
      ShowMessage('Tag de fechamento : ' + Self.Tag_Fechamento + ' não foi encontrada!');

    end
    else
    begin
      {
        Tag de Fechamento Encontrada. Temos as Posições das 2 Tags, Podemos
        continuar o processo de separação das Strings.
      }

      {
        Na tag de Fechamento eu não preciso pular nada pois, eu quero o conteúdo
        que está a partir do fim da Tag de Abertura até o início da Tag de
        Fechamento. Ou seja.... o Conteúdo entre as tags
      }

      {
        Obtendo o conteúdo entre as Tag's de Abertura e Fechamento [Substring]

        Detalhe, o Delphi trabalha igual ao PHP você fornece uma posição de
        início e depois informa quantas casas à frente daquela posição você
        quer pegar, ou seja, eu preciso realizar a diferença entre a Tag de
        de Fechamento e a Tag de Abertura para dizer que quero somente
        o conteúdo entre aquelas Tags.
      }

      {
        Realizando Diferença entre as Tags para informar a quantidade de
        posições que devem ser obtidas a partir da Tag_Abertura.
      }
      Diferenca_Entre_Posicoes_Tags := Posicao_Tag_Fechamento - Posicao_Tag_Abertura;


      {
        Pegando o Conteúdo Entre as Tags
        [Substring no Delphi é realizada com o Copy]
      }
      Conteudo_Entre_Tags := Copy(PaginaHTML, Posicao_Tag_Abertura, Diferenca_Entre_Posicoes_Tags);

      //Quebrando os Dados em Vetor para atribuição aos atributos da Classe

        {
          O ExtractString funciona assim você aponta o Delimitador [','] depois
          aponta o que deve ser iguinorado, que no nosso caso eu não vou iguinorar
          nada por isso []. Depois converte para PChar o conteúdo que vai ser
          quebrado, e em seguida aponta para onde vai os dados quebrados que deve
          ser um tipo TStringList.
        }
        ExtractStrings([','],[], PChar(Conteudo_Entre_Tags), Lista_Quebrada_Com_Os_Dados);

      //Fim da Quebra dos Dados em Vetor para Atribuição aos atributos da Classe

      {
        Checando se após a separação dos dados a Vetor Lista do tipo String
        possui 4 posições, pois se ele não possuir algo deu errado,
        provavelmente o CEP está incorreto ou é um CEP inválido o mesmo o CEP
        não existe na Base do Site que estamos consultado. Por tanto vou
        checar as posições se o número de posições for diferente de 4 eu vou
        levantar um erro. Se não eu vou preencher os atributos da classe.
      }
      if(Lista_Quebrada_Com_Os_Dados.Count <> 4) then
      begin

        //Erro na obtenção/separação dos dados.
        ShowMessage('Houve um erro na separação da String resultante do WebSite de consulta em Lista : TStringList. O Cep pode estar digitado incorreto ou o Cep digitado não é valido. Favor Conferir. Tamanho do Vetor Lista : ' + IntToStr(Lista_Quebrada_Com_Os_Dados.Count));

      end
      else
      begin

        //Posições na Lista/Vetor de Strings do Tipo TStringList começam no 0

        {
          Atribuindo os Dados do Endereço para os Atributos.

          O Vetor Lista de Strings está configurado da seguinte maneira

          Nome da Rua -> Posição 0
          Cidade -> Posição 1
          UF -> Posição 2

          Todos os dados precisam ser tratados, você precisa tirar um Espaço
          que existe no início de cada String e precisa remover um Prefixo
          que é adicionado nos dados da posição 0. O prefixo é 'Qual o CEP da'
          Você precisa tirar isso dos dados da rua na posição 0 e depois
          remover o Espaço ' '  no início de cada Dado, pois o Site manda os
          dados com esse espaço no início depois da vírgula. A ordem aqui tem
          importância, primeiro você tira o prefixo depois tira os espaços,
          o prefixo é só da posição 0 o espaço é de todas as posições.
        }

        //Executando Tratamentos

          //Removendo o prefixo 'Qual o CEP da'
          Lista_Quebrada_Com_Os_Dados[0] := StringReplace(Lista_Quebrada_Com_Os_Dados[0], 'Qual o CEP da', '', [rfReplaceAll]);

          {
            Removendo a primeira posição de todas as Strings com Resultado, pois,
            o espaço está na primeira posição de todas elas, é só o espaço no
            início de cada dado que eu quero remover = )

            Perceba que para fazer essa Brincadeira de remover o primeiro
            eu iniciei os Copy cortado na posição 2 até o próprio tamanho da
            String, eu começo na 2 por que no Delphi as posições de
            Strings começam a contar do 1 e não do 0, ou seja, eu pulo o
            primeiro e vou até o último assim eu elimino o primeiro carácter
            que é o maldito do espaço que eu quero tratar.
          }
          Lista_Quebrada_Com_Os_Dados[0] := Copy(Lista_Quebrada_Com_Os_Dados[0], 2, Length(Lista_Quebrada_Com_Os_Dados[0]));
          Lista_Quebrada_Com_Os_Dados[1] := Copy(Lista_Quebrada_Com_Os_Dados[1], 2, Length(Lista_Quebrada_Com_Os_Dados[1]));
          Lista_Quebrada_Com_Os_Dados[2] := Copy(Lista_Quebrada_Com_Os_Dados[2], 2, Length(Lista_Quebrada_Com_Os_Dados[2]));

          //Atribuindo os Dados trataos para os Atributos
          Self.Rua := Lista_Quebrada_Com_Os_Dados[0];
          Self.Cidade := Lista_Quebrada_Com_Os_Dados[1];
          Self.Estado := Lista_Quebrada_Com_Os_Dados[2];

      end;

    end;

  end;

  //Retirando objetos criados da Memória [O Unico aqui foi a lista]
  Lista_Quebrada_Com_Os_Dados.Free;

end;

end.
