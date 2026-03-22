// ------------------------------------------------------------
// Clase abstracta: Bala
// Define propiedades y métodos comunes para todas las balas.
// ------------------------------------------------------------
abstract class Bala {
  protected float x, y;        // posición
  protected float velocidad;   // velocidad vertical
  protected int dano;          // daño que causa
  protected color c;           // color visual
  protected float tamano;      // tamaño del proyectil


  Bala(float x, float y, float velocidad, int dano, color c, float tamano) {
    this.x = x;
    this.y = y;
    this.velocidad = velocidad;
    this.dano = dano;
    this.c = c;
    this.tamano = tamano;
  }

  // Método abstracto: cómo se mueve
  abstract void moverse();

  // Dibuja la bala
  void dibujar() {
    noStroke();
    fill(c);
    ellipse(x, y, tamano, tamano * 2);
  }

  // Comprueba si la bala salió de la pantalla
  boolean fueraDePantalla() {
    return (y < -20 || y > height + 20);
  }
}
