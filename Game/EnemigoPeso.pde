abstract class EnemigoPeso {
  private float peso;

  EnemigoPeso(float peso) {
    this.peso = peso;
  }
  abstract NaveEnemiga generar();
}
