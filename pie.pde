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
  color othC = color(60, 179, 113);
  
  Pie(Table table, String endMonth, float rad, PVector center) {

    this.endMonth = endMonth;
    this.table = table;
    this.bigR = rad;
    this.smallR = rad * .5;
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
  
  //pie displays data for whatever month / state is selected --> should just draw all rows in table!
  void drawChart() {
  //commented out below b/c not resizable  
  //  r = min(width, height) * 0.4;
  //  center = new PVector(width / 2, height / 2);

    if (!isPie) {
      donutR = bigR * 0.75;
    }
    float dStart = 0;
    float dEnd;
    float rStart = 0;
    float rEnd;
    float oStart = 0;
    float oEnd;
    float start = 0;
    float end;
    
    
    stroke(0);
    strokeWeight(1);   
    rStart = start;
    start = drawChunk(start, bigR, "Republican", repC);
    rEnd = start;
    dStart = start;
    start = drawChunk(start, bigR, "Democrat", demC);
    dEnd = start;
    oStart = start;
    start = drawChunk(start, bigR, "Other", othC);
    oEnd = start;

    //drawSlice(rStart, rEnd, smallR);

    //smallPie //<>// //<>//
  }
  
  //make function to draw slice, (basically just calls arc???)
  private float drawSlice(float start, float end, float rad) {
      arc(center.x, center.y,
      rad * 2,
      rad * 2,
      start,
      end, PIE);
      noFill();
      return end;
  }
  
  //returns end angle
  private float drawChunk(float start, float rad, String party, color c) {
    float end = 0;
    
    for (TableRow row : table.matchRows(party, "Party")) {
      end = start + row.getFloat(endMonth) * 2 * PI / this.total;
      if (highlight(start, end, rad)) {
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