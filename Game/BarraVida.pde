class BarraVida {
  private float x, y, ancho, alto;
  private int vida, vidaMax; // 1,2,3 golpes

  BarraVida(float x, float y, float ancho, int vida) {
    super();
    this.x = x;
    this.y = y;
    this.ancho = ancho/1.2;
    this.alto = 8;
    this.vidaMax = vida;
    this.vida = vida;
  }

  void dibujar(float x, float y, int vida) {
    this.x = x;
    this.y = y;
    this.vida = vida;
    
    float porcentaje = vida / float(vidaMax);
    
    color c;
    if (porcentaje >= 0.7) c = color(0, 255, 0);
    else if (porcentaje > 0.5) c = color(255, 165, 0);
    else c = color(255, 0, 0);

    noStroke();
    fill(c);
    rectMode(CENTER);
    rect(x, y - 50, ancho * porcentaje, alto);

    noFill();
    stroke(255);
    strokeWeight(1.5);
    rect(x, y - 50, ancho, alto);
  }
}
