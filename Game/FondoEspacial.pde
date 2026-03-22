// ------------------------------------------------------------
// Clase FondoEspacial: maneja todas las estrellas
// ------------------------------------------------------------
class FondoEspacial {
  private Estrella[] estrellas;
  private int cantidadEstrellas;
  private color colorFondo;
  private color inicioFondo = color(10, 25, 40);
  private color finFondo = color(5, 5, 10);
  private float progresoFondo;

  FondoEspacial(int cantidad) {
    this.cantidadEstrellas = cantidad;
    this.colorFondo = inicioFondo;
    this.progresoFondo = 0;
    estrellas = new Estrella[cantidadEstrellas];

    for (int i = 0; i < cantidadEstrellas; i++) {
      estrellas[i] = new Estrella(random(width), random(height), random(0.3, 2.5));
    }
  }

  void actualizar() {
    for (Estrella e : estrellas) e.mover();
    cambiarFondo(0.0001f);
  }

  void dibujar() {
    for (Estrella e : estrellas) e.dibujar();
  }
  
  void cambiarFondo(float aceleracion){
    if (gameManager.estado.equals("jugando")){
      if (progresoFondo < 1){
        progresoFondo += aceleracion;
        colorFondo = lerpColor(inicioFondo, finFondo, progresoFondo);
      }
      else{
        progresoFondo = 1;
        colorFondo = finFondo;
      }
    }
  }
  
  public color getColorFondo(){
    return colorFondo;
  }
}
