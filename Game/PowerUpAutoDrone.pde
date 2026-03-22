// ------------------------------------------------------------
// Clase: PowerUpAutoDrone
// PowerUp que crea un AutoDrone temporal para el jugador.
// ------------------------------------------------------------
class PowerUpAutoDrone extends PowerUp {

  PowerUpAutoDrone(float xInicial, float yInicial) {
    super(xInicial, yInicial, "data/auto_drone.png");
  }

  @Override
  void aplicarEfecto(NaveAliada jugador) {
    // Duración 7 segundos
    AutoDrone nuevo = new AutoDrone(jugador, 7000);
    gameManager.autoDrones.add(nuevo);
    activo = false;
  }

  @Override
  String getTipo() {
    return "auto_drone";
  }
}
