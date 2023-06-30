/**
 * Flocking 
 * An implementation of Craig Reynold's Boids program to simulate
 * 
 * Click to Start.
 */



Back background;
Flock flock;
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
//ArrayList<Submarine> submarines = new ArrayList<Submarine>();
String scene = "title"; //シーンを指定する文字列
PImage SubmarineImage1;
int count; //時間カウンター
ArrayList<Submarine> submarines = new ArrayList<Submarine>();

float volume = 0.0;  // 初期音量
float targetVolume = 1.0;  // 目標音量
float volumeIncrement = 0.02;  // 音量の増加量
int death = 0;
int score = 0;

void setup() {

  surface.setResizable(true);
  surface.setSize(1024, 584); //for "night.jpg"
 
  
  collisionSound = new SoundFile(this, "Sound/hit.mp3"); // 衝突音声ファイルの読み込み
  selectSound1 = new SoundFile(this, "Sound/select01.mp3"); // スタート音声ファイルの読み込み
  attackSound = new SoundFile(this, "Sound/attack.mp3");
  bgmSound = new SoundFile(this, "Sound/PerituneMaterial_Suspense5_loop.mp3");
  clearSound = new SoundFile(this, "Sound/HIRAHIRA.mp3");
  

  //MissileImage = loadImage("Missile3.png");// 敵(魚雷型)画像を読み込み
   SubmarineImage1 = loadImage("images/submarine1.png");// 敵(魚雷型)画像を読み込み
   //textFont(createFont("Arial", 10));
   background = new Back();
   
   // Add an initial set of enemies into the system
  for (int i = 0; i < 10; i++) {
    enemies.add(new Enemy());
  }
  Submarine submarine = new Submarine();
  submarines.add(submarine);
  
  //submarine = new Submarine();
  
   flock = new Flock(enemies);
   
   // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  
  count = 0;
   
}

void draw() {
  //scene変数の番号によって関数呼び出し
  switch(scene){
    case "title":
      title_scene();
      break;
    case "play":
      play_scene();
      break;
     case "clear":
       clear_scene();
       break;
  }  
  
}

///////////シーン処理/////////////////
//タイトル画面での処理
void title_scene(){
  
  background.back_set();
  textSize(100);  //テキストサイズを指定
  text("Start",400,250); //座標350,500にStartを表示
  textSize(50);  //テキストサイズを指定
  text("Press left click",350,350);  //座標300,600にPress left clickを表示
    
  //左クリックされたらプレイ画面へ
  if(mouseButton == LEFT){
    selectSound1.play();
    scene = "play";
    bgmSound.loop();
  }
}

//プレイ画面での処理
void play_scene(){
  count++;
  if(count < 40){
    background(0);
    // 音量を徐々に上げる
    if (volume < 1.4) {
      volume += volumeIncrement;
      // 音量を制限する（0.0から1.0の範囲内に収める）
      volume = constrain(volume, 0.0, 1.0);
      bgmSound.amp(volume);  // 音量を設定する
    }
    return;
  }
  background.back_draw();
  
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy enemy = enemies.get(i);
    enemy.run();
  }
   
  submarines.get(0).run(flock.boids);
  
  //Changed:目標点を設定・描画
  PVector target = new PVector(mouseX, mouseY);
  flock.target = target;
  fill(255,0,0);
  noStroke();
  ellipse(mouseX, mouseY,10,10);
  ///////

  flock.run();
  
  textSize(20);
  textAlign(RIGHT);
  text("Number: " + flock.boids.size(), width - 10, height - 70);
  text("Death: " + death, width - 10, height - 45);
  text("Score: " + score, width - 10, height - 20);
  fill(255, 20); // 黒色の塗りつぶし (0: 黒色, 100: 透明度)
  stroke(255);
  rect(width - 140, height - 90, 140, 80);
  
  //if(score == 50){
  //  scene = "clear";
  //  bgmSound.stop();
  //  clearSound.loop();
  //  if (volume < targetVolume) {
  //    volume += volumeIncrement;
  //    // 音量を制限する（0.0から1.0の範囲内に収める）
  //    volume = constrain(volume, 0.0, 1.0);
  //    bgmSound.amp(volume);  // 音量を設定する
  //  }
  //}
}

//クリア画面での処理
void clear_scene(){
  
  background(0);  //0は黒の背景　255は白の背景
  fill(255);
  textSize(100);  //テキストサイズを指定
  text("Game Clear!!",820,360); //座標350,500にStartを表示
  //textSize(50);  //テキストサイズを指定
  //text("Press left click",350,350);  //座標300,600にPress left clickを表示
    
}
