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
 ArrayList<Candidate> candidates;
 LineGraph lineGraph;
 Map map;
 
 void setup() {
   size(950,700);
   parser = new Parser("candidates.csv");
   masterTable = parser.getData();
//   candidates = parser.getData();
   
   lineGraph = new LineGraph(10, 20, 525, 325, masterTable);
  // map = new Map (10, 360, 525,325, masterTable);
   
  /* for (Candidate c : candidates) {
     println(c.name + " " + c.state + " " + c.party + " " + c.funds);
   } */
   
 }
 
 
 void draw() {
   //draw line graph
   //draw map
   //draw pie charts
   
   fill(255);
   rect(10,20, 525,325);
   rect(10, 360, 525,325);
   rect(545,20, 395, 660);
   
   lineGraph.render();
  // map.render();
   
 }
 
 