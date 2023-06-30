//障害物クラス

class Obstacle {
  PVector position;
  float radius;
  
  Obstacle(float x, float y, float r) {
    position = new PVector(x, y);
    radius = r;
  }
  
  void display() {
    fill(175);
    noSmooth();
    ellipseMode(CENTER);
    ellipse(position.x, position.y, radius*2, radius*2);
  }
}
