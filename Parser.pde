/*
 *
 *
 *
 */
 
 
 class Parser {
 
   ArrayList<Candidate> candidates;
   String[] lines;
   
   Table table;
   
   public Parser(String file) {
     table = loadTable(file, "header");
   }
   
   public Table getData() {
     return table;
   }
   
   
 }