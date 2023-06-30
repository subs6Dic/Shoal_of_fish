// The Boid class
import processing.sound.*;
SoundFile collisionSound; // 衝突音声ファイル
SoundFile selectSound1; // スタート音声ファイル
SoundFile attackSound; // スタート音声ファイル
SoundFile bgmSound;// BGM音声ファイル
SoundFile clearSound;// BGM音声ファイル
Bubble bubble;
    
public class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  boolean isAlive; // 追加: 群れの生存フラグ
  ArrayList<Enemy> enemies;
  int color_num;
  
  PApplet parent;             //Sound再生用にPApplet
  
  float xtar = 500; //Changed:目標点のx座標
  float ytar = 200; //Changed:目標点のy座標

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
     float angle = random(TWO_PI);
     velocity = new PVector(cos(angle), sin(angle));
       
    position = new PVector(x, y);
    
    r = 3.0;
    maxspeed = 4;
    maxforce = 0.04;
    isAlive = true; // 追加: 初期状態は生存とする
    enemies = new ArrayList<Enemy>();
    color_num=int(random(3));

  }

  void run(ArrayList<Boid> boids, ArrayList<Enemy> enemies, PVector target) {
    flock(boids, target);
    update();
    render();  
    checkCollision(enemies, boids); // 敵との衝突判定
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, PVector target) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
//    PVector avo = avoid(boids);      // Avoid      //回避
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    PVector seekForce = seek(target); // 目標地点への操作力を取得
    seekForce.mult(1.5); // 目標地点への操作力を強めに
    applyForce(seekForce); // 目標地点への操作力を適用
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) { //目標地点への追従機能を実装
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    if (!isAlive) {
      return; // 追加: 群れが消滅していれば何もしない
    }
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    
    //int color_num=int(random(3));
    //switch(color_num){
    //  case 0:
    //    fill(255, 255,239);
    //    break;
    //  case 1:
    //    fill(221, 255,255);
    //    break;
    //  case 2:
    //    fill(228, 62, 80);
    //    break;
    //}
    switch(color_num){
      case 0:
        fill(255, 255,239, 170);
        break;
      case 1:
        fill(221, 255,255, 170);
        break;
      case 2:
        fill(228, 62, 80, 170);
        break;
    }
    stroke(255,170);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    //beginShape(TRIANGLES);
    //vertex(0, -r*2);
    //vertex(-r, r*2);
    //vertex(r, r*2);
    //endShape();
  
    //魚図形(改良)
    beginShape();
    vertex(0, -r*2);
    vertex(-r*2, r*2);
    vertex(-r/4, r*2);
    vertex(-r, r*3);
    vertex(r, r*3);
    vertex(r/4, r*2);
    vertex(r*2, r*2);
    endShape(CLOSE);
    
    popMatrix();

  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 100;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  // 追加: 衝突検出と群れの消滅
  void checkCollision(ArrayList<Enemy> enemies, ArrayList<Boid> boids) {
    if (!isAlive) {
      return; // 追加: 群れが消滅していれば何もしない
    }
    
    //for (Enemy enemy : enemies) {
    //  float d = PVector.dist(position, enemy.position);
    //  if ((d > 0) && (d < r*4)) {
    //    isAlive = false; // 衝突した場合に群れを消滅させる
    //    for (int i = 0; i < 6; i++) {
    //      Bubble bubble = new Bubble(position.x + random(0, 5), position.y ,random(3, 8));
    //      bubbles.add(bubble);
    //    }
    //    enemy.position.set(width , random(height));
    //    collisionSound.play(); // 衝突音を再生
    //    break;
    //  }
    //}
    
    // 画面の端に到達したら反対側にループする
      if (position.x > width ) {
        death++;
        isAlive = false; // 衝突した場合に群れを消滅させる
        collisionSound.amp(0.4);
        collisionSound.play(); // 衝突音を再生
        return;
     }
    
    
  
  boolean collided = false;
  for (int i = enemies.size() - 1; i >= 0; i--) {
    
    Enemy enemy = enemies.get(i);
    float d = PVector.dist(position, enemy.position);
    if ((d > 0) && (d < r*4)) {
      enemy.position.set(width , random(height));
      collided = true; // 衝突したフラグを立てる
      break;
    }
  }


  if (collided) {
    death++;
    // Add an initial set of enemies into the system
    for (int i = 0; i < 6; i++) {
      Bubble bubble = new Bubble(position.x + random(0, 5), position.y ,random(3, 8));
      bubbles.add(bubble);
    }
    collisionSound.amp(0.4);
    collisionSound.play(); // 衝突音を再生
    // 衝突した場合に群れから削除
    int index = boids.indexOf(this);
    if (index >= 0) {
      boids.subList(index, index + 1).clear();
    }
    
    isAlive = false; // 群れの消滅フラグを立てる
  }
    
  }
}
 
