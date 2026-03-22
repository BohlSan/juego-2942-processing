// ------------------------------------------------------------
// Clase: BalaEnemiga
// Disparo de las naves enemigas. Se mueve hacia abajo.
// ------------------------------------------------------------
class BalaEnemiga extends Bala {

  BalaEnemiga(float x, float y, int dano, color c, int tamano) {
    super(x, y, 5, dano, c, tamano); // más lenta, roja
  }

  void moverse() {
    y += velocidad;
  }
}
