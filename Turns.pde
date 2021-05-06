void turnZ(int index, int dir){ // drej Z akse funktion
  for(int i = 0; i < cube.length; i++){ // tjek alle cubies
    Cubie qb = cube[i];
      if (qb.z == index){ // hvis z koordinater = index (cubie findes i det ønskede lag)
    PMatrix2D matrix = new PMatrix2D(); // opret matrix
    matrix.rotate(HALF_PI*dir); // roter 90 grader i ønskede direction
    matrix.translate(qb.x, qb.y); // translate koordinater
    qb.update(round(matrix.m02),round(matrix.m12),qb.z); // update koordinater
    qb.turnZ(dir);   // update faces
      }
    }
  }
  void turnX(int index,int dir){
  for(int i = 0; i < cube.length; i++){
    Cubie qb = cube[i];
      if (qb.x == index){
    PMatrix2D matrix = new PMatrix2D();
    matrix.rotate(HALF_PI*dir);
    matrix.translate(qb.y, qb.z);
    qb.update(qb.x,round(matrix.m02),round(matrix.m12));
    qb.turnX(dir);  
     }
    }
  }
  void turnY(int index, int dir){
  for(int i = 0; i < cube.length; i++){
    Cubie qb = cube[i];
      if (qb.y == index){
    PMatrix2D matrix = new PMatrix2D();
    matrix.rotate(HALF_PI*dir);
    matrix.translate(qb.x, qb.z);
    qb.update(round(matrix.m02),qb.y,round(matrix.m12));
    qb.turnY(dir);  
     }
    }
  }
