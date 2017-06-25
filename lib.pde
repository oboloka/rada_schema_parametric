void printSchema(String[] schema) {
	for (int y = 0; y < schema.length; y++) {
    println("");
    for (int x = 0; x < schema[y].length(); x++) {
      print(schema[y].charAt(x));
    }
  }
}

boolean charToBool(char c) {
  if (c == '1') {
      return true;
  } else {
      return false;
  }
}

int getColor(boolean hasCell, int defColor) {
	int cellColor;
	if (hasCell){
		cellColor = 255;
	} else {
		cellColor = defColor;
	}
	return cellColor;
}
