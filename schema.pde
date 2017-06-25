import controlP5.*;
import processing.pdf.*;
import java.util.Map;

/**
 * Global variables
 */
ControlP5 gui;
ControlGroup guiGroup;
DropdownList guiStickerDL;
// falg for saving pdf
boolean save = false;

// price sticker parameters
float stickerHeight = 26;
float stickerWidth = 12;
// sticker margin
float marginHoriz = 6;
float marginVert = 3;
// screenMargin
float marginScreenX;
float marginScreenY;

// 2D Array of stickers
Cell[][] grid;
String[] currentColorSchema;

// Number of columns and rows in the grid
int cols = 45;
int rows = 22;
// colors
int bgColor = 160;
// current color
color selectedColor = #ffffff;
// Available colors
color[] stickerColors = { #e2fe85, #9cffa5, #fe9470, #fab655, #fc53c4, #ffffff };
// Price sticker's size types:
String[] stickerTypes = { "26x12", "26x16", "21x12", "21.5x12", "30x20", "30x25", "50x35" };

// Fill Cells Grid with values
void setGrid(String[] schema, String[] colorSchema) {
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

// Set magrin for render screen based on grid size
void setScreenMargin(int screenSizeX, int screenSizeY){
	float gridSizeX = cols * (stickerWidth + marginHoriz*2);
	float gridSizeY = rows * (stickerHeight + marginVert*2);
	marginScreenX = (screenSizeX - gridSizeX)/2;
	marginScreenY = (screenSizeY - gridSizeY)/2;
}

// Display grid
void displayGrid() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].display();
    }
  }
	displayLegend();
}

String getFileName() {
	String filename = gui.get(Textfield.class, "guiInputFilename").getText();
	if(filename == null || filename.trim().length() == 0) filename = "output";
	filename = filename + ".pdf";
	return filename;
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

/**
 * This is main function, it runs once, when the program starts.
 * It's used to define initial enviroment properties.
 */
void setup() {
	// prepare screen
  size(1200, 800, P2D);
	smooth();

	setScreenMargin(1200, 800);
	// TODO grids array with legend, choose by dropbox
	setGrid(schema, currentColorSchema);
	// TODO setGrids

	gui = initGui();
	// noLoop();
}

/**
 * Called directly after setup(), the draw() function continuously executes the lines of code
 * contained inside its block until the program is stopped or noLoop() is called.
 */
void draw() {
	if (save) { // start saving PDF
    beginRecord(PDF, getFileName());
  }

  background(bgColor);
	displayGrid();

	if (save) { // end saving PDF
    endRecord();
    save = false;
  }
}
