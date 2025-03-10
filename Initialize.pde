//methods for adding objects to arraylists and general setup

void initialize() {//called in setup
  //initiate sounds
  purchase = new SoundFile(this, "Sounds/Purchase.mp3");
  shoot = new SoundFile(this, "Sounds/BowShoot.mp3");
  bowHitGround = new SoundFile(this, "Sounds/BowHitGround.mp3");
  bowHitZombie = new SoundFile(this, "Sounds/BowHitZombie.mp3");
  
  zombieDeath1 = new SoundFile(this, "Sounds/ZombieDeath1.mp3");
  zombieDeath2 = new SoundFile(this, "Sounds/ZombieDeath2.mp3");
  zombieDeaths = new SoundFile[2];
  zombieDeaths[0] = zombieDeath1;
  zombieDeaths[1] = zombieDeath2;

  gateHit1 = new SoundFile(this, "Sounds/GateHit1.mp3");
  gateHit2 = new SoundFile(this, "Sounds/GateHit2.mp3");
  gateHits = new SoundFile[2];
  gateHits[0] = gateHit1;
  gateHits[1] = gateHit2;
  //loads highest score if game has been played previously, default is 0
  highestScoreSave = loadJSONObject("data.json");
  highestScore = highestScoreSave.getInt("HighestScore");
  //add buttons
  addButton("Quicker Drawing", 375 + 250*0, 675, 200, 75, 10);
  addButton("Faster Arrows", 375 + 250*1, 675, 200, 75, 10);
  addButton("Sharper Arrows", 375 + 250*2, 675, 200, 75, 15);
  addButton("Fix Gate", 375 + 250*3, 675, 200, 75, 25);

}

void addProjectiles(int num) {//add a number of projectiles
   for (int i = 0; i<num; i++) {
     
    String t = "Arrow";
    float angle = findAngleToMouse();
        
    Projectile proj = new Projectile(t, angle, -0.5, projVelocity, projDamage);
    projectiles.add(proj);
  }
}

void addEnemies(String t, int num) {//add a number of enemies
  for (int i = 0; i<num; i++) {
    Enemy zomb;
    
    switch(t) {
      case "Zombie":
        zomb = new Enemy(t, 100 + 10*minutes, 5, 10);//enemy health will increase after 1 minute
        enemies.add(zomb);
        break;
      case "FastZombie":
        zomb = new Enemy(t, 100 + 10*(minutes-1), 5, 20);//health will start increasing after 2 minutes
        enemies.add(zomb);
        break;
      case "GiantZombie":
        zomb = new Enemy(t, 250 + 10*(minutes-2), 15, 50);//health will start increasing after 3 minutes
        enemies.add(zomb);
        break;
    }
    
  }
}

void addButton(String sentText, float sentXPos, float sentYPos, float sentXSize, float sentYSize, int sentPrice) {
  Button button = new Button(sentText, sentXPos, sentYPos, sentXSize, sentYSize, sentPrice);
  buttons.add(button);
}

float findAngleToMouse() {
  //sin(angle) = opp/hyp; angle = asin(opp/hyp); getting angle from origin to mouse
  float opp = -(mouseY-projYOrigin);
  float hyp = dist(projXOrigin, projYOrigin, mouseX, mouseY);
  float angle = degrees(asin(opp/hyp));
  return angle;
}

void shoot() {
  //prevent spamming of projectile
  if (time - timeSinceLastClick > 60/rpm) {
    timeSinceLastClick = time;
    shoot.play(1,0.5);
    addProjectiles(1);
  }
}

Button mouseOverButton (boolean buying) {
  if (time - timeSinceLastPurchase > 1) {
    for (int j = 0; j < buttons.size(); j++) {
      Button b = buttons.get(j); //collision detection with mouse and buttons
      if (mouseX < b.xPos + b.xSize &&  
          mouseX > b.xPos &&
          mouseY < b.yPos + b.ySize &&
          mouseY > b.yPos) {
        if (buying == true && money >= b.price) {//buying
          timeSinceLastPurchase = time;
          money -= b.price;
          b.updatePrice(b.price+15);
          purchase.play();
          
          switch(b.text) {
            case "Quicker Drawing":
              rpm += 10;
              break;
            case "Faster Arrows":
              projVelocity += 5;
              break;
            case "Sharper Arrows":
              projDamage += 15;
              break;
            case "Fix Gate":
              gateHealth = 250;
              break;
          }
          
        }
        return b;
      }
    } 
  }
  return null;
}
