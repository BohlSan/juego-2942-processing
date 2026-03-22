class Temporizador {
  private int duracion;
  private int inicio;
  private boolean activo;

  Temporizador(int ms) {
    duracion = ms;
    activo = false;
  }

  void iniciar() {
    inicio = millis();
    activo = true;
  }

  boolean cumplido() {
    if (activo && millis() - inicio >= duracion) {
      activo = false;
      return true;
    }
    return false;
  }
}
