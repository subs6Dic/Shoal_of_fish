//敵機クラス

class Submarine {
  PVector position;
  PVector velocity;
  float r;
  PVector fixed_velocity;
  float maxspeed;
  float maxforce;
  float angle; // リサージ曲線の角度
  float radius; // リサージ曲線の半径
  
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Submarine() {
    position = new PVector(width, random(height));
    velocity = new PVector(-2, 0); // 初期速度を設定
    fixed_velocity = new PVector(-2,0); 
    r = 40.0;
    maxspeed = 1;
    maxforce = 0.1;
    angle = (int)random(360); // 初期角度
    radius = (int)random(500,1000); // リサージ曲線の半径
  }
  
  //
  void run(ArrayList<Boid> boids){
    update();
    render();
    checkCollision(boids);
    if(count % 100 == 0){
      int n = 10;
      float radius = 10; // 円の半径
      for (int i = 0; i < n; i++) {
        float angle = TWO_PI * i / n; // 円周上の角度
        float x = position.x+30+ cos(angle) * radius; // x座標を計算
        float y = position.y +50 + sin(angle) * radius; // y座標を計算
        Enemy enemy = new Enemy();
        enemy.position = new PVector(x, y); // 指定した位置からEnemyオブジェクトを作成
        enemies.add(enemy);
      }
    }
  }

  void update() {
    // リサージ曲線の座標を計算
    float x = width / 2 + cos(angle) * radius;
    float y = height / 2 + sin(angle) * radius;
    PVector target = new PVector(x, y);

    // 目標地点へのベクトルを計算
    PVector desired = PVector.sub(target, position);
    desired.setMag(maxspeed);

    // ステアリングフォースを計算して速度を制御
    PVector steering = PVector.sub(desired, velocity);
    steering.limit(maxforce);
    velocity.add(steering);
    velocity.limit(maxspeed);

    // 位置を更新
    position.add(velocity);
    position.add(fixed_velocity);

    // リサージ曲線の角度を増加させる
    angle += 0.01;

    // 画面の端に到達したら反対側にループする
    if (position.x < -r*2) {
      position.x = width + r;
      position.y = random(height);
    }
  }

  void render() {
    noStroke();
    fill(255, 100);
    arc(position.x -r/3, position. y, r/3,  r/3, radians(60), radians(120));
    image(SubmarineImage1, position.x, position.y);
  }
  
  void checkCollision(ArrayList<Boid> boids) { //群れとの衝突判定
    float x = position.x + 60;
    float y = position.y + 40;
    PVector temp = new PVector(x, y);
    
    for (Boid boid : boids) {
      float d = PVector.dist(temp, boid.position);
      if ((d > 0) && (d < 3+30)) {
        for (int i = 0; i < 10; i++) {
          Boid boid_t = new Boid(temp.x + random(-30,30), temp.y + random(-50,50));
          boids.add(boid_t);
        }
        score++;
        position.set(width , random(100, height-100));
        attackSound.amp(0.6);
        attackSound.play(); // 衝突音を再生
        break;
      }
    }
  }
}
