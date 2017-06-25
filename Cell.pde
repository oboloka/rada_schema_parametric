// A Cell object
class Cell {
  // A cell object knows about its location in the grid
  // as well as its size with the variables x,y,w,h
  float x,y;   // x,y location
  float w,h;   // width and height
  int cellColor; // color
	boolean active;

  // Cell Constructor
  Cell(float tempX, float tempY, float tempW, float tempH, int tempColor, boolean activeState) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    cellColor = tempColor;
		active = activeState;
  }

  void display() {
    noStroke();
		changeColorOnClick();
    fill(cellColor);
    rect(x,y,w,h,2);
  }

	void changeColorOnClick() {
		if(active && // cell is available
			(mouseX >= x && mouseX <= x+w) && //check horizontal bounds(left/right)
			(mouseY >= y && mouseY <= y+h) //check vertical bounds(top/bottom)
		){
			if(mousePressed){//if mouse is over/within a boxes bounds and clicked
				cellColor = selectedColor;
			}
		}
	}

	void setColor(int c) {
		cellColor = c;
	}
}
