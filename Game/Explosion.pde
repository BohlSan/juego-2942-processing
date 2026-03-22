// ------------------------------------------------------------
// Clase: Explosion
// Animación simple de una explosión (círculo que crece y se desvanece).
// ------------------------------------------------------------
class Explosion {
  private float x, y;
  private float radio;
  private float crecimiento;  // velocidad de expansión
  private float opacidad;     // transparencia
  private color colorExplosion;
  private boolean activa;

  Explosion(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.radio = 10;
    this.crecimiento = 3.5;
    this.opacidad = 255;
    this.colorExplosion = c;
    this.activa = true;
  }

  // Actualiza la animación
  void actualizar() {
    if (activa) {
      radio += crecimiento;
      opacidad -= 10;

      if (opacidad <= 0) {
        activa = false;
      }
    }
  }

  // Dibuja la explosión
  void dibujar() {
    if (activa) {
      noStroke();
      fill(colorExplosion, opacidad);
      ellipse(x, y, radio * 2, radio * 2);
    }
  }

  // Saber si terminó
  boolean terminada() {
    return !activa;
  }
}
