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

int getNearestColor(int input, int[] choices){
  int c = 0;
  int r = int(red(input));
  int g = int(green(input));
  int b = int(blue(input));
  int bestDist = 766;
  for(int i = 0; i < choices.length; i++){
    int R = int(red(choices[i]));
    int G = int(green(choices[i]));
    int B = int(blue(choices[i]));
    int dist = abs(R - r) + abs(G - g) + abs(B - b);
    if(dist < bestDist){
      c = choices[i];
      bestDist = dist;
    }
  }
  return c;
}

color hexStrToColor(String s) {
	return unhex("FF" + s.substring(1));
}
