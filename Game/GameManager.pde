// ------------------------------------------------------------
// Clase: GameManager
// Gestiona el juego, enemigos, balas, colisiones, vidas, puntaje y power-ups.
// ------------------------------------------------------------
class GameManager {
  private FondoEspacial fondo;
  private NaveAliada jugador;
  private GeneradorEnemigos genEnemigos;
  private CambiosDeDificultad cambiosDificultad;

  private ArrayList<NaveEnemiga> enemigos;
  private ArrayList<BalaEnemiga> balasEnemigas;
  private ArrayList<Explosion> explosiones;
  private ArrayList<PowerUp> powerUps;
  private ArrayList<AutoDrone> autoDrones;

  private boolean pausado = false;
  private String estado = "menu";   // "menu" | "jugando" | "muriendo" | "gameover"
  private int score = 0;

  // Para retrasar la pantalla de game over y ver la explosión
  private int gameOverAt = -1;      // millis() cuando debemos pasar a "gameover"

  private PImage corazon; // ❤️ sprite del corazón

  String[] menuPrincipal = {"Iniciar", "Estadisticas", "Salir"};
  String[] menuPausa = {"Continuar", "Reiniciar", "Menú Principal"};
  int opcionSeleccionada = -1;

  GameManager() {
    fondo = new FondoEspacial(150);
    genEnemigos = new GeneradorEnemigos();
    cambiosDificultad = new CambiosDeDificultad();
    powerUps = new ArrayList<PowerUp>();
    autoDrones = new ArrayList<AutoDrone>();
    actualizarListas(); // referencias iniciales del generador
    corazon = loadImage("data/corazon.png");
  }

  // ---------- LOOP ----------
  void actualizar() {
    fondo.actualizar();
    if (estado.equals("jugando") && !pausado) {
      // Sincroniza punteros a listas internas del generador
      actualizarListas();

      genEnemigos.actualizar();
      cambiosDificultad.actualizar();
      jugador.moverse();


    // Balas aliadas (sin penalizar score)
    for (int i = jugador.getBalasAliadas().size()-1; i >= 0; i--) {
      BalaAliada b = jugador.getBalasAliadas().get(i);
      b.moverse();
      if (b.fueraDePantalla()) {
        jugador.getBalasAliadas().remove(i);
        dataManager.sumarBalaPerdida();  // seguís registrando la métrica
        
        if ((b.getTipoBala()) && (score > 0)){
          score += -5;
        }
      }
    }

      // PowerUps
      for (int i = powerUps.size()-1; i >= 0; i--) {
        PowerUp p = powerUps.get(i);
        p.moverse();
        if (dist(p.x, p.y, jugador.x, jugador.y) < 40) {
          jugador.guardarPowerUp(p);
          soundManager.reproducirPowerUp();
          p.activo = false; // se desactiva al agarrarlo
        }
        if (!p.activo) powerUps.remove(i);
      }

      // Colisiones
      detectarColisiones();

      // Muerte: detonación y paso a "muriendo" con delay
      if (!jugador.estaViva()) {
        genEnemigos.explotar(jugador);
        estado = "muriendo";
        gameOverAt = millis() + 900; // ~0.9s para ver la explosión
        cursor();
        return; // cortar frame
      }

      // Drones
      for (int i = autoDrones.size() - 1; i >= 0; i--) {
        AutoDrone d = autoDrones.get(i);
        d.actualizarAutoDrone();
        if (!d.activo) autoDrones.remove(i);
      }

    } else if (estado.equals("muriendo")) {
      genEnemigos.actualizar();
      if (millis() >= gameOverAt) endGame();

    }
    
  }

  // ---------- DRAW ----------
  void dibujar() {
    background(fondo.getColorFondo());
    fondo.dibujar();

    if (estado.equals("menu")) {
      mostrarMenuPrincipal();
    }
    else if (estado.equals("jugando")) {
      jugador.dibujar();
      genEnemigos.dibujar();
      for (AutoDrone a : autoDrones) a.dibujar();
      for (BalaAliada b : jugador.getBalasAliadas()) b.dibujar();
      for (Explosion e : explosiones) e.dibujar();
      for (PowerUp p : powerUps) p.dibujar();

      mostrarHUD();
      if (pausado) mostrarMenuPausa();
    }
    else if (estado.equals("muriendo")) {
      genEnemigos.dibujar();
      for (Explosion e : explosiones) e.dibujar();
      for (PowerUp p : powerUps) p.dibujar();

    }
    else if (estado.equals("gameover")) {
      mostrarGameOver();
    }
    else if (estado.equals("estadisticas")){
      mostrarMenuEstadisticas();
    }
  }

  // ---------- HUD ----------
  void mostrarHUD() {
    fill(255);
    textAlign(LEFT, TOP);
    textSize(25);
    text("Puntaje: " + score, 20, 20);

    // ❤️ Vidas
    float corazonX = width - 40;
    for (int i = 0; i < jugador.vidasActuales; i++) {
      imageMode(CENTER);
      image(corazon, corazonX - i * 40, 30, 32, 32);
    }
  }

  // ---------- COLISIONES ----------
  void detectarColisiones() {
    if (enemigos == null || jugador == null) return;

    // 💥 Balas aliadas vs enemigos
    for (int i = enemigos.size() - 1; i >= 0; i--) {
      if (i >= enemigos.size()) continue; // defensa si la lista cambió
      NaveEnemiga enemigo = enemigos.get(i);

      // Meteorito destruido por salir de pantalla (no da score)
      if (enemigo instanceof Meteorito && ((Meteorito)enemigo).getDestruido()) {
        if (i < enemigos.size()) enemigos.remove(i);
        genEnemigos.setEnemigos(enemigos);
        continue;
      }

      ArrayList<BalaAliada> balas = jugador.getBalasAliadas();
      for (int j = (balas != null ? balas.size() - 1 : -1); j >= 0; j--) {
        if (j >= balas.size()) continue;
        BalaAliada bala = balas.get(j);
        if (dist(enemigo.x, enemigo.y, bala.x, bala.y) < enemigo.ancho / 3) {
          enemigo.recibirDanio(bala.dano);
          if (j < balas.size()) balas.remove(j);
          if (!enemigo.estaViva()) {
            destruirEnemigo(enemigo, i);
            continue; // pasar al siguiente enemigo (i ya no es válido)
          }
        }
      }

      // 💥 Colisión jugador con enemigo
      if (i < enemigos.size()) {
        if (dist(jugador.x, jugador.y, enemigo.x, enemigo.y) < 40) {
          jugador.recibirDanio(3);
          destruirEnemigo(enemigo, i);
          continue;
        }
      }
    }

    // 💥 Balas enemigas vs jugador
    for (int i = balasEnemigas.size() - 1; i >= 0; i--) {
      if (i >= balasEnemigas.size()) continue;
      BalaEnemiga b = balasEnemigas.get(i);
      if (dist(jugador.x, jugador.y, b.x, b.y) < 35) {
        jugador.recibirDanio(1);
        if (i < balasEnemigas.size()) balasEnemigas.remove(i);
        explosiones.add(new Explosion(b.x, b.y, color(255, 80, 0)));
      }
    }
  }
  
  void endGame() {
    guardarDatos();      // record + partidas.csv + reset fondo
    pausado = false;
    estado = "gameover";
    cursor();
  }

  // ---------- CICLOS DE VIDA ----------
  void iniciarJuego() {
    genEnemigos.iniciarJuego();
    jugador = new NaveAliada(width / 2, height - 100, "data/nave.png");
    enemigos.clear();
    jugador.getBalasAliadas().clear();
    balasEnemigas.clear();
    explosiones.clear();
    powerUps.clear();
    autoDrones.clear();
    score = 0;
    estado = "jugando";
    pausado = false;
    noCursor();
    dataManager.reiniciar();
  }
  
  // ---------- GAME OVER UI ----------
  void mostrarGameOver() {
    pushStyle();

    rectMode(CORNER);
    noStroke();

    // Capa oscura (deja ver el fondo en movimiento)
    fill(0, 180);
    rect(0, 0, width, height);

    // Vignette sutil
    int steps = 6;
    for (int i = 0; i < steps; i++) {
      float t = map(i, 0, steps-1, 0.4, 1.0);
      float a = map(i, 0, steps-1, 20, 3);
      fill(0, 0, 0, a);
      float rw = width  * t;
      float rh = height * t;
      ellipseMode(CENTER);
      ellipse(width/2, height/2, rw, rh);
    }

    // Título ESTÁTICO (sin pulso)
    textAlign(CENTER, CENTER);
    textFont(createFont("data/Audiowide-Regular.ttf", 70));
    fill(200, 10, 10);
    text("GAME OVER", width/2, height/2 - 200);

    // Score + record
    textSize(22);
    fill(220);
    text("Score: " + score,                         width/2, height/2 - 130);
    fill(200, 200, 30);
    text("Record: " + str(dataManager.getRecord()), width/2, height/2 - 80);

    // Botones
    textSize(24);
    String[] opcionesGO = {"Reintentar", "Menú Principal"};
    for (int i = 0; i < opcionesGO.length; i++) {
      float yBtn = height/2 - 10 + i * 60;
      boolean hover = (mouseX > width/2 - 140 && mouseX < width/2 + 140 &&
                       mouseY > yBtn - 22   && mouseY < yBtn + 22);
      float bw = 280, bh = 44, rx = 14;

      noStroke();
      fill(hover ? color(255, 255, 255, 28) : color(255, 255, 255, 12));
      rectMode(CENTER);
      rect(width/2, yBtn, bw, bh, rx);

      fill(hover ? color(255, 200, 80) : 255);
      text(opcionesGO[i], width/2, yBtn);
    }

    popStyle();
  }
  
  void irEstadisticas(){
    /*textAlign(CENTER, TOP);
    textFont(createFont("data/Audiowide-Regular.ttf", 90));
    fill(200, 10, 10);
    text("Estadisticas", width / 2, height / 2 + 200);*/
    estado = "estadisticas";
    pausado = false;
    cursor();
  }

  void togglePausa() {
    if (estado.equals("jugando")) {
      if (pausado) noCursor();
      else cursor();
    }
    pausado = !pausado;
  }

  void volverAlMenu() {
    guardarDatos();
    pausado = false;
    estado = "menu";
    cursor();
  }

  void reiniciarJuego() {
    guardarDatos();
    iniciarJuego();
  }

  void guardarDatos() {
    dataManager.guardarRecord("datos/record.json", score);
    dataManager.guardarPartida();
    fondo = new FondoEspacial(150);
  }

  // ---------- MENÚS ----------
  void mostrarMenuPrincipal() {
    pushStyle();
    fill(255);
    textAlign(LEFT, TOP);
    textSize(24);
    text("Record: " + str(dataManager.getRecord()), 10, 15);

    textAlign(CENTER, CENTER);
    textFont(createFont("data/Audiowide-Regular.ttf", 90));
    fill(200, 10, 10);
    text("2942", width / 2, height / 2 - 230);
    fill(255);
    textSize(60);
    text("SPACE INVASION", width / 2, height / 2 - 130);

    textSize(22);
    for (int i = 0; i < menuPrincipal.length; i++) {
      float yBtn = height / 2 - 20 + i * 60;
      boolean hover = (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
                       mouseY > yBtn - 20 && mouseY < yBtn + 20);
      fill(hover ? color(255, 180, 0) : 255);
      text(menuPrincipal[i], width / 2, yBtn);
    }
    popStyle();
  }

  void mostrarMenuPausa() {
    pushStyle();                // aísla estilos
    fill(30, 30, 40);
    rectMode(CENTER);
    rect(width / 2, height / 2, 320, 260, 20);
    fill(255);
    textAlign(CENTER, TOP);
    textSize(28);
    text("PAUSA", width / 2, height / 2 - 110);
    textSize(22);

    for (int i = 0; i < menuPausa.length; i++) {
      float yBtn = height / 2 - 40 + i * 60;
      boolean hover = (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
                       mouseY > yBtn - 20 && mouseY < yBtn + 20);
      fill(hover ? color(255, 180, 0) : 255);
      text(menuPausa[i], width / 2, yBtn);
    }
    popStyle();                 // restaura rectMode, fill, etc.
  }
  
  void mostrarMenuEstadisticas() {
    pushStyle();                // aísla estilos
    fill(255);
    textAlign(CENTER, TOP);
    textSize(height * 0.027777778);
  
    float xBtn = width * 0.1515;
    float yBtn = height * 0.9259;
    boolean hover = (mouseX > xBtn - 100 && mouseX < xBtn + 100 &&
                     mouseY > yBtn - 20 && mouseY < yBtn + 20);
    fill(hover ? color(255, 180, 0) : 255);
    text("Volver al Menu", xBtn, yBtn);
    
    textFont(createFont("data/Audiowide-Regular.ttf", height * 0.092592593));
    fill(240, 120, 20);
    text("Estadisticas", width / 2, height * 0.092592593);
    
    textAlign(CENTER, TOP);
    textFont(createFont("solid.oft", height * 0.027777778));
    fill(255);
    HashMap totales = dataManager.obtenerSumaDatosTabla();
    text("🎮  Cantidad de Partidas: " + totales.get("Cantidad Partidas"), width * 0.151515152, height * 0.277777778);
    text("🎯  Precisión: " + totales.get("Precision") + "%", width * 0.151515152, height * 0.37037037);
    text("👾  Enemigos Eliminados: " + totales.get("Naves Destruidas"), width * 0.151515152, height * 0.462962963);
    //text("Power Ups Recolectados: " + totales.get("Power Ups Agarrados"), 300, 800);
    text("💥  Daño Recibido: " + totales.get("Daño Recibido"), width * 0.151515152, height * 0.555555556);
    text("💎  Power Ups Usados: " + totales.get("Power Ups Usados"), width * 0.151515152, height * 0.648148148);

    fill(255, 215, 10);
    text("⭐  Record Histórico: " + dataManager.getRecord(), width * 0.151515152, height * 0.740740741);
    //text("🔫 Balas Disparadas: " + totales.get("Balas Disparadas"), 300, 900);
    //popStyle();
    dataManager.BarrasScore();
    dataManager.boxplotAccuracy();
  }

  void clickEnMenu(float mx, float my) {
    if (estado.equals("menu")) {
      for (int i = 0; i < menuPrincipal.length; i++) {
        float yBtn = height / 2 - 20 + i * 60;
        if (mx > width / 2 - 100 && mx < width / 2 + 100 &&
            my > yBtn - 20 && my < yBtn + 20) {
          if (menuPrincipal[i].equals("Iniciar")) iniciarJuego();
          if (menuPrincipal[i].equals("Estadisticas")) irEstadisticas();
          if (menuPrincipal[i].equals("Salir")) exit();
        }
      }
    }

    if (pausado) {
      for (int i = 0; i < menuPausa.length; i++) {
        float yBtn = height / 2 - 40 + i * 60;
        if (mx > width / 2 - 100 && mx < width / 2 + 100 &&
            my > yBtn - 20 && my < yBtn + 20) {
          if (menuPausa[i].equals("Continuar")) {
            pausado = false;
            noCursor();
          }
          if (menuPausa[i].equals("Reiniciar")) reiniciarJuego();
          if (menuPausa[i].equals("Menú Principal")) volverAlMenu();
        }
      }
    }

    if (estado.equals("gameover")) {
      float yReintentar = height/2 - 10;
      float yMenu      = height/2 + 50;

      if (mx > width/2 - 140 && mx < width/2 + 140) {
        if (my > yReintentar - 22 && my < yReintentar + 22) {
          iniciarJuego();   // run limpia sin doble guardado
        } else if (my > yMenu - 22 && my < yMenu + 22) {
          estado = "menu";
        }
      }
    }
    
    if (estado.equals("estadisticas")) {
      float xMenu = width * 0.1515;
      float yMenu = height * 0.9259;

      if (mx > xMenu - 140 && mx < xMenu + 140) {
        if (my > yMenu - 22 && my < yMenu + 22) {
           estado = "menu";
        }
      }
    }
  }

  // ---------- UTIL ----------
  void actualizarListas() {
    enemigos = genEnemigos.getEnemigos();
    balasEnemigas = genEnemigos.getBalasEnemigas();
    explosiones = genEnemigos.getExplosiones();
  }

  public void naveDisparar() {
    if (estaJugando()) jugador.dispararAliado();
  }

  public ArrayList<PowerUp> getPowerUps() { return powerUps; }

  public boolean estaJugando() { return (estado.equals("jugando") && !pausado); }

  // Eliminación segura (no doble remove)
  void destruirEnemigo(NaveEnemiga enemigo, int i) {
    if (enemigos == null || enemigos.size() == 0) return;
    int idx = i;
    if (idx < 0 || idx >= enemigos.size() || enemigos.get(idx) != enemigo) {
      idx = enemigos.indexOf(enemigo);
      if (idx < 0) return; // ya fue eliminado
    }
    genEnemigos.explotar(enemigo);
    enemigos.remove(idx);
    genEnemigos.setEnemigos(enemigos);
    score += enemigo.score;
    dataManager.sumarNavesDestruidas();
  }

  public void activarPowerUp() { if (jugador != null) jugador.usarPowerUp(); }
  public GeneradorEnemigos getGenEnemigos() { return genEnemigos; }
  public int getScore() { return score; }
}
