PFont font;
void setup() {
  fullScreen(P2D);
  frameRate(60);
  rectMode(RADIUS);
  font = loadFont("Fuente1.vlw");
  textFont(font);
  j1 = new Player(50.0, height/2);
  j2 = new Player(width-50.0, height/2);
  b = new Ball(width/2, height/2, random(-10, 10), random(-2, 2));
}

boolean p1[] = new boolean [2];
boolean p2[] = new boolean [2];
boolean football=false;
Player j1;
Player j2;
Ball b;
int bkg = 0;

void draw() {
  background(0);
//UI
  strokeWeight(7);
  stroke(255);
  line(0, 0, width, 0);//lateral
  //line(0, 0, 0, height);
  line(0, height, width, height);//lateral
  //line(width, 0, width, height);
  strokeWeight(10);
  line(width/2, 0, width/2, height);//middle line
  strokeWeight(1);

//CAMPO DE FUTBOL
if(football==true){
  stroke(255);
  strokeWeight(5);
  fill(0, 0, 0, 0);
  ellipse(width/2,height/2,height/3,height/3);
  ellipse(width, height/2, height, height);
  ellipse(width-width, height/2, height, height);
 }
// Puntuación

  //J1
  textSize(60);
  textAlign(CENTER);
   if(b.pos.x<=width-width){
    strokeWeight(0);
    fill(255,0,0);
  rect(width-width,height/2,width/2,height,50);
  }
  fill(255);
  text(j1.score, width/3, height/6);
  if(j1.score ==5){
  text("YOU WIN¡", width/4,height/2);
  }
  
  //J2
  textSize(60);
  textAlign(CENTER);
  if(b.pos.x>=width){
    strokeWeight(0);
    fill(255,0,0);
  rect(width,height/2,width/2,height,50);
  }
  fill(255);
  text(j2.score, width-width/3, height/6);
  if(j2.score ==5){
  text("YOU WIN¡", width-width/4,height/2);
  }
  strokeWeight(2);
  
//objects  
  j1.update(p1);
  j2.update(p2);
  j1.render();
  j2.render();

  b.update();

  strokeWeight(2);
  stroke(0);
  b.render();
}

class Player {
  PVector pos = new PVector();
  PVector speed;
  final float len = 80;
  public int score = 0;//puntuacion
  public float mult = 1.05;//energía multiplicadora
  public float plysbar = 0.0;//barra de velocidad
  public float plyebar = 0.0;//barra de energía
  public float  plymult = 1.0;//multiplicador de velocidad
  public int clrsb = 0;//color de la barra de velocidad cuando está completa
  public int clreb = 0;//color del la barra de energía cuando está completa
  Player(float posx, float posy) {
    pos.set(posx, posy);
    speed = new PVector(0.0, 0.0);
  }

  void update(boolean controls[]) {
    float delta = 1/frameRate; 
    if(plymult == 2){ //activa la velocidad sónica
    if (controls[0]) speed.y = -800;
    if (controls[1]) speed.y = 800;
    if (!controls[0] && !controls[1]) speed.y = 0;
    pos.y += (speed.y)*delta;
    pos.y = constrain(pos.y, len, height-len);
    }else{
    if (controls[0]) speed.y = -300;
    if (controls[1]) speed.y = 300;
    if (!controls[0] && !controls[1]) speed.y = 0;
    //energy bar
    if(!b.paused){
    if(plyebar <= width/2-60){
    clreb = 0;
    plyebar += 80*delta;
    }else clreb = 255;
    //speed bar
    if(plysbar <= width/2-60){
    clrsb = 0;
    plysbar += 40*delta;
    }else clrsb = 255;
    pos.y += (speed.y)*delta;
    pos.y = constrain(pos.y, len, height-len);
    }
    
    }
}

  void render() {
    if(mult == 2 && plymult ==2){
      
     fill(255, 0, 255);
     
    }else{
    if (mult == 2.0 ) { //comprueba si la fuerza esta activada
      
      fill(255, 0, 0);//establece color rojo
      
    } else{
      
        if (plymult == 2.0) {//coprueba si la velocidad está acivada
        
        fill(0, 0, 255);//establece el color azul
        
       }else fill(255);
      }
    }
    rect(pos.x, pos.y, 10, len);
    //rectMode(CENTER);
    strokeWeight(2);
    fill(clreb,0,0);
    rect(pos.x, height-height+7,plyebar,5);
    fill(0,0,clrsb);
    rect(pos.x, height-height+17,plysbar,5);
   }
   
}

class Ball {
  PVector pos = new PVector();
  
  public int rad = 20;//radio de la pelota
  public int rellenoball1=255;//relleno de la bola R (RGB)
  public int rellenoball2 = 255;//relleno de la bola GB (RGB)
  
  public boolean paused = true;
  PVector speed = new PVector();
  Player last = null;

  Ball(float posx, float posy, float speedx, float speedy) {
    pos.set(posx, posy);
    speed.set(speedx, speedy);
  }

  void update() {

    if (pos.y+speed.y-10 <= 0) speed.y = -speed.y; 
    if (pos.y+speed.y+10 >= height) speed.y = -speed.y;

    // Player 1
    if (pos.x + speed.x - rad <= j1.pos.x && pos.y + speed.y - rad <= j1.pos.y+j1.len && pos.y + speed.y >= j1.pos.y - j1.len) {
      if (j1.mult==2) {
        rellenoball1=255;
        rellenoball2 =0;
      }else{
      rellenoball1 =255;
      rellenoball2= 255;      
      }
      if(j1.plymult == 2.0){
      j1.plymult = 1;
      }
      last = j1;
      speed.x = -speed.x*j1.mult;
      j1.mult = 1.05;
      speed.y += (j1.speed.y*1.0/frameRate)*0.5;
    }
    if (pos.x + speed.x + 20 >= j2.pos.x && pos.y + speed.y - rad <= j2.pos.y+j2.len && pos.y + speed.y >= j2.pos.y - j2.len) {
       if (j2.mult==2) {
        rellenoball1=255;
        rellenoball2 =0;
      }else{
      rellenoball1 =255;
      rellenoball2= 255;      
      }
      if(j2.plymult == 2.0){
      j2.plymult = 1;
      }
      last = j2;
      speed.x = -speed.x*j2.mult;
      j2.mult = 1.05;
      speed.y += (j1.speed.y*1.0/frameRate)*0.5;
    }

    if (pos.x <= 0 || pos.x >= width) {
      if (pos.x <= 0 && last!= null) j2.score++;
      if(pos.x >= width && last!= null) j1.score++;
      j1.pos.y = height/2;
      j2.pos.y= height/2;
      paused = true;
      rellenoball1 =255;
      rellenoball2= 255;
      pos.set(width/2, height/2);
      speed.set(random(-10, 10), random(-2, 2));
      last = null;
    }
    if (!paused){
      pos.add(speed);
    }
}

  void render() {
    strokeWeight(1);
    fill(rellenoball1, rellenoball2, rellenoball2);
    ellipse(pos.x, pos.y, rad, rad);
  }
}

void keyPressed() {
  switch (key) {
    
  case 'w':
    p1[0] = true;
    break;
  case 's':
    p1[1] = true;
    break;

  case 'o':
    p2[0] = true;
    break;
  case 'l':
    p2[1] = true;
    break;
  case ' ':
  if(j1.score ==5 || j2.score ==5){
  j1.score = 0;
  j2.score =0;
  j1.plysbar = 0.0;
  j1.plyebar = 0.0;
  j2.plysbar = 0.0;
  j2.plyebar = 0.0;
  }else b.paused = false;
    break;
    
    //Mejoras del jugador
  case 'e':
  if(j1.plyebar >= width/2-70){
    j1.plyebar = 0.0;
    j1.mult = 2.0;
  }
    break;
  case 'p':
    if(j2.plyebar >= width/2-70){
    j2.plyebar = 0.0;
    j2.mult = 2.0;
  }
    break;
  case 'q':
  if(j1.plysbar >= width/2-70){    
    j1.plysbar = 0.0;
    j1.plymult=2.0;
    
    if(j1.mult ==2 && j1.plymult ==2){
    j1.plysbar = 0.0;
    j1.plyebar = 0.0;
    j1.plymult=2.0;
    }
  }
    break;
  case'i': 
    if(j2.plysbar >= width/2-70){    
    j2.plysbar = 0.0;
    j2.plymult=2.0;
    
    if(j1.mult ==2 && j1.plymult ==2){
    j2.plysbar = 0.0;
    j2.plyebar = 0.0;
    j2.plymult=2.0;
    }
  }
  
    break;
  
  case 'b':
  if(football ==false){
    football=true;
  }else football = false;
 }
}

void keyReleased() {
  switch (key) {
  case 'w':
    p1[0] = false;
    break;
  case 's':
    p1[1] = false;
    break;

  case 'o':
    p2[0] = false;
    break;
  case 'l':
    p2[1] = false;
    break;
  }
}
