 /* class algorithms{
 Cubie cubie; */
 int stageNo = 0;
 int turnsDone=0;
 
  //  STAGE 6
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void finalRotations() {


    Cubie ruf_corner = findCubie(new PVector(1,-1,1));
    printDebugln("Right top corner. Yellow points: " + ruf_corner.getFace(yellow));
    if (correctRotation(ruf_corner)) {
      if (turnsDone==4) {
        stageNo++;
        println("Moves Counter (final rotations): " + (moveCounter-lastMoveCounter));
        lastMoveCounter=moveCounter;
        return;
      } else {
        // It is correct rotated
        turnsDone++;
        // but we are not done yet
        printDebugln("Not done. Next");
        turns+="U";
        return;
      }
    } else {
      printDebugln("Not correct. Fix");
      turns += "R'D'RD"; 
      return;
    }
  }

  boolean correctRotation(Cubie piece) {
    return(piece.getFace(yellow)  =='U');
  }



  //  STAGE 5
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void getCornersInCorrectPositions() {
    printDebugln("");
    printDebugln("Solving for top corners correct position: ");

    int correctCounter = 0;

    Cubie correctPiece = findCubie(new PVector(-1,-1,-1));
    Cubie testPiece = findCubie(new PVector(-1,-1,-1)); // (left,  top,   back)

    if (cornerInCorrectPosition('L', 'U', 'B', testPiece)) {
      printDebugln("L,U,B matches");
      correctCounter ++;
    }
    testPiece = findCubie(new PVector(1,-1,-1)); // (right,  top,   back)
    if (cornerInCorrectPosition('R', 'U', 'B', testPiece)) {
      printDebugln("R,U,B matches");
      correctCounter ++;
      correctPiece = findCubie(new PVector(1,-1,-1));
    }

    testPiece = findCubie(new PVector(1,-1,1)); // (right, top,   front)
    if (cornerInCorrectPosition('R', 'U', 'F', testPiece)) {
      printDebugln("R,U,F matches");
      correctCounter ++;
      correctPiece = findCubie(new PVector(1,-1,1)); 
    }

    testPiece = findCubie(new PVector(-1,-1,1)); // (left,  top,   front)
    if (cornerInCorrectPosition('L', 'U', 'F', testPiece)) {
      printDebugln("L,U,F matches");
      correctCounter ++;
      correctPiece = findCubie(new PVector(1,-1,1));
    }

    if (correctCounter ==4) {
      stageNo++;
      println("Moves Counter (top corners in position): " + (moveCounter-lastMoveCounter));
      lastMoveCounter=moveCounter;
      return;
    }

    if (correctCounter ==0) {
      printDebugln("No correct");
      turns += "URU'L'UR'U'L";
      return;
    }


    //only one is correct
    printDebugln("only one is tops  aye");
    String temp =getDirectionsCorners(correctPiece.pos(), new PVector(1, -1, 1));
    turns+=temp;
    turns+="URU'L'UR'U'L";
    turns += reverseDirections(temp);
  }


  boolean cornerInCorrectPosition(char face1, char face2, char face3, Cubie piece) {

    color c1 = getFaceColor(face1);
    color c2 = getFaceColor(face2);
    color c3 = getFaceColor(face3);


    if (piece.getFace(c1) == ' ') {
      return false;
    }
    if (piece.getFace(c2) == ' ') {
      return false;
    }
    if (piece.getFace(c3) == ' ') {
      return false;
    }
    return true;
  }


//  STAGE 4
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void finishTopCross() {
    printDebugln("Finish Top Cross");
    
    color[] order = {green, red, blue, orange, green, red, blue, orange, green, red};

    // we have 4+1 due to 4 top edges, but we have an algo that does i+1
    PVector[] ptopYellowEdges={
      new PVector(0, -1, 1),  // front 
      new PVector(-1, -1, 0), //left 
      new PVector(0, -1, -1), // back 
      new PVector(1, -1, 0),  // right
      new PVector(0, -1, 1)};  // front
      
    // each edge have two faces, we are ofcourse looking for the one not point up
    char[] facedirection={'F','L','B','R','F'};

    color[] currentOrder = new color[5];
    for(int i = 0; i<ptopYellowEdges.length ; i++) {
       for(int j= 0; j<cube.length; j++) {
         if(pvectorsEqual(cube[j].pos(),ptopYellowEdges[i])) {
            Cubie c = cube[j];
            currentOrder[i]=c.getFaceColor(facedirection[i]);
         }
       }
    }


    printDebug("current order: ");
    for(int i=0;i<currentOrder.length;i++) {
      printDebug(colToName(currentOrder[i]) +",");
    }
    printDebugln("");

    printDebug("desired order: ");
    for(int i=0;i<order.length;i++) {
      printDebug(colToName(order[i]) +",");
    }
    printDebugln("");
    printDebug("turns: " +turns);


    //also need to check if the order is already correct
    for (int i = 0; i< order.length - 4; i++) {
      // try to find perfect match for all i
      
      boolean perfectMatch = true;
      
      // if we from start i and 4 forward can match up, then perfect
      // else try for next i.
      for (int j = 0; j<4; j++) {
        if ((order[i+j] & 0x00FFFFFF) != (currentOrder[j] & 0x00FFFFFF)) {
          perfectMatch = false;
        }
      }
      
      // if this i gave perfect match, then we just need to 
      // turn it into place
      if (perfectMatch) {
        for (int k = 0; k < i%4; k++) {
          turns+="U";
        }
        
        // and then onto next stage
        stageNo++;
        println("Moves Counter (finish top cross): " + (moveCounter-lastMoveCounter));
        lastMoveCounter=moveCounter;
        return;
      }
    }

    // we did not have 4 correct in a sequence
    // that mean we have 3 or less. 
    // we can't have zero right. we have these cases:
    // correct - wrong - wrong - wrong
    // correct - wrong - correct - wrong
    // correct - correct - wrong - wrong
    // correct - wrong - wrong - correct
    // wrong - wrong - correct - correct
    // wrong - correct - correct - wrong
    
    
    for (int i = 0; i< order.length - 4; i++) {
      boolean previousMatched = false;
      for (int j = 0; j<5; j++) {
        printDebugln("(i,j) = ("+i+","+j+")");
        if ((order[i+j] & 0x00FFFFFF) == (currentOrder[j] & 0x00FFFFFF)) {
           printDebugln("  matched " + colToName(currentOrder[j]));
 
          if (previousMatched) {
            
            // we matched previous
  
            printDebugln("  Double match");
            
            //algo below swaps in place where j=0
            //for each i rotate U. we have not matched (j-1,j), so we need to flip (j+1,j+2)
            switch(j) {
               case 1:
                 // 0 and 1 match up, 2 and 3 does not. Push forward 2
                 turns += "U2";
                 break;
               case 2:
                 // 1 and 2 match up. 0 and 3 does not. Push forward 1
                 turns += "U";
                 break;
               
               case 3:
                  // do nothing
                  break;
            }
            
         
 
            turns+= "RUR'URU2R'U";
            return;
          } else {
            previousMatched = true;
          }
        } else {
          previousMatched = false;
        }
      }
    }
    printDebugln("  No double match. Swap");
    turns+= "RUR'URUUR'";
    return;  
}

  //  STAGE 3
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void positionTopCross() {
    int numberOfYellowEdgesOnTop  = 0;
    //back,front,left, right
    PVector[] ptopYellowEdges={new PVector(0, -1, -1), new PVector(0, -1, 1), new PVector(-1, -1, 0), new PVector(1, -1, 0)};

    boolean[] topYellowEdges = new boolean[4];
    for(int i = 0; i<ptopYellowEdges.length ; i++) {
       for(int j= 0; j<cube.length; j++) {
         if(pvectorsEqual(cube[j].pos(),ptopYellowEdges[i])) {
            topYellowEdges[i]=(cube[j].getFace(yellow) == 'U');
         }
       }
    }
    
    printDebug("top: (");
    for (int i = 0; i< 4; i++) { 
      printDebug(topYellowEdges[i] + ",");
      if (topYellowEdges[i]) {
        numberOfYellowEdgesOnTop ++;
      }
    }
    printDebugln(")");
    
    //case 1 cross is already formed
    if (numberOfYellowEdgesOnTop == 4) {
      println("Moves Counter (position top cross): " + (moveCounter-lastMoveCounter));
      lastMoveCounter=moveCounter;
      stageNo ++;
      return;
    }
    printDebugln("number:" + numberOfYellowEdgesOnTop);
    //case 2 line on top

    if (topYellowEdges[0] && topYellowEdges[1]) {
      printDebugln("vertical line on top");
      turns+= "UFRUR'U'F'"; 
      return;
    }

    if (topYellowEdges[2] && topYellowEdges[3] ) {
      printDebugln("horizontal line on top");
      
      turns+= "FRUR'U'F'";
      return;
    }

    //case 3 just a dot on top
    if (numberOfYellowEdgesOnTop ==0) {
      printDebugln("dot");
      //this should convert it to case 4
      turns+= "FURU'R'F'";
      return;
    }


    //case 4 a little L
    //first positionL to top left
    printDebug("its an L");
    if (!topYellowEdges[0] && topYellowEdges[2]) {
      printDebugln("L1");
      turns+="U";
    } else if (topYellowEdges[0] && !topYellowEdges[2]) {
      printDebugln("L2");
      turns+="U'";
    } else if (!topYellowEdges[0] && !topYellowEdges[2]) {
      printDebugln("L3");
      turns+="U2";
    }
    printDebugln("L");

    turns += "FURU'R'F'";
   
  }



  //  STAGE 2
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void layer2edges() {
    color[][] colorOrder = {{red, green}, {green, orange}, {orange, blue}, {blue, red}};
    int completedEdges=0;
    while (completedEdges<4) {
      positionMiddleEdge(colorOrder[completedEdges][0], colorOrder[completedEdges][1]);
      if (turns.length() > 0) {
        return;
      }
      completedEdges++;
    }
    println("Moves Counter (layer2edges): " + (moveCounter-lastMoveCounter));
    lastMoveCounter=moveCounter;
    stageNo++;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void  positionMiddleEdge(color c1, color c2) {
    //c1 should be to the left of c2 when white is down

    color[] cols = {c1, c2};
    Cubie piece = findCenterEdge(cols);
    char colfacec1=piece.getFace(c1);
    char colfacec2=piece.getFace(c2);



    if (piece.y ==-1) {//top layer

          char face=colfacec1;
          color fc=c1;
          color uc=c2;
          if(colfacec1 == 'U') {
             face=colfacec2;
             fc=c2;
             uc=c1;
          }
        color cf=(getFaceColor(face) & 0x00FFFFFF);

    
    
        
        if ((cf) != (fc & 0x00FFFFFF)) {//if not in right place
          turns += "U";
        } else if (cf == (fc & 0x00FFFFFF)) {
          
          switch (face) {
            case 'F':
               // color matches on front
               if((getFaceColor('R') & 0x00FFFFFF) == (uc & 0x00FFFFFF)) {
                  // UP color and right color mathces, thus use  right algo
                  turns += "URU'R'U'F'UF";
               } else {
                  // up color and left color matches, thus use left algo
                  turns += "U'L'ULUFU'F'";
               }
               break;
            case 'R':
               // color matches to the right
               if((getFaceColor('B') & 0x00FFFFFF) == (uc & 0x00FFFFFF)) {
                  // UP color and back color mathces, thus use transposed right algo
                  turns += "UBU'B'U'R'UR";
               } else {
                  // up color and front color matches, thus use 'transposed left algo
                  turns += "U'F'UFURU'R'";
               }
               break;
            case 'B': 
               // color matches to the left
               if((getFaceColor('L') & 0x00FFFFFF) == (uc & 0x00FFFFFF)) {
                  // UP color and left color mathces, thus use transposed right algo
                  turns += "ULU'L'U'B'UB";
               } else {
                  // up color and right matches, thus use 'transposed left algo
                  turns += "U'R'URUBU'B'";
               }
               
               break;
            case 'L': 
               // color matches to the left
               if((getFaceColor('F') & 0x00FFFFFF) == (uc & 0x00FFFFFF)) {
                  // UP color and front color mathces, thus use transposed right algo
                  turns += "UFU'F'U'L'UL";
               } else {
                  // up color and front back matches, thus use 'transposed left algo
                  turns += "U'B'UBULU'L'";
               }
               break;
          }

        }
        return;//ignore piece for now
     
    } else if (piece.y == 0) {
      // edge is in correct layer, but might be in wrong spot or wrong orientation

      if (
        (getFaceColor(colfacec2) & 0x00FFFFFF)  == (c2 & 0x00FFFFFF) &&
        (getFaceColor(colfacec1) & 0x00FFFFFF)  == (c1 & 0x00FFFFFF)
        ) 
        {
          // everything is fine. This is correct
          return;
        } else { // move piece to upper layer
          
          if(piece.x == 1 && piece.z == 1) { // right front piece, incorrect position or incorrect orientation
            turns += "RU'R'U'F'UF";
          } else if(piece.x == 1 && piece.z == -1) { // right back piece, incorrect position or incorrect orientation
            turns += "BU'B'U'R'UR";
          } else if(piece.x == -1 && piece.z == -1) { // left back piece, incorrect position or incorrect orientation
           turns += "LU'L'U'B'UB";
          } else if(piece.x == -1 && piece.z == 1) { // left front piece, incorrect position or incorrect orientation
          turns += "FU'F'U'L'UL";
          } 
        }
    }
  }



//
// STAGE 1 is bottom corners
//



void bottomCorners() {
     printDebugln("");
     printDebugln("Solving bottom corners: ");
     
     int completedCorners=0;
     color[][] colorOrder = {{green, orange}, {orange, blue}, {blue, red}, {red, green}};
     while (completedCorners<4) {
        if(Solver == "Optimized") {
          positionCornerAtBottomOptimized(colorOrder[completedCorners][0], colorOrder[completedCorners][1]);          
        } else {
          positionCornerAtBottom(colorOrder[completedCorners][0], colorOrder[completedCorners][1]);
        }
        if (turns.length() > 0) {
             return;
        }
        printDebug("   completed corners: " + completedCorners);
        completedCorners++;
    }
    println("Moves Counter (bottom corners): " + (moveCounter-lastMoveCounter));
    lastMoveCounter=moveCounter;
    stageNo++;
}

  PVector findtopcorner(color c1, color c2) {
     // Find the right corner where c1 and c2 are on either side
     PVector p = new PVector(0,0,0);
     if((c1 & 0x00FFFFFF) == (green & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (orange & 0x00FFFFFF)) {
        p = new PVector(1,-1,1);
     } else if((c1 & 0x00FFFFFF) == (orange & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (blue & 0x00FFFFFF)) {
        p = new PVector(1,-1,-1);
     } else if((c1 & 0x00FFFFFF) == (blue & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (red & 0x00FFFFFF)) {
        p = new PVector(-1,-1,-1);
    } else if((c1 & 0x00FFFFFF) == (red & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (green & 0x00FFFFFF)) {
        p = new PVector(-1,-1,1);
    }
        
     return p;
  }


  PVector findbottomcorner(color c1, color c2) {
     // Find the right corner where c1 and c2 are on either side
     PVector p = new PVector(0,0,0);
     if((c1 & 0x00FFFFFF) == (green & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (orange & 0x00FFFFFF)) {
        p = new PVector(1,1,1);
     } else if((c1 & 0x00FFFFFF) == (orange & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (blue & 0x00FFFFFF)) {
        p = new PVector(1,1,-1);
     } else if((c1 & 0x00FFFFFF) == (blue & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (red & 0x00FFFFFF)) {
        p = new PVector(-1,1,-1);
    } else if((c1 & 0x00FFFFFF) == (red & 0x00FFFFFF) && (c2 & 0x00FFFFFF) == (green & 0x00FFFFFF)) {
        p = new PVector(-1,1,1);
    }
        
     return p;
  }



  void  positionCornerAtBottom(color c1, color c2) {
    //c1 should be to the left of c2 when white is down

    color[] cols = {c1, c2, white};
    Cubie piece = findCornerPiece(cols);


    // only top or bottom have corners
    
    if (piece.y == -1) {//top layer
      printDebug("\n      Found in top layer");
      PVector correcttopcorner= findtopcorner(c1,c2);
      // find moves to turn corner into (right, top,   front) corner
      String temp = getDirectionsCorners(piece.pos(), correcttopcorner);
      
      if (!temp.equals("")) {
        printDebugln("\n      Moving: " + temp);
        turns+=temp;
        return;
      }
      //now the piece is in the correct top corner
      // but what corner is that. 4 possible cases

      char colFace=piece.getFace(white);      

      int index = pVectorToIndex(piece.pos());
      switch(index) {
        case 0:
            // (left,  top,   back)
            // based on what way the white is facing, then we do different algos
            
            switch(colFace) {
               case 'B':
                   turns += "ULU'L'";
                   break;
               case 'U': 
                   turns += "ULU'L'ULU'L'ULU'L'";
                   break;
               case 'L': 
                   turns += "ULU'L'ULU'L'ULU'L'ULU'L'ULU'L'";
                   break;
            }
            break;
        case 2:
            // (left,  top,   front)
            // based on what way the white is facing, then we do different algos
            switch(colFace) {
               case 'L':
                   turns += "UFU'F'";
                   break;
               case 'U': 
                   turns += "UFU'F'UFU'F'UFU'F'";
                   break;
               case 'F': 
                   turns += "UFU'F'UFU'F'UFU'F'UFU'F'UFU'F'";
                   break;
            }
            break;
        case 18:
            // (right, top,   back) 
            // based on what way the white is facing, then we do different algos
            
            switch(colFace) {
               case 'R':
                   turns += "UBU'B'";
                   break;
               case 'U': 
                   turns += "UBU'B'UBU'B'UBU'B'";
                   break;
               case 'B': 
                   turns += "UBU'B'UBU'B'UBU'B'UBU'B'UBU'B'";
                   break;
            }
            break;
        case 20: 
            // (right, top,   front)
            // based on what way the white is facing, then we do different algos
            
            switch(colFace) {
               case 'F':
                   turns += "URU'R'";
                   break;
               case 'U': 
                   turns += "URU'R'URU'R'URU'R'";
                   break;
               case 'R': 
                   turns += "URU'R'URU'R'URU'R'URU'R'URU'R'";
                   break;
            }
            break;
     }

      
      
    } else if (piece.y == 1) {
      // we have corner in right layer, but might not be in right position or with right orientation
      PVector correctbottomcorner= findbottomcorner(c1,c2);
      
      char colFace=piece.getFace(white);
      if (!pvectorsEqual(piece.pos(), correctbottomcorner) || (colFace != 'D')) {
        
        //then its not in the right position or white is not down. Chuck it up in top and let top algo deal with it
        int index = pVectorToIndex(piece.pos());
        switch(index) {
           case 6:
               // (left,  bottom,back)
               turns += "LUL'U'";
               break;
           case 8:
               // (left,  bottom,front)
               turns += "L'ULU'";
               break;
           case 24:
               turns += "R'URU'";
               // (right, bottom,back)
               break;
           case 26: 
               // (right, bottom,front)
               turns += "RUR'U'";
               break;
        }
      }
    }
  }



  void  positionCornerAtBottomOptimized(color c1, color c2) {
    //c1 should be to the left of c2 when white is down

    color[] cols = {c1, c2, white};
    Cubie piece = findCornerPiece(cols);


    // only top or bottom have corners
    
    if (piece.y == -1) {//top layer
      printDebug("\n      Found in top layer");
      PVector correcttopcorner= findtopcorner(c1,c2);
      // find moves to turn corner into (right, top,   front) corner
      String temp = getDirectionsCorners(piece.pos(), correcttopcorner);
      
      if (!temp.equals("")) {
        printDebugln("\n      Moving: " + temp);
        turns+=temp;
        return;
      }
      //now the piece is in the correct top corner
      // but what corner is that. 4 possible cases

      char colFace=piece.getFace(white);      

      int index = pVectorToIndex(piece.pos());
      switch(index) {
        case 0:
            // (left,  top,   back)
            // based on what way the white is facing, then we do different algos
            
            switch(colFace) {
               case 'B':
                   turns += "B'U'B";
                   break;
               case 'U': 
                   turns += "LU2L'U'LUL'";
                   break;
               case 'L': 
                   turns += "LUL'";
                   break;
            }
            break;
        case 2:
            // (left,  top,   front)
            // based on what way the white is facing, then we do different algos
            switch(colFace) {
               case 'L':
                   turns += "L'U'L";
                   break;
               case 'U': 
                   turns += "L'U2LUL'U'L";
                   break;
               case 'F': 
                   turns += "FUF'";
                   break;
            }
            break;
        case 18:
            // (right, top,   back) 
            // based on what way the white is facing, then we do different algos
            
            switch(colFace) {
               case 'R':
                   turns += "R'UR";
                   break;
               case 'U': 
                   turns += "R'U2RUR'UR";
                   break;
               case 'B': 
                   turns += "BUB'";
                   break;
            }
            break;
        case 20: 
            // (right, top,   front)
            // based on what way the white is facing, then we do different algos
            
            switch(colFace) {
               case 'F':
                   turns += "F'U'F";
                   break;
               case 'U': 
                   turns += "RU2R'U'RUR'";
                   break;
               case 'R': 
                   turns += "RUR'";
                   break;
            }
            break;
     }

      
      
    } else if (piece.y == 1) {
      // we have corner in right layer, but might not be in right position or with right orientation
      PVector correctbottomcorner= findbottomcorner(c1,c2);
      
      char colFace=piece.getFace(white);
      if (!pvectorsEqual(piece.pos(), correctbottomcorner) || (colFace != 'D')) {
        
        //then its not in the right position or white is not down. Chuck it up in top and let top algo deal with it
        int index = pVectorToIndex(piece.pos());
        switch(index) {
           case 6:
               // (left,  bottom,back)
               turns += "LUL'";
               break;
           case 8:
               // (left,  bottom,front)
               turns += "L'UL";
               break;
           case 24:
               turns += "R'UR";
               // (right, bottom,back)
               break;
           case 26: 
               // (right, bottom,front)
               turns += "RUR'";
               break;
        }
      }
    }
  }


//
// STAGE 0 is whiteCross at bottom
//


void whiteCross() {
    printDebugln("");
    printDebugln("Solving for whitecross: ");

    if (turns.length() != 0) {
      return;
    }

   printDebugln("  fixing red/white: ");
   positionWhiteCrossColor(red);
   if (turns.length() != 0) {
     return;
   }
    printDebugln("");
    printDebugln("  fixing orange/white: ");
    positionWhiteCrossColor(orange);
    if (turns.length() != 0) {
      return;
    }
    printDebugln("");
    printDebugln("  fixing blue/white: ");
    positionWhiteCrossColor(blue);
    if (turns.length() != 0) {
      return;
    }
    
    printDebugln("");
    printDebugln("  fixing green/white: ");
    positionWhiteCrossColor(green);
    if (turns.length() == 0) {
      println("Moves Counter (white cross): " + (moveCounter-lastMoveCounter));
      lastMoveCounter=moveCounter;
      stageNo++;
    }
  }
  
  
  color getFaceColor(char face) {
    // looks at center piece for a face and returns color
    switch(face) {
    case 'D':  
      return(cube[16].faces[2].c);
    case 'U':
      return(cube[10].faces[3].c);
    case 'L':
      return(cube[4].faces[5].c);
    case 'R':
      return(cube[22].faces[4].c);
    case 'F':
      return(cube[14].faces[1].c);
    case 'B':
      return(cube[12].faces[0].c);
    }
    return color(0);
  }
  
  
  
  void positionWhiteCrossColor(color col) {
    color[] colors = {col, white}; // look for piece with col, white (whitecross)
    Cubie piece = findCenterEdge(colors);
    
    if (piece.y==-1) { //if piece in top row
      printDebug("    " + colToName(col) + "/white piece is in top row,");
      if (piece.getFace(white) == 'U') {
        printDebug("    white color on piece points U,");
        char colFace=piece.getFace(col);
        printDebug("    " + colToName(col) + " color on piece points " + colFace + ",");
          color cf=(getFaceColor(colFace) & 0x00FFFFFF);
          printDebug("    " + colFace + " face has color " + colToName(cf) + ",");
        if ((cf) != (col & 0x00FFFFFF)) {//if not in right place
          turns += "U";
        } else if (cf == (col & 0x00FFFFFF)) {
          
          switch (colFace) {
            case 'F':
               turns += "F2";
               break;
            case 'R': 
               turns += "R2";
               break;
            case 'B': 
               turns += "B2";
               break;
            case 'L': 
               turns += "L2";
               break;
          }

        }
        return;//ignore piece for now
      } else {
         //piece is on the top layer with white not  up 
         printDebug("    white color on piece points not U,");
         char colFace=piece.getFace(white);
         printDebug("    " + colToName(white) + " color on piece points " + colFace + ",");
         color cf=(getFaceColor(colFace) & 0x00FFFFFF);
         printDebug("    " + colFace + " face has color " + colToName(cf) + ",");
         if ((cf) != (col & 0x00FFFFFF)) {//if not in right place
           printDebug("     executing U"); 
           turns += "U";
         } else if (cf == (col & 0x00FFFFFF)) {
           printDebug("     Center and piece allign, but white is not up, ");
           switch (colFace) {
             case 'F':
                turns += "U'R'FR";
                break;
             case 'R': 
                turns += "U'B'RB";
                break;
             case 'B': 
                turns += "U'B'L'B";
                break;
             case 'L': 
                turns += "U'F'LF";
                break;
           }
           printDebug("executing " + turns);
         } 
      } // white is not up  
     
      return;
    } //piece.y == -1
    
    if (piece.y==0) {//if in the middle row
      printDebug("    " + colToName(col) + "/white piece is in middle row,");

      
      if (piece.x ==-1) {
        // if piece is to left

        if(piece.z == -1) {
          // if piece is in the back, then turn left bringing piece on top, rotate it out of the way and turn left face to not destory bottom
          printDebug(" piece is to the left/back - executing LUL'");
          turns+= "LUL'";

        } else {
          // if piece is in the front, then turn left' bringing piece on top, rotate it out of the way and turn left face to not destory bottom
          printDebug(" piece is to the left/front - executing L'UL");
          turns+= "L'UL";
        }
      } else {
        // if piece is to right
        if(piece.z == -1) {
          // if piece is in the back, then turn right bringing piece on top, rotate it out of the way and turn right face to not destory bottom
          printDebug(" piece is to the right/back - executing R'UR");

          turns+= "R'UR";

        } else {
          // if piece is in the front, then turn right' bringing piece on top, rotate it out of the way and turn right face to not destory bottom
          printDebug(" piece is to the right/front - executing RUR'");

          turns+= "RUR'";
        }
      }
    }
    if (piece.y==1) {//if in the bottom row
      
      printDebug("    " + colToName(col) + "/white piece is in bottom row,");
      if (piece.getFace(white) != 'D') {
         printDebug("    Piece is rotated wrong!");
         char colFace=piece.getFace(white);
         printDebug("    " + colToName(white) + " color on piece points " + colFace + ",");
          switch (colFace) {
             case 'F':
                turns += "D'L'DF'"; // only this tested
                break;
             case 'L': 
                turns += "D'B'DL'";
                break;
             case 'B': 
                turns += "D'R'DB'";
                break;
             case 'R': 
                turns += "D'F'DR'";
                break;
           }
           printDebug("executing " + turns);
      } else {
         // oriented correct, but might be wrong position
         char colFace=piece.getFace(col);
         color cf=(getFaceColor(colFace) & 0x00FFFFFF);
         if (cf != (col & 0x00FFFFFF)) {
             // non white color does not match with color of face
             
             switch(colFace) {
               case 'L':
                 turns+="LL";
                 break;
               case 'B':
                 turns+="BB";
                 break;
               case 'R':
                 turns+="RR";
                 break;
               case 'F':
                 turns+="FF";
                 break;
                 
             }
         }
         
      }
    }
    
  }
  
  void printcolors(color[] pieceColors) {
     printDebug("(");
     for(int i=0;i<pieceColors.length;i++) {
       printDebug(colToName(pieceColors[i])+",");
     }
     printDebug(")");
  }
  
  Cubie findCornerPiece(color[] pieceColors) {

    printDebug("   Looking for ");
    printcolors(pieceColors);
    for (int i = -1; i<= 1; i+=dim-1) { 
      for (int j = -1; j<= 1; j+=dim-1) { 
        for (int k = -1; k<=1;  k+=dim-1) {
            PVector pvec = new PVector(i,j,k);
            int index = pVectorToIndex(pvec);
            if (cube[index].matchesColors(pieceColors)) {
                return cube[index];
            }
        }
      }
    }

    return null;
  }


   Cubie findCenterEdge(color[] pieceColors) {
    for (int i = 0; i< edgeCenters.length; i++) { 
      PVector vec = edgeCenters[i];
      int index = pVectorToIndex(vec);
      if (cube[index].matchesColors(pieceColors)) {
        return cube[index];
      }
    }
    return null;
  }
  
  void continueSolve(){
    
    switch(stageNo) {
      case 0://cross
        Stage="Solving white bottom cross";
        whiteCross(); 
        break;
      case 1:
        Stage="Solving white bottom corners";
        bottomCorners();    
        break;
      case 2:
        Stage="Solving middle edges";
    
        layer2edges();    
        break;
      case 3:
       Stage="Solving top cross positions";
      
       positionTopCross();
        break;
      case 4:
       Stage="Solving top cross rotations";
       finishTopCross();    
        break;
      case 5:
        Stage="Solving top corner positions";

        getCornersInCorrectPositions();
        turnsDone=0;
        break;
      case 6:
        Stage="Solving top corner rotations";
        finalRotations();
        break;
      case 7:
        Solved();
        break;
    }
  }

 
