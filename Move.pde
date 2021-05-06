class Move {
  float angle = 0;
  int x = 0;
  int y = 0;
  int z = 0;
  int dir;
  String humanFriendlyNotation;
  boolean simpleMove = true;
  volatile boolean animating = false;
    
  Move(int x, int y, int z, int dir, String humanFriendlyNotation){
   
     this.x = x;
     this.y = y;
     this.z = z;
     this.dir = dir;
     this.humanFriendlyNotation = humanFriendlyNotation;
    
  }
  void start_animating(){
   animating = true; 
   this.angle = 0;
  }
  
  
  boolean animate(){
   if(animating)
   {
     
     angle += dir * speed;
     if(abs(angle) >= HALF_PI*abs(dir)){
      if(abs(z) > 0){
        turnZ(z,dir);
      } else if (abs(x) > 0) {
        turnX(x,dir);
      } else if (abs(y) > 0) {
        turnY(y,dir);
      }
      
      angle = 0;
      animating = false;
     }
   }
    return animating;
  }
}
