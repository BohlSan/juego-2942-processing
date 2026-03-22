import java.util.HashMap;

class DataManager {
  private int recorda;
  private int scoreActual = 0;
  private int cantDisparosActual = 0;
  private int cantDanoActual = 0;
  private int cantBalasPerdidasActual = 0;
  private int cantPowerUpsAgarrados = 0;
  private int cantPowerUpsUsados = 0;
  private int cantNavesDestruidas = 0;
  
  DataManager(){}
  
  void leerRecord(String rutaArchivo){
    try{
      JSONObject recordJSON = loadJSONObject(rutaArchivo);
      int x = recordJSON.getInt("record");
      recorda = x;
    } catch (Exception e) {
      JSONObject recordJSON = new JSONObject();
      recordJSON.setInt("record", 0);
      saveJSONObject(recordJSON, "datos/record.json");
      recorda = 0;
    }
  }

  void guardarRecord(String rutaArchivo, int score){
    scoreActual = score;
    JSONObject recordJSON = loadJSONObject(rutaArchivo);
    if (score > recorda){
      recordJSON.setInt("record", score);
      saveJSONObject(recordJSON, "datos/record.json");
      recorda = score;
    }
  }
  
  void verificarPartida(){
    Table tablaPartidas;
    try{
      tablaPartidas = loadTable("datos/partidas.csv", "header"); 
      if (tablaPartidas == null) {
        throw new Exception();
       }
    }
    catch(Exception e) {
      tablaPartidas = new Table();
  
      tablaPartidas.addColumn("Score");
      tablaPartidas.addColumn("Balas Disparadas");
      tablaPartidas.addColumn("Daño Recibido");
      tablaPartidas.addColumn("Balas Perdidas");
      tablaPartidas.addColumn("Power Ups Agarrados");
      tablaPartidas.addColumn("Power Ups Usados");
      tablaPartidas.addColumn("Naves Destruidas");
  
      saveTable(tablaPartidas, "datos/partidas.csv");
    }
  }

  void guardarPartida(){
    Table tablaPartidas = loadTable("datos/partidas.csv", "header");
    TableRow fila = tablaPartidas.addRow();
    
    fila.setInt("Score", scoreActual);
    fila.setInt("Balas Disparadas", cantDisparosActual);
    fila.setInt("Daño Recibido", cantDanoActual);
    fila.setInt("Balas Perdidas", cantBalasPerdidasActual);
    fila.setInt("Power Ups Agarrados", cantPowerUpsAgarrados);
    fila.setInt("Power Ups Usados", cantPowerUpsUsados);
    fila.setInt("Naves Destruidas", cantNavesDestruidas);

    saveTable(tablaPartidas, "datos/partidas.csv");
  }
  
  public void reiniciar(){
    cantDisparosActual = 0;
    cantDanoActual = 0;
    cantBalasPerdidasActual = 0;
    cantPowerUpsAgarrados = 0;
    cantPowerUpsUsados = 0;
    cantNavesDestruidas = 0;
  }
  
  public void sumarDisparo(){
    cantDisparosActual += 1;
  }
  
  public void sumarDanio(){
    cantDanoActual += 1;
  }
  
  public void sumarBalaPerdida(){
    cantBalasPerdidasActual += 1;
  }
  
  public void sumarPowerUpAgarrado(){
    cantPowerUpsAgarrados += 1;
  }
  
  public void sumarPowerUpUsado(){
    cantPowerUpsUsados += 1;
  }
  
  public void sumarNavesDestruidas(){
    cantNavesDestruidas += 1;
  }
  
  public HashMap obtenerSumaDatosTabla(){
    Table historial = loadTable("datos/partidas.csv", "header");
    HashMap<String, Number> totales = new HashMap<String, Number>();
    
    totales.put("Cantidad Partidas", historial.getRowCount());
    totales.put("Balas Disparadas", 0);
    totales.put("Daño Recibido", 0);
    totales.put("Balas Perdidas", 0);
    totales.put("Power Ups Agarrados", 0);
    totales.put("Power Ups Usados", 0);
    totales.put("Naves Destruidas", 0);
    
    for (TableRow fila : historial.rows()) {
      totales.put("Balas Disparadas", totales.get("Balas Disparadas").intValue() + fila.getInt("Balas Disparadas"));
      totales.put("Daño Recibido", totales.get("Daño Recibido").intValue() + fila.getInt("Daño Recibido"));
      totales.put("Balas Perdidas", totales.get("Balas Perdidas").intValue() + fila.getInt("Balas Perdidas"));
      totales.put("Power Ups Agarrados", totales.get("Power Ups Agarrados").intValue() + fila.getInt("Power Ups Agarrados"));
      totales.put("Power Ups Usados", totales.get("Power Ups Usados").intValue() + fila.getInt("Power Ups Usados"));
      totales.put("Naves Destruidas", totales.get("Naves Destruidas").intValue() + fila.getInt("Naves Destruidas"));
    }
    
    float sumaBalas = totales.get("Balas Disparadas").intValue() - totales.get("Balas Perdidas").intValue();
    float precision = ((sumaBalas/totales.get("Balas Disparadas").intValue()) * 100);

    totales.put("Precision", round(precision * 100) / 100.0);
    
    return totales;
  }
  
  public int getRecord(){
   return recorda; 
  }
  public void BarrasScore(){
      Table historial = loadTable("datos/partidas.csv", "header");
      
      int graphx = (int)(width * 0.325);
      int graphy = (int)(height * 0.6);
      int spacing = (int)(0.00858586 * width);
      float graphHeight = height * 0.3;
      float graphWidth = spacing*30;
  
      //El fondo
      noStroke();
      fill(245);
      rectMode(CORNER);
      rect(graphx-50,graphy, graphWidth+100, -graphHeight-100, 15);
      
      //El titulo
      fill(0,0,0);
      textAlign(CENTER);
      textFont(createFont("data/Audiowide-Regular.ttf", 100));
      textSize(height * 0.02962);
      text("Ultimos 30 puntajes", graphx + graphWidth/2, graphy - graphHeight - 50);

      
      int[] score = historial.getIntColumn("Score");
      
      int start = max(0, historial.getRowCount() - 30);
      int[] ultimas30 = new int[historial.getRowCount() - start];
      
      for (int i = start; i < historial.getRowCount(); i++) {
        ultimas30[i - start] = score[i];
      }
      
      int barrax = graphx;
      fill(48,113, 224);
      int escala = max(ultimas30) / (int)(height*0.277777778);
      for (int s : ultimas30){
        int altura = max(1,s / escala);
        rectMode(CORNER);
        rect(barrax, graphy - altura, spacing * 0.75, altura);
        barrax += spacing;
      }
      //Los numeros de referencia

      for (float t = 0.2; t <= 1.0; t += 0.2) {
        float yTick = graphy - t * height*0.277777778;
        fill(0);
        textAlign(LEFT);
        textSize(height * 0.0185);
        text(String.format("%.0f", t * max(ultimas30)), graphx - 45, yTick);
        
        stroke(180);
        strokeWeight(1);
        line(graphx+50+ graphWidth, yTick, graphx+50, yTick);
        noStroke();
      }
  }
  
  
  public void boxplotAccuracy() {
    Table historial = loadTable("datos/partidas.csv", "header");
    int[] balasDisparadas = historial.getIntColumn("Balas Disparadas");
    int[] balasPerdidas = historial.getIntColumn("Balas Perdidas");
    
    int cantBalas = balasDisparadas.length;
    float[] accuracy = new float[cantBalas];
    
    // Calcular accuracy
    for (int i = 0; i < cantBalas; i++) {
      accuracy[i] = (float)(balasDisparadas[i] - balasPerdidas[i]) / balasDisparadas[i];
    }
    
    // Ordenar para percentiles
    accuracy = sort(accuracy);
    
    float q1 = accuracy[cantBalas / 4];
    float mediana = accuracy[cantBalas / 2];
    float q3 = accuracy[3 * cantBalas / 4];
    float minimo = accuracy[0];
    float maximo = accuracy[cantBalas - 1];

    int graphx = (int)(width * 0.3);
    int graphy = (int)(height * 0.9);
    float boxHeight = height * 0.2;
    float boxWidth = width * 0.3;
    
    //El fondo
    noStroke();
    fill(245);
    rectMode(CORNER);
    rect(graphx, graphy+50, boxWidth, -boxHeight-130, 15);
    //El titulo
    fill(0,0,0);
    textAlign(CENTER);
    textFont(createFont("data/Audiowide-Regular.ttf", 100));
    textSize(height * 0.02962);
    text("Distribucion de Precision", graphx + boxWidth/2, graphy - boxHeight - 33);
    
    //La linea del medio
    stroke(1);
    line(graphx, graphy-boxHeight/2, graphx + boxWidth, graphy-boxHeight/2);
    
    //La caja del boxplot
    fill(200, 100, 100, 150);
    stroke(0);
    rectMode(CORNER);
    rect(graphx + q1 * boxWidth, graphy, (q3-q1) * boxWidth, -boxHeight);
    //Linea de mediana
    line(graphx + mediana * boxWidth, graphy, graphx + mediana * boxWidth, graphy - boxHeight);
    
    //Los puntos
    randomSeed(42);
    fill(0, 150, 200, 180);
    noStroke();
    for (float acc : accuracy) {
      float x = graphx + acc * boxWidth;
      float y = graphy - boxHeight/2 + random(-boxHeight/2, boxHeight/2);
      ellipse(x, y, 6, 6);
    }
    
    //Los numeros de referencia
    stroke(0);
    strokeWeight(1.2);
    line(graphx, graphy, graphx + boxWidth, graphy);
    noStroke();
    for (float t = 0.1; t <= 1.0; t += 0.1) {
      float xTick = graphx + t * boxWidth;
      fill(0);
      textAlign(LEFT);
      textFont(createFont("data/Audiowide-Regular.ttf", height * 0.01851));
      text(String.format("%.1f", t), xTick-20, graphy + 38);
      stroke(100);
      strokeWeight(1);
      line(xTick, graphy+10, xTick, graphy-10);
      noStroke();
    }
    strokeWeight(1);
  }



}
