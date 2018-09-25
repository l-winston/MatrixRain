import java.util.Arrays;


int textSize = 20;
int shift = 5;
String[] chars;
int maxRains = 50;
ArrayList<Rain> rains;
color whiteText = color(255);
color textColor = color(70, 140, 50);

float spawnProb = 0.5;
float deathProb = 0.05;
float shortenProb = 0.1;
float mutateProb = 0.1;
void setup() {
  chars = loadStrings("chars.txt");
  rains = new ArrayList<Rain>();
  fullScreen();
  smooth();
}

void draw() {
  if (frameCount%100==0) {
    println(frameRate);
    println(rains.size());
  }

  translate(width/2, height/2);
  background(0);
  if (random(1) < spawnProb && rains.size() < maxRains) {
    rains.add(new Rain());
  }
  for (Rain rain : rains.toArray(new Rain[rains.size()])) {
    rain.increment();
    rain.display();
    if (random(1) < deathProb) {
      rain.alive = false;
    }
  }

  for (Rain rain : rains.toArray(new Rain[rains.size()])) {
    float y = rain.position.y;
    float x = rain.position.x;
    float scale = rain.scale;
    if (y*scale>height/2 | y*scale<-height/2|x*scale>width/2|x*scale<-width/2) {
      rains.remove(rain);
    }
    if (rain.body.size()<2 && !rain.alive) {
      rains.remove(rain);
    }
  }
}


PVector randVec() {
  return new PVector(random(1)*width-width/2, random(1)*height-height/2);
}

String randChar() {
  return chars[floor(random(chars.length))];
}

class Rain {
  ArrayList<String> body;
  String head;
  PVector position;
  boolean alive;
  float scale;

  public Rain() {
    position = randVec();
    head = randChar();
    body = new ArrayList<String>();
    alive = true;
    scale = random(1)+0.5;
  }

  public Rain(ArrayList<String> _body, String _head, PVector _position, float _scale) {
    body = _body;
    head = _head;
    position = _position;
    alive = true;
    scale = _scale;
  }

  public void increment() {
    if(scale > 2)
      alive = false;
    
    if (alive) {
      position.y += shift;
      body.add(head);
      head = randChar();
    } else if (body.size() > 0) {
      head = body.get(0);
      if (random(1) < shortenProb)
        body.remove(0);
    }

    for (int i = 0; i < body.size(); i++) {
      if (random(1) < mutateProb) {
        body.set(i, randChar());
      }
    }
    
    scale*=1.001;
  }

  public void display() {
    textSize(textSize*scale);
    fill(whiteText);
    if (body.size()!=0)
      text(head, position.x*scale, position.y*scale);
    fill(textColor);
    for (int i = 0; i < body.size(); i++) {
      text(body.get(i), position.x*scale, position.y*scale - (i+1)*textSize*scale);
    }
  }
}
