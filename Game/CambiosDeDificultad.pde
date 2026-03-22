class CambiosDeDificultad {
  private int fase = -1;
  private int scoreActual = 0;

  CambiosDeDificultad() {}

  void actualizar() {
    scoreActual = gameManager.getScore();

    // Nueva fase cada 1250 puntos
    int nuevaFase = max(0, scoreActual / 1250);
    if (nuevaFase == fase) return;
    fase = nuevaFase;

    // Cambios de intervalo de aparicion de enemigos
    int intervalo = max(650, 2000 - 120 * fase);

    // Cambia Cantidad maxima de enemigos
    int maxEn = min(24, 10 + (int)floor(0.9f * fase));

    // Transicion de probabilidades continua
    int probNormal     = max(25, 100 - 6 * fase);   // 100 → 25
    int probTanque     = min(120, 30 + 5 * fase);   // 30  → 120
    int probDivisor    = min(120, 10 + 4 * fase);   // 10  → 120
    int probMeteorito  = min(80,  20 + 2 * fase);   // 20  → 80

    // Apply to generator
    GeneradorEnemigos gen = gameManager.getGenEnemigos();
    gen.setIntervaloEnemigos(intervalo);
    gen.setMaxEnemigos(maxEn);
    gen.cambiarOpcionesEnemigos(probNormal, probTanque, probDivisor, probMeteorito);
  }

  public int getFase() { return fase; }
}
