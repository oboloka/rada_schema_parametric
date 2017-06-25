// A Grid object
class Grid {
  String name;
  // A grid object knows about its cells
	Cell[][] grid;
	// screen size
	int screenWidth;
	int screenHeight;
	// screenMargin
	float marginScreenX;
	float marginScreenY;
	// colors
	int bgColor = 160;
	color selectedColor = #ffffff;
	// price sticker parameters
	float stickerHeight = 26;
	float stickerWidth = 12;
	// sticker margin
	float marginHoriz = 6;
	float marginVert = 3;

  // Grid Constructor
  Grid(String gridName, int scrW, int scrH) {
    name = gridName;
		screenWidth = scrW;
		screenHeight = scrH;
		setGrid(schema, currentSchemaName);
  }

	// Display schema
	public void display() {
		displayGrid();
		displayLegend();
	}

	void displayGrid() {
		// loop by cells of grid
		for (int i = 0; i < cols; i++) {
	    for (int j = 0; j < rows; j++) {
	      grid[i][j].display();
	    }
	  }
	}

	// Fill Grid Cells with values
	void setGrid(String[] schema, String colorSchema) {
		setScreenMargin();
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
		int size = 20;
		int numColors = stickerColors.length;
	  for(int i=0; i<numColors; i++) {
			int xPos = width - 20 - (i)*20;
			int yPos = 0;
			if (stickerColors[i] == selectedColor) {
				stroke(255);
				strokeWeight(3);
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

	// Set magrin for render screen based on grid size
	void setScreenMargin(){
		float gridSizeX = cols * (stickerWidth + marginHoriz*2);
		float gridSizeY = rows * (stickerHeight + marginVert*2);
		marginScreenX = (screenWidth - gridSizeX)/2;
		marginScreenY = (screenHeight - gridSizeY)/2;
	}

	void setBackground(int bg) {
		bgColor = bg;
		for (int i = 0; i < cols; i++) {
	    for (int j = 0; j < rows; j++) {
				if(!grid[i][j].active) {
		      grid[i][j].setColor(bgColor);
					grid[i][j].display();
				}
	    }
	  }
	};

	void setMarginHoriz(float val) {
		marginHoriz = val;
		setGrid(schema, currentSchemaName);
		display();
	}
	void setMarginVert(float val) {
		marginVert = val;
		setGrid(schema, currentSchemaName);
		display();
	}
	void setSticker(float stWidth, float stHeight) {
		stickerWidth = stWidth;
		stickerHeight = stHeight;
		setGrid(schema, currentSchemaName);
		display();
	}
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
