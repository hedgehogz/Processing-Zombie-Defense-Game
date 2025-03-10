//enemy class and relevant methods like animating

class Enemy {
  String type;//type of enemy
  boolean restarted; //if enemy needs to be repositioned from breaking entrance
  int aCycle; //animation cycle number
  float xPos, yPos, hitXPos, hitYPos, t, health, reward, damage, tSinceLastDamage; //hitXPos and hitYPos are hitboox positions for collision detection, t is time
  
  Enemy(String sentType, float sentHealth, float sentDamage, float sentReward) {
    type = sentType;
    
    xPos = 1920;
    yPos = 0;
    hitXPos = 0;
    hitYPos = 0;
    
    aCycle = 0;
    t = 0;
    
    health = sentHealth;
    reward = sentReward;
    
    damage = sentDamage;
    tSinceLastDamage = 0;
    
    restarted = false;
  }
  
  void update(float spawnX, float spawnY, float xIncrement, float yIncrement) {
    xPos = spawnX - xIncrement*t; //left to right
    yPos = spawnY - yIncrement*t; 
    
    hitXPos = xPos-22.5;
    hitYPos = yPos-60;
    
    if (t%15 == 0) {aCycle++;}
    if (aCycle > 3) {aCycle = 0;}
    
    if (type.equals("FastZombie")) {
      fill(102, 177, 212);
      drawEnemy();
    }
    else if (type.equals("Zombie")) {
      fill(75,127,78);
      drawEnemy();
    }
    else if (type.equals("GiantZombie")) {
      fill(31, 56, 33);
      drawGiantZombie();
    }
    
    t++;
  }
  
  void drawEnemy() {
    pushMatrix();    
    translate(xPos, yPos);
    
    rect(-2.5,-45,5,35);//body
    ellipse(0,-50,20,20);//head
    
    zombWalk(aCycle);
    
    fill(255, 0, 0);
    ellipse(-5,-52.5,5,5);//eye
    rect(-8,-46,10,1);//mouth
          
    popMatrix();
  }
  
  void drawGiantZombie() {
    pushMatrix();    
    translate(xPos, yPos);
    
    rect(-10,-60,20,30);//body
    ellipse(0,-70,20,20);//head
    
    giantZombWalk(aCycle);
    
    fill(255, 0, 0);
    ellipse(-5,-74,5,5);//eye
    rect(-8,-67.5,10,2);//mouth
          
    popMatrix();
  }
  
  void restartPos() {restarted = true;}
  void resetDamageTimer() {tSinceLastDamage = time;}
  void damage(float sentDamage) {health -= sentDamage;}
  void reset() {t = 0;}
}

void drawLimb(float xPos, float yPos, float xSize, float ySize, float degree) {
  pushMatrix();
  translate(xPos,yPos);
  rotate(radians(degree));
  rect(0,0,xSize,ySize);
  popMatrix();
}

void giantZombWalk(int num) {
  if (num == 0) {
    drawLimb(-5, -33, 10, 40, 45); //left leg
    drawLimb(-6, -30, 10, 40, -45); //right leg
    
    drawLimb(-2, -47, 8, 40, 91); //left arm
    drawLimb(-1, -50, 8, 40, 89);  //right arm
  }
  else if (num == 1) {
    drawLimb(-6, -30, 10, 40, 0); //left leg
    drawLimb(-5, -33, 10, 40, 0); //right leg
    
    drawLimb(-2, -47, 8, 40, 89); //right arm
    drawLimb(-1, -50, 8, 40, 91);  //left arm
  }
  else if (num == 2) {
    drawLimb(-5, -33, 10, 40, -45); //left leg
    drawLimb(-6, -30, 10, 40, 45); //right leg
    
    drawLimb(-2, -47, 8, 40, 91); //left arm
    drawLimb(-1, -50, 8, 40, 88);  //right arm
  }
  else if (num == 3) {
    drawLimb(-6, -30, 10, 40, 0); //left leg
    drawLimb(-5, -33, 10, 40, 0); //right leg
    
    drawLimb(-2, -47, 8, 40, 89); //right arm
    drawLimb(-1, -50, 8, 40, 91);  //left arm
  }
}

void zombWalk(int num) {
  if (num == 0) {
    drawLimb(-1, -15, 5, 20, 45); //left leg
    drawLimb(-2, -12, 5, 20, -45); //right leg
    
    drawLimb(-2, -32, 5, 20, 92.5); //right arm
    drawLimb(-1, -35, 5, 20, 87.5);  //right arm
  }
  else if (num == 1) {
    drawLimb(-1, -15, 5, 20, 0); //left leg
    drawLimb(-2, -12, 5, 20, 0); //right leg
    
    drawLimb(-2, -32, 5, 20, 87.5); //right arm
    drawLimb(-1, -35, 5, 20, 92.5);  //right arm
  }
  else if (num == 2) {
    drawLimb(-2, -12, 5, 20, -45); //right leg
    drawLimb(-1, -15, 5, 20, 45); //left leg
    
    drawLimb(-1, -35, 5, 20, 87.5);  //right arm
    drawLimb(-2, -32, 5, 20, 92.5); //right arm
  }
  else if (num == 3) {
    drawLimb(-2, -12, 5, 20, 0); //right leg
    drawLimb(-1, -15, 5, 20, 0); //left leg
    
    drawLimb(-1, -35, 5, 20, 92.5);  //right arm
    drawLimb(-2, -32, 5, 20, 87.5); //right arm
  }
}

void moveEnemies(Enemy enemy, int num) {//called when updating enemy in runGame gamestate method
  if (num==1) {//normal
    if (enemy.type.equals("Zombie")) {enemy.update(enemyXSpawn, enemyYSpawn, 0.75, 0);}
    else if (enemy.type.equals("FastZombie")) {enemy.update(enemyXSpawn, enemyYSpawn, 0.9 , 0);}
    else if (enemy.type.equals("GiantZombie")) {enemy.update(enemyXSpawn, enemyYSpawn, 0.6, 0);}
  }
  else if (num == 2) {//move from gate
    if (enemy.type.equals("Zombie")) {enemy.update(300, enemyYSpawn, 0.75, 0);}
    else if (enemy.type.equals("FastZombie")) {enemy.update(300, enemyYSpawn, 0.9, 0);}
    else if (enemy.type.equals("GiantZombie")) {enemy.update(300, enemyYSpawn, 0.6, 0);}
  }
  else if (num==3) {//test
    if (enemy.type.equals("Zombie")) {enemy.update(enemyXSpawn, enemyYSpawn, 10, 0);}
    else if (enemy.type.equals("FastZombie")) {enemy.update(enemyXSpawn, enemyYSpawn, 10 , 0);}
    else if (enemy.type.equals("GiantZombie")) {enemy.update(enemyXSpawn, enemyYSpawn, 10, 0);}
  }
}
