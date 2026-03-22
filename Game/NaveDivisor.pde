// ------------------------------------------------------------
// Clase: NaveDivisor
// Enemigo que, al morir, genera dos copias más pequeñas y rápidas
// ------------------------------------------------------------
class NaveDivisor extends NaveEnemiga {

  private GeneradorEnemigos genEnemigos;
  private boolean dividido = false;
  private boolean original;
  private int[] velocidades = {-3, 3};

  NaveDivisor(int vida, boolean esOriginal) {
    super("naveDivisor", vida, 100, "data/nave_divisor.png", 100); // 2 de vida, ancho 72
    this.original = esOriginal;
    this.velX = velocidades[(int)random(velocidades.length)];
    this.velY = 3;
    this.dano = 1;
    this.colorBala = color(255, 200, 0);
    this.tamanoBala = 8;
    genEnemigos = gameManager.getGenEnemigos();
  }

  // ------------------------------------------------------------
  // Disparo: opcional, este enemigo no dispara por ahora
  // ------------------------------------------------------------
  void disparar(ArrayList<BalaEnemiga> listaBalas) {
    if (!descendiendo && millis() - tiempoUltimoDisparo > intervaloDisparo) {
      listaBalas.add(new BalaEnemiga(x, y + alto / 2, this.dano, this.colorBala, this.tamanoBala));
      tiempoUltimoDisparo = millis();
      //soundManager.reproducirDisparo();
    }
  }

  // ------------------------------------------------------------
  // Recibe daño y se divide al morir
  // ------------------------------------------------------------
  void recibirDanio(int d) {
    soundManager.reproducirDano(vida);
    vida -= d;

    if (vida <= 0 && !dividido && this.original) {
        // 1️⃣ Dividir primero
        dividir();
        dividido = true;
        
        vida = 0;
    }
  }

  void dividir() {
    // crea dos copias más pequeñas y rápidas
    NaveDivisor e1 = new NaveDivisor(1, false);
    NaveDivisor e2 = new NaveDivisor(1, false);

    e1.x = x - 50;
    e2.x = x + 50;
    e1.y = y - 10;
    e2.y = y - 10;
    
    e1.velX *= 1.2;
    e2.velX *= 1.2;

    e1.ancho *= 0.6;
    e1.alto *= 0.6;
    e2.ancho *= 0.6;
    e2.alto *= 0.6;
    
    e1.score /= 4;
    e2.score /= 4;

    e1.vida = 1;
    e2.vida = 1;

    genEnemigos.agregarEnemigo(e1);
    genEnemigos.agregarEnemigo(e2);
  }
}
