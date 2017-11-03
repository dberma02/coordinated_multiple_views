/*
 *
 *
 *
 */
 
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
  ArrayList<Integer> hiList = new ArrayList<Integer>();

  
  private float maxValue = 0;
   
  public LineGraph(int xPos, int yPos, int canvasWidth, int canvasHeight, 
                   Table table) {
    
    offset = min(canvasWidth, canvasHeight) * 0.09;
    selectedMonth = "Sep";
    
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
 
  
  public ArrayList<Integer> render() {
    drawAxes();
    drawSeparators();
    drawLabels();
    return drawData();


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
    stroke(0);
    float labelY = chartBottom + offset/2;
    for (int i = 0; i < NUM_MONTHS; i++) {
      float labelX = chartX + offset + pointDist + pointDist*2*i;
      text(months[i], labelX, labelY);      
    }
    
  }
  
  private boolean highlight(float x, float y, float r) {
    if(dist(x, y, mouseX, mouseY) < r) {
      return true;
    } else {
      return false; 
    }
  }
  
  private boolean drawCandidate(TableRow row, color c) {
    boolean hlight = false;
    fill(c);
    stroke(c);
    int index = 0;
    for (int i = START_MONTH_COL; i < START_MONTH_COL + NUM_MONTHS-1; i++) {
      float leftPointX = chartX + offset + pointDist*.5 + pointDist*2*index;
      float leftPointY = chartBottom - (row.getFloat(i) * chartHeight/maxValue);
      float rightPointX = chartX + offset + pointDist*.5 + pointDist*2*(index+1);
      float rightPointY = chartBottom - (row.getFloat(i+1) * chartHeight/maxValue); 

      line(leftPointX + pointDist/2, leftPointY, rightPointX + pointDist/2, rightPointY);
      //fill(220);
      ellipse(leftPointX + pointDist/2, leftPointY, 0.015*chartWidth, 0.015*chartWidth);
      if (highlight(leftPointX + pointDist/2, leftPointY, 0.015*chartWidth)) {
        hlight = true;
      }
        
      if (i == START_MONTH_COL + NUM_MONTHS-2) {
        ellipse(rightPointX + pointDist/2, rightPointY, 0.015*chartWidth, 0.015*chartWidth);
        if (highlight(leftPointX + pointDist/2, leftPointY, 0.015*chartWidth)) {            
          hlight = true;
        }
      }
      index++;
    }
    return hlight;

  }
  
  
  private ArrayList<Integer> drawData() {
    hiList.clear();
    for (TableRow row : table.rows()) {
      if ( drawCandidate(row, 195) ) {
       hiList.add(row.getInt("ID"));
       drawCandidate(row, #ff0000);
      }

      //highlight_row(row)
      //return ArrayList with rowID
    }
    //second for loop so highlighted lines are drawn on top of others 
    for (TableRow row : table.matchRows("true","Highlight")) {
       drawCandidate(row, #ff0000);
    }
    return hiList;
  }
  
  
   
 }