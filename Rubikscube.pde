import peasy.*;

PeasyCam cam;

int scrTurns = 20;
int benchmarkcount=200;
String turns = "";
int dim = 3;

scramble scramble = new scramble(scrTurns);
boolean scr = false;
Cubie[] cube = new Cubie[dim*dim*dim]; // array af cubies
boolean solve=false;
boolean printDebug=false;
Move currentMove;
int moveCounter;
int lastMoveCounter;
boolean scrambled=false;

String Solvers[] = { "Basic", "Optimized"};
String Modes[] = { "Single", "Continuous", "Benchmark" };

String Solver = Solvers[0];
String Mode = Modes[0];
String Stage = "Idle";
float Speeds[] = {0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,HALF_PI};
int speedindex=0;
float speed = Speeds[speedindex];

int benchmarksdone=0;
int [] benchmarks = new int[benchmarkcount];

int keeptrackof=5;
String [] TurnsTaken= new String[5];


// Koordinat system er lidt fubar. 
//  x-aksen er som plejer: -1 = venstre, 0 = midten, 1 = højre 
//  y-aksen er spejlet:    -1 = op     , 0 = midten, 1 = bund
//  z-aksen er som plejer: -1 = bag    , 0 = midten, 1 = front

// Piece locations (initial)
//   (-1,-1,-1) = cube[0]   = (left,  top,   back)    = corner
//   (-1,-1, 0) = cube[1]   = (left,  top,   middle)  = centeredge
//   (-1,-1, 1) = cube[2]   = (left,  top,   front)   = corner
//   (-1, 0,-1) = cube[3]   = (left,  middle,back)    = centeredge
//   (-1, 0, 0) = cube[4]   = (left,  middle,middle)  = left center
//   (-1, 0, 1) = cube[5]   = (left,  middle,front)   = centeredge
//   (-1, 1,-1) = cube[6]   = (left,  bottom,back)    = corner
//   (-1, 1, 0) = cube[7]   = (left,  bottom,middle)  = centeredge
//   (-1, 1, 1) = cube[8]   = (left,  bottom,front)   = corner
//   ( 0,-1,-1) = cube[9]   = (middle,top,   back)    = centeredge
//   ( 0,-1, 0) = cube[10]  = (middle,top,   middle)  = top center
//   ( 0,-1, 1) = cube[11]  = (middle,top    front)   = center edge
//   ( 0, 0,-1) = cube[12]  = (middle,middle,back)    = back center
//   ( 0, 0, 0) = cube[13]  = (middle,middle,middle)  = nonvisible center
//   ( 0, 0, 1) = cube[14]  = (middle,middle,front)   = front center
//   ( 0, 1,-1) = cube[15]  = (middle,bottom,back)    = center edge
//   ( 0, 1, 0) = cube[16]  = (middle,bottom,middle)  = bottom center
//   ( 0, 1, 1) = cube[17]  = (middle,bottom,front)   = center edge
//   ( 1,-1,-1) = cube[18]  = (right, top,   back)    = corner
//   ( 1,-1, 0) = cube[19]  = (right, top,   middle)  = center edge
//   ( 1,-1, 1) = cube[20]  = (right, top,   front)   = corner
//   ( 1, 0,-1) = cube[21]  = (right, middle,back)    = center edge
//   ( 1, 0, 0) = cube[22]  = (right, middle,middle)  = right center
//   ( 1, 0, 1) = cube[23]  = (right, middle,front)   = center edge
//   ( 1, 1,-1) = cube[24]  = (right, bottom,back)    = corner
//   ( 1, 1, 0) = cube[25]  = (right, bottom,middle)  = center edge
//   ( 1, 1, 1) = cube[26]  = (right, bottom,front)   = corner


// face[0] = back   = blue
// face[1] = front  = green
// face[2] = bottom = white
// face[3] = top    = yellow
// face[4] = right  = orange
// face[5] = left   = red


// array af alle tænkelige edgepositions
PVector[] edgeCenters= {new PVector(0, -1, -1), new PVector(1, -1, 0), new PVector(0, -1, 1), 
  new PVector(-1, -1, 0), new PVector(0, 1, -1), new PVector(-1, 1, 0), new PVector(0, 1, 1), new PVector(1, 1, 0), 
  new PVector(-1, 0, -1), new PVector(1, 0, -1), new PVector(-1, 0, 1), new PVector(1, 0, 1)};


color green = color(0, 255, 0,0);
color blue = color(0, 0, 255,0);
color red = color(255, 0, 0,0);
color white = color(255, 255, 255,0);
color yellow = color(255, 255, 0,0);
color orange =  color(255, 140, 0,0);

Move[] allMoves = new Move[]{
  new Move(1, 0, 0, -1, "R'"),
  new Move(1, 0, 0, 1, "R"),
  new Move(1, 0, 0, 2, "R2"), 

  new Move(-1, 0, 0, -1, "L"),
  new Move(-1, 0, 0, 1, "L'"),
  new Move(-1, 0, 0, 2, "L2"), 

  new Move(0, 1, 0, -1, "D"),
  new Move(0, 1, 0, 1, "D'"), 
  new Move(0, 1, 0, 2, "D2"), 

  new Move(0, -1, 0, -1, "U'"),
  new Move(0, -1, 0, 1, "U"), 
  new Move(0, -1, 0, 2, "U2"), 

  new Move(0, 0, 1, -1, "F'"), 
  new Move(0, 0, 1, 1, "F"), 
  new Move(0, 0, 1, 2, "F2"), 

  new Move(0, 0, -1, -1, "B"),
  new Move(0, 0, -1, 1, "B'"),
  new Move(0, 0, -1, 2, "B2"),
}; 
void cubeSetup(){
  scramble.generate();
  int index = 0;
  for (int x = -1; x <= 1; x++) { // koordinater til cubies
    for (int y = -1; y <= 1; y++) { // koordinater til cubies
      for (int z = -1; z <= 1; z++) { // koordinater til cubies
        PMatrix3D matrix = new PMatrix3D(); // matrix
        matrix.translate(x, y, z);
        cube[index] = new Cubie(matrix, x, y, z); // opret 27 cubies
        index++;
      }
    }
  }
}

void setup() {
  size(800, 600, P3D); // canvas med P3D
  cam = new PeasyCam(this, 400); // peasycam extension
  cubeSetup();
  resetCube();
  resetStats();
  for(int i=0;i<TurnsTaken.length; i++) {
   TurnsTaken[i]=""; 
   }

  
}

void resetCube() {
    moveCounter = 0;
    lastMoveCounter=0;
    stageNo = 0;
    turnsDone = 0;
    currentMove.angle = 0;
    cubeSetup();
  
  
    scr = false;
    scrambled=false;
}

void resetStats() {
    benchmarksdone=0;
    for(int i=0;i<TurnsTaken.length;i++) {
      TurnsTaken[i]="";
    }
    
    for(int i=0;i<benchmarks.length;i++) {
      benchmarks[i]=0;
    }
    solve=false;
    Stage="Idle";
}

void Solved() {
    println("Solved!");
    for(int i=1;i<TurnsTaken.length;i++) {
       TurnsTaken[i-1]=TurnsTaken[i];
    }
    TurnsTaken[TurnsTaken.length-1]="" + moveCounter;
    benchmarks[benchmarksdone]=moveCounter;
    benchmarksdone++;

    resetCube();

    if(Mode == "Continuous") {
      scr=true;
      scrambled=false;
    } else if(Mode == "Benchmark") {
   
      if(benchmarksdone < benchmarkcount) {
        scr=true;
        scrambled=false;        
      } else {
       saveBenchmark();
       resetCube();
       Mode = "Single";
       solve=false;
       speedindex=0;
      }
    } else if(Mode == "Single") {
       solve=false;
       resetCube();
    }
}

void draw() {
  speed = Speeds[speedindex];
  if (scr && solve) {
        Stage="Scrambling";
        scramble.doScramble();
  }

  background(51);
  fill(0);
  textSize(32);
  text(moveCounter, 100, 100);

  if(!scr && solve) {  
    executeMove();
  }
  
  scale(50);
  for (int i = 0; i < cube.length; i++) {
    push();
    if (abs(cube[i].z) > 0 && cube[i].z == currentMove.z) { 
      rotateZ(currentMove.angle);
    } else if (abs(cube[i].x) > 0 && cube[i].x == currentMove.x) {
      rotateX(currentMove.angle);
    } else if (abs(cube[i].y) > 0 && cube[i].y == currentMove.y) {
      rotateY(-currentMove.angle);
    }
    cube[i].show();
    pop();
  }

  
    //-----------Stopping peasy ------
  cam.beginHUD();
  fill(-1);
  text("Solver: " + Solver, 40, 40);
  text("Mode: " + Mode, 40,80);
  text("Stage: " + Stage, 40,120);
  
  text("Speed:" + speed, 520,40);
  if(Mode == "Benchmark") {
     text("Benchmark: " + benchmarksdone, 520,80); 
  }
  int ypos=200;
  for(int i = 0; i<TurnsTaken.length;i++) {
    text("" +TurnsTaken[i], 40,ypos);
    ypos+=40;
  }

  cam.endHUD();
  //--------------------------------


}

void saveBenchmark() {
 
   String[] lines = new String[benchmarkcount];
  for (int i = 0; i < benchmarkcount; i++) {
    lines[i] = i+","+benchmarks[i];
  }
  String filename="cube_benchmark_"+Solver + "_" + year()+month()+day()+"_"+hour()+minute()+second()+".csv";
  saveStrings(filename, lines);
}

void executeMove() {
  while (!currentMove.animate() && turns.length() != 0) {
    
    if(match(turns,"^R'") != null) { // R'
     turns = turns.substring(2, turns.length()); 
     currentMove = allMoves[0]; }
    else if (match(turns,"^R2") != null){ // R2
     turns = turns.substring(2, turns.length());
     currentMove = allMoves[2]; }
    else if (match(turns,"^R") != null){ // R
     turns = turns.substring(1, turns.length());
     currentMove = allMoves[1]; }

    else if(match(turns,"^L'") != null) { // L'
     turns = turns.substring(2, turns.length()); 
     currentMove = allMoves[4]; }
    else if (match(turns,"^L2") != null){ // L2
     turns = turns.substring(2, turns.length());
     currentMove = allMoves[5]; }
    else if (match(turns,"^L") != null){ // L
     turns = turns.substring(1, turns.length());
     currentMove = allMoves[3]; }

    else if(match(turns,"^D'") != null) { // D'
     turns = turns.substring(2, turns.length()); 
     currentMove = allMoves[7]; }
    else if (match(turns,"^D2") != null){ // D2
     turns = turns.substring(2, turns.length());
     currentMove = allMoves[8]; }
    else if (match(turns,"^D") != null){ // D
     turns = turns.substring(1, turns.length());
     currentMove = allMoves[6]; }

    else if(match(turns,"^U'") != null) { // U'
     turns = turns.substring(2, turns.length()); 
     currentMove = allMoves[9]; }
    else if (match(turns,"^U2") != null){ // U2
     turns = turns.substring(2, turns.length());
     currentMove = allMoves[11]; }
    else if (match(turns,"^U") != null){ // U
     turns = turns.substring(1, turns.length());
     currentMove = allMoves[10]; }

    else if(match(turns,"^F'") != null) { // F'
     turns = turns.substring(2, turns.length()); 
     currentMove = allMoves[12]; }
    else if (match(turns,"^F2") != null){ // F2
     turns = turns.substring(2, turns.length());
     currentMove = allMoves[14]; }
    else if (match(turns,"^F") != null){ // F
     turns = turns.substring(1, turns.length());
     currentMove = allMoves[13]; }

    else if(match(turns,"^B'") != null) { // B'
     turns = turns.substring(2, turns.length()); 
     currentMove = allMoves[16]; }
    else if (match(turns,"^B2") != null){ // B2
     turns = turns.substring(2, turns.length());
     currentMove = allMoves[17]; }
    else if (match(turns,"^B") != null){ // B
     turns = turns.substring(1, turns.length());
     currentMove = allMoves[15]; }

     currentMove.start_animating();
     moveCounter++;
  }
  if(turns.length() == 0 && solve && !currentMove.animating && currentMove.angle == 0) {
     continueSolve();
  }
}
