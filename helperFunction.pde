// make turns to go from fromIndex to toIndex using turnCharacter
String foundRotation(int fromIndex, int toIndex, char turnCharacter) {
  String returnString ="";
  if (abs(fromIndex - toIndex) ==2) {
    if(Mode == "Optimized") {
      return "" + turnCharacter + "2";
    } else {
      return "" + turnCharacter + turnCharacter;
    }
  }
  if (fromIndex<=toIndex) {
    for (int i = fromIndex; i< toIndex; i++) { 
      returnString += turnCharacter;
    }
  } else {
    for (int i = toIndex; i< fromIndex; i++) { 
      returnString += turnCharacter + "\'";
    }
  }
  return returnString;
}
// debug 
void printpiececolor(Cubie c) {
  print("(");
   for(int i=0; i < 6; i++) {
     print(colToName(c.faces[i].c) + ","); 
   }
   print(")");
}

int pVectorToIndex(PVector P){
  return((((int)P.x)+1)*9+(((int)P.y)+1)*3+(((int)P.z)+1));
}

char pVectorToFace(PVector p) {
  // assumption p is always orthorgonal with an axis
  char c=' ';
  if(p.x ==-1)
    c='L';
  if(p.x ==1)
    c='R';
  if(p.y ==-1)
    c='U';
  if(p.y ==1)
    c='D';
  if(p.z ==-1)
    c='B';
  if(p.z ==1)
    c='F';
  return c;
}

void printDebug(String str) {
  if(printDebug) {
    print(str);  
  }
}

void printDebugln(String str) {
  if(printDebug) {
    println(str);  
  }
}


PVector[] edgeRotationU = {new PVector(0, -1, -1), new PVector(1, -1, 0), new PVector(0, -1, 1), new PVector(-1, -1, 0)};
PVector[] edgeRotationD = {new PVector(0, 1, -1), new PVector(-1, 1, 0), new PVector(0, 1, 1), new PVector(1, 1, 0)};


String getDirectionsEdges(PVector from, PVector to) {

  int fromIndex = getIndex(edgeRotationU, from);
  int toIndex = getIndex(edgeRotationU, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'U');
  }

  fromIndex = getIndex(edgeRotationD, from);
  toIndex = getIndex(cornerRotationD, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'D');
  }

  return "";
}
  

PVector[] cornerRotationU = {new PVector(-1, -1, -1), new PVector(1, -1, -1), new PVector(1, -1, 1), new PVector(-1, -1, 1)};
PVector[] cornerRotationD = {new PVector(-1, 1, -1), new PVector(-1, 1, 1), new PVector(1, 1, 1), new PVector(1, 1, -1)};


String getDirectionsCorners(PVector from, PVector to) {
  // get turns to rotate from into to position in upper layer
  int fromIndex = getIndex(cornerRotationU, from);
  int toIndex = getIndex(cornerRotationU, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'U');
  }

  // get turns to rotate from into to position in bottom layer
  fromIndex = getIndex(cornerRotationD, from);
  toIndex = getIndex(cornerRotationD, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'D');
  }

  return "";
}


int getIndex(PVector[] arr, PVector c) {
  for (int i = 0; i< arr.length; i++) { 
    if (pvectorsEqual(arr[i], c)) {
      return i;
    }
  }
  return -1;
}
boolean pvectorsEqual(PVector p1, PVector p2) {
  return(p1.x ==p2.x && p1.y == p2.y &&  p1.z == p2.z);
}

//converts into reverse e.g. RULR' becomes RL'U'R'
String reverseDirections(String original) {
  String reverse = "";
  for (int i = 0; i< original.length(); i++) {
    if (i+1< original.length() && original.charAt(i+1) == '\'') {
      reverse = original.charAt(i) + reverse;
      i+=1;
    } else {
      reverse = original.charAt(i) + "'" + reverse;
    }
  }

  return reverse;
}

String colToName(color col) {
  String colName="undefined";
    switch(hex(col & 0x00FFFFFF)) 
    {
       case "00FF0000": 
          colName="red"; 
          break;
       case "00FFFFFF": 
          colName="white"; 
          break;
       case "00FF8C00": 
          colName="orange"; 
          break;
       case "0000FF00": 
          colName="green"; 
          break;
       case "00FFFF00": 
          colName="yellow"; 
          break;
       case "000000FF": 
          colName="blue"; 
          break;
          
    }
    return colName;
}

Cubie findCubie(PVector pvec) {
  for(int i=0; i<cube.length;i++) {
    if(pvectorsEqual(cube[i].pos(),pvec)){
       return cube[i]; 
    }

  }
  return cube[0];
}
