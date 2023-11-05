import 'conversorMoedas.dart';

void main(){
  Fila filaTeste = Fila(firstElement: 'A');
  filaTeste.add('C');
  filaTeste.add('F');
  filaTeste.add('E');
  filaTeste.add('G');
  filaTeste.present();
  print(filaTeste.pop());
  print(filaTeste.pop());
  print(filaTeste.pop());
  print(filaTeste.pop());
  filaTeste.present();
}