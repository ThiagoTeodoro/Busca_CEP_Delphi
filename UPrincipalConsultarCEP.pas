unit UPrincipalConsultarCEP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Mask, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP,
  UBusca_CEP; //Use para processar o Html e encontrar os Dados do Cep

type
  TFormPrincipalConsultarCEP = class(TForm)
    LabelTituloCEP: TLabel;
    SpeedButtonPesquisar: TSpeedButton;
    MaskEditCEP: TMaskEdit;
    IdHTTP: TIdHTTP;
    LabelEndereco: TLabel;
    LabelCidade: TLabel;
    LabelEstado: TLabel;
    EditEndereco: TEdit;
    EditCidade: TEdit;
    EditEstado: TEdit;
    procedure SpeedButtonPesquisarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  {
    NOTAS DO LAYOUT DA JANELA.

    Para configurar uma Máscara no CEP eu utilizei o componente MaskEdit. Ele
    tem uma propriedade a EditMask que permite realizar a elaboração de uma
    mascara. Através disso eu coloquei a máscara do CEP 00000-000. Para colocar
    essa máscara o componente fornece uma “fabrica de máscaras” lá eu setei a
    máscara como 00000-000 dai já ficou todo configurado.


    Para conseguir pegar/obter o HTML de uma página eu vou precisar usar o
    componente IdHttp que está colocado nesse Form e ele que captura o HTML
    da página e coloca em uma String.


    A Classe que está realmente fazendo o processamento é a UBusca_CEP
    eu apenas obtenho os dados aqui, por que o componente que obtêm o
    HTML só funciona em Forms, e mando o HTML da Busca já efetuada
    para tratamento na UBusca_CEP, ela então trata de ler, identificar
    as Tag's <title></title> e tratar o resultado entre essas Tag's.
    A Classe da UBusca_CEP é a TBusca_CEP

  }

var
  FormPrincipalConsultarCEP: TFormPrincipalConsultarCEP;

implementation

{$R *.dfm}

procedure TFormPrincipalConsultarCEP.SpeedButtonPesquisarClick(Sender: TObject);
var
  URL_Busca : string;
  CEP : string;
  Resultado_Busca_Pagina_HTML :string;
  Busca_CEP : TBusca_CEP;
  teste : TStringList;

begin
  //Ação do Botão Pesquisar CEP

    //Inicializando Variáveis (Boa prática);
    URL_Busca := '';
    CEP := '';
    Resultado_Busca_Pagina_HTML := '';

    //Criando Objeto Busca_CEP para enviar os dados da página recebida da Busca
    Busca_CEP := TBusca_CEP.Create;

    //Configurando URL_Busca para efeturar a Busca
    URL_Busca := 'http://www.qualocep.com/busca-cep';

    {
      Retirando do CEP o carácter separador "-" que não é utilizado para fazer
      a busca no site. A Sentença [rfReplaceAll] é padrão informa que é para ser
      feito o replace de todos as ocorrências encontradas iguais '-'.
    }
    CEP := StringReplace(MaskEditCEP.Text, '-', '', [rfReplaceAll]);

    {
      Concatenando o CEP digitado com a URL_Busca para realizar a Busca do CEP
      no Site de Busca de CEP's e obter a página HTML com os dados de Endereço
      do CEP solicitado. Eu concateno e armazeno na própria URL_Busca.
    }
    URL_Busca := URL_Busca + '/' + CEP;

    {
      Efetuando a Busca do CEP no Site de Busca de Cep's http://www.qualocep.com
      e armazenando o resultado em Resultado_Busca_Pagina_HTML
    }
    Resultado_Busca_Pagina_HTML := IdHTTP.Get(URL_Busca);

    //Enviando Resultado da Busca para Tratamento em UBusca_CEP
    Busca_CEP.SepararRuaCidadeEstado(Resultado_Busca_Pagina_HTML);

    //Atribuindo para os campos do Form os CEP encontrado se ele for encontrado
    EditEndereco.Text := Busca_CEP.getRua;
    EditCidade.Text   := Busca_CEP.getCidade;
    EditEstado.Text   := Busca_CEP.getEstado;

    //Retirando objetos criados da memória [O Unico aqui foi o Busca_CEP]
    Busca_CEP.Free;

end;

end.
