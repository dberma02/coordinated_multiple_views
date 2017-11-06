/*
 *
 *
 *
 *
 */
 
 import java.util.ArrayList;
 
 class Map {
  color REPUB_COLOR = color(200, 10, 0);
  color DEM_COLOR = color(5, 100, 230);
  color OTHER_COLOR = color (144,75,191);
   
  private int chartX, chartY;
  private float chartWidth, chartHeight;
  private float offset;
  private Table table;
  private float sizeLength;
  ArrayList<Integer> hiList = new ArrayList<Integer>();
  boolean hasSelectedState;
  String selectedState = null;
  

  private String[] states = {"AK", "", "", "", "", "", "", "", "", "", "", "ME",
                             "",       "", "", "", "", "", "", "", "", "", "VT", "NH", 
                             "", "WA", "ID", "MT", "ND", "MN", "IL", "WI", "MI", "NY", "RI", "MA",
                             "", "OR", "NV", "WY", "SD", "IA", "IN", "OH", "PA", "NJ", "CT", "",
                             "", "CA", "UT", "CO", "NE", "MO", "KY", "WV.", "VA", "MD", "DE", "",
                             "",  "", "AZ", "NM", "KS", "AR", "TN", "NC", "SC", "DC", "", "",
                             "", "", "", "", "OK.", "LA", "MS", "AL", "GA", "", "", "",
                             "HI", "", "", "", "TX", "", "", "", "", "FL", "", ""};
                             
  private HashMap<String, String> statesStatus = new HashMap<String, String>();
  
  public Map(int xPos, int yPos, int canvasWidth, int canvasHeight, 
             Table table, boolean hasSelectedState, String selectedState) {
               
    offset = min(canvasWidth, canvasHeight) * 0.04;
    
    chartX = xPos;
    chartY = yPos;
    chartWidth = canvasWidth - offset*2;
    chartHeight = canvasHeight - offset*4;
    this.table = table;
    sizeLength = chartWidth/13;
    
    this.hasSelectedState = hasSelectedState;
    this.selectedState = selectedState;
    
    for (TableRow row : table.rows()) {
      String state = row.getString("State");
      String party = row.getString("Party");
      
      if (statesStatus.containsKey(state)) {
        String currParty = statesStatus.get(state);
        if (currParty != party) {
          statesStatus.put(state, currParty + ", " + party);
        }
      } else {
        statesStatus.put(state, party);
      }      
    }
  
    println(statesStatus);
  }
  
  public ArrayList<Integer> render() {
    hiList.clear();
    
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        if (states[i*12 + j] != "") {
          Iterable<TableRow> stateCands = table.matchRows(states[i*12+j], "State");
          
          boolean republican, democrat, other;
          republican = democrat = other = false;
          
          for (TableRow row : stateCands) {
            String party  = row.getString("Party");
            if (party.equals("Republican")) {
              republican = true;
            } else if (party.equals("Democrat")) {
              democrat = true;
            } else if (party.equals("Other")) {
              other = true;
            }
          }
          
          boolean splitState = false;
          color squareColor = color(220);
          color triangleColor = color(220);
          
          if (republican && democrat) {
            splitState = true;
            squareColor = REPUB_COLOR;
            triangleColor = DEM_COLOR;
            //draw red square and blue triangle
          } else if (democrat && other) {
            splitState = true;
            squareColor = DEM_COLOR;
            triangleColor = OTHER_COLOR;
            // draw blue square and green triangle
          } else if (republican) {
            squareColor = REPUB_COLOR;
            //red square
          } else if (democrat) {
            squareColor = DEM_COLOR;
            //blue square
          } else if (other) {
            squareColor = OTHER_COLOR;
            // green square
          } 
          
          if (isHighlighted(chartX + offset*1.5 + sizeLength*j, chartY + offset + sizeLength*i) && squareColor != color(220)) {
            squareColor = makeHighlightC(squareColor);
            triangleColor = makeHighlightC(triangleColor);
            
            for (TableRow row : stateCands) {
              hiList.add(row.getInt("ID"));
            }
            
          }
          
          if (hasSelectedState) { 
            if (selectedState == states[i*12 + j]) {
              squareColor = makeHighlightC(squareColor);
              triangleColor = makeHighlightC(triangleColor);
            } else if (squareColor != color(220)) {
              squareColor = darkenC(squareColor);
              triangleColor = darkenC(triangleColor);
            }
            
          }
            
          stroke(0);
          fill(squareColor);
          rect(chartX + offset*1.5 + sizeLength*j, chartY + offset + sizeLength*i, sizeLength-3, sizeLength-3);
          fill(0);
          
          if (splitState) {
            fill(triangleColor);
            triangle(chartX + offset*1.5 + sizeLength*j, chartY + offset + sizeLength*i, 
                     chartX + offset*1.5 + sizeLength*j, chartY + offset + sizeLength*i + sizeLength-3,
                     chartX + offset*1.5 + sizeLength*j + sizeLength-3, chartY + offset + sizeLength*i + sizeLength-3);
          }
          
          fill(0);
          textAlign(CENTER);
          textSize(10);
          text(states[i*12 + j], chartX + offset*1.5 + sizeLength*j + sizeLength/2-2, chartY + sizeLength/2+2 +  offset + sizeLength*i);
        }
        
      }
    }
    
    return hiList;
  }
  
  public String stateClicked() {
    if (mouseButton == RIGHT) {
      return "ALL";
    }
    
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        if (isHighlighted(chartX + offset*1.5 + sizeLength*j, chartY + offset + sizeLength*i)) {
          return states[i*12 + j];
        }
      }
    }
    
    return null;
    
  }
  
  public boolean isHighlighted(float leftX, float leftY) {
    if (mouseX > leftX && mouseX < leftX + sizeLength-3 && mouseY > leftY && mouseY < leftY + sizeLength-3) {
      return true;
    }
    return false;
    
  }
  
  private color makeHighlightC(color c) {
    float red = red(c);
    float green = green(c);
    float blue = blue(c);
    float sclr = 1.5;
    return color(red*sclr, green*sclr, blue*sclr);
  }
  
  private color darkenC(color c) {
    float red = red(c);
    float green = green(c);
    float blue = blue(c);
    float sclr = 1.2;
    return color(red/sclr, green/sclr, blue/sclr);
  }
   
 }