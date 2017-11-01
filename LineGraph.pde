/*
 *
 *
 *
 */
 
 static int NUM_MONTHS = 9;
 static int START_MONTH_COL = 4;
 
 class LineGraph {
  private int chartX, chartY;
  private float chartWidth, chartHeight;
  private float offset;
  private ArrayList<Candidate> candidates;
  private float chartBottom;
  private float pointDist;
  private Table table;
  
  private float maxValue = 0;
   
  public LineGraph(int xPos, int yPos, int canvasWidth, int canvasHeight, 
                   Table table) {
    
    offset = min(canvasWidth, canvasHeight) * 0.09;

    
    chartX = xPos;
    chartY = yPos;
    chartWidth = canvasWidth - offset*2;
    chartHeight = canvasHeight - offset*2.5;
  //  this.candidates = candidates;
    this.table = table;
    
    pointDist = chartWidth/(table.getRowCount()*2+1);    
    chartBottom = yPos + chartHeight + offset;
    
    // set max value of data
    for (TableRow row : table.rows()) {
      float funds = row.getFloat("Sep");
      if (funds > maxValue) {
          maxValue = funds;
        }
    }
  }
 
  
  public void render() {
    drawAxes();
    drawSeparators();
    drawData();

  }
  
  private void drawAxes() {
    line(chartX + offset, chartBottom, chartX+offset+chartWidth, chartBottom);
    line(chartX + offset, chartY + offset, chartX + offset, chartBottom);
  }
  
  
  private void drawSeparators() {
    int numMonths = NUM_MONTHS;
    
    println(chartWidth);
    println(pointDist);
    float firstX = chartX + offset + pointDist*2;
    
    for (int i = 0; i < numMonths; i++) {
      stroke(200);
      line(firstX + pointDist*2*i, chartBottom, firstX + pointDist*2*i, chartY + offset);
    }
    stroke(0);
  }
  
  private void drawData() {
    
    for (TableRow row : table.rows()) {
      int index = 0;
      for (int i = START_MONTH_COL; i < START_MONTH_COL + NUM_MONTHS-1; i++) {
        float leftPointX = chartX + offset + pointDist*.5 + pointDist*2*index;
        float leftPointY = chartBottom - (row.getFloat(i) * chartHeight/maxValue);
        
        float rightPointX = chartX + offset + pointDist*.5 + pointDist*2*(index+1);
        float rightPointY = chartBottom - (row.getFloat(i+1) * chartHeight/maxValue); 

        line(leftPointX + pointDist/2, leftPointY, rightPointX + pointDist/2, rightPointY);
        
        ellipse(leftPointX + pointDist/2, leftPointY, 0.015*chartWidth, 0.015*chartWidth);
        if (i == START_MONTH_COL + NUM_MONTHS-2) {
          ellipse(rightPointX + pointDist/2, rightPointY, 0.015*chartWidth, 0.015*chartWidth);
        }
        index++;
      }
    }
    

  }
  
  
   
 }