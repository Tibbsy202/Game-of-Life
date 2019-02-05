
// Colours for cells alive and dead 
color alive = color(0);
color dead = color(255);

// Size of Cells
int gridSize = 10;

// 2D Array for the board 
int[][] grid; 

// Buffer to record the state of the board 
int[][] Buffer;

// Pause function
boolean pause = false; 


void setup(){
  size(500, 300);
  frameRate(24);
  
  // Initialize the arrays
  grid = new int[width/gridSize][height/gridSize];
  Buffer = new int[width/gridSize][height/gridSize];
  
    // Draw the background
    stroke(255);
    
    
  // Initilization of the board
  for (int x=0; x < width/gridSize; x++) {
    for (int y=0; y < height/gridSize; y++) {
      grid[x][y] = int(random (2));
    }
  }
}

void draw(){
  
  //Draw grid
    for ( int x = 0; x < width/gridSize; x++) {
      for ( int y = 0; y < height/gridSize; y++) {
        if ((grid[x][y] == 1)) fill(alive);
        else fill(dead); 
        stroke(0);
        rect(x*gridSize, y*gridSize, gridSize, gridSize);
      }
    }
    
  // Create new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/gridSize));
    xCellOver = constrain(xCellOver, 0, width/gridSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/gridSize));
    yCellOver = constrain(yCellOver, 0, height/gridSize-1);

    // Check against cells in buffer
    if (Buffer[xCellOver][yCellOver]==1) { // Cell is alive
      grid[xCellOver][yCellOver]=0; // Dead
      fill(dead); // Fill with dead colour
    }
    else { // Cell is dead
      grid[xCellOver][yCellOver]=1; // Alive
      fill(alive); // Fill alive colour
    }
  } 
  else if (pause && !mousePressed) { // Save to buffer once mouse goes up
    // Save cells to buffer and opeate with one array keeping the other intact
    for (int x=0; x < width/gridSize; x++) {
      for (int y=0; y < height/gridSize; y++) {
        Buffer[x][y] = grid[x][y];
      }
    }
  }
    if (!pause){
     generate();
   }
}

void generate(){
    // Save cells to buffer and opeate with one array keeping the other intact
  for (int x=0; x<width/gridSize; x++) {
    for (int y=0; y<height/gridSize; y++) {
      Buffer[x][y] = grid[x][y];
   }
  }
    int[][] next = new int[width/gridSize][height/gridSize];

    // Loop through every cell and check cells neighbors
    for (int x = 1; x < width/gridSize-1; x++) {
      for (int y = 1; y < height/gridSize-1; y++) {

        // Add up all the states in a 3x3 surrounding grid
        int neighbours = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
             neighbours += grid[x+i][y+j];
          }
        }
             
        // Subtract the current cell's state since it was added in the above loop
            neighbours -= grid[x][y];
            
        // Rules of the Game of Life
        if      ((Buffer[x][y] == 1) && (neighbours <  2)) next[x][y] = 0;           // Underpopulation
        else if ((Buffer[x][y] == 1) && (neighbours >  3)) next[x][y] = 0;           // Overcrowding
        else if ((Buffer[x][y] == 0) && (neighbours == 3)) next[x][y] = 1;           // Creation of life
        else                                             next[x][y] = Buffer[x][y];  // Survival 
     }
    }
        //Next is the new board
        grid = next;
}

void keyPressed() {
  // Rest: when 'r' is pressed rest the grid 
  if (key == 'r' || key == 'R'){
    for (int x=0; x < width/gridSize; x++) {
    for (int y=0; y < height/gridSize; y++) {
      grid[x][y] = int(random (2));
      }
     }  
    }
  // Pause: when ' ' is pressed pause iterations
  if (key == ' ') {
    pause = !pause;
    }
    // Clear: when 'c' is pressed set grid to zero and clear grid
    if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<width/gridSize; x++) {
      for (int y=0; y<height/gridSize; y++) {
        grid[x][y] = 0; // Save all to zero
      }
    }
  }
}
