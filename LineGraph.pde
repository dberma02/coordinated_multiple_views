/*
 *
 *
 *
 */
 
 static int NUM_MONTHS = 9;
 static int START_MONTH_COL = 4;
 
 class LineGraph {
  private float chartX, chartY;
  private float chartWidth, chartHeight;
  private float offset;
  private ArrayList<Candidate> candidates;
  private float chartBottom;
  private float pointDist;
  private Table table;
  ArrayList<Integer> hiList = new ArrayList<Integer>();

  
  private float maxValue = 0;
   
  public LineGraph(int xPos, int yPos, int canvasWidth, int canvasHeight, 
                   Table table) {
    
    offset = min(canvasWidth, canvasHeight) * 0.09;

    
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
    return drawData();


  }
  
  private void drawAxes() {
    line(chartX + offset, chartBottom, chartX+offset+chartWidth, chartBottom);
    line(chartX + offset, chartY + offset, chartX + offset, chartBottom);
  }
  
  
  private void drawSeparators() {
    int numMonths = NUM_MONTHS;
    
    float firstX = chartX + offset + pointDist*2;
    
    for (int i = 0; i < numMonths; i++) {
      stroke(200);
      line(firstX + pointDist*2*i, chartBottom, firstX + pointDist*2*i, chartY + offset);
    }
    stroke(0);
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
      if ( drawCandidate(row, 0) ) {
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