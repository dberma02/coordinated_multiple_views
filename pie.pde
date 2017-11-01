color blue = color(0, 150, 200);
color lightBlue = color(0, 200, 255);

public class Pie {
  Table table;
  String names[];
  int values[];
  int total = 0;
  boolean isPie;
  float bigR;
  PVector center;
  float donutR;
  String endMonth;
  
  Pie(Table table, String endMonth, float rad, PVector center) {
//    this.names = names;
//    this.values = values;
    this.endMonth = endMonth;
    this.table = table;
    this.bigR = rad;
    this.center = center;
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

    if (!isPie) { //<>//
      donutR = bigR * 0.75;
    }
    float start = 0;
    float end;
    stroke(0);
    strokeWeight(1);      
    for (TableRow row : table.rows()) {
      end = start + row.getFloat(endMonth) * 2 * PI / this.total;
      if (highlight(start, end, bigR)) {
 //       println(row.getString("Candidate"));
        drawLabel(row.getString("Candidate"), row.getString(endMonth));
        fill(lightBlue);
      } else {
        fill(blue);
      }
      arc(center.x, center.y,
      bigR * 2,
      bigR * 2,
      start,
      end, PIE);
      start = end;
    }
    //could recurse here and draw center pie in middle???

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