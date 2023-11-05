class Fila{
  List content = [];

  Fila({dynamic firstElement}){
    if (firstElement != null)
      this.content.add(firstElement);
  }

  void add(var element){
    this.content.add(element);
  }

  dynamic pop(){
    var aux = null;
    if (this.content.length > 0){
      aux = this.content.first;
      this.content.remove(aux);
    } 
    return aux;
  }

  void present(){
    int c = 0;
    this.content.forEach((element) {
      print("$c = $element");
      c++;
    });
  }
}

class Nodo{
  String? moeda;
  double? taxaConversao;
  Nodo? pai;
  List<Nodo> filhos = [];
  int profundidade = 0;
  
  Nodo(String moeda, {Nodo? nodo_pai, double? tx_convs}){
    this.moeda = moeda;
    this.pai = nodo_pai;
    this.taxaConversao = tx_convs;

    if (nodo_pai != null) this.profundidade = nodo_pai.profundidade + 1;  
    else this.profundidade = 0; 
  }

  void setFilho(Nodo newNode){
    this.filhos.add(newNode);
  }

  void present(){
    if (this.moeda == null) print("null");
    
    String append = '';
    for(int i = 0; i < this.profundidade; i++){
      append = append + '-';
    }
    print(append + this.moeda! + ' ' + this.taxaConversao.toString());
  }
}

class Arvore{
  Nodo? raiz;

  Arvore(Nodo raiz){
    this.raiz = raiz;
  }

  void show(){
    if (raiz == null) return;
    
    raiz!.present();
    raiz!.filhos.forEach((element) {
      Arvore avr = Arvore(element);
      avr.show();
    }); 
  }

  void build(Map conversoes){
    Nodo? atual = raiz;
    Fila newNodes = Fila();

    while (atual != null){
      var susc = this.sucessores(atual.moeda, conversoes);
      print(susc);

      susc.forEach((key, value) {
        var currentNode = Nodo(key[1], nodo_pai: atual, tx_convs: value);
        newNodes.add(currentNode);
        atual!.setFilho(currentNode);
      });

      atual = newNodes.pop(); 
    }
  }

  Map<List<String>, double> sucessores(String? moeda, Map conversoes){
    Map<List<String>, double> resultado = {};

    if (moeda == null) return {};
    conversoes.forEach((key, value) {
      if (key[0] == moeda){
        resultado.addAll({key : value});
      }});
    return resultado;
  }

  Nodo? search(String moeda){
    if (this.raiz == null) return null;

    Nodo? newNode = raiz;
    Fila aux = Fila();

    while((newNode != null) && (newNode.moeda != moeda)){
      newNode.filhos.forEach((element) {
        aux.add(element);
      });
      newNode = aux.pop();
    }

    return newNode;
  }
}

class Conversor{
  final Map<List<String>, double> conversoes = {["Real", "Dolar"]: 0.2,
                                                ["Dolar", "Yen"]: 150.39,
                                                ["Dolar", "Yuan"]: 7.14, 
                                                ["Yuan", "Peso Argentino"] : 47.82,
                                                ["Dolar", "Euro"] : 0.93,
                                                ["Euro", "Rupia"] : 89.28,
                                                ["Yen", "Libra"] : 0.0054,
                                                ["Libra", "Rublo"] : 113.52
                                                };

  double calculaCambio(String moeda_inicial, String moeda_alvo){
    Nodo? aux = Nodo(moeda_inicial);
    Arvore avr = Arvore(aux);
    double taxaCambio = 1;

    avr.build(this.conversoes); // Constrói uma árvore para conversão das moedas
    avr.show();  // Apresenta a árvore construida (debug)
    aux = avr.search(moeda_alvo); // Busca por um nodo da árvore com o objetivo

    // Se for encontrado, "sobe" a árvore de volta até o primeiro nodo, calculado a taxa de conversão total enquanto segue pelo caminho
    if (aux != null){
      while((aux != null) && (aux.taxaConversao != null)){
        taxaCambio = taxaCambio * aux.taxaConversao!;
        aux = aux.pai;
      }
      return taxaCambio;

    }else{
      return -1.0;
    }
  }
}

void main(){
  Conversor convs = Conversor();
  String moeda1 = "Dolar", moeda2 = "Peso Argentino";
  double resultado = convs.calculaCambio(moeda1, moeda2);
  if (resultado != -1.0){
    print("---------------------------");
    print("Taxa de Conversão de $moeda1 para $moeda2 : $resultado");
  }else{
    print("Conversão impossível com a base de dados atual");
  }
} 

/*
Objetivo = calcular a taxa de cambio de uma moeda A para uma moeda B
0. Crie um nodo baseado na moeda A e ela será a raiz da árvore
1. Encontre todas as moedas X para as quais existe um câmbio de A para X
2. Crie um nodo para cada moeda X e adicione cada nodo como filho da moeda A
3. Para cada nodo adicionado, repete esse processo até encontrar um nodo com a moeda B
4. Daí, retorna para o pai, e multiplica o valor do cambio até chegar no nodo A
*/