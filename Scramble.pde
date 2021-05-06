class scramble{
  int scrTurns;  
  int counter = 0;
  ArrayList<Move> sequence = new ArrayList<Move>();
  
  scramble(int scrTurns){
   this.scrTurns = scrTurns;
   }
  
  String str="";
  void generate(){
    for (int i = 0; i < this.scrTurns; i++){
     int r = int(random(allMoves.length));
     Move m = allMoves[r];
     sequence.add(m);
     str += m.humanFriendlyNotation;
    }
    currentMove = sequence.get(counter);
   
 }
   
   void doScramble(){
     boolean status = currentMove.animate();
     if(!status){
      if(counter < sequence.size()-1){
        counter++;
        currentMove = sequence.get(counter);
        currentMove.start_animating();
      } else {
       scr=false;
       scrambled=true;
       Stage="Idle";
      }//171, 244, 232
     }
 }
}
