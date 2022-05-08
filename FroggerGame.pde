//Pritha Das DASPD2003 Question 1

int level=1, midColor=1, end;
float bandHeight, frogPosx, frogPosy, frogSize, offset=0.75, speed=0.8;
final int NUM_TYPES=3; //total types of hazards
final float HAZARD_SIZE = 0.5; ///size of each hazard
boolean frogMove=true; //stops the frog if game is over
boolean message=true; //displays 'Game Over' if frog collides with hazard

void setup() {
  fullScreen();
  if (level<=5)
    end=(level+4)%10-1;
  else
    end=(level+4)%100-1;
  bandHeight=height/(level+4);
  frogPosx=width/2;
  frogSize=0.35*bandHeight;
  frogPosy=(end+0.5)*bandHeight;
}

void drawWorld() {
  for (int i=1; i<=level+4; i++) {
    if (i==1) {
      stroke(#EDA460);
      fill(#EDA460);
      rect(0, 0, width, bandHeight);
    } else if (i==level+4) {
      stroke(#EDA460);
      fill(#EDA460);
      rect(0, end*bandHeight, width, bandHeight);
    } else {
      stroke(#639CF5);
      fill(#639CF5);
      rect(0, midColor*bandHeight, width, bandHeight);
      midColor++;
    }
  }
  midColor=1;
}

void drawFrog(float x, float y, float diam) {
  stroke(0);
  fill(#30742B);
  ellipse(x, y, diam, diam);
}

void moveFrog(float xChange, float yChange) {
  if (objectInCanvas(frogPosx, frogPosy, frogSize)) {
    if (key=='w'||key=='W'||key=='i'||key=='I') {
      frogPosy-=yChange;
      frogPosy=max(frogPosy, height/(end+1));
    }
    if (key=='a'||key=='A'||key=='j'||key=='J') {
      frogPosx-=xChange;
      frogPosx=max(frogPosx, width/20);
    }
    if (key=='s'||key=='S'||key=='k'||key=='K') {
      frogPosy+=yChange;
      frogPosy=min(frogPosy, height-height/20);
    }
    if (key=='d'||key=='D'||key=='l'||key=='L') {
      frogPosx+=xChange;
      frogPosx=min(frogPosx, width-width/20);
    }
  }
}

void keyPressed() {
  if (frogMove)
    moveFrog(bandHeight, bandHeight);
}

void drawHazards() {
  for (int line=0; line<level+2; line++) {
    float lineSpacing = (line+3)*bandHeight;
    float lineOffset = (line+3)*offset;
    if (line%2==0)
      lineOffset = lineSpacing-lineOffset;
    float x = -lineSpacing + lineOffset;
    float y = height-(line+1.5)*bandHeight;
    do {
      drawHazard(line%NUM_TYPES, x, y, HAZARD_SIZE*bandHeight);
      x += lineSpacing;
    } while (objectInCanvas(x, y, HAZARD_SIZE*bandHeight));
  }
}

boolean drawHazard(int type, float x, float y, float size) {
  stroke(0);
  if (type==0) {
    fill(255, 0, 0);
    ellipse(x, y, size, size);
  }  
  if (type==1) {
    fill(0);
    rect(x-size/2, y-size/2, size, size);
  }  
  if (type==2) {
    fill(255);
    ellipse(x, y, size, size);
  }
  if (objectsOverlap(frogPosx, frogPosy, x, y, frogSize, size)) {
    speed=0;  
    frogMove=false;
    message=false;
    return true;
  } else {
    return false;
  }
}

boolean objectInCanvas(float x, float y, float diam) {
  if ( y>height || y<0 || x>width || x<0 )
    return false;  
  else
    return true;
}

void displayMessage(String m) {
  fill(0);
  textSize(0.5*bandHeight);
  if (detectWin()) {
    level++;
    setup();
  }
  text(m, width/2-textWidth(m)/2, 0.65*bandHeight);
}

boolean detectWin() {
  if (frogPosy<=bandHeight) {
    return true;
  } else
    return false;
}

boolean objectsOverlap(float x1, float y1, float x2, float y2, float size1, float size2) {
  float dist=sqrt(sq(x2-x1)+sq(y2-y1));
  if (dist==0||dist<=size1)
    return true;
  else
    return false;
}

void draw() {
  drawWorld();
  drawHazards();
  drawFrog(frogPosx, frogPosy, frogSize);
  offset = (offset+speed)%bandHeight;
  if (message)
    displayMessage("Level "+level);
  else
    displayMessage("Game Over");
  detectWin();
}
