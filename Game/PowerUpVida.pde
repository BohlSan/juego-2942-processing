// ------------------------------------------------------------
// Clase: PowerUpVida
// Aumenta una vida del jugador (si no tiene el máximo).
// ------------------------------------------------------------
class PowerUpVida extends PowerUp {

  PowerUpVida(float xInicial, float yInicial) {
    super(xInicial, yInicial, "data/corazon.png");
  }

  void aplicarEfecto(NaveAliada jugador) {
    if (jugador.vidasActuales < jugador.vidasMax) {
      jugador.vidasActuales++;
    }
    activo = false;
  }
  
  String getTipo() {
    return "vida";
  }
}
