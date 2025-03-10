//handles the Projectile class that holds methods such as updating its position and collision with enemies

class Projectile { 
  String type;
  float angle, rotAngle, rad, a, v, t, xPos, yPos, damage; //a: acceleration; v: velocity; t: time
  
  Projectile (String sentType, float sentAngle, float sentAcceleration, float sentVelocity, float sentDamage) {  
    type = sentType;
    
    angle = sentAngle;
    rotAngle = angle;
    rad = radians(angle);
    
    a = sentAcceleration;
    v = sentVelocity;
    t = 0;
    
    xPos = 0; 
    yPos = 0;
    
    damage = sentDamage;

  } 
  
  void update(int i) { 
    //vy = (x1 + v1*t + 0.5 * a * t * t) / t; projectile equation
    xPos = projXOrigin + (v*cos(rad)*t);
    yPos = projYOrigin - (v*sin(rad)*t + 0.5*a*t*t);
    //stop rotating proj if it is going straight down
    if (rotAngle <= -90) {rotAngle = -90;}
    //rotating proj as it moves    
    if (angle <= 90) {rotAngle -= 1+t*0.005;} 
    else if (angle > 90) {rotAngle += 1+t*0.005;}
    
    boolean hitTarget = hitEnemy(this, i); //cleanups enemy if it is hit by projectile
        
    //if ground is hit, check that it has not hit an enemy and cleanup projectile
    if (hitTarget == false && (xPos >= width || xPos <= 0 || yPos >= height-210)) {
      reset();
      projectiles.remove(i);
    }
    
    fill(0, 0, 0);
    
    pushMatrix();
    translate(xPos, yPos);
    rotate(-radians(rotAngle)); //rotate projectile as it goes through path
    drawArrow(0, 0);
    popMatrix();
    
    t++;
  } 
  
  void reset() {t = 0;}
  
  boolean hitEnemy(Projectile proj, int i) {
    if (enemies.size() > 0) {
      for (int i2 = 0; i2 < enemies.size(); i2++) {
        Enemy enemy = enemies.get(i2);
        //fill(0,0,0,1);
        float hitWidth = 45; float hitHeight = 65;
        //rect(enemy.hitXPos,enemy.hitYPos,hitWidth,hitHeight);//hitbox
        //rectangle collision detection
        if (proj.xPos < enemy.hitXPos + hitWidth &&  
          proj.xPos + arrowWidth > enemy.hitXPos &&
          proj.yPos < enemy.hitYPos + hitHeight &&
          proj.yPos + arrowHeight > enemy.hitYPos) {
          bowHitZombie.play();
          //damage
          Enemy hitResult = enemies.get(i2);
          hitResult.damage(proj.damage);
          
          println(hitResult.health);
          
          if (hitResult.health <= 0) {//rewards & cleanup
            score += hitResult.reward;
            money += (hitResult.reward)/2;
            zombieDeaths[round(random(0,1))].play(1,0.5);
            enemies.remove(i2);
          }
          //cleanup projectile
          proj.reset();
          projectiles.remove(i);
          
          return true;
        }
      }
    }
    return false;
  }
  
} 
