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
	// price sticker parameters
	float stickerHeight = 26;
	float stickerWidth = 12;
	// sticker margin
	float marginHoriz = 6;
	float marginVert = 3;
	// Number of columns and rows in the grid
	int cols = 45;
	int rows = 22;
	// Redused list of colors and amounts
	HashMap<String, Integer> colors = new HashMap<String, Integer>();

  // Grid Constructor
  Grid(String gridName, int scrW, int scrH) {
    name = gridName;
		screenWidth = scrW;
		screenHeight = scrH;
		setGrid(schema, currentSchemaName);
  }

	// Fill Grid Cells with values
	void setGrid(String[] schema, String colorSchema) {
		setScreenMargin();
		setCells(schema, colorSchema);
		setInfo();
	}

	void setCells(String[] schema, String colorSchema){
		grid = new Cell[cols][rows];
		for (int i = 0; i < cols; i++) {
			for (int j = 0; j < rows; j++) {
				// prepare cel parameters
				float x = i*stickerWidth + i*marginHoriz*2 + marginScreenY;
				float y = j*stickerHeight + j*marginVert*2 + marginScreenY;
				boolean hasCell = charToBool(schema[j].charAt(i));
				int cellColor = getColor(hasCell, bgColor, emptyColor);
				// Initialize each object
				grid[i][j] = new Cell(i, j, x, y, stickerWidth, stickerHeight, cellColor, hasCell);
			}
		}
	}

	void setInfo(){
		JSONArray fractList = radaJson.getJSONArray(currentSchemaName);
		if(fractList.size() > 0) {
			for (int i = 0; i < fractList.size(); i++) {
				JSONObject fract = fractList.getJSONObject(i);
				int amount = fract.getInt("amount", 0);
				String name = fract.getString("name", "Unknown");
				String fcolorStr = fract.getString("color", "#ffffff");
				color fcolor = hexStrToColor(fcolorStr);
				color nearestColor = getNearestColor(fcolor, stickerColors);
				addReducedColor(nearestColor, amount);
			}
			// printReducedColors();
		}
	}

	// Display schema
	public void display() {
		displayGrid();
		displayLegend();
		displayInfo();
	}

	void displayGrid() {
		// loop by cells of grid
		for (int i = 0; i < cols; i++) {
	    for (int j = 0; j < rows; j++) {
	      grid[i][j].display();
	    }
	  }
	}

	void displayLegend() {
		int size = 20;
		int numColors = stickerColors.length;
	  for(int i=0; i<numColors; i++) {
			int xPos = width - 20 - (i)*20;
			int yPos = 0;
	    fill(stickerColors[i]);
			if (stickerColors[i] == selectedColor) {
				stroke(emptyColor);
				strokeWeight(3);
			}
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

	void displayInfo() {
		int size = 20;
		JSONArray fractList = radaJson.getJSONArray(currentSchemaName);
		if(fractList.size() > 0) {
			for (int i = 0; i < fractList.size(); i++) {
				JSONObject fract = fractList.getJSONObject(i);
				int amount = fract.getInt("amount", 0);
				String name = fract.getString("name", "Unknown");
				String fcolorStr = fract.getString("color", "#ffffff");
				color fcolor = hexStrToColor(fcolorStr);
				// draw original data
				int xPos = width - size;
				int yPos = 200 + (i)*size;
				stroke(emptyColor);
				strokeWeight(3);
				fill(fcolor);
				rect(xPos, yPos, size, size);
				// compare sticker colors to original colors and draw nearest
				color nearestColor = getNearestColor(fcolor, stickerColors);
				fill(nearestColor);
				rect(xPos-size, yPos, size, size);
				fill(0);
				text(amount, xPos+3, yPos+11);
			}
			displayReducedColors(width-size*3, 200, size);
		}
	}

	void displayReducedColors(int x, int y, int size) {
		int i = 0;
		int total = 0;
		Object[] a = colors.entrySet().toArray();
		Arrays.sort(a, new Comparator() {
	    public int compare(Object o1, Object o2) {
	      return ((Map.Entry<String, Integer>) o2).getValue()
	              .compareTo(((Map.Entry<String, Integer>) o1).getValue());
	    }
		});
		int yPos = 0;
		for (Object e : a) {
			color c = hexStrToColor(((Map.Entry<String, Integer>) e).getKey().toString());
			String amount = ((Map.Entry<String, Integer>) e).getValue().toString();
			yPos = y + (i)*size;
			fill(c);
			rect(x, yPos, size, size);
			fill(0);
			text(amount, x+3, yPos+11);
			total += Integer.parseInt(amount);
			i++;
		}
		int unused = 450 - total;
		if (unused > 0){
			noFill();
			noStroke();
			rect(x, yPos+size, size, size);
			fill(0);
			text(unused+"?", x-5, yPos+size+11);
		}
	}

	void addReducedColor(color c, int amount){
		String colorKey = hex(c);
		if (colors.containsKey(colorKey)) {
			int curAmount = colors.get(colorKey);
			colors.put(colorKey, curAmount + amount);
		} else {
			colors.put(colorKey, amount);
		}
	}

	void printReducedColors(){
		Object[] a = colors.entrySet().toArray();
		Arrays.sort(a, new Comparator() {
	    public int compare(Object o1, Object o2) {
	      return ((Map.Entry<String, Integer>) o2).getValue()
	              .compareTo(((Map.Entry<String, Integer>) o1).getValue());
	    }
		});
		for (Object e : a) {
		  println(((Map.Entry<String, Integer>) e).getKey() + " : " + ((Map.Entry<String, Integer>) e).getValue());
		}
	}

	boolean subtrReducedColor(color c){
		String colorKey = hex(c);
		if (colors.containsKey(colorKey)) {
			int curAmount = colors.get(colorKey);
			if (curAmount > 0) {
				colors.put(colorKey, curAmount - 1);
				return true;
			}
		}
		return false;
	}

/*
Flood fill, also called seed fill, is an algorithm that determines the area connected to
a given node in a multi-dimensional array. It is used in the "bucket" fill tool of paint
programs to fill connected, similarly-colored areas with a different color. When applied on
an image to fill a particular bounded area with color, it is also known as boundary fill.
https://en.wikipedia.org/wiki/Flood_fill

Flood-fill (node, target-color, replacement-color):
 1. If target-color is equal to replacement-color, return.
 2. If the color of node is not equal to target-color, return.
 3. Set the color of node to replacement-color.
 4. Perform Flood-fill (one step to the south of node, target-color, replacement-color).
    Perform Flood-fill (one step to the north of node, target-color, replacement-color).
    Perform Flood-fill (one step to the west of node, target-color, replacement-color).
    Perform Flood-fill (one step to the east of node, target-color, replacement-color).
 5. Return.
 */
	void floodFill(int x, int y, color targetColor, color replacementColor) {
		Cell stCell = grid[x][y];
		if(targetColor == replacementColor) return;
		if(color(stCell.cellColor) != targetColor) return;
		// println("floodFill", x, y, targetColor, replacementColor);
		if(color(stCell.cellColor) != color(bgColor)) {
			if(!stCell.setColor(replacementColor)) return;
		}
		// println(x, y, cols, rows, hex(stCell.cellColor, 6));
		if (y+1 < rows-1) this.floodFill(x, y+1, targetColor, replacementColor);
		if (y-1 >= 0) this.floodFill(x, y-1, targetColor, replacementColor);
		if (x-1 >= 0) this.floodFill(x-1, y, targetColor, replacementColor);
		if (x+1 < cols-1) this.floodFill(x+1, y, targetColor, replacementColor);
		return;
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
		// FIXME don't clear all settings
		setGrid(schema, currentSchemaName);
		display();
	}
	void setMarginVert(float val) {
		marginVert = val;
		// FIXME don't clear all settings
		setGrid(schema, currentSchemaName);
		display();
	}
	void setSticker(float stWidth, float stHeight) {
		stickerWidth = stWidth;
		stickerHeight = stHeight;
		// FIXME don't clear all settings
		setGrid(schema, currentSchemaName);
		display();
	}
}
