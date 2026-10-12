// Draycen Worthington | 9/14/26 | calculator
// Standard Calculator Sketch in Processing

String displayStr = "0";
float firstNum = 0;
char currentOp = ' ';
boolean newNumber = true;

Button[] buttons;

void setup() {
  size(260, 470);
  buttons = new Button[22]; // 16 original + 6 new buttons
  
  // Row 0: C, DEL, √, ^
  buttons[0] = new Button(20, 100, 50, 50, "C");
  buttons[1] = new Button(75, 100, 50, 50, "DEL");
  buttons[2] = new Button(130, 100, 50, 50, "√");
  buttons[3] = new Button(185, 100, 50, 50, "^");
  
  // Row 1: 7, 8, 9, /
  buttons[4] = new Button(20, 160, 50, 50, "7");
  buttons[5] = new Button(75, 160, 50, 50, "8");
  buttons[6] = new Button(130, 160, 50, 50, "9");
  buttons[7] = new Button(185, 160, 50, 50, "/");
  
  // Row 2: 4, 5, 6, *
  buttons[8] = new Button(20, 220, 50, 50, "4");
  buttons[9] = new Button(75, 220, 50, 50, "5");
  buttons[10] = new Button(130, 220, 50, 50, "6");
  buttons[11] = new Button(185, 220, 50, 50, "*");
  
  // Row 3: 1, 2, 3, -
  buttons[12] = new Button(20, 280, 50, 50, "1");
  buttons[13] = new Button(75, 280, 50, 50, "2");
  buttons[14] = new Button(130, 280, 50, 50, "3");
  buttons[15] = new Button(185, 280, 50, 50, "-");
  
  // Row 4: +/-, 0, ., +
  buttons[16] = new Button(20, 340, 50, 50, "+/-");
  buttons[17] = new Button(75, 340, 50, 50, "0");
  buttons[18] = new Button(130, 340, 50, 50, ".");
  buttons[19] = new Button(185, 340, 50, 50, "+");
  
  // Row 5: %, =
  buttons[20] = new Button(20, 400, 50, 50, "%");
  buttons[21] = new Button(75, 400, 160, 50, "=");
}

void draw() {
  background(230);
  
  // White screen display
  fill(255);
  stroke(150);
  strokeWeight(1);
  rect(20, 20, 215, 60, 5);
  
  // Black display text
  fill(0);
  textSize(28);
  textAlign(RIGHT, CENTER);
  text(displayStr, 225, 47);
  
  // Draw green buttons
  for (Button b : buttons) {
    b.display();
  }
}

void mousePressed() {
  for (Button b : buttons) {
    if (b.isMouseOver()) {
      processInput(b.label);
    }
  }
}

void processInput(String val) {
  if (val.equals("C")) {
    displayStr = "0";
    firstNum = 0;
    currentOp = ' ';
    newNumber = true;
  } else if (val.equals("DEL")) {
    if (!displayStr.equals("0") && !displayStr.equals("Error")) {
      if (displayStr.length() > 1) {
        displayStr = displayStr.substring(0, displayStr.length() - 1);
      } else {
        displayStr = "0";
        newNumber = true;
      }
    }
  } else if (val.equals("√")) {
    float num = Float.parseFloat(displayStr);
    if (num >= 0) {
      formatAndSetResult(sqrt(num));
    } else {
      displayStr = "Error";
    }
    newNumber = true;
  } else if (val.equals("%")) {
    float num = Float.parseFloat(displayStr);
    formatAndSetResult(num / 100.0);
    newNumber = true;
  } else if (val.equals("+/-")) {
    if (!displayStr.equals("0") && !displayStr.equals("Error")) {
      if (displayStr.startsWith("-")) {
        displayStr = displayStr.substring(1);
      } else {
        displayStr = "-" + displayStr;
      }
    }
  } else if (val.equals(".")) {
    if (newNumber || displayStr.equals("Error")) {
      displayStr = "0.";
      newNumber = false;
    } else if (!displayStr.contains(".")) {
      displayStr += ".";
    }
  } else if (val.equals("=")) {
    calculateResult();
    currentOp = ' ';
  } else if (val.equals("+") || val.equals("-") || val.equals("*") || val.equals("/") || val.equals("^")) {
    firstNum = Float.parseFloat(displayStr);
    currentOp = val.charAt(0);
    newNumber = true;
  } else {
    if (newNumber || displayStr.equals("0") || displayStr.equals("Error")) {
      displayStr = val;
      newNumber = false;
    } else {
      displayStr += val;
    }
  }
}

void calculateResult() {
  if (currentOp == ' ') return; 
  
  float secondNum = Float.parseFloat(displayStr);
  float result = 0;
  
  if (currentOp == '+') result = firstNum + secondNum;
  else if (currentOp == '-') result = firstNum - secondNum;
  else if (currentOp == '*') result = firstNum * secondNum;
  else if (currentOp == '/') {
    if (secondNum != 0) result = firstNum / secondNum;
    else { 
      displayStr = "Error"; 
      newNumber = true; 
      return; 
    }
  } else if (currentOp == '^') {
    result = pow(firstNum, secondNum);
  }
  
  formatAndSetResult(result);
  newNumber = true;
}

void formatAndSetResult(float result) {
  if (Float.isNaN(result) || Float.isInfinite(result)) {
    displayStr = "Error";
  } else if (result == (int)result) {
    displayStr = str((int)result);
  } else {
    displayStr = str(result);
  }
}

class Button {
  float x, y, w, h;
  String label;
  
  Button(float x, float y, float w, float h, String label) {
    this.x = x; 
    this.y = y; 
    this.w = w; 
    this.h = h; 
    this.label = label;
  }
  
  void display() {
    if (isMouseOver()) {
      fill(50, 205, 100);    // Lighter green on hover
    } else {
      fill(34, 139, 34);     // Green fill
    }
    stroke(20, 90, 20);
    strokeWeight(1);
    rect(x, y, w, h, 5);
    
    fill(255);              // White button text
    textSize(18);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2 - 2);
  }
  
  boolean isMouseOver() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
