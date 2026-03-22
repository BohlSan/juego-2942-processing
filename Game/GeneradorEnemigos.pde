class GeneradorEnemigos{
  private ArrayList<NaveEnemiga> enemigos;
  private ArrayList<BalaEnemiga> balasEnemigas;
  private ArrayList<Explosion> explosiones;
  
  private int tiempoUltimoEnemigo = 0;
  private int intervaloEnemigos = 1700;
  private int maxEnemigos = 10;
  private int meta = 5000;
  
  private OpcionesEnemigos opcionesEnemigos;
  private OpcionesPowerUps opcionesPU;
  
  GeneradorEnemigos() {
    enemigos = new ArrayList<NaveEnemiga>();
    balasEnemigas = new ArrayList<BalaEnemiga>();
    explosiones = new ArrayList<Explosion>();
    opcionesEnemigos = new OpcionesEnemigos(100, 30, 10, 20);
  }
  
  void iniciarJuego() {
    tiempoUltimoEnemigo = millis();
  }
  
  public void actualizar(){
    // Balas enemigas
    for (int i = balasEnemigas.size()-1; i >= 0; i--) {
      BalaEnemiga b = balasEnemigas.get(i);
      b.moverse();
      if (b.fueraDePantalla()) balasEnemigas.remove(i);
    }
    
    // Enemigos
    for (NaveEnemiga n : enemigos) {
      n.moverse();
      n.disparar(balasEnemigas);
      if (n instanceof NaveBoss){
         n.actualizar();
      }
    }

    // Explosiones
    for (int i = explosiones.size()-1; i >= 0; i--) {
      Explosion e = explosiones.get(i);
      e.actualizar();
      if (e.terminada()) explosiones.remove(i);
    }
    
    generarEnemigos();
  }
  
  public void dibujar() {
    for (NaveEnemiga n : enemigos) n.dibujar();
    for (BalaEnemiga b : balasEnemigas) b.dibujar();
  }
    
  void generarEnemigos() {
    generadorBosses();
    
    if (millis() - tiempoUltimoEnemigo > intervaloEnemigos && enemigos.size() < maxEnemigos) {
      float totalPeso = 0;
      for (EnemigoPeso o : opcionesEnemigos.opciones) totalPeso += o.peso;

      float eleccion = random(totalPeso);
      float acumulado = 0;

      for (EnemigoPeso o : opcionesEnemigos.opciones) {
        acumulado += o.peso;
        if (eleccion <= acumulado) {
          enemigos.add(o.generar());
          break;
        }
      }
      tiempoUltimoEnemigo = millis();
    }
  }
  
  void generadorBosses(){
    int score = gameManager.getScore();
    if (score > meta){
      crearBoss(score/250);
      meta += 5000;
    }
  }
  
  public void crearBoss(int vida){
    NaveBoss boss = new NaveBoss(vida);
    enemigos.add(boss);
  }
  
  public void agregarEnemigo(NaveEnemiga enemigo){
    enemigos.add(enemigo);
  }
  
  public void explotar(Nave nave){
    explosiones.add(new Explosion(nave.x, nave.y, color(255, 100, 0)));
    soundManager.reproducirExplosion();
    
    if (!nave.getNombre().equals("star")){
      generarPowerUp(nave.x, nave.y, random(1));
    }
  }
  
  public ArrayList<NaveEnemiga> getEnemigos(){
    return enemigos;
  }
  
  public ArrayList<BalaEnemiga> getBalasEnemigas(){
    return balasEnemigas;
  }
  
  public ArrayList<Explosion> getExplosiones(){
    return explosiones;
  }
  
  public void setEnemigos(ArrayList<NaveEnemiga> e){
    enemigos = e;
  }
  
  public void setIntervaloEnemigos(int nuevoIntervalo){
    intervaloEnemigos = nuevoIntervalo;
  }
  
  public void setMaxEnemigos(int nuevoMax){
    maxEnemigos = nuevoMax;
  }
  
  public void cambiarOpcionesEnemigos(int probNormal, int probTanque, int probDivisor, int probMeteorito){
    opcionesEnemigos = new OpcionesEnemigos(probNormal, probTanque, probDivisor, probMeteorito);
  }
  
  public void generarPowerUp(float x, float y, float suertePU){
    if (suertePU <= 0.3f){
      //                                vida  |  escudo  |  ametralladora  |  drone  |  canon
      opcionesPU = new OpcionesPowerUps(3, 3, 3, 2, 1, x, y);
      float totalPesos = 0;
      for (PowerUpPeso pu : opcionesPU.opciones) totalPesos += pu.peso;
      
      float r = random(totalPesos);
      float acumulado = 0;
      
      for (PowerUpPeso pu : opcionesPU.opciones) {
        acumulado += pu.peso;
        if (r < acumulado) {
          gameManager.powerUps.add(pu.generar());
          break;  // solo un power-up
        }
      }
    }
    
    //                                vida  |  escudo  |  ametra  |  drone  |  canon
    opcionesPU = new OpcionesPowerUps(3, 3, 3, 2, 1, x, y);
  }
}
