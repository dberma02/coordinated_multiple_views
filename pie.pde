color blue = color(0, 150, 200);
color lightBlue = color(0, 0, 0);
//color lightBlue = color(0, 100, 255);

public class Pie {
  Table table;
  int total = 0;
  boolean isPie;
  float bigR;
  float smallR;
  PVector center;
  float donutR;
  String endMonth;
  color repC = color(200, 10, 3);
  color demC = color(5, 100, 230);
  color othC = color(144, 75, 191);
  ArrayList<Integer> hiList = new ArrayList<Integer>();
  
  Pie(Table table, String endMonth, float rad, PVector center) {

    this.endMonth = endMonth;
    this.table = table;
    this.bigR = rad;
    this.smallR = rad * .7;
    this.center = center;
  //  this.bigAngles = setAngles();
    setTotal();
    isPie = true;
     //r = min(width, height) * 0.4;
     bigR = rad;
    donutR = 0;
    textFont(createFont("Arial", height / 60 + 4, true));
  }
  
  //Make this the inner chart for party!  
  void setTotal() {
    for (TableRow row : table.rows()) {
      float funds = row.getFloat(endMonth);
        total += funds;  
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
    start = drawChunk(start, bigR, "Republican", repC);
    start = drawChunk(start, bigR, "Democrat", demC);
    start = drawChunk(start, bigR, "Other", othC);
    
//    fill(225);
//    ellipse(center.x, center.y, smallR, smallR);
    return hiList; 
  }
  
  //Draws single slice (probably didn't have to be own function)
  //Returns end angle.
  private float drawSlice(float start, float end, float rad) {
      arc(center.x, center.y,
      rad * 2,
      rad * 2,
      start,
      end, PIE);
      noFill(); //<>//
      return end;
  } //<>//
  
  //Used so that we can draw each party a different color.
  //Returns the end angle of last slice in the chunk, (will be used as
  //start angle in next chunk)
  private float drawChunk(float start, float rad, String party, color c) {
    float end = 0;    
    for (TableRow row : table.matchRows(party, "Party")) {
      end = start + row.getFloat(endMonth) * 2 * PI / this.total;
      if (highlight(start, end, rad)) {
        hiList.add(row.getInt("ID"));
      }
      
      if (row.getString("Highlight").equals("true")) {
        drawLabel(row.getString("Candidate"), row.getString(endMonth));
        float red = red(c);
        float green = green(c);
        float blue = blue(c);
        float sclr = 1.5;
        fill(red*sclr, green*sclr, blue*sclr);
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
    fill(0);
    textAlign(CENTER);
    text(label, center.x, center.y + bigR + 20);
  }
  
}