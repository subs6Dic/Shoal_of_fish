//敵機クラス
PImage MissileImage;

class Enemy {
  PVector position;
  PVector velocity;
  PVector fixed_velocity;
  float r;
  float maxspeed;
  float maxforce;
  float angle; // リサージ曲線の角度
  float radius; // リサージ曲線の半径

  Enemy() {
    position = new PVector(width, random(height));
    velocity = new PVector(-100, 0); // 初期速度を設定
    fixed_velocity = new PVector(-4,0); 
    r = 4.0;
    maxspeed = 2;
    maxforce = 0.1;
    angle = (int)random(360); // 初期角度
    radius = (int)random(500,1500); // リサージ曲線の半径
  }
  
  //
  void run(){
    update();
    render();
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
    if (position.x < -r) {
      if(random(2)<1.2){
        enemies.remove(this);
        return;
      }
      position.x = width + r;
      position.y = random(height);
    }
  }

  void render() {
    fill(255, 100, 100);
    noStroke();
    ellipse(position.x, position.y, r * 2, r * 2);

    // 敵の位置に画像を表示
    //image(MissileImage, position.x, position.y);
  }
  
  
}
