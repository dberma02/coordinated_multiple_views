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
   //  lines = loadStrings(file);
     table = loadTable(file, "header");
     table.addColumn("Highlight");
     
     for (TableRow row : table.rows()) {
       row.setString("Highlight", "false");
     }

    for (TableRow row : table.rows()) {
    
        String id = row.getString("Candidate");
        String species = row.getString("State");
        String name = row.getString("Party");
        String highlight = row.getString("Highlight");
    
  //  println(name + " (" + species + ") has an ID of " + id + " " + highlight);
    
  }
  
//  println("Candidate: " + table.getString(6, "Candidate"));
   }
   
   public Table getData() {
     return table;
  /*   candidates = new ArrayList<Candidate>();
     
     for (int i = 1; i < lines.length; i++) {
       String[] data = split(lines[i], ",");
       
       // create funds list
       ArrayList funds = new ArrayList();
       funds.add(float(data[5]));
       funds.add(float(data[6]));
       funds.add(float(data[7]));
       funds.add(float(data[8]));  
       funds.add(float(data[9]));       
       funds.add(float(data[10]));
       funds.add(float(data[11]));  
       funds.add(float(data[12]));   
       funds.add(float(data[13]));  
       
       Candidate c = new Candidate(data[0] + "," + data[1], data[2], data[3], funds);
       candidates.add(c);
     }

     return candidates; */
     
   }
   
   
 }