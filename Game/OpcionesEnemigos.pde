class OpcionesEnemigos {
  private ArrayList<EnemigoPeso> opciones;
  private int probENormal = 100;
  private int probETanque = 30;
  private int probEDivisor = 10;
  private int probEMeteorito = 40;
  
  private int[] tamanosMet = {60, 90, 120};

  OpcionesEnemigos(int probNormal, int probTanque, int probDivisor, int probMeteorito){
    this.probENormal = probNormal;
    this.probETanque = probTanque;
    this.probEDivisor = probDivisor;
    this.probEMeteorito = probMeteorito;
    
    opciones = new ArrayList<EnemigoPeso>();

    //Nave Normal
    opciones.add(new EnemigoPeso(probENormal) {
      NaveEnemiga generar() {
        return new NaveEnemigaNormal();
      }
    });

    //Nave Tanque
    opciones.add(new EnemigoPeso(probETanque) {
      NaveEnemiga generar() {
        return new NaveTanque();
      }
    });
    
    //Nave Divisor
    opciones.add(new EnemigoPeso(probEDivisor) {
      NaveEnemiga generar() {
        return new NaveDivisor(3, true);
      }
    });
    
    // 🚀 Meteorito
    opciones.add(new EnemigoPeso(probEMeteorito) {
      NaveEnemiga generar() {
        return new Meteorito(tamanosMet[int(random(tamanosMet.length))]);
      }
    });
  }
  
  /*public void cambiarProbabilidades(int probNormal, int probTanque, int probDivisor){
    opciones.set(0, new EnemigoPeso(probENormal));
    opciones.set(1, new EnemigoPeso(probETanque));
    opciones.set(2, new EnemigoPeso(probEDivisor));
  }*/
}
