final float MIN_SCALE = 0.85f;
final float GRAVITY = 0.05f;
final float MAX_PARTICLES = 1500;

ArrayList<Particle> particles;

boolean debugMode = false;
boolean trailMode = false;

float _gravity;
float _ssize;
float _nparticles;

void setup() {
  fullScreen();
  frameRate(60);
  particles = new ArrayList<Particle>();
  _gravity = 1;
  _ssize = 7;
  _nparticles = 30;
  
  //createParticles(int(_nparticles));
}

void draw() {
  background(0);

  for (int i = 0; i < particles.size(); i++) {
    Particle p1 = particles.get(i);
    p1.update();
    p1.display();
    p1.collide(particles);
    if (trailMode) p1.drawTrail();

    for (int j = 0; j < particles.size(); j++) {
      if (i != j) {
        Particle p2 = particles.get(j);
        PVector force = calculateGravitationalForce(p1, p2);
        p1.applyForce(force);
      }
    }
  }
}


void createParticles(int n) {
  for (int i = 0; i < n; i++) {
    particles.add(new Particle(random(width), random(height)));
  }
}

void mousePressed() {
  Particle p = new Particle(mouseX, mouseY);
  particles.add(p);
}

void mouseWheel(MouseEvent event) {
  //float wheelValue = event.getCount();
  //if (wheelValue <= 0.85 && 
  
}

void keyPressed() {
  if (key == 'd') {
    debugMode = !debugMode;
  }
  if (key == 'r') {
    particles.clear();
  }
  if (key == 'i') {
    if (particles.size() < _nparticles) {
      createParticles(int(_nparticles));
    }
  }
  if (key == 't') {
    trailMode = !trailMode;
  }
}

PVector calculateGravitationalForce(Particle p1, Particle p2) {
  float distance = dist(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
  distance = max(distance, 5.0); // Evitar divisão por zero
  float forceMagnitude = (_gravity * p1.mass * p2.mass) / (distance * distance);
  PVector force = new PVector(p2.position.x - p1.position.x, p2.position.y - p1.position.y);
  force.normalize();
  force.mult(forceMagnitude);
  return force;
}
