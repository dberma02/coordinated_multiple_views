/*
 *
 *
 *
 */
 
 import java.util.Set;
 import java.util.HashSet;
 
 static int NUM_MONTHS = 9;
 static int START_MONTH_COL = 4;
 static String[] months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep" };
 
 class LineGraph {
  private float chartX, chartY;
  private float chartWidth, chartHeight;
  private float offset;
  private ArrayList<Candidate> candidates;
  private float chartBottom;
  private float pointDist;
  private Table table;
  private String selectedMonth;
  private int selectedMonthIndex;
  private color repC = color(200, 10, 3);
  private color demC = color(5, 100, 230);
  private color othC = color(144,75,191);
  ArrayList<Integer> hiList = new ArrayList<Integer>();
  Set<String> labelList = new HashSet<String>();

  private float maxValue = 0;
   
  public LineGraph(int xPos, int yPos, int canvasWidth, int canvasHeight, 
                   Table table, String currMonth) {
    
    offset = min(canvasWidth, canvasHeight) * 0.09;
    selectedMonth = currMonth;
    selectedMonthIndex = getMonthIndex(currMonth);

    
    chartX = xPos;
  //  topY = yPos + offset;
    chartY = yPos;

    chartWidth = canvasWidth - offset*2;
    chartHeight = canvasHeight - offset*2.5;
  //  this.candidates = candidates;
    this.table = table;
    
    pointDist = (chartWidth/NUM_MONTHS)/2;
    //println("chartWidth: ", chartWidth, "rowCount: ", table.getRowCount(),
    //        "pointDist: ", pointDist);
    chartBottom = yPos + chartHeight + offset;
    
    
    // set max value of data
    for (TableRow row : table.rows()) {
      float funds = row.getFloat("Sep");
      if (funds > maxValue) {
          maxValue = funds;
        }
    }
  }
 
  public int getMonthIndex(String month) {
      for (int i = 0; i < months.length; i++) {
        if (months[i] == month) {
          return i;
        }
      }
      return -1;
  }
  
  public ArrayList<Integer> render() {
    drawAxes();
    drawSeparators();
    drawLabels();
    return drawData();


  }
  
  public void setMonth(String month) {
    selectedMonth = month;
    selectedMonthIndex = getMonthIndex(month);
  }
  
  public Boolean onCanvas() {
    if(mouseX > chartX && mouseX < (chartX + chartWidth) &&
       mouseY > chartY && mouseY < (chartY + chartHeight)) {
         return true;
       } else {
         return false; 
       }
  }
  
  public String monthClicked() {
    float firstX = chartX + offset + pointDist*2; //<>//
    
      for (int i = 0; i < NUM_MONTHS; i++) {
        if (monthHighlighted(firstX + pointDist*2*i - pointDist*2, chartY + offset)) {
          println("numMonths: ", NUM_MONTHS, "months i:", months[i]);
          return months[i];
        }
      }
    
    return "";
    
  }
  
  private void drawAxes() {
    line(chartX + offset, chartBottom, chartX+offset+chartWidth, chartBottom);
    line(chartX + offset, chartY + offset, chartX + offset, chartBottom);
  }
  
  
  private void drawSeparators() {
    
    float firstX = chartX + offset + pointDist*2;
    
    for (int i = 0; i < NUM_MONTHS; i++) {
      stroke(200);
      line(firstX + pointDist*2*i, chartBottom, firstX + pointDist*2*i, chartY + offset);
      
      if (monthHighlighted(firstX + pointDist*2*i - pointDist*2, chartY + offset)) {
        //fill(170, 213, 250);
        fill(235);
        noStroke();
        rect(firstX + pointDist*2*i - pointDist*2, chartY + offset*.9, pointDist*2, chartHeight+offset/1.4);
      }
      
      if (selectedMonth == months[i]) {
        fill(170, 213, 250);
        noStroke();
        rect(firstX + pointDist*2*i - pointDist*2, chartY + offset*.9, pointDist*2, chartHeight+offset/1.4);
      } 
    }
       
    stroke(0);
    fill(0);
  }
  
  private boolean monthHighlighted(float topX, float topY) {
    if (mouseX > topX && mouseX < (topX + pointDist*2) && mouseY > topY && mouseY < (topY + chartHeight)) {
      return true;
    }
    
    return false;
  }
  
  private void drawLabels() {
    textSize(10);
    stroke(0);
    float labelY = chartBottom + offset/2;
    for (int i = 0; i < NUM_MONTHS; i++) {
      float labelX = chartX + offset + pointDist + pointDist*2*i;
      text(months[i], labelX, labelY);      
    }
    
    textSize(14);
    rotate(3*PI/2);
    text("Funding (dollars)", -325, 30);
    rotate(PI/2);
    
    textSize(8);
    line(chartX + offset*.9, offset, chartX + offset*1.1, offset);
    text(maxValue, chartX+ offset*.7, offset);
    
  }
  
  private boolean highlight(float x, float y, float r) {
    if(dist(x, y, mouseX, mouseY) < r) {
      return true;
    } else {
      return false; 
    }
  }
  
  // Returns true if candidate should be highlighted (currently hovered over).
  // Returns false otherwise.
  private boolean drawCandidate(TableRow row, float endMonthCol, color c) {
    boolean hlight = false;
    fill(c);
    stroke(c);
    int index = 0;
    for (int i = START_MONTH_COL; i < endMonthCol; i++) {
      float leftPointX = chartX + offset + pointDist*.5 + pointDist*2*index;
      float leftPointY = chartBottom - (row.getFloat(i) * chartHeight/maxValue);
      float rightPointX = chartX + offset + pointDist*.5 + pointDist*2*(index+1);
      float rightPointY = chartBottom - (row.getFloat(i+1) * chartHeight/maxValue); 

      line(leftPointX + pointDist/2, leftPointY, rightPointX + pointDist/2, rightPointY);
      //fill(220);
      ellipse(leftPointX + pointDist/2, leftPointY, 0.015*chartWidth, 0.015*chartWidth);
      ellipse(rightPointX + pointDist/2, rightPointY, 0.015*chartWidth, 0.015*chartWidth);
      if (highlight(leftPointX + pointDist/2, leftPointY, 0.015*chartWidth)) {
        labelList.add(row.getString("Candidate") + ", " + row.getString(i));
        hlight = true;
      }
        
      if (i == START_MONTH_COL + NUM_MONTHS-2) {
        ellipse(rightPointX + pointDist/2, rightPointY, 0.015*chartWidth, 0.015*chartWidth);
        if (highlight(rightPointX + pointDist/2, rightPointY, 0.015*chartWidth)) {  
          labelList.add(row.getString("Candidate") + ", " + row.getString(i));
          hlight = true;
        }
      }
      index++;
    }
    return hlight;

  }
  
  private color setColor(TableRow row) {
    String party = row.getString("Party");
    color lineColor = color(0);
  
    if (party.equals("Democrat")) {
      lineColor = demC;
    } else if (party.equals("Republican")) {
      lineColor = repC;
    } else if (party.equals("Other")) {
      lineColor = othC;
    }
    return lineColor;
  }
  
  boolean noneHighlighted() {
     for(TableRow row : table.findRows("true", "Highlight")) {
      return false; 
     }
     return true;
  }
  
  private ArrayList<Integer> drawData() {
    hiList.clear();
    labelList.clear();
    for (TableRow row : table.rows()) {
      color lineColor = setColor(row);
      
      if ( drawCandidate(row, START_MONTH_COL + NUM_MONTHS-1, lineColor) ) {
       hiList.add(row.getInt("ID"));
       drawCandidate(row, START_MONTH_COL + selectedMonthIndex, makeHighlightC(lineColor));
      }

      
    }
    //second for loop so highlighted lines are drawn on top of others 
    
    if(!noneHighlighted()) {
      for (TableRow row : table.findRows("true","Highlight")) {
        color lineColor = setColor(row);
        color highlightColor = makeHighlightC(lineColor);
        drawCandidate(row, START_MONTH_COL + selectedMonthIndex, highlightColor);
      }
     } else {
    
      for (TableRow row : table.findRows("true","Highlight")) {
        color lineColor = setColor(row);
        color highlightColor = makeHighlightC(lineColor);
        drawCandidate(row, START_MONTH_COL + selectedMonthIndex, highlightColor);
      }
     // for (TableRow row : table.findRows("false","Highlight")) {
     //   drawCandidate(row, START_MONTH_COL + NUM_MONTHS-1, color(235));
     //}
    }
    
    drawHover();
    
    return hiList;
  }
  
  private color makeHighlightC(color c) {
    float red = red(c);
    float green = green(c);
    float blue = blue(c);
    float sclr = 1.5;
    return color(red*sclr, green*sclr, blue*sclr);
  }
  
  private void drawHover() {
    if (labelList.size() != 0 ) {
      fill(255);
      stroke(0);
      int i = 0;
      rect(chartX+offset*4-90, chartY-10 + offset*2, 180, 5+10*labelList.size());
      fill(0);
      for (String label : labelList) {
        text(label, chartX+offset*4, chartY + offset*2 + i*10);
        i++;
      }
      stroke(0);
    }
  }
  
  
   
 }