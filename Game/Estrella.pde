// ------------------------------------------------------------
// Clase Estrella: representa una estrella individual
// ------------------------------------------------------------
class Estrella {
  private float x, y;
  private float velocidad;
  private float brillo, tamano;
  private float aumento = 0.0005;

  Estrella(float x, float y, float velocidad) {
    this.x = x;
    this.y = y;
    this.velocidad = velocidad;
    brillo = random(150, 255);
    tamano = map(velocidad, 0.3, 12, 1.2, 1.7);
  }

  // Mueve la estrella
  void mover() {
    y += velocidad;
    if (y > height) {
      y = 0;               // reaparece arriba
      x += 10;
      //x = random(width);   // posición horizontal aleatoria
      //brillo = random(150, 255);
    }
    
    if (x > width){
      x = 0;
    }
    
    if (gameManager.estado.equals("jugando") && velocidad < 12) {
      velocidad += aumento;
    }
    
    tamano = map(velocidad, 0.3, 12, 1.2, 1.7); // tamaño relativo a velocidad
  }

  // Dibuja la estrella
  void dibujar() {
    noStroke();
    fill(brillo);
    ellipse(x, y, tamano, tamano);
  }
}
