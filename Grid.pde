// A Grid object
class Grid {
  // A grid object knows about its cells
  String name;
	Cell[][] grid;
	int bgColor = 160;
	color selectedColor = #ffffff;
	// price sticker parameters
	float stickerHeight = 26;
	float stickerWidth = 12;
	// sticker margin
	float marginHoriz = 6;
	float marginVert = 3;

  // Grid Constructor
  Grid(String gridName) {
    name = gridName;
  }

	// Display grid
	public void display() {
	  for (int i = 0; i < cols; i++) {
	    for (int j = 0; j < rows; j++) {
	      grid[i][j].display();
	    }
	  }
		displayLegend();
	}

	// Fill Grid Cells with values
	void set(String[] schema, String[] colorSchema) {
		grid = new Cell[cols][rows];
		for (int i = 0; i < cols; i++) {
			for (int j = 0; j < rows; j++) {
				// prepare cel parameters
				float x = i*stickerWidth + i*marginHoriz*2 + marginScreenY;
				float y = j*stickerHeight + j*marginVert*2 + marginScreenY;
				boolean hasCell = charToBool(schema[j].charAt(i));
				// TODO colorSchema
				int cellColor = getColor(hasCell, bgColor);
				// Initialize each object
				grid[i][j] = new Cell(x, y, stickerWidth, stickerHeight, cellColor, hasCell);
			}
		}
	}

	void displayLegend() {
		int numColors = stickerColors.length;
		int size = 20;
	  for(int i=0; i<numColors; i++) {
			int xPos = width - 20 - (i)*20;
			int yPos = 0;
			if (stickerColors[i] == selectedColor) {
				stroke(255);
				strokeWeight(3);
				// println(xPos, yPos, xPos+size, yPos+size);
			}
	    fill(stickerColors[i]);
			if((mouseX >= xPos && mouseX <= xPos+size) && //check horizontal bounds(left/right)
	       (mouseY >= yPos && mouseY <= yPos+size) //check vertical bounds(top/bottom)
			){
				if(mousePressed){//if mouse is over/within a boxes bounds and clicked
				  selectedColor = stickerColors[i];
				}
			}
			rect(xPos, yPos, size, size);
	  }
	}

	void setBackground(int bg) {
		bgColor = bg;
		for (int i = 0; i < cols; i++) {
	    for (int j = 0; j < rows; j++) {
	      grid[i][j].setColor(bgColor);
				grid[i][j].display();
	    }
	  }
	};
/*
  void display() {

    // stroke(255);
    noStroke();
		if((mouseX >= x && mouseX <= x+w) && //check horizontal bounds(left/right)
       (mouseY >= y && mouseY <= y+h) //check vertical bounds(top/bottom)
		){
			if(mousePressed){//if mouse is over/within a boxes bounds and clicked
			  cellColor = selectedColor;
			}
		}
    // Color calculated using sine wave
    fill(cellColor);
    rect(x,y,w,h,2);
  }*/
}
