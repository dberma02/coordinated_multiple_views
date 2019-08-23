

public class Pie {
  Table table;
  Table masterTable;
  int total = 0;
  boolean zeroTotal;
  boolean isPie;
  float bigR;
  float smallR;
  PVector center;
  float donutR;
  String selectedMonth;
  color repC = color(200, 10, 3);
  color demC = color(5, 100, 230);
  color othC = color(144,75,191);
  ArrayList<Integer> hiList = new ArrayList<Integer>();
  
  Pie(Table table, String selectedMonth, float rad, PVector center, Table masterTable) {

    this.selectedMonth = selectedMonth;
    this.table = table;
    this.masterTable = masterTable;
    this.bigR = rad;
    this.smallR = rad * .7;
    this.center = center;
    
    setTotal();
    isPie = true;
    bigR = rad;
    donutR = 0;
    textFont(createFont("Arial", height / 60 + 4, true));
  }
  
  //Make this the inner chart for party!  
  void setTotal() {
    for (TableRow row : table.rows()) {
      float funds = row.getFloat(selectedMonth);
        total += funds;  
      }
      if(total > 0) {
        zeroTotal = false;
      } else {
        zeroTotal = true; 
      }
   }
  
  void toggleState() {
   isPie = !isPie;
   if (donutR == 0) {
     donutR = .75 * bigR;
   } else {
     donutR = 0;
   }
  }
  
  //While drawing, will check if mouse over any of the slices (i.e. to be highlighted).
  //If mouse over a slice, add's ID of that slice's row to the list hiList. Returns hiList.
  //Clears hiList at beginning of function re setting it so that it is based only on current location of
  //mouse
  public ArrayList<Integer> drawChart() {
    hiList.clear();

    if (!isPie) {
      donutR = bigR * 0.75;
    }
    float start = 0;
    
    
    stroke(0);
    strokeWeight(1);   

    if( !zeroTotal ) {
      start = drawChunk(start, bigR, "Republican", repC);
      start = drawChunk(start, bigR, "Democrat", demC);
      start = drawChunk(start, bigR, "Other", othC);
      
     // fill(255);
     // ellipse(center.x, center.y, donutR, donutR);
    } else {
      drawChunk(0, bigR, "Republican", repC);
      drawChunk(0, bigR, "Democrat", demC);
      drawChunk(0, bigR, "Other", othC);
    } //<>//
    
    return hiList; 
  }
  
  //Draws single slice (probably didn't have to be own function)
  //Returns end angle.
  private float drawSlice(float start, float end, float rad) {
      arc(center.x, center.y,
      rad * 2,
      rad * 2,
      start, //<>//
      end, PIE);
      noFill();
      return end;
  }
  
  private color makeHighlightC(color c) {
    float red = red(c);
    float green = green(c);
    float blue = blue(c);
    float sclr = 1.5;
    return color(red*sclr, green*sclr, blue*sclr);
  }
  
  //Used so that we can draw each party a different color.
  //Returns the end angle of last slice in the chunk, (will be used as
  //start angle in next chunk)
  private float drawChunk(float start, float rad, String party, color c) {
    float end = 0;  
    for (TableRow row : table.matchRows(party, "Party")) {
      if(zeroTotal) {
        end = 2 * PI;
      } else {
        end = start + row.getFloat(selectedMonth) * 2 * PI / this.total;
      }
      
      if (highlight(start, end, rad)) {
        hiList.add(row.getInt("ID"));
      }
      
      // needs to check if highlighted in the master table
      if (masterTable.findRow(row.getString("Candidate"), "Candidate").getString("Highlight").equals("true")) {        
        //loadimage
       /* PImage img = loadImage(row.getString("Candidate") + ".jpg");
        image(img, center.x-20, center.y-20, img.width/5, img.height/5); */
        
        drawLabel(row.getString("Candidate"), row.getString(selectedMonth));
        fill(makeHighlightC(c));
      } else {
        fill(c); 
      }
      start = drawSlice(start, end, rad);
    }
    return end;
  }
  
  private color partyColor(String party) {
    if(party.equals("Republican")) {
      return repC; 
    } else if(party.equals("Democrat")) {
      return demC;
    } else if(party.equals("Other")) {
      return othC;
    } else {
      return -1; 
    }
  }
  
  int quadrant() {
    if(mouseX > center.x && mouseY < center.y) {
       return 4; 
    } else if(mouseX < center.x && mouseY < center.y) {
      return 3;
    } else if(mouseX < center.x && mouseY > center.y) {
      return 2;
    } else {
      return 1;
    }
  }
  
  boolean highlight(float start, float end, float rad) {
    float angle;
    
    float opposite = abs(mouseY - center.y);
    float hypotenuse = dist(mouseX, mouseY, center.x, center.y);
    angle = asin(opposite / hypotenuse);
    
    //if quad 1, angle doesnt need to change
    if(quadrant() == 2) {
       angle = PI - angle;
    } else if(quadrant() == 3) {
       angle = PI + angle;
    } else if(quadrant() == 4) {
       angle = 2*PI - angle;
    }
    
    return hypotenuse <= bigR &&
           hypotenuse >= donutR / 2 &&
           start < angle &&
           angle < end;
  }
  
  void drawLabel(String name, String value) {
    String label = name + ", " + value;
    
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect(center.x, center.y + bigR + 20, 400, 30);
    rectMode(CORNER);
    stroke(0);
    
    fill(0);
    textAlign(CENTER);
    text(label, center.x, center.y + bigR + 20);
  }

  
}