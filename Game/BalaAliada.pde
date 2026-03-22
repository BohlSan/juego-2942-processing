// ------------------------------------------------------------
// Clase: BalaAliada
// Disparo del jugador. Se mueve hacia arriba.
// ------------------------------------------------------------
class BalaAliada extends Bala {
  private boolean balaJugador;

  BalaAliada(float x, float y, boolean tipoBala) {
    super(x, y, 8, 1, color(50, 255, 100), 6); // rápida, verde
    balaJugador = tipoBala;
    dataManager.sumarDisparo();
  }

  void moverse() {
    y -= velocidad;
  }
  
  public boolean getTipoBala(){
  return balaJugador;
  }
}
