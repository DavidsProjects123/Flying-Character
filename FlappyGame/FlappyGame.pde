import processing.sound.*;


int score;
int gameState; // 0 = start, 1 = running, 2 = over
Player me;
Pipe pipeOne;
Pipe pipeTwo;
PImage Background;
SoundFile Mario; 
SoundFile scoreSound;
SoundFile Die;


void setup() {
  Background = loadImage("Game Background.png");
  size(500, 500);
  textAlign(CENTER);
  score = 0;
  gameState = 0;
  me = new Player();
  pipeOne = new Pipe(1);
  pipeTwo = new Pipe(2);
  Mario = new SoundFile(this, "Mario.mp3");
  Mario.loop();
  scoreSound = new SoundFile(this, "Coin.mp3");
  Die = new SoundFile(this, "Die.mp3");
}

void draw() {
  image(Background, 0, 0, width, height);
  if (gameState == 0) {
    // game start
    fill(255);
    textSize(30);
    text("flappy Bird", width/2, 80);
    me.show();
  } else if (gameState == 1) {
    pipeOne.show();
    pipeOne.move();
    pipeTwo.show();
    pipeTwo.move();
    me.show();
    me.move();

    if ( me.yPos < 0 || me.yPos + me.objHeight > height) {

      gameState = 2;
      Die.play();
    }
    if (me.xPos <pipeOne.xPos + pipeOne.objWidth
      && me.xPos + me.objWidth > pipeOne.xPos
      && me.yPos < pipeOne.yPos + pipeOne.objHeight
      &&me.yPos + me.objHeight > pipeOne.yPos) {
      gameState = 2;
      Die.play();
    }
    if (me.xPos <pipeTwo.xPos + pipeTwo.objWidth
      && me.xPos + me.objWidth > pipeTwo.xPos
      && me.yPos < pipeTwo.yPos + pipeTwo.objHeight
      &&me.yPos + me.objHeight > pipeTwo.yPos) {
      gameState = 2;
      Die.play();
    }
    if (pipeOne.counted == false && pipeOne.xPos + pipeOne.objWidth < me.xPos) {
      score = score + 1;
      pipeOne.counted = true;
      scoreSound.play();
    }
       if (pipeTwo.counted == false && pipeTwo.xPos + pipeTwo.objWidth < me.xPos) {
      score = score + 1;
      pipeTwo.counted = true;
      scoreSound.play();
    }
    text(score, 200, 200);
    // game running
  } else { // gameState == 2
    // game over
    Mario.stop();
    me.show();
    pipeOne.show();
     pipeTwo.show();
    fill(0);
    textSize(50);
    text("Game Over!!!", width/2, height/2);
  }
  println(gameState);
}

void keyPressed() {
  if (key == ' ' && gameState == 0) { 
    gameState = 1;
  }
  if (key == ' ' && gameState == 1) {
    me.jump();
  }
  if (key == ' ' && gameState == 2) {
    score = 0;
    Mario.loop();
    Die.stop();
    gameState = 1;
    me = new Player();
    pipeOne = new Pipe(1);
    pipeTwo = new Pipe(2);
    me.jump();
  }
}