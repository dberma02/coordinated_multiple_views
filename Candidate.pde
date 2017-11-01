/*
 * Candidate class
 *
 *
 */
 
 import java.util.ArrayList;
 
class Candidate {
  private String name;
  private String state;
  private String party;
  private ArrayList<Float> funds;
  
  
  public Candidate(String name, String state, String party, ArrayList funds) {
    this.name = name;
    this.state = state;
    this.party = party;
    this.funds = funds;
  }
  
}