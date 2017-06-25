import java.util.regex.Pattern;

/**
 * Init GUI controls
 * @type {ControlP5}
 */
ControlP5 initGui() {
	gui = new ControlP5(this);
	guiGroup = gui.addGroup("Controls");

	int defBgColor = currentSchema.bgColor;
	float defMarginVert = currentSchema.marginVert;
	float defMarginHoriz = currentSchema.marginHoriz;

	gui.addSlider("guiBgSlider")
		.setCaptionLabel("background")
		.setPosition(10,10)
		.setSize(250,20)
		.setRange(0,255)
		.setValue(defBgColor)
		.setGroup(guiGroup);

	gui.addTextfield("guiInputFilename")
	  .setCaptionLabel("File Name")
		.setPosition(10, 40)
		.setSize(160, 20)
		.setGroup(guiGroup);

	gui.addButton("guiButtonSave")
		.setCaptionLabel("Save PDF")
		.setValue(0)
		.setPosition(180, 40)
		.setSize(80, 20)
		.setGroup(guiGroup);

	gui.addScrollableList("guiStickerType")
		.setCaptionLabel("Sticker type")
		.setPosition(10, 80)
		.setSize(150, 100)
		.setBarHeight(20)
		.setItemHeight(20)
		.addItems(stickerTypes)
		.setType(ScrollableList.DROPDOWN)
		.setOpen(false)
		.setValue(0);

/*	gui.addTextfield("guiStickerHeight")
		.setCaptionLabel("Height")
		.setPosition(180, 80)
		.setSize(30, 20)
		.setGroup(guiGroup);

	gui.addTextfield("guiStickerWidth")
		.setCaptionLabel("Width")
		.setPosition(230, 80)
		.setSize(30, 20)
		.setGroup(guiGroup);*/

	gui.addTextfield("guiMarginHoriz")
		.setCaptionLabel("Margin Horizont")
		.setDefaultValue(defMarginHoriz)
		.setPosition(10, 120)
		.setSize(30, 20)
		.setAutoClear(false)
		.setGroup(guiGroup);

	gui.addTextfield("guiMarginVert")
		.setCaptionLabel("Margin Vertical")
		.setDefaultValue(defMarginVert)
		.setPosition(80, 120)
		.setSize(30, 20)
		.setAutoClear(false)
		.setGroup(guiGroup);

	gui.addScrollableList("guiConvocationList")
		.setCaptionLabel("Rada Convocation Number")
		.setPosition(10, 160)
		.setSize(150, 100)
		.setBarHeight(20)
		.setItemHeight(20)
		.addItems(schemaList)
		.setType(ScrollableList.DROPDOWN)
		.setOpen(false);

	// TODO colors select

	return gui;
}

/**
 * GIU event handlers
 */
void guiBgSlider(int colorValue) {
  bgColor = color(colorValue);
	// TODO grid update
	currentSchema.setBackground(bgColor);
}

void guiButtonSave(int theValue) {
  println("a button event from savePDF: "+theValue);
  save = true;
}

public void guiMarginHoriz(String val) {
  float marginHoriz = Float.valueOf(val);
	println("set marginHoriz:"+marginHoriz);
	currentSchema.setMarginHoriz(marginHoriz);
}
public void guiMarginVert(String val) {
  float marginVert = Float.valueOf(val);
	println("set marginVert:"+marginVert);
	currentSchema.setMarginVert(marginVert);
}

void guiStickerType(int n) {
  String size = (String) gui.get(ScrollableList.class, "guiStickerType").getItem(n).get("text");
	String[] sizeArray = size.split(Pattern.quote("x"));
	float stickerWidth = Float.valueOf(sizeArray[1]);
	float stickerHeight = Float.valueOf(sizeArray[0]);
	currentSchema.setSticker(stickerWidth, stickerHeight);
}

void guiConvocationList(int n) {
	String type = (String) gui.get(ScrollableList.class, "guiConvocationList").getItem(n).get("text");
	currentSchemaName = type;
	setSchemas(schema, type); // FIXME
}
