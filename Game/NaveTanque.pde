class NaveTanque extends NaveEnemiga {

  private int dano = 1;
  private color colorBala = color(148, 0, 211);
  private int tamanoBala = 14;
  
  NaveTanque() {
    super("naveTanque", 5, 200, "data/nave_tanque.png", 200); // 5 de vida, por ejemplo
    
    velX = random(-1, 1);
    velY = random(0.5, 1);
    intervaloDisparo = 2000; // más lento
  }

  void disparar(ArrayList<BalaEnemiga> listaBalas) {
    if (!descendiendo && millis() - tiempoUltimoDisparo > intervaloDisparo) {
      listaBalas.add(new BalaEnemiga(x, y + alto / 2, this.dano, this.colorBala, this.tamanoBala));
      tiempoUltimoDisparo = millis();
      //soundManager.reproducirDisparo();
    }
  }
}
