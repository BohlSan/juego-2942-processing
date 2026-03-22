class OpcionesPowerUps {
  ArrayList<PowerUpPeso> opciones;

  // 5 pesos: vida, escudo, ametralladora, autoDrone, canon
  OpcionesPowerUps(float probVida, float probEscudo, float probAmetralladora, float probAutoDrone, float probCanon,
                   final float x, final float y) {
    opciones = new ArrayList<PowerUpPeso>();

    // Vida
    opciones.add(new PowerUpPeso(probVida) {
      PowerUp generar() { return new PowerUpVida(x, y); }
    });

    // Escudo
    opciones.add(new PowerUpPeso(probEscudo) {
      PowerUp generar() { return new PowerUpEscudo(x, y); }
    });

    // Ametralladora (temporal)
    opciones.add(new PowerUpPeso(probAmetralladora) {
      PowerUp generar() { return new PowerUpAmetralladora(x, y); }
    });

    // AutoDrone (temporal)
    opciones.add(new PowerUpPeso(probAutoDrone) {
      PowerUp generar() { return new PowerUpAutoDrone(x, y); }
    });

    // Cañón (permanente hasta perder vida) — sprite opcional
    opciones.add(new PowerUpPeso(probCanon) {
      PowerUp generar() { return new PowerUpCanon(x, y); }
    });
  }
}
