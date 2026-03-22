class NaveBoss extends NaveEnemiga {

  private int dano = 1;
  private color colorBala = color(20, 20, 255);
  private int tamanoBala = 8;
  private boolean cargando = false;
  private boolean disparando = false;
  // 0 = idle, 1 = cargando, 2 = disparando
  private int estadoBoss = 0; 
  private int tiempoCambioEstado = 0;
  private int duracionIdle = 2500;      
  private int duracionCargando = 2500;  
  private int duracionDisparando = 3000;

  
  NaveBoss(int vida) {
    super("boss", vida, 500, "data/nave_rayo.png", 300);
    this.intervaloDisparo= 75;
    velX = 2;
    velY = 8;
    this.alturaObjetivo = 150;
    this.x = width/2;
  }
  
  void disparar(ArrayList<BalaEnemiga> listaBalas) {
    if(estadoBoss == 2){
      if (!descendiendo && millis() - tiempoUltimoDisparo > intervaloDisparo) {
        listaBalas.add(new BalaEnemiga(x, y + alto / 2, dano, colorBala, tamanoBala));
        tiempoUltimoDisparo = millis();
      }
    }
    
    
  }
  
  void moverse() {
    if (descendiendo) {
      y += velY;
      if (y >= alturaObjetivo) descendiendo = false;
    }
    
    else if((estadoBoss == 0)  || (estadoBoss == 2)){
      x += velX;
      if (x < ancho/4 || x > width - ancho/4 ) velX *= -1;
    }
  }
  
  void dibujar() {
    imageMode(CENTER);
    image(sprite, x, y, ancho, alto);
    barra.dibujar(x, y, vida);
    
    if(estadoBoss == 0){
      noFill();
      stroke(0, 200, 255);
      strokeWeight(3);
      ellipse(x, y, ancho + 20, alto + 20);
    } else if (estadoBoss == 1){
      fill(20, 20, 255);
      noStroke();
      ellipse(x, y + ancho / 2.2, 40, 40);
    }
  }
  

  void actualizar() {
    int ahora = millis();
    int tiempoEnEstado = ahora - tiempoCambioEstado;

    if (estadoBoss == 0) { 
      if (tiempoEnEstado >= duracionIdle) {
        entrarCargando();
      }
    } else if (estadoBoss == 1) { 
      if (tiempoEnEstado >= duracionCargando) {
        entrarDisparando();
      }
    } else if (estadoBoss == 2) { 
      if (tiempoEnEstado >= duracionDisparando) {
        entrarIdle();
      }
    }
  }

  void entrarIdle() {
    estadoBoss = 0;
    tiempoCambioEstado = millis();
    cargando = false;
    disparando = false;
  }

  void entrarCargando() {
    estadoBoss = 1;
    tiempoCambioEstado = millis();
    cargando = true;
    disparando = false;
  }

  void entrarDisparando() {
    estadoBoss = 2;
    tiempoCambioEstado = millis();
    cargando = false;
    disparando = true;
  }
    
  
  void recibirDanio(int cantidad) {
    if (cargando || disparando){
      soundManager.reproducirDano(vida);
      vida -= cantidad;
      if (vida < 0) vida = 0;
    }
  }
  
}
