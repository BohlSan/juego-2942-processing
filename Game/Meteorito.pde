// ------------------------------------------------------------
// Clase: Meteorito
// Enemigo que cae sin disparar, gira y puede generar partículas
// ------------------------------------------------------------
class Meteorito extends NaveEnemiga {
  
  private float angulo = 0;
  private float velocidadRotacion;
  private boolean destruido = false;
  //int[] tamanos = {60, 90, 120};
  //ArrayList<FragmentoMeteorito> fragmentos = new ArrayList<FragmentoMeteorito>();

  Meteorito(int numRandom) {
    //float ancho = tamanos[int(random(tamanos.length))];
    //int vida = ancho / 30;
    super("meteorito", numRandom / 30, 0, "data/meteorito.png", numRandom);
    this.velY = 300 / ancho;
    this.velocidadRotacion = random(0.01, 0.05);
    this.barra = null; // No tiene barra visible
  }

  @Override
  void moverse() {
    if (!destruido) {
      y += velY;
      angulo += velocidadRotacion;

      // Rebote leve en bordes (opcional)
      x += velX;
      if (x < ancho / 2 || x > width - ancho / 2) velX *= -1;

      // Si sale de la pantalla, marcar destruido
      if (y > height + alto) destruido = true;
    }/* else {
      // Actualiza partículas tras la explosión
      for (int i = fragmentos.size() - 1; i >= 0; i--) {
        FragmentoMeteorito fr = fragmentos.get(i);
        fr.actualizar();
        if (fr.opacidad <= 0) fragmentos.remove(i);
      }
    }*/
  }

  @Override
  void disparar(ArrayList<BalaEnemiga> listaBalas) {
    // No dispara (los meteoritos solo caen)
  }

  @Override
  void dibujar() {
    pushMatrix();
    translate(x, y);
    rotate(angulo);
    imageMode(CENTER);
    image(sprite, 0, 0, ancho, alto);
    popMatrix();

    // Dibuja partículas si está destruido
    /*for (FragmentoMeteorito fr : fragmentos) {
      fr.dibujar();
    }*/
  }

  /*void explotar() {
    if (!destruido) {
      destruido = true;
      for (int i = 0; i < 20; i++) {
        fragmentos.add(new FragmentoMeteorito(x, y));
      }
    }
  }*/
  
  public boolean getDestruido(){
    return destruido;
  }
}
