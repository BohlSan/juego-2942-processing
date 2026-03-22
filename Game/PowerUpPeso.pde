abstract class PowerUpPeso {
  private float peso;

  PowerUpPeso(float peso) {
    this.peso = peso;
  }

  abstract PowerUp generar();
}
