/*
 *
 *
 *
 *
 */
 
 
 class Map {
   
  private int chartX, chartY;
  private float chartWidth, chartHeight;
  private float offset;

  private ArrayList<Candidate> candidates;

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
             Table table) {
               
    offset = min(canvasWidth, canvasHeight) * 0.04;
    
    chartX = xPos;
    chartY = yPos;
    chartWidth = canvasWidth - offset*2;
    chartHeight = canvasHeight - offset*4;
    this.candidates = candidates;
    
    for (Candidate c : candidates) {
      String state = c.state;
      String party = c.party;
      
      if (statesStatus.containsKey(state)) {
        String currParty = statesStatus.get(state);
        if (currParty != party) {
          statesStatus.put(state, "Multiple");
        }
      } else {
        statesStatus.put(state, party);
      }
    }
    
    println(statesStatus);
  }
  
  public void render() {
    float sizeLength = chartWidth/13;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 12; j++) {
        if (states[i*12 + j] != "") {
          fill(220);
          if (statesStatus.containsKey(states[i*12+j])) {
            String stateParty = statesStatus.get(states[i*12+j]);
            
            if (stateParty.equals("Republican")) {
               fill(200, 10, 0);
            } else if (stateParty.equals("Democrat")) {
              fill(0,191,255);
            } else if (stateParty.equals("Other")) {
              fill(60,179,113);
            } else {
              fill(123,104,238);
            }
          }
            
          rect(chartX + offset*1.5 + sizeLength*j, chartY + + offset + sizeLength*i, sizeLength-3, sizeLength-3);
          fill(0);
          textAlign(CENTER);
          textSize(10);
          text(states[i*12 + j], chartX + offset*1.5 + sizeLength*j + sizeLength/2-2, chartY + sizeLength/2+2 +  offset + sizeLength*i);
        }
        
      }
      
      
      
    }
    
  }
   
   
   
 }