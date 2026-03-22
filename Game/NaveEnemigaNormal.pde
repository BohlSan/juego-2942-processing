
class NaveEnemigaNormal extends NaveEnemiga {

  private int dano = 1;
  private color colorBala = color(255, 80, 80);
  private int tamanoBala = 8;
  
  NaveEnemigaNormal() {
    super("naveNormal", 2, 100, "data/nave_enemiga.png", 100);
    
    this.dano = 1;
    this.colorBala = color(255, 100, 100);
    this.tamanoBala = 8;
  }
  
  void disparar(ArrayList<BalaEnemiga> listaBalas) {
    if (!descendiendo && millis() - tiempoUltimoDisparo > intervaloDisparo) {
      listaBalas.add(new BalaEnemiga(x, y + alto / 2, dano, colorBala, tamanoBala));
      tiempoUltimoDisparo = millis();
      intervaloDisparo = int(random(500, 1500));
      //soundManager.reproducirDisparo();
    }
  }
}
