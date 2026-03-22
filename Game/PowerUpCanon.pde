// ------------------------------------------------------------
// Clase: PowerUpCanon
// Aumenta permanentemente el número de cañones (hasta x5).
// Se resetea cuando el jugador pierde una vida.
// ------------------------------------------------------------
class PowerUpCanon extends PowerUp {
  PowerUpCanon(float xInicial, float yInicial) {
    // Usamos un asset existente para evitar warnings: nave_doble.png
    super(xInicial, yInicial, "data/nave_doble.png");
  }

  void aplicarEfecto(NaveAliada jugador) {
    jugador.incrementarCannon();  // +1 cañón (máx 5)
  }

  String getTipo() { 
    return "canon"; 
  }
}
