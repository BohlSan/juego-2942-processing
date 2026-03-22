// ------------------------------------------------------------
// Clase: PowerUpAmetralladora
// Permite disparar con mayor cadencia al jugador.
// ------------------------------------------------------------
class PowerUpAmetralladora extends PowerUp {

  private int duracion = 4000; // 4 segundos

  PowerUpAmetralladora(float xInicial, float yInicial) {
    super(xInicial, yInicial, "data/ametralladora.png");
  }
  
  void aplicarEfecto(NaveAliada jugador) {
    jugador.activarPowerUp(duracion, "ametralladora");
  }

  String getTipo() {
    return "ametralladora";
  }
}
