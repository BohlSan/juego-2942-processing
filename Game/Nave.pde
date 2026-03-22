abstract class Nave {
  protected float x;
  protected float y;
  protected int vida;
  protected String nombre;

  Nave(String nombre, float xInicial, float yInicial, int vidaInicial) {
    this.x = xInicial;
    this.y = yInicial;
    this.vida = vidaInicial;
    this.nombre = nombre;
  }

  void recibirDanio(int cantidad) {
    soundManager.reproducirDano(vida);
    vida -= cantidad;
    if (vida < 0) vida = 0;
  }

  boolean estaViva() {
    return vida > 0;
  }
  
  public String getNombre(){
    return nombre;
  }

  abstract void moverse();
  abstract void dibujar();
  //abstract void explotar();
}
