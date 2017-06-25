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
				// TODO colorSchema
				int cellColor = getColor(hasCell, bgColor);
				// Initialize each object
				grid[i][j] = new Cell(x, y, stickerWidth, stickerHeight, cellColor, hasCell);
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
				stroke(255);
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
			text(unused+"?", x+3, yPos+size+11);
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

	void subtrReducedColor(color c){
		String colorKey = hex(c);
		if (colors.containsKey(colorKey)) {
			int curAmount = colors.get(colorKey);
			colors.put(colorKey, curAmount - 1);
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
