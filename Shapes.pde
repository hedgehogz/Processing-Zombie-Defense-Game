//methods setting up background and environment

void setupBackgroundShapes() {  
  //ground
  noStroke();
  fill(176, 104, 53);
  rect(0, height - 200, width, 50);
  fill(217, 150, 78);
  rect(0, height - 150, width, 150);
  fill(143, 176, 53);
  rect(0, height - 210, width, 10);
  
  //tower
  fill(138, 138, 138);
  rect(projYOrigin-100, projYOrigin+60-100, 20, 100);
  rect(projYOrigin+80, projYOrigin+60-100, 20, 100);
  rect(projYOrigin-100, projYOrigin-60, 200, 20);
  
  stroke(0,0,0);
  rect(100, 237, 200, 353);
  
  //castle
  fill(112, 110, 110);
  rect(0, projYOrigin+90, 100, 300);
  fill(158, 126, 87);
  if (gateHealth > 0) {rect(275, 400, 25, 190);}
  else {rect(125, 565, 190, 25);}
  
  for (int i = 0; i < 8; i++) {
    drawTree(1400+i*75,450);
  }
}

void drawTree(float xPos, float yPos) {
  noStroke();
  
  fill(120, 100, 80);
  rect(xPos-1, yPos+50, 35, 90);
  
  fill(87, 125, 49);
  rect(xPos, yPos+25, 35, 25);
  
  arc(xPos, yPos+25, 50, 50, HALF_PI, PI);
  arc(xPos+31, yPos+25, 50, 50, 0, HALF_PI);
  triangle(xPos-25, yPos+25, xPos+55, yPos+25, xPos+17.5, yPos-75);
  stroke(1);
}

void drawRotatingArcher(float rad) {
  fill(125, 125, 125);
  pushMatrix();
  translate(projXOrigin, projYOrigin);
  drawBody();
  rotate(-rad);
  
  drawArcherLimbs();//rotate arms and bow
  fill(0, 0, 0);
  //create illusion that arrow is launching from bow
  if (time - timeSinceLastClick > 60/rpm) {
    drawArrow(0, 0);
  }
  popMatrix();
}

void drawArrow(float xPos, float yPos) {
  rect(xPos, yPos, 20, 1); //base
  triangle(xPos, yPos, 20+xPos, -1+yPos, 20+xPos, 1+yPos); //arrow head
  if (projVelocity > 25) {
    fill(204, 169, 98);
    triangle(xPos, yPos, -7.5+xPos, -7.5+yPos, -7.5+xPos, 7.5+yPos);
  } //back feather}
  if (projDamage > 25) {
    fill(219, 219, 219);
    triangle(xPos, yPos, 20+xPos, -1.5+yPos, 20+xPos, 1.5+yPos);
  } //arrow head}
}


void drawBody() {//body of archer
  float addX = -5;
  float addY = 35;
  
  if (rpm > 30) {//draw quiver if upgraded fast arrows
    pushMatrix();
    fill(0,0,0);
    rotate(radians(-10));
    rect(-15.5, -9, 5, 25);
    rotate(radians(90));
    drawArrow(-15, 15);
    drawArrow(-15, 7.5);
    popMatrix();
  }
  
  fill(199, 193, 193);
  rect(-2.5+addX,-45+addY,5,35);//body
  
  drawLimb(-1+addX, -15+addY, 5, 20, 45); //left leg
  drawLimb(-2+addX, -12+addY, 5, 20, -45); //right leg
  
  pushMatrix();
  rotate(radians(-preservedAngle*0.5));//rotate head
  ellipse(0+addX,-50+addY,20,20);//head

  fill(0,0,0);

  ellipse(addX+5,-52.5+addY,5,5);//eye
  rect(addX,-46+addY,10,1);//mouth
  fill(199, 193, 193);
  popMatrix();
}

void drawArcherLimbs() {//bow and arms
  drawLimb(0, -3, 5, 20, 75);  //left arm
  drawLimb(0, 0, 5, 20, 45); //right arm
  //bow
  rect(2.5,-20,2,40);
  noFill();
  arc(2.5,0,20,40, PI+HALF_PI, TWO_PI+HALF_PI);
}
