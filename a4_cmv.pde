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
  
   lineGraph = new LineGraph(0, 0, 500, 700, masterTable, currMonth);
   map = new Map (500, 0, 450,400, masterTable, false, null);
   pie = new Pie(masterTable, "Sep", .40*395, new PVector(720, 500), masterTable); 
   
 }
 
 
 void draw() {
   
   background(255);
   fill(255);
  
   highlight();
 }
 
 private void highlight() {
     
     newHighlights.clear();
     
     newHighlights.addAll(lineGraph.render());
     newHighlights.addAll(map.render());
     
     //pie = new Pie(currentTable, currMonth, .40*395, new PVector(720, 500));
     newHighlights.addAll(pie.drawChart());
     
     //now unhighlight old, highlight all new
     for(Integer i : highlights) {
       masterTable.setString(i,"Highlight", "false");
     }
     highlights.clear();
     for(Integer i : newHighlights) {
       masterTable.setString(i,"Highlight", "true");
     }
     highlights.addAll(newHighlights);
 }
 

 void mouseClicked() {
   String month = lineGraph.monthClicked();
   
   //changed back to "" bc .equals(null) throws null pointer exception
   if (!month.equals("")) {
     lineGraph.setMonth(month);
     currMonth = month;
     pie = new Pie(currentTable, currMonth, .40*395, new PVector(720, 500), masterTable); 
   }
   
   String state = map.stateClicked();
   if (state != null) { 
     if (state.equals("ALL")) {
       currState = null;
       currentTable = masterTable;
       map = new Map (500, 0, 450,400, masterTable, false, null);
       pie = new Pie(masterTable, currMonth, .40*395, new PVector(720, 500), masterTable);
       
     } else {
       Iterable<TableRow> newRows = masterTable.findRows(state, "State");
     
       boolean hasData = false;
       //checks whether there is a corresponding candidate(s)
       for (TableRow row : newRows) {
         hasData = true;
         break;
       }
       
       if (hasData) {
         Table newTable = new Table();
         newTable.addColumn("Candidate");
         newTable.addColumn("State");
         newTable.addColumn("Party");
         newTable.addColumn("Party 2");
         newTable.addColumn("Jan");
         newTable.addColumn("Feb");
         newTable.addColumn("Mar");       
         newTable.addColumn("Apr");
         newTable.addColumn("May");
         newTable.addColumn("Jun");
         newTable.addColumn("Jul");
         newTable.addColumn("Aug");
         newTable.addColumn("Sep"); 
         newTable.addColumn("Highlight");
         newTable.addColumn("ID");
         
         for (TableRow row : newRows) {
           newTable.addRow(row);
         }
         
         currState = state;
         currentTable = newTable;
         
         map = new Map (500, 0, 450,400, masterTable, true, state);
         pie = new Pie(currentTable, currMonth, .40*395, new PVector(720, 500), masterTable); 
       }
     }
   } 
 }