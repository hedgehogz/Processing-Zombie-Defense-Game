//methods for gamestates

void instructions() {
  background(179, 135, 132);
  textSize(50);
  textAlign(CENTER);
  text("Press F to start the game \n\n Use your touchpad or mouse to aim. Click to shoot. \n\n Your objective is to prevent the zombies from breaking down the castle entrance and entering. \n\n Highest Score: " + highestScore, (width/2)-400, (height/2)-275, 800, 600);
  //start game
  if (keyPressed && (key == 'f' || key == 'F')) {gameState = 1;}
}

void results() {
  fill(255,255,255);
  background(179, 135, 132);
  
  if (score > highestScore) {
    highestScore = score;
    highestScoreSave.setInt("HighestScore", highestScore);
    saveJSONObject(highestScoreSave, "data.json");//save highestScore to data.json
  }
  
  textSize(50);
  textAlign(CENTER);
  //different texts based on how long you survived
  if (minutes > 1) {text("You survived for " + minutes + " minutes and " + seconds + " seconds" + "\n\n Your Highest Score is " + highestScore + "\n\n Press F to play again ", (width/2)-400, (height/2)-175, 800, 600);}
  else if (minutes > 0 && minutes < 2) {text("You survived for " + minutes + " minute and " + seconds + " seconds" + "\n\n Your Highest Score is " + highestScore + "\n\n Press F to play again ", (width/2)-400, (height/2)-175, 800, 600);}
  else if (minutes == 0) {text("You survived for " + seconds + " seconds" + "\n\n Your Highest Score is " + highestScore + "\n\n Press F to play again ", (width/2)-400, (height/2)-175, 800, 600);}
  //restart game
  if (keyPressed && (key == 'f' || key == 'F')) {
    //cleanup arraylists and set variables to original values
    enemies = new ArrayList<Enemy>();
    projectiles = new ArrayList<Projectile>();
    
    for (int j = 0; j < buttons.size(); j++) {buttons.get(j).resetPrice();}
        
    time = 0;
    minutes = 0;
    seconds = 0;
    timeSinceLastClick = 0; 
    timeSinceLastPurchase = 0;
    timeSinceLastEnemySpawned = 0;
    
    minSpawnTime = 6;
    maxSpawnTime = 8;
    
    gameState = 1;
    score = 0;
    money = 0;
    gateHealth = 300;
    
    projDamage = 25;
    projVelocity = 30;
    rpm = 30;
    
  }
}
//healthbar variables
float gateHealthXPos = 150; float gateHealthXSize = 100;
float gateHealthYPos = 400; float gateHealthYSize = 25;

void runGame() {
  background(159, 212, 245);
    
  setupBackgroundShapes();
  fill(255,255,255);
  textSize(25);
  textAlign(LEFT);
  text("Score:" + score, 125, 675, 400, 100);
  text("$" + money, 125, 700, 400, 100);
  //healthbar of gate
  fill(199, 50, 102);
  rect(gateHealthXPos, gateHealthYPos, gateHealthXSize, gateHealthYSize);
  fill(89, 196, 77);
  rect(gateHealthXPos, gateHealthYPos, gateHealth/3, gateHealthYSize);// 100/1 = 250/2.5
  fill(255, 255, 255);
  textAlign(CENTER);
  text(gateHealth + "/300", gateHealthXPos, gateHealthYPos+3, gateHealthXSize, gateHealthYSize);
  //constantly update angle so it follows mouse
  float angle = findAngleToMouse();
  preservedAngle = angle;
  drawRotatingArcher(radians(preservedAngle)); //part of archer that rotates
  
  for (int j = 0; j < buttons.size(); j++) {
    Button b = buttons.get(j);
    
    Button b2 = mouseOverButton(false); //hover mouse over button to change color
    if (b2 != null && b2 == b) {fill(237, 217, 116);}
    else {fill(153, 140, 73);}
    
    rect(b.xPos, b.yPos, b.xSize, b.ySize, 20);
    fill(255,255,255);
    textAlign(CENTER);
    textSize(25);
    text(b.text + "\n $" + b.price, b.xPos, b.yPos+12.5, b.xSize, b.ySize);
  }
  
  if (maxSpawnTime > 4) {
    minSpawnTime -= 0.00005;//make more enemies spawn over time
    maxSpawnTime -= 0.00005;
  }
  
  time += 1/fps; //keep track of time in seconds
  minutes = int(time/60);
  seconds = int(time - minutes*60);
  //prevents excessive spawning of enemies
  if (time - timeSinceLastEnemySpawned > minSpawnTime) {
    if (seconds % round(random(minSpawnTime, maxSpawnTime)) == 0) {//spawn regular zombies
      timeSinceLastEnemySpawned = time;
      addEnemies("Zombie", 1); 
    }
    if (minutes > 0 && seconds % (2*round(random(minSpawnTime, maxSpawnTime))) == 0) {//spawn fast zombies when 1 minute passes, spawns less frequent than normal zombie
      timeSinceLastEnemySpawned = time;
      addEnemies("FastZombie", 1);
    }
    if (minutes > 1 && seconds % (5*round(random(minSpawnTime, maxSpawnTime))) == 0) {//spawn giant zombies when 2 minute passes, spawns less frequent than fast zombie
      timeSinceLastEnemySpawned = time;
      addEnemies("GiantZombie", 1);
    }
  }
  //handles each enemy
  if (enemies.size() > 0) {
    for (int i = 0; i < enemies.size(); i++) {
      Enemy enemy = enemies.get(i);

      if (gateHealth > 0) {//gate is not broken
        if (enemy.xPos > gateXPos) {//not at gate, move
          moveEnemies(enemy, 1);
        }
        else {//at gate, don't move, damage gate
          if (enemy.xPos <= gateXPos && enemy.xPos > gateXPos - 10) {enemy.update(gateXPos, enemyYSpawn, 0, 0);}
          else if (enemy.xPos < gateXPos - 10) {//if already inside and gate has been repaired, keep moving
            moveEnemies(enemy, 2);
          }
          if (time - enemy.tSinceLastDamage > 2) {//prevent excessive gate damage
            enemy.resetDamageTimer();
            gateHits[round(random(0,1))].play(1,0.5);
            gateHealth -= enemy.damage;
          }
        }
      }
      else {//gate is broken
        if (enemy.xPos > gateXPos) {
          moveEnemies(enemy, 1);
        }
        else {//reset t to 0 and draw enemy from gate
          if (enemy.restarted == false) {
            enemy.restartPos();
            enemy.reset();
            moveEnemies(enemy, 2);
          }
          else {
            moveEnemies(enemy, 2);
          }
        }
      }
      
      if (enemy.xPos <= 50) {gameState = 2;} //trigger result screen
      
    }    
  }
  
  //handles each projectile
  if (projectiles.size() > 0) {
    for (int i = 0; i < projectiles.size(); i++) {
      Projectile proj = projectiles.get(i);
      
      proj.update(i);
      
    }
  }
}
