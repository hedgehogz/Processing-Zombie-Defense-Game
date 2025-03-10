//button class for upgrade buttons

class Button {
  String text;
  int oPrice, price; //original price to reset it when game restarts
  float xPos, yPos, xSize, ySize;
  
  Button(String sentText, float sentXPos, float sentYPos, float sentXSize, float sentYSize, int sentPrice) {
    text = sentText;
    
    xPos = sentXPos;
    
    yPos = sentYPos;
    
    xSize = sentXSize;
    ySize = sentYSize;
    
    oPrice = sentPrice;
    price = sentPrice;
  }
  
  void resetPrice() {price = oPrice;} //when game restarts
  void updatePrice(int sentPrice) {price = sentPrice;} //when player purchases
}
