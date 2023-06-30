// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  PVector target = new PVector(0,0);
  ArrayList<Enemy> enemies;
  Enemy enemy;
  
  Flock( ArrayList<Enemy> temp_enemies) {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    enemies =  temp_enemies;
  }
   

  void run() {
    //for (Boid b : boids) {
    //  b.run(boids, enemies, target);  // Passing the entire list of boids to each boid individually
    //  if(!b.isAlive){
    //    b.remove(this);
    //  }
    //}
    for (int i = boids.size() - 1; i >= 0; i--) {
      Boid boid = boids.get(i);
      boid.run(boids, enemies, target);
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

}
