// ------------------------------------------------------------
// Clase: AutoDrone
// Dron aliado que actúa como "jugador extra": no recoge ítems,
// no recibe daño, dura un tiempo y dispara igual que la nave aliada.
// ------------------------------------------------------------
class AutoDrone extends NaveAliada {
  private NaveAliada jugadorRef;       // referencia a la nave principal
  private float angulo;                // ángulo orbital
  private float radioOrbitaX;
  private float radioOrbitaY;
  private float velocidadOrbita;       // velocidad de giro
  private long tiempoExpiracion;       // momento en que debe desaparecer
  public boolean activo = true;        // público para que GameManager lo lea

  AutoDrone(NaveAliada jugador, long duracionMillis) {
    super(jugador.x, jugador.y, "data/auto_drone.png");
    this.jugadorRef = jugador;

    this.ancho = 40;
    this.alto = 40;
    this.vidasMax = 1;
    this.vidasActuales = 1;

    this.angulo = random(TWO_PI);
    this.radioOrbitaX = 120;
    this.radioOrbitaY = 80;
    this.velocidadOrbita = 0.04;
    this.tiempoExpiracion = millis() + duracionMillis;

    this.powerUpActual = null;
  }

  @Override
  public void guardarPowerUp(PowerUp powerUp) {
    // no hace nada: el dron no puede agarrar ítems
  }

  @Override
  void recibirDanio(int d) {
    // inmune
  }

  @Override
  void moverse() {
    angulo += velocidadOrbita;
    x = jugadorRef.x + cos(angulo) * radioOrbitaX;
    y = jugadorRef.y + sin(angulo) * radioOrbitaY;

    x += sin(frameCount * 0.05 + angulo) * 0.5;
    y += cos(frameCount * 0.05 + angulo) * 0.5;
  }

  @Override
  void dibujar() {
    pushMatrix();
    translate(x, y);
    imageMode(CENTER);
    if (sprite != null) image(sprite, 0, 0, ancho, alto);
    else {
      noStroke();
      fill(0, 200, 200);
      ellipse(0, 0, ancho, alto);
    }
    noFill();
    stroke(50, 200, 255, 150);
    strokeWeight(2);
    ellipse(0, 0, ancho + 12, alto + 12);
    popMatrix();
  }

  // Disparo automático desde la posición del dron
  void accionarDisparoAliado() {
    if (millis() - this.tiempoUltimoDisparo > this.cooldown) {
      this.tiempoUltimoDisparo = millis();
      jugadorRef.getBalasAliadas().add(new BalaAliada(this.x, this.y - 30, false));
      soundManager.reproducirDisparo();
      // IMPORTANTE: no sumarDisparo() acá; BalaAliada ya cuenta en constructor si fuese del jugador
    }
  }

  // Actualiza: mover + disparar + expiración
  void actualizarAutoDrone() {
    if (!activo) return;
    moverse();
    accionarDisparoAliado();

    if (millis() > tiempoExpiracion) {
      activo = false;
      gameManager.getGenEnemigos().explosiones.add(new Explosion(x, y, color(100, 220, 255)));
    }
  }
}
