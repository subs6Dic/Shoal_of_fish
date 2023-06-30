//背景クラスの設定

PImage backgroundImage;
PImage cityImage;
ArrayList<Bubble> bubbles = new ArrayList<Bubble>();

class Back{
  int xPos;

  
  void back_set(){
    //背景画像(海底)の読み込み
    //size(640, 360); //for "sea_back_640x360.jpg"
    //size(1080, 715);//for "sea_back.png"
    // backgroundImage = loadImage("sea_back.png"); 
    background(0);  //0は黒の背景　255は白の背景
    backgroundImage = loadImage("images/night.jpg"); 
    //cityImage = loadImage("images/city2.png");
    xPos = 0;
  }
  
  void back_draw(){
    background(0);
    // 背景画像を描画
    image(backgroundImage, xPos, 0);
    image(backgroundImage, xPos + width, 0);
    
      
    // 半透明の黒色の矩形を描画して背景を暗くする
    fill(0,50,50, 100); // 黒色の塗りつぶし (0: 黒色, 100: 透明度)
    rect(0, 0, width, height);
     //image(cityImage, xPos, 0);
     //image(cityImage, xPos + width, 0);
    // 画像の位置を更新
    xPos--;    
    // 画像が画面外に出たら位置をリセット
    if (xPos <= -width) {
      xPos = 0;
    }
    
    
    // 泡をランダムに生成
    if (random(1) < 0.05) {
        Bubble bubble = new Bubble(random(width), height, random(3, 8)); //泡のサイズ設定
        bubbles.add(bubble);
    }
    
    // 泡(big)をランダムに生成
    if (random(1) < 0.005) {
        Bubble bubble = new Bubble(random(width), height, random(15, 20)); //泡のサイズ設定
        bubbles.add(bubble);
    }
  
     // 泡の更新と描画
     for (int i = bubbles.size() - 1; i >= 0; i--) {
        Bubble bubble = bubbles.get(i);
        bubble.update();
        bubble.display();
      
        // 画面外に出た泡は削除
        if (bubble.isOffScreen()) {
          bubbles.remove(i);
        }
     }
  }
  
}


//泡クラスの設定
class Bubble {
  PVector position;
  float radius;
  float speed;
  
  Bubble(float x, float y, float r) {
    position = new PVector(x, y);
    radius = r;
    speed = random(1, 2);
  }
  
  void update() {
    position.y -= speed;
  }
  
  void display() {
    noStroke();
    fill(255, 100);
    ellipse(position.x, position.y, radius, radius);
  }
  
  boolean isOffScreen() {
    return position.y + radius < 0;
  }
}
