// A Cell object
class Cell {
  // A cell object knows about its location in the grid
  // as well as its size with the variables x,y,w,h
  float x,y;   // x,y location
  float w,h;   // width and height
	int posX, posY; // position in grid
  int cellColor; // color
	boolean active;
	boolean doOnce;

  // Cell Constructor
  Cell(int tempPosX, int tempPosY, float tempX, float tempY, float tempW, float tempH, int tempColor, boolean activeState) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
		posX = tempPosX;
		posY = tempPosY;
    cellColor = tempColor;
		active = activeState;
  }

  void display() {
    noStroke();
		changeColorOnClick();
    fill(cellColor);
    rect(x,y,w,h,2);
  }

	boolean setColor(color c){
		if(currentSchema.subtrReducedColor(c)){
			cellColor = c;
			return true;
		}
		return false;
	}

	void changeColorOnClick() {
		if(active && // cell is available
			(mouseX >= x && mouseX <= x+w) && //check horizontal bounds(left/right)
			(mouseY >= y && mouseY <= y+h) //check vertical bounds(top/bottom)
		){
			if(mousePressed && doOnce == false){//if mouse is over/within a boxes bounds and clicked
				doOnce = true;
				if(isFloodFill){
					currentSchema.floodFill(posX, posY, color(emptyColor), selectedColor);
				} else {
					this.setColor(selectedColor);
				}
			}
		}
	}

	void mouseReleased() {
	  doOnce = false;
	}
}
