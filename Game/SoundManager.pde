import processing.sound.*;

class SoundManager {
  private SoundFile sonidoPowerUp;
  private SoundFile sonidoDisparo;
  private SoundFile sonidoDano;
  private SoundFile sonidoExplosion;
  private PApplet parent;  // referencia al sketch principal

  SoundManager(PApplet parent) {
    this.parent = parent;

    // Cargar los archivos de sonido
    sonidoPowerUp = new SoundFile(parent, "data/musica/agarrar_power_up.wav");
    sonidoDisparo = new SoundFile(parent, "data/musica/disparar.wav");
    sonidoDano = new SoundFile(parent, "data/musica/dano.wav");
    sonidoExplosion = new SoundFile(parent, "data/musica/explosion.wav");
  }

  void reproducirPowerUp() {
    if (sonidoPowerUp != null) sonidoPowerUp.play(1.2f, 1f);
  }

  void reproducirDisparo() {
    if (sonidoDisparo != null) sonidoDisparo.play(0.6f, 0.1f);
  }
  
  void reproducirDano(float vidaActual) {
    if ((sonidoDano != null) && (vidaActual > 1f)) sonidoDano.play(1f, 1f);
  }

  void reproducirExplosion() {
    if (sonidoExplosion != null) sonidoExplosion.play(0.5f, 0.1f);
  }
}
