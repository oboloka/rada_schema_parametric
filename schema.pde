import controlP5.*;
import processing.pdf.*;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

/**
 * Global variables
 */
ControlP5 gui;
ControlGroup guiGroup;
DropdownList guiStickerDL;

// falg for saving pdf
boolean save = false;
// screen size
int screenWidth = 1200;
int screenHeight = 800;
// 2D Array of stickers
// Cell[][] grid;
HashMap<String, Grid> schemas = new HashMap<String, Grid>();
String currentSchemaName = "default";
Grid currentSchema;
// Number of columns and rows in the grid
int cols = 45;
int rows = 22;
// colors
int bgColor = 160;
color selectedColor = #ffffff;
// Available colors
color[] stickerColors = { #e2fe85, #9cffa5, #fe9470, #fab655, #fc53c4, #ffffff };
// Price sticker's size types:
String[] stickerTypes = { "26x12", "26x16", "21x12", "21.5x12", "30x20", "30x25", "50x35" };
// Rada Convocations list
String[] schemaList = { "default", "rada1", "rada2", "rada3", "rada4", "rada5", "rada6", "rada7", "rada8" };

// Prepare Schemas object with Grids for each Rada's convocation
void setSchemas(String[] schema, String colorSchema) {
	int numSchemas = schemaList.length;
	for (int i = 0; i < numSchemas; i++) {
		Grid radaSchema = new Grid(schemaList[i], screenWidth, screenHeight);
		schemas.put(schemaList[i], radaSchema);
	}
	currentSchema = schemas.get(currentSchemaName);
}

// Display grid
void displaySchema() {
/*	Set set = schemas.entrySet();
	Iterator iterator = set.iterator();
	while(iterator.hasNext()) {
		Map.Entry schema = (Map.Entry)iterator.next();
		print("key is: "+ schema.getKey() + " & Value is: ");
		println(schema.getValue());
	}*/
	currentSchema.display();
}

String getFileName() {
	String filename = gui.get(Textfield.class, "guiInputFilename").getText();
	if(filename == null || filename.trim().length() == 0) filename = "output";
	filename = filename + ".pdf";
	return filename;
}

/**
 * This is main function, it runs once, when the program starts.
 * It's used to define initial enviroment properties.
 */
void setup() {
	// prepare screen
  size(1200, 800, P2D);
	smooth();
	// TODO prepare data
	// loadJson("data/rada.json");
	// init schemas
	setSchemas(schema, currentSchemaName); // FIXME controls are broken
	// init controls
	gui = initGui();
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
	displaySchema();

	if (save) { // end saving PDF
    endRecord();
    save = false;
  }
}
