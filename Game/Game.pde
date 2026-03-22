GameManager gameManager;
DataManager dataManager;
SoundManager soundManager;

void setup() {
  //size(1500, 1000);
  fullScreen();
  gameManager = new GameManager();
  dataManager = new DataManager();
  soundManager = new SoundManager(this);
  
  dataManager.leerRecord("datos/record.json");
  dataManager.verificarPartida();

}

void draw() {
  gameManager.actualizar();
  gameManager.dibujar();
  
  if(mouseButton == LEFT){
     //mouseButton = 0;
     gameManager.naveDisparar();
  }
}

void keyPressed() {
  if (key == ESC) {
    key = 0;
    gameManager.togglePausa();
  }

}

void mousePressed() {
  if (mouseButton == LEFT){
    gameManager.clickEnMenu(mouseX, mouseY);
  }
  else if (mouseButton == RIGHT){
    if (gameManager.estado.equals("jugando")){
    gameManager.activarPowerUp();
    }
  }
}
