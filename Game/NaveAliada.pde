// ------------------------------------------------------------
// Clase: NaveAliada (blindada)
// - Offsets dinámicos (sin arrays fijos) => sin OOB.
// - Clamps en nivel de cañón.
// - Logs de depuración al disparar.
// ------------------------------------------------------------
class NaveAliada extends Nave {
  protected PImage sprite;
  protected int vidasMax = 3;
  protected int vidasActuales;
  protected float ancho = 100;
  protected float alto = 100;

  // Sprites por nivel (opcionales; si faltan no rompe)
  protected PImage spriteLv1, spriteLv2, spriteLv3, spriteLv4, spriteLv5;

  // Escudo / powerups
  protected int durabilidadEscudo = 0;
  protected boolean ametralladoraActivo = false;
  protected PowerUp powerUpActual;
  protected int tiempoEscudoFin = 0;
  protected int tiempoAmetralladoraFin = 0;

  // Disparo
  protected int cooldown = 270;
  protected float tiempoUltimoDisparo = 0;

  // Multi-cañón
  protected int multiCannonLevel = 1;
  protected final int MULTI_CANNON_MAX = 5;

  protected ArrayList<BalaAliada> balasAliadas;

  NaveAliada(float xInicial, float yInicial, String rutaSprite) {
    super("star", xInicial, yInicial, 3);
    balasAliadas = new ArrayList<BalaAliada>();

    spriteLv1 = safeLoad("data/nave.png");
    spriteLv2 = safeLoad("data/nave_doble.png");
    spriteLv3 = safeLoad("data/nave_triple.png");
    spriteLv4 = safeLoad("data/nave_cuadruple.png");
    spriteLv5 = safeLoad("data/nave_quintuple.png");

    sprite = (spriteLv1 != null) ? spriteLv1 : safeLoad(rutaSprite);
    if (sprite == null) {
      sprite = createImage(64, 64, ARGB);
      sprite.loadPixels();
      for (int i = 0; i < sprite.pixels.length; i++) sprite.pixels[i] = color(200, 200, 255, 200);
      sprite.updatePixels();
    }
    vidasActuales = vidasMax;
  }

  private PImage safeLoad(String path) {
    try { return (path == null || path.length()==0) ? null : loadImage(path); }
    catch (Exception e) { return null; }
  }

  private void applyCannonSprite() {
    int lvl = constrain(multiCannonLevel, 1, MULTI_CANNON_MAX);
    PImage next = sprite; // default mantener
    if (lvl == 1 && spriteLv1 != null) next = spriteLv1;
    else if (lvl == 2 && spriteLv2 != null) next = spriteLv2;
    else if (lvl == 3 && spriteLv3 != null) next = spriteLv3;
    else if (lvl == 4 && spriteLv4 != null) next = spriteLv4;
    else if (lvl == 5 && spriteLv5 != null) next = spriteLv5;
    sprite = next;
  }

  void moverse() {
    x = mouseX;
    y = mouseY;
    x = constrain(x, ancho/2, width - ancho/2);
    y = constrain(y, alto/2, height - alto/2);
    actualizarPowerUp();

    // seguridad extra: jamás dejar que el nivel quede fuera de rango
    if (multiCannonLevel < 1) { multiCannonLevel = 1; applyCannonSprite(); }
    if (multiCannonLevel > MULTI_CANNON_MAX) { multiCannonLevel = MULTI_CANNON_MAX; applyCannonSprite(); }
  }

  void dibujar() {
    imageMode(CENTER);
    image(sprite, x, y, ancho, alto);
    if (powerUpActual != null) powerUpActual.dibujarObtenido();

    if (durabilidadEscudo > 0) {
      noFill();
      stroke(0, 200, 255);
      strokeWeight(3);
      ellipse(x, y, ancho + 20, alto + 20);
    }
  }

  void dispararAliado() {
    if (!cooldownListo()) return;
    tiempoUltimoDisparo = millis();

    int lvl = constrain(multiCannonLevel, 1, MULTI_CANNON_MAX);
    float[] pattern = buildOffsetsForLevel(lvl);
    if (pattern == null || pattern.length == 0) pattern = new float[]{0};

    // safety extra: si por alguna razón patternLen > 9, recorto
    int cap = min(pattern.length, 9);
    for (int i = 0; i < cap; i++) {
      balasAliadas.add(new BalaAliada(x + pattern[i], y - 30, true));
    }
    soundManager.reproducirDisparo();
  }

  // Offsets dinámicos centrados; todas las balas rectas.
  private float[] buildOffsetsForLevel(int level) {
    int n = constrain(level, 1, MULTI_CANNON_MAX);
    float spacing = 12f;
    float[] out = new float[n];

    if (n == 1) { out[0] = 0; return out; }

    // Simetría: para n par, evitamos 0 exacto (…,-0.5,0.5,…)
    int midLeft = (n - 1) / 2;
    float centerShift = (n % 2 == 0) ? 0.5f : 0f;

    for (int i = 0; i < n; i++) {
      out[i] = ( (i - midLeft) + centerShift ) * spacing;
    }
    return out;
  }

  boolean cooldownListo() {
    return millis() - tiempoUltimoDisparo > cooldown;
  }

  void incrementarCannon() {
    int before = multiCannonLevel;
    if (multiCannonLevel < MULTI_CANNON_MAX) multiCannonLevel++;
    multiCannonLevel = constrain(multiCannonLevel, 1, MULTI_CANNON_MAX);
    if (multiCannonLevel != before) applyCannonSprite();
  }

  void resetCannon() {
    multiCannonLevel = 1;
    applyCannonSprite();
  }

  void recibirDanio(int d) {
    if (durabilidadEscudo <= 0) {
      soundManager.reproducirDano(vidasActuales);
      int antes = vidasActuales;
      vidasActuales -= d;
      if (vidasActuales < 0) vidasActuales = 0;
      dataManager.sumarDanio();
      if (vidasActuales < antes) resetCannon();
    } else {
      durabilidadEscudo -= 1;
    }
  }

  public void guardarPowerUp(PowerUp powerUp){
    powerUpActual = powerUp;
    dataManager.sumarPowerUpAgarrado();
  }
  
  public void usarPowerUp() {
    if (powerUpActual != null) {
      powerUpActual.aplicarEfecto(this);
      powerUpActual = null;
      dataManager.sumarPowerUpUsado();
    }
  }
  
  void activarPowerUp(int duracion, String tipoPowerUp) {
    if (tipoPowerUp.equals("escudo")){
      tiempoEscudoFin = millis() + duracion;
      durabilidadEscudo = 3;
    }
    else if (tipoPowerUp.equals("ametralladora")){
      tiempoAmetralladoraFin = millis() + duracion;
      ametralladoraActivo = true;
      cooldown = 150;
    }
  }

  void actualizarPowerUp() {
    if (millis() > tiempoEscudoFin) durabilidadEscudo = 0;
    if (millis() > tiempoAmetralladoraFin) { ametralladoraActivo = false; cooldown = 270; }
  }

  boolean estaViva() {
    return vidasActuales > 0;
  }

  ArrayList<BalaAliada> getBalasAliadas() { return balasAliadas; }
}
