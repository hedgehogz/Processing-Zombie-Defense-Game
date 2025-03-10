import processing.sound.*;
//Sounds
SoundFile purchase;
SoundFile shoot;
SoundFile bowHitGround;
SoundFile bowHitZombie;

SoundFile zombieDeath1;
SoundFile zombieDeath2;
SoundFile[] zombieDeaths;

SoundFile gateHit1;
SoundFile gateHit2;
SoundFile[] gateHits;

//Main objects
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();
ArrayList<Button> buttons = new ArrayList<Button>();

//Positions projectiles and enemies spawn
float projXOrigin = 200;
float projYOrigin = 200;
float enemyXSpawn = 1920;
float enemyYSpawn = 580;
float gateXPos = 300;

//Angle of projectiles
float preservedAngle = 0;

//Dimensions of projectiles
float bulletWidth = 20;
float bulletHeight = 7.5;
float arrowWidth = 20;
float arrowHeight = 7.5;

//Times
float time = 0;
int seconds = 0;
int minutes = 0;
float fps = 60;

float timeSinceLastClick = 0; 
float timeSinceLastPurchase = 0;
float timeSinceLastEnemySpawned = 0;
float minSpawnTime = 5;
float maxSpawnTime = 8;

//Proj properties
float projVelocity = 25;
float projDamage = 25;
float rpm = 30; //how many projectiles can be shot in a minute

//Game variables
int gameState = 0; //0 = instructions; 1 = playing game; 2 = results
int gateHealth = 300;
int money = 0;
int score = 0;
int arrowType = 1;
int highestScore = 0;
JSONObject highestScoreSave;

void setup() {  
  size(1920, 800);
  frameRate(fps);  
  
  initialize();

}

void draw() {
  if (gameState == 0) {instructions();}
  else if (gameState == 2) {results();}
  else if (gameState == 1) {runGame();}
}

void mousePressed() {  
  if (gameState == 1) {
    shoot();
    mouseOverButton(true); //purchasing
  }
}
