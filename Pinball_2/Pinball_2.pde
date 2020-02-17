import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import ddf.minim.*;
import ddf.minim.signals.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import static javax.swing.JOptionPane.*;

// This is the reference for box2d world
Box2DProcessing box2d;

// Create array for music 
// For music and use 5 types of music thats why create an array with size 5
AudioPlayer[] player = new AudioPlayer[5];
Minim minim;

// For windmills
ArrayList<Windmill> windmills;


// Use this for background image 
PImage backDrop;
PFont font;

// Tracking the score and lives for pinball 
int score = 0;
int lives = 1;

//for the flippers
Flipper fl;
Flipper fr;

Spring spring;
ArrayList<Pair> pairs;
ArrayList<Circle> circle;

//Chain Shapes
Level a;
Pinball pb;

// For flippers to interaction with pinball
boolean lflip;
boolean rflip;

void setup() {
  size(400, 600);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();  
  box2d.listenForCollisions();  
  box2d.setGravity(0, -25);

  // Make the windmill at an x,y position
  windmills = new ArrayList<Windmill>();
  windmills.add(new Windmill(width/6, 360));
  windmills.add(new Windmill(width/1.4, 360));
  windmills.add(new Windmill(width/2.3, 180));


  a = new Level();
  pb = new Pinball(width - 15, height - 220, 8);
  
  pairs = new ArrayList<Pair>();
  circle = new ArrayList<Circle>();
  Pair p = new Pair(width, height/2, new Particle(width+15, height-200), new Box(width-10, height-200, 45, 40));
  pairs.add(p);
  minim = new Minim(this);

  // For flippers creation
  fr = new Flipper(width/2 + 70, height - 120, 25, -QUARTER_PI/2, QUARTER_PI, false, 15, 10, 60);
  fl = new Flipper(width/2 - 120, height - 120, 25, -QUARTER_PI/2 - radians(15), QUARTER_PI - radians(20), true, 15, 10, 60); //have no idea why they don't match up but this works

  // all music load here
  player[0] = minim.loadFile("Streamline.wav");
  player[1] = minim.loadFile("laun.wav");
  player[2] = minim.loadFile("flip.wav");
  player[3] = minim.loadFile("bump.wav");
  player[4] = minim.loadFile("final.wav");

  player[0].play(); 
  player[0].loop();

  // Show background
  backDrop = loadImage("background.jpg");
  spring = new Spring();

  // Create 3 Circles 
  Circle c1 = new Circle(width/2 + 90, height/2 - 100, 30);
  Circle c2 = new Circle(width/2 - 170, height/2 - 100, 30);
  Circle c3 = new Circle(width/2 - 5, 50, 25);
  circle.add(c1);
  circle.add(c2);
  circle.add(c3);

  // After ending game reset all flippers
  rflip = false;
  lflip = false;

  // Using font for showing score
  font = loadFont("Stencil-48.vlw");
  textFont(font, 24);
  textAlign(CENTER);
}

void draw() {
  background(backDrop); //set background
  box2d.step();
  pb.display();
  spring.update(mouseX, mouseY);

  // Draw the windmill
  for (Windmill w : windmills)
    w.display();

  // Draw Chainshapes
  a.display();

  // Draw flippers
  fr.display();
  fl.display(); 

  // Draw for number of circles
  for (Circle c : circle)
  {
    c.display();
  }

  // Checking games over or not 
  if (lives > 0)
  {
    //displays score and lives
    text("Score: ", 50, 50);
    text(score, 45, 75);
    text("Lives: " + lives, 550, 50);

    // Reset all parameter sound, score and live
    if (pb.done())
    {
      minim.stop(); 
      setup();
      --lives;
    }
  } else
  {
    player[0].pause();
    // For showing the score 
    showMessageDialog( null, "Your Score is: " + score );
    score = 0;
    lives = 1;
    minim.stop();
    setup();
  }

  // Draw all boxes
  for (Pair p : pairs) {
    p.display();
  }

  // For position flipper
  rflip = true;
  lflip = true;
}

// For some sounde
void mouseReleased() {
  player[1].play();
  player[1].rewind();
  spring.destroy();
}

// Press for launcher 
void mousePressed() {
  if (pairs.get(0).p2.contains(mouseX, mouseY)) {
    spring.bind(mouseX, mouseY, pairs.get(0).p2);
  }
}

// For flippers sound
void keyPressed() {
  if (keyCode == RIGHT && rflip)
  {
    fr.reverseSpeed();
    player[2].play();
    player[2].rewind();
    rflip = false;
  }
  if (keyCode == LEFT && lflip)
  {
    fl.reverseSpeed();
    player[2].play();
    player[2].rewind();
    lflip = false;
  }
}

// Reset all flippers
void keyReleased( ) {
  if (keyCode == RIGHT && rflip) {
    fr.reverseSpeed();
    rflip = true;
  } else if (keyCode == LEFT && lflip) {
    fl.reverseSpeed();
    lflip = true;
  }
}

// Make force and Play song for every interaction with two object
void applyForceAndPlaySong(Object o, float point, Integer songNumber) {
  Pinball p = (Pinball) o;
  p.change();
  p.body.applyAngularImpulse(400000);
  player[songNumber].play();
  player[songNumber].rewind();
  score += point;
}

//for collisions: applyingImpulses, playing sounds, incrementing the score
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1 instanceof Circle && o2 instanceof Pinball) {
    applyForceAndPlaySong(o2, 50, 3);
  } else if (o1 instanceof Pinball && o2 instanceof Circle) {
    applyForceAndPlaySong(o1, 50, 3);
  } else if (o1 instanceof Rectangle && o2 instanceof Pinball) {
    applyForceAndPlaySong(o2, 10, 4);
  } else if (o1 instanceof Pinball && o2 instanceof Rectangle) {
    applyForceAndPlaySong(o1, 10, 4);
  }
}

// Objects stop touching each other
void endContact(Contact cp) {
  //Get the fixtures
  Fixture f = cp.getFixtureA();
  // Get the bodies
  Body b = f.getBody();
  // Get bodies any object
  Object object = b.getUserData();
  // match which type of object and stop the sound
  if (object instanceof Circle || object instanceof Pinball || object instanceof Rectangle) {
    player[0].pause();
  }
}
