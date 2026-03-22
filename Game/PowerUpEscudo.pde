// ------------------------------------------------------------
// Clase: PowerUpEscudo
// Activa un escudo temporal alrededor del jugador.
// ------------------------------------------------------------
class PowerUpEscudo extends PowerUp {

  private int duracion = 5000; // 5 segundos

  PowerUpEscudo(float xInicial, float yInicial) {
    super(xInicial, yInicial, "data/escudo.png");
  }

  /*void aplicarEfecto(NaveAliada jugador) {
    jugador.activarPowerUp(duracion, "escudo");
    activo = false;
  }*/
  
  void aplicarEfecto(NaveAliada jugador) {
    jugador.activarPowerUp(duracion, "escudo");
  }

  String getTipo() {
    return "escudo";
  }
}
