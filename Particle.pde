
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  color partColor;
  float charge;
  ArrayList<PVector> trail;

  Particle(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = random(1, 4);
    charge = random(-1, 1);
    partColor = color(random(255), random(255), random(255));
    trail = new ArrayList<PVector>();
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    
    if (trailMode) {
      trail.add(position.copy());
      if (trail.size() > 400) {
        trail.remove(0);
      }
    }
  
    // Tratamento de colisão com as extremidades da tela
    if (position.x < 0) {
      position.x = 0;
      velocity.x *= -1;
    } else if (position.x > width) {
      position.x = width;
      velocity.x *= -1;
    }
    if (position.y < 0) {
      position.y = 0;
      velocity.y *= -1;
    } else if (position.y > height) {
      position.y = height;
      velocity.y *= -1;
    }
  }
  
  void collide(ArrayList<Particle> particles) {
    for (int i = 0; i < particles.size(); i++) {
      Particle p2 = particles.get(i);
      if (this != p2) {
        float distance = dist(position.x, position.y, p2.position.x, p2.position.y);
        float minDist = mass * (_ssize/2) + p2.mass * (_ssize/2); // Distância mínima antes da colisão
        if (distance < minDist) {
          // Tratamento de colisão entre partículas
          PVector dir = PVector.sub(p2.position, position);
          dir.normalize();
          float overlap = minDist - distance;
          PVector move = PVector.mult(dir, overlap * 0.5);
          position.sub(move);
          p2.position.add(move);

          // Ajustar velocidades levando em consideração as massas
          float v1x = (velocity.x * (mass - p2.mass) + (2 * p2.mass * p2.velocity.x)) / (mass + p2.mass);
          float v1y = (velocity.y * (mass - p2.mass) + (2 * p2.mass * p2.velocity.y)) / (mass + p2.mass);
          float v2x = (p2.velocity.x * (p2.mass - mass) + (2 * mass * velocity.x)) / (mass + p2.mass);
          float v2y = (p2.velocity.y * (p2.mass - mass) + (2 * mass * velocity.y)) / (mass + p2.mass);

          velocity.set(v1x, v1y);
          p2.velocity.set(v2x, v2y);
        }
      }
    }
  }
  
  void display() {
    float size = mass * _ssize;
    fill(partColor);
    ellipse(position.x, position.y, size, size);
    if (debugMode) {
      fill(0, 255, 0);
      text("DEBUG MODE: ON", 25, 15);
      text("M: " + mass, position.x - (size/4), position.y);
      text("p: " + this.position, position.x - (size/4), position.y + 14);
      text("v: " + this.velocity, position.x - (size/4), position.y + 28);
      text("a: " + this.acceleration, position.x - (size/4), position.y + 42);
    }
    if (trailMode) {
      fill(0, 255, 0);
      text("TRAIL MODE: ON", 25, 35);
    }
    
  }
  
  void drawTrail() {
    noFill();
    stroke(partColor, 155); // Cor da trilha com baixa opacidade
    beginShape();
    for (PVector pt : trail) {
      vertex(pt.x, pt.y);
    }
    endShape();
  }
}
