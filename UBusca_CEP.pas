unit UBusca_CEP;

interface

//Aqui vem as uses
uses
  Vcl.Dialogs, //Use para emitir menssagens
  System.SysUtils, //Classe padr�o do Delphi para fun��es uteis comumente utilizadas como convers�es por exemplo.
  System.Classes; //Classe tamb�m padr�o do Delphi para trabalhar com a TStringList a ExtracStrings tamb�m � daqui.
  
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

  //M�todo Construtor da Classe
  Constructor Create();

  //M�todos de Acesso nesse Caso apenas GET para os atributos da Classe
  function getRua() : string;
  function getCidade() : string;
  function getEstado() : string;

  //M�todos da Classe.
  procedure SepararRuaCidadeEstado(PaginaHTML : string);

  end;


implementation

{ TBusca_CEP }

constructor TBusca_CEP.Create;
begin

  //Inicializando as v�riaveis.
  {
    O bom de Inicializar as vari�veis assim, � que caso d� erro e os
    atributos n�o sejam setados pelo m�todo SepararRuaCidadeEstado() quando o
    Form tentar acessar os atributos eles estar�o setados com vazio e n�o
    nulos o que vai minimizar erros com rela��o a NullPointer,
    Minimizando as dores de cabe�a em caso de erros ao encontrar o
    CEP ou erros da Classe. Se der erro o m�ximo que vai acontecer �
    os campos ficarem com a setagem de inicializa��o que � vazia
    ou seja n�o d� erro mais tamb�m n�o d� nada no Form =).
  }
  Self.Rua := '';
  Self.Cidade := '';
  Self.Estado := '';
  Self.Tag_Abertura := '';
  Self.Tag_Fechamento := '';

  //Configurando as Tags de abertura e fechamento que ser�o procuradas
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
  M�todo que encontra as Tag's <title></title> separa o conte�do
  entre elas, quebra os dados em vetor, retira as palavras e
  espa�os desnecess�rios e armazena os dados de endere�o nos
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

  //Inicializando as v�riaveis.
  Posicao_Tag_Abertura := 0;
  Posicao_Tag_Fechamento := 0;
  Diferenca_Entre_Posicoes_Tags := 0;
  Conteudo_Entre_Tags := '';

  //Instanciando Lista para receber os dados quebrados
  Lista_Quebrada_Com_Os_Dados := TStringList.Create;

  {
    Encontrando a posi��o da Tag_Abetura na PaginaHTML

    Lembrete :

    No Delphi as posi��es de uma string come�am a contar do 1 e n�o do 0
  }
  Posicao_Tag_Abertura := Pos(Self.Tag_Abertura, PaginaHTML);

  {
    Checando se a posi��o da Tag_Abertura foi encontrada. Caso ela n�o tenha
    "sido" encontrada a vari�vel Posicao_Tag_Abertura receber� o valor 0.
  }
  if (Posicao_Tag_Abertura = 0) then
  begin

    //Informando que a Tag de Abertura n�o foi encontrada.
    ShowMessage('Tag de abertura : ' + Self.Tag_Abertura + ' n�o foi encontrada!');

  end
  else
  begin

    {
      Se a Tag de Abertura foi encontrada, eu vou mover o ponteiro para o fim
      da Tag, pois no conte�do que eu quero trabalhar, eu n�o quero que a
      Tag apare�a ent�o para fazer isso eu vou precisar mover o ponteiro
      da Posi��o de in�cio da Tag de Abertura que foi obtido para o fim
      dela ou seja eu vou pular a tag. Para fazer isso basta eu adicionar �
      posi��o de in�cio da Tag de Abertura o seu pr�prio tamanho.

      Lembrete :

      No Delphi as posi��es de uma string come�am a contar do 1 e n�o do 0
    }
    Posicao_Tag_Abertura := Posicao_Tag_Abertura + Self.Tag_Abertura.Length;


    //Tag de Abertura encontrada, tentando encontrar a Tag de Fechamento
    Posicao_Tag_Fechamento := Pos(Self.Tag_Fechamento, PaginaHTML);

    {
      Checando se a posi��o da Tag_Fechamento foi encontrada. Caso ela n�o tenha
      "sido" encontrada a vari�vel Posicao_Tag_Fechamento receber� o valor 0.
    }
    if (Posicao_Tag_Fechamento = 0) then
    begin

      //Informando que a Tag de Abertura n�o foi encontrada.
      ShowMessage('Tag de fechamento : ' + Self.Tag_Fechamento + ' n�o foi encontrada!');

    end
    else
    begin
      {
        Tag de Fechamento Encontrada. Temos as Posi��es das 2 Tags, Podemos
        continuar o processo de separa��o das Strings.
      }

      {
        Na tag de Fechamento eu n�o preciso pular nada pois, eu quero o conte�do
        que est� a partir do fim da Tag de Abertura at� o in�cio da Tag de
        Fechamento. Ou seja.... o Conte�do entre as tags
      }

      {
        Obtendo o conte�do entre as Tag's de Abertura e Fechamento [Substring]

        Detalhe, o Delphi trabalha igual ao PHP voc� fornece uma posi��o de
        in�cio e depois informa quantas casas � frente daquela posi��o voc�
        quer pegar, ou seja, eu preciso realizar a diferen�a entre a Tag de
        de Fechamento e a Tag de Abertura para dizer que quero somente
        o conte�do entre aquelas Tags.
      }

      {
        Realizando Diferen�a entre as Tags para informar a quantidade de
        posi��es que devem ser obtidas a partir da Tag_Abertura.
      }
      Diferenca_Entre_Posicoes_Tags := Posicao_Tag_Fechamento - Posicao_Tag_Abertura;


      {
        Pegando o Conte�do Entre as Tags
        [Substring no Delphi � realizada com o Copy]
      }
      Conteudo_Entre_Tags := Copy(PaginaHTML, Posicao_Tag_Abertura, Diferenca_Entre_Posicoes_Tags);

      //Quebrando os Dados em Vetor para atribui��o aos atributos da Classe

        {
          O ExtractString funciona assim voc� aponta o Delimitador [','] depois
          aponta o que deve ser iguinorado, que no nosso caso eu n�o vou iguinorar
          nada por isso []. Depois converte para PChar o conte�do que vai ser
          quebrado, e em seguida aponta para onde vai os dados quebrados que deve
          ser um tipo TStringList.
        }
        ExtractStrings([','],[], PChar(Conteudo_Entre_Tags), Lista_Quebrada_Com_Os_Dados);

      //Fim da Quebra dos Dados em Vetor para Atribui��o aos atributos da Classe

      {
        Checando se ap�s a separa��o dos dados a Vetor Lista do tipo String
        possui 4 posi��es, pois se ele n�o possuir algo deu errado,
        provavelmente o CEP est� incorreto ou � um CEP inv�lido o mesmo o CEP
        n�o existe na Base do Site que estamos consultado. Por tanto vou
        checar as posi��es se o n�mero de posi��es for diferente de 4 eu vou
        levantar um erro. Se n�o eu vou preencher os atributos da classe.
      }
      if(Lista_Quebrada_Com_Os_Dados.Count <> 4) then
      begin

        //Erro na obten��o/separa��o dos dados.
        ShowMessage('Houve um erro na separa��o da String resultante do WebSite de consulta em Lista : TStringList. O Cep pode estar digitado incorreto ou o Cep digitado n�o � valido. Favor Conferir. Tamanho do Vetor Lista : ' + IntToStr(Lista_Quebrada_Com_Os_Dados.Count));

      end
      else
      begin

        //Posi��es na Lista/Vetor de Strings do Tipo TStringList come�am no 0

        {
          Atribuindo os Dados do Endere�o para os Atributos.

          O Vetor Lista de Strings est� configurado da seguinte maneira

          Nome da Rua -> Posi��o 0
          Cidade -> Posi��o 1
          UF -> Posi��o 2

          Todos os dados precisam ser tratados, voc� precisa tirar um Espa�o
          que existe no in�cio de cada String e precisa remover um Prefixo
          que � adicionado nos dados da posi��o 0. O prefixo � 'Qual o CEP da'
          Voc� precisa tirar isso dos dados da rua na posi��o 0 e depois
          remover o Espa�o ' '  no in�cio de cada Dado, pois o Site manda os
          dados com esse espa�o no in�cio depois da v�rgula. A ordem aqui tem
          import�ncia, primeiro voc� tira o prefixo depois tira os espa�os,
          o prefixo � s� da posi��o 0 o espa�o � de todas as posi��es.
        }

        //Executando Tratamentos

          //Removendo o prefixo 'Qual o CEP da'
          Lista_Quebrada_Com_Os_Dados[0] := StringReplace(Lista_Quebrada_Com_Os_Dados[0], 'Qual o CEP da', '', [rfReplaceAll]);

          {
            Removendo a primeira posi��o de todas as Strings com Resultado, pois,
            o espa�o est� na primeira posi��o de todas elas, � s� o espa�o no
            in�cio de cada dado que eu quero remover = )

            Perceba que para fazer essa Brincadeira de remover o primeiro
            eu iniciei os Copy cortado na posi��o 2 at� o pr�prio tamanho da
            String, eu come�o na 2 por que no Delphi as posi��es de
            Strings come�am a contar do 1 e n�o do 0, ou seja, eu pulo o
            primeiro e vou at� o �ltimo assim eu elimino o primeiro car�cter
            que � o maldito do espa�o que eu quero tratar.
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

  //Retirando objetos criados da Mem�ria [O Unico aqui foi a lista]
  Lista_Quebrada_Com_Os_Dados.Free;

end;

end.
