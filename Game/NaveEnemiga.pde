// ------------------------------------------------------------
// Clase abstracta: NaveEnemiga
// Base modular para cualquier tipo de nave enemiga
// ------------------------------------------------------------
abstract class NaveEnemiga extends Nave {
  protected String nombre;
  protected float ancho, alto;
  protected float velX, velY;
  protected PImage sprite;
  protected int score = 100;

  protected boolean descendiendo = true;
  protected float alturaObjetivo;

  protected int tiempoUltimoDisparo = 0;
  protected int intervaloDisparo;
  protected int dano;
  protected color colorBala;
  protected int tamanoBala;

  protected BarraVida barra;

  // Constructor flexible con ancho personalizado
  NaveEnemiga(String n, int vidaInicial, int score, String rSpr, float ancho) {
    super(n, random(100, width - 100), -100, vidaInicial);
    this.nombre = n;
    this.score = score;
    this.ancho = ancho;
    this.alto = ancho;
    this.sprite = loadImage(rSpr);

    velX = random(-2, 2);
    velY = random(1, 2);
    alturaObjetivo = random(100, 250);
    intervaloDisparo = int(random(500, 1500));

    barra = new BarraVida(x, y, ancho, vidaInicial);
  }

  // ------------------------------------------------------------
  // Movimiento común: entrada desde arriba y patrullaje
  // ------------------------------------------------------------
  void moverse() {
    if (descendiendo) {
      y += velY;
      if (y >= alturaObjetivo) descendiendo = false;
    } else {
      x += velX;
      if (x < ancho / 2 || x > width - ancho / 2) velX *= -1;
    }
  }

  // ------------------------------------------------------------
  // Disparo genérico (puede sobreescribirse)
  // ------------------------------------------------------------
  abstract void disparar(ArrayList<BalaEnemiga> listaBalas);

  // ------------------------------------------------------------
  // Dibujo común (sprite + barra de vida)
  // ------------------------------------------------------------
  void dibujar() {
    imageMode(CENTER);
    image(sprite, x, y, ancho, alto);
    barra.dibujar(x, y, vida);
  }
  
  boolean getDestruido() {return false;}
  
  void actualizar() {}
}
