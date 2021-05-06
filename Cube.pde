class Cubie{
 PMatrix3D matrix;
 int x = 0;
 int y = 0;
 int z = 0;
 Face[] faces = new Face[6];
 
 Cubie(PMatrix3D m, int x, int y, int z){
  matrix = m;
  this.x = x;
  this.y = y;
  this.z = z;
  
  if(x==-1) {
    faces[5] = new Face(new PVector(-1,0,0), color(255,0,0)); } // red 
  else {
    faces[5] = new Face(new PVector(-1,0,0), color(0,0,0)); } // black
    
  if(x==1) {
    faces[4] = new Face(new PVector(1,0,0), color(255,140,00)); // orange
    
  }else {
    faces[4] = new Face(new PVector(1,0,0), color(0,0,0)); } // black 
  
  if(y==-1) { 
    faces[3] = new Face(new PVector(0,-1,0), color(255,255,0)); // yellow
  }else {
    faces[3] = new Face(new PVector(0,-1,0), color(0,0,0)); // black
  } 
  if(y==1) {
    faces[2] = new Face(new PVector(0,1,0), color(255,255,255)); // white
  } else {
    faces[2] = new Face(new PVector(0,1,0), color(0,0,0)); // black
  }
  
  if(z==-1) {
    
    faces[0] = new Face(new PVector(0,0,-1), color(0,0,255)); // blue
  }
else {
    faces[0] = new Face(new PVector(0,0,-1), color(0,0,0)); // black
    
}
  if(z==1) {
    faces[1] = new Face(new PVector(0,0,1), color(0,255,0)); // green
  }
  else {
    faces[1] = new Face(new PVector(0,0,1), color(0,0,0)); // black
  }
 }
 
   void turnZ(int dir){
  for (Face f : faces){
  f.turnZ(dir*HALF_PI);
  }
 }
 
  void turnX(int dir){
  for (Face f : faces){
  f.turnX(dir*HALF_PI);
  }
 }
 
  void turnY(int dir){
  for (Face f : faces){
  f.turnY(dir*HALF_PI);
  }
 }
 
 void update(int x, int y, int z){
  matrix.reset();
  matrix.translate(x,y,z);
  this.x = x;
  this.y = y;
  this.z = z;  
 
 }

 PVector pos() { // return pvector from coordinates
   return new PVector(x,y,z);
 }
 
 void show(){
  
   //fill(255);
   noFill();
   stroke(0);
   strokeWeight(0.1);
   pushMatrix();
   applyMatrix(matrix);
   box(1);
    for (Face f : faces){
      if(f != null) 
       f.show();
 }
   popMatrix();
   
 }
 
 boolean matchesColors(color[] cols) {

    for (int i = 0; i< cols.length; i++) {
      boolean foundMatch = false;
      for (int j = 0; j < faces.length; j++) {
        if ((faces[j].c & 0x00FFFFFF) == (cols[i] & 0x00FFFFFF)) {
          foundMatch = true;
          break;
        }
      }
      if (!foundMatch) {
        return false;
      }
    }


    return true;
  }
  
  char getFace(color col) { // find face with color col
    for (int j = 0; j < faces.length; j++) {
      if ((faces[j].c & 0x00FFFFFF)== (col & 0x00FFFFFF)) {
        return pVectorToFace(faces[j].normal); // returns
      }
    }
    return  ' ';
  }
  
  color getFaceColor(char direction) { // find color of part of piece that faces "direction"
    
    PVector lookfornormalvector = new PVector(0,0,0);
    color c=color(0,0,0);
    switch(direction) {
      case 'L':  
        lookfornormalvector=new PVector(-1,0,0);
        break;
      case 'R':
        lookfornormalvector=new PVector(1,0,0);
        break;
      case 'U':
        lookfornormalvector=new PVector(0,-1,0);
        break;
      case 'D':
        lookfornormalvector=new PVector(0,1,0);
        break;
      case 'B':
        lookfornormalvector=new PVector(0,0,-1);
        break;
      case 'F':
        lookfornormalvector=new PVector(0,0,1);
        break;
    }
    
    for(int i=0;i<faces.length;i++) {
      if(pvectorsEqual(lookfornormalvector,faces[i].normal)) {
        return faces[i].c; 
      }
    }
    return c;
    
  }
}
