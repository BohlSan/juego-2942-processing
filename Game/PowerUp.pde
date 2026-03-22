// ------------------------------------------------------------
// Clase abstracta: PowerUp
// Representa un ítem que cae y puede ser recogido por el jugador.
// Tolerante a sprites faltantes (no crashea si no existe el PNG).
// ------------------------------------------------------------
abstract class PowerUp {
  protected float x, y;
  protected float velocidad = 2;
  protected boolean activo = true;
  protected PImage sprite;

  PowerUp(float xInicial, float yInicial, String rutaSprite) {
    x = xInicial;
    y = yInicial;
    sprite = safeLoad(rutaSprite);  // carga segura (puede devolver null)
  }

  // Carga segura: no lanza; retorna null si el archivo no existe o falla
  PImage safeLoad(String path) {
    try {
      if (path == null || path.length() == 0) return null;
      return loadImage(path);  // Processing retorna null si no existe
    } catch (Exception e) {
      return null;
    }
  }

  void moverse() {
    y += velocidad;
    if (y > height + 40) {
      activo = false;
    }
  }

  void dibujar() {
    if (!activo) return;
    imageMode(CENTER);
    if (sprite != null) {
      image(sprite, x, y, 32, 32);
    } else {
      // Fallback vectorial para evitar NPE si falta el asset
      pushStyle();
      noStroke();
      fill(30, 180, 255);
      ellipse(x, y, 28, 28);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(12);
      text(shortLabel(), x, y); // letra según tipo
      popStyle();
    }
  }
  
  void dibujarObtenido() {
    imageMode(CENTER);
    if (sprite != null) {
      image(sprite, width - 100, height - 100, 50, 50);
    } else {
      // Fallback HUD si falta sprite
      pushStyle();
      noStroke();
      fill(30, 180, 255);
      ellipse(width - 100, height - 100, 44, 44);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(16);
      text(shortLabel(), width - 100, height - 100);
      popStyle();
    }
  }

  // Letra corta para placeholder por tipo
  private String shortLabel() {
    String t = getTipo();
    if (t == null || t.length() == 0) return "?";
    return t.substring(0, 1).toUpperCase();
  }

  abstract void aplicarEfecto(NaveAliada jugador);
  abstract String getTipo();
}
