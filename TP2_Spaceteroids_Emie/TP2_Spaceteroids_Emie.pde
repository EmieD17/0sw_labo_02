import processing.sound.*;
SoundFile pew;
SoundFile lifeUp;

PImage bg;

int currentTime;
int previousTime;
int deltaTime;

int points = 0;
int pointsForLife = 0;
int boidsDeleted = 0;

int timerP = 0;
int timerPRate = 200;

float distanceVM;
float distanceVP ;
float distanceMP ; 

ArrayList<Projectile> bullets;
int maxBullets = 6;

ArrayList<Mover> flock;
int flockSize;
Niveau n;

Vaisseau v;

void setup () {
  pew = new SoundFile(this, "pew.mp3");
  lifeUp = new SoundFile(this, "lifeUp.mp3");
  bg = loadImage("Space.png");
  size (1024, 512);
  currentTime = millis();
  previousTime = millis();
  
  points = 0;
  pointsForLife = 0;
  boidsDeleted = 0;
  
  timerP = 0;
  
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  v.isVisible = true;
  
  bullets = new ArrayList<Projectile>();
  
  n = new Niveau(20);
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  update(deltaTime);
  display();
}

PVector thrusters = new PVector(0, -0.02);

/***
  The calculations should go here
*/
void update(int delta) {
  if (keyPressed) {
    switch (key) {
      case 'w':
        v.thrust();
        break;
      case 'a': //gauche
        v.pivote(-.03); 
        break;
      case 'd': //droite
        v.pivote(.03); 
        break;
      case ' ': //fire
        if(timerP >= timerPRate)
        {
          pew.play();
          v.fire();
        }
        break;
    }
  }
  
  timerP += delta;
  
  v.update(delta);
  for ( Projectile p : bullets) {
    p.update(deltaTime);
  }
  
  collisions();
  
  for (Mover m : flock) {
    m.flock(flock);
    m.update(delta);
  }
}

/***
  The rendering should go here
*/
void display () {
  background(bg);
  fill(0,255,0);
  textSize(32);
  text(points + " points", 30, 40);
  
  fill(255,20,147);
  textSize(32);
  text(v.vie + " Vie", width - 90 , 40);
  
  fill(255,100,40);
  textSize(32);
  text("Level " + n.num, (width / 2) - 40, 40);
  
  v.display();
  for ( Projectile p : bullets) {
    p.display();
  }
  
  for (Mover m : flock) {
    m.display();
  }
  
  fill(0,255,0);
  ellipse(v.getLocation().x, v.getLocation().y, v.getRadius() * 10, v.getRadius() * 10);

}



void keyReleased() {
    switch (key) {
      case 'w':
        v.noThrust();
        break;
      case 'r': //reset
        setup();
        break;
    }  
}

void flockCreation(){
  flock = new ArrayList<Mover>();
  for (int i = 0; i < flockSize; i++) {
    Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
    flock.add(m);
  } 
}

void collisions(){
  for (Mover m : flock ) {  
    
    for (Projectile p : bullets) {
      distanceVM = PVector.dist(v.getLocation(), m.getLocation());
      distanceVP = PVector.dist(v.getLocation(), p.getLocation());
      distanceMP = PVector.dist(m.getLocation(), p.getLocation());
      
      //boids & projectiles
      if((p.getRadius() + m.getRadius() >=distanceMP)  && m.isVisible && p.isVisible )
      {
        println("point!");
        p.deleted();
        m.deleted();
        points++;
        pointsForLife++;
      } 
      //boids & vaisseau
      if((v.getRadius() + m.getRadius() >=distanceVM)  && v.isVisible && m.isVisible)
      {      
        println("boids & vaisseau collision");
        m.deleted();
        v.deleted();
      } 
      //projectiles & vaisseau
      if((v.getRadius() + p.getRadius() >=distanceVP)  && v.isVisible && p.isVisible)
      {
        println("I hit myself!");
        p.deleted();
        v.deleted();
      } 
    }
  }
}
