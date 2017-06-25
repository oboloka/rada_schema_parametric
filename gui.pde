import java.util.regex.Pattern;

/**
 * Init GUI controls
 * @type {ControlP5}
 */
ControlP5 initGui() {
	gui = new ControlP5(this);
	guiGroup = gui.addGroup("Controls");

	gui.addSlider("guiBgSlider")
		.setCaptionLabel("background")
		.setPosition(10,10)
		.setSize(250,20)
		.setRange(0,255)
		.setValue(160)
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

	gui.addTextfield("guiStickerHeight")
		.setCaptionLabel("Height")
		.setPosition(180, 80)
		.setSize(30, 20)
		.setGroup(guiGroup);

	gui.addTextfield("guiStickerWidth")
		.setCaptionLabel("Width")
		.setPosition(230, 80)
		.setSize(30, 20)
		.setGroup(guiGroup);

	gui.addTextfield("guiMarginHoriz")
		.setCaptionLabel("Margin Horizont")
		.setStringValue("3")
		.setPosition(10, 120)
		.setSize(30, 20)
		.setAutoClear(false)
		.setGroup(guiGroup);

	gui.addTextfield("guiMarginVert")
		.setCaptionLabel("Margin Vertical")
		.setDefaultValue(marginVert)
		.setPosition(80, 120)
		.setSize(30, 20)
		.setAutoClear(false)
		.setGroup(guiGroup);

	gui.addScrollableList("guiConvocationNum")
		.setCaptionLabel("Convocation Number")
		.setPosition(10, 160)
		.setSize(150, 100)
		.setBarHeight(20)
		.setItemHeight(20)
		.addItems(stickerTypes)
		.setType(ScrollableList.DROPDOWN)
		.setOpen(false)
		.setValue(0);

	// TODO colors select

	return gui;
}

/**
 * GIU event handlers
 */
void guiBgSlider(int colorValue) {
  bgColor = color(colorValue);
}

void guiButtonSave(int theValue) {
  println("a button event from savePDF: "+theValue);
  save = true;
}

public void guiMarginHoriz(String val) {
  marginHoriz = Float.valueOf(val);
	println("set marginHoriz:"+marginHoriz);
}
public void guiMarginVert(String val) {
  marginVert = Float.valueOf(val);
	println("set marginVert:"+marginVert);
}

void guiStickerType(int n) {
  String size = (String) gui.get(ScrollableList.class, "guiStickerType").getItem(n).get("text");
	String[] sizeArray = size.split(Pattern.quote("x"));
	stickerWidth = Float.valueOf(sizeArray[1]);
	stickerHeight = Float.valueOf(sizeArray[0]);
}
