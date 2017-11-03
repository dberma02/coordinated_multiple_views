/*
 * Coordinated-Multiple Views (CMV) 
 * Dani Kupfer & Dan Berman
 * 10/31/17
 *
 * CMV for line chart, interactive map & multiple pie charts
 *
 */
 
 import java.util.ArrayList;
 
 Parser parser;
 Table masterTable;
 Table currentTable;
 ArrayList<Candidate> candidates;
 LineGraph lineGraph;
 Map map;
 Pie pie;
 ArrayList<Integer> highlights = new ArrayList<Integer>();
 ArrayList<Integer> newHighlights = new ArrayList<Integer>();
 
 String currMonth = "Sep";
 String currState = null;


 void setup() {
   size(950,700);
   pixelDensity(displayDensity());

   parser = new Parser("candidates.csv");
   masterTable = parser.getData();
   masterTable.addColumn("Highlight");
   masterTable.addColumn("ID");
   int ID = 0;
     for (TableRow row : masterTable.rows()) {
       row.setInt("ID", ID);
       row.setString("Highlight", "false");
       ID++;
     }
   currentTable = masterTable;
//   candidates = parser.getData();
   
   lineGraph = new LineGraph(10, 20, 525, 325, masterTable, currMonth);
   map = new Map (10, 360, 525,325, masterTable);
  //   rect(545,20, 395, 660);
   pie = new Pie(masterTable, "Sep", .45*395, new PVector(545 + .5*(395), (20 + (.45*395) + 20))); 
  
   
  /* for (Candidate c : candidates) {
     println(c.name + " " + c.state + " " + c.party + " " + c.funds);
   } */
   
 }
 
 
 void draw() {
   //draw line graph
   //draw map
   //draw pie charts
   
   fill(255);
   background(255);
 /*  rect(10,20, 525,325);
   rect(10, 360, 525,325);
   rect(545,20, 395, 660); */
   
   map.render();
  
  //figure out highlighting here
  //have a current highlight list
  //set all in the list to highlight
  //feed the list to the graphs
    //graphs will return new hightlight list--each one can be the last one appended to eachother
    //then at end, unhighlight old list, rehighlight new one
  
  highlight();

   
 }
 
 private void highlight() {
     newHighlights.clear();
     
    // lineGraph = new LineGraph(10, 20, 525, 325, currentTable, currMonth);
     newHighlights.addAll(lineGraph.render());
     
     pie = new Pie(currentTable, currMonth, .45*395, new PVector(545 + .5*(395), (60 + (.4*395))));
     newHighlights.addAll(pie.drawChart());
     
     
     //now unhighlight old, highlight all new
     for(Integer i : highlights) {
       currentTable.setString(i,"Highlight", "false");
     }
     highlights.clear();
     for(Integer i : newHighlights) {
       currentTable.setString(i,"Highlight", "true");
     }
     highlights.addAll(newHighlights);
     
 }
 
 void mouseClicked() {
   String month = lineGraph.monthClicked();
   if (!month.equals(null)) {
     lineGraph.setMonth(month);
     currMonth = month;
   }
   
   String state = map.stateClicked();
 }
 