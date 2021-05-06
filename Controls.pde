void keyPressed(){
  switch (key)
  {
    case '1': // R'
    addMoves("R'"); break;
    case '2': // R
    addMoves("R"); break;
    case '3': // R2
    addMoves("R2"); break;
    
    case '4': // L
    addMoves("L"); break;
    case '5': // L'
    addMoves("L'"); break;
    case '6': // L2
    addMoves("L2"); break;
    
    case '7': // D
    addMoves("D"); break;
    case '8': // D'
    addMoves("D'"); break;
    case '9': // D2
    addMoves("D2"); break;
    
    case 'q': // U'
    addMoves("U'"); break;
    case 'w': // U
    addMoves("U"); break;
    case 'e': // U2
    addMoves("U2"); break;
    
    case 't': // F'
    addMoves("F'"); break;
    case 'y': // F
    addMoves("F"); break;
    case 'u': // F2
    addMoves("F2"); break;
    
    case 'i': // B
    addMoves("B"); break;
    case 'o': // B'
    addMoves("B'"); break;
    case 'p': // B2
    addMoves("B2"); break;

    case '+': 
       if(speedindex < Speeds.length-1) {
          speedindex++;
       }
       break;

    case '-': 
       if(speedindex >0) {
          speedindex--;
       }
       break;

    case 'm': // mode
       int currentIndex=getIndex(Modes,Mode);
       int nextIndex=((currentIndex+1)%(Modes.length));
       Mode=Modes[nextIndex];
       
       // Default speed per mode
       if(Mode == "Benchmark") {
         speedindex=Speeds.length-1; 
       } else {
         speedindex=0; 
       }
       scr=true;
       
       break;
    case 's': // solver
       int currentIndex2=getIndex(Solvers,Solver);
       int nextIndex2=((currentIndex2+1)%(Solvers.length));
       Solver=Solvers[nextIndex2];
       break;

    case 'x': // scramble
      scr = true;
      break;
    case 'r': // reset cube
      resetCube();
      resetStats();

      break;

    case 'z': // zolve
       solve=!solve;
       break;
    
    }
  }
  void addMoves(String moves){
    turns += moves;
  }
  
  int getIndex(String[] list, String item) {
      for(int i=0;i<list.length;i++) {
          if(list[i]==item) {
              return i; 
          }
     }
     return -1;
  }
