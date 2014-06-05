part of TOTC;

class Fleet extends Sprite {
  static const TEAMASARDINE = 1;
  static const TEAMBSARDINE = 2;
  static const TEAMATUNA = 3;
  static const TEAMBTUNA = 4;
  static const TEAMASHARK = 5;
  static const TEAMBSHARK = 6;
  
  static const DOCK_SEPARATION = 100;
  static const LARGE_DOCK_HEIGHT = 0;
  
  static const SMALLNET = 0;
  static const LARGENET = 1;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  List<Boat> boats = new List<Boat>();

  num dockHeight;
  int touchReminders = 4;

  int teamANetSize;
  int teamBNetSize;
  
  Fleet(ResourceManager resourceManager, Juggler juggler, Game game) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;

    BitmapData.load("images/dock.png").then((bitmapData) {
      dockHeight = bitmapData.height;
      
      teamANetSize = SMALLNET;
      teamBNetSize = SMALLNET;
      
      addBoat(TEAMASARDINE, teamANetSize);
      addBoat(TEAMASARDINE, teamANetSize);
      
      addBoat(TEAMBSARDINE, SMALLNET);
      addBoat(TEAMBSARDINE, SMALLNET);
      
      addBoatsToTouchables();
      returnBoats();
      for (int i=0; i<boats.length; i++) {
        boats[i]._promptUser();
      }
    });
  }
  
  
  void sellBoat(int index){
   
    if(contains(boats[index])) removeChild(boats[index]);
    boats.removeAt(index);
    
  }
  
  Boat addBoat(int type,int netSize) {
    Boat boat = new Boat(_resourceManager, _juggler, type, _game, this, netSize);

    boats.add(boat);
    addChild(boat);
//    boat._promptUser();
    _juggler.add(boat);
    
    return boat;
  }
  
  void makeSardine(bool teamA){
    
    for(int i = 0; i < boats.length; i++){
      if(boats[i]._teamA == teamA){
        sellBoat(i);
        i--;
      }
    }
    
    if(teamA){
      addBoat(TEAMASARDINE, teamANetSize);
      addBoat(TEAMASARDINE, teamANetSize);
    }
    else{
      addBoat(TEAMBSARDINE, teamBNetSize);
      addBoat(TEAMBSARDINE, teamBNetSize);
    }
    _game._offseason.clearAndRefillDock();
  }
  void makeTuna(bool teamA){
    for(int i = 0; i < boats.length; i++){
      if(boats[i]._teamA == teamA){
        sellBoat(i);
        i--;
      }
    }
    if(teamA){
      addBoat(TEAMATUNA, teamANetSize);
      addBoat(TEAMATUNA, teamANetSize);
    }
    else{
      addBoat(TEAMBTUNA, teamBNetSize);
      addBoat(TEAMBTUNA, teamBNetSize);
    }
    _game._offseason.clearAndRefillDock();
  }
  void makeShark(bool teamA){
    for(int i = 0; i < boats.length; i++){
      if(boats[i]._teamA == teamA){
        sellBoat(i);
        i--;
      }
    }
    if(teamA){
      addBoat(TEAMASHARK, teamANetSize);
      addBoat(TEAMASHARK, teamANetSize);
    }
    else{
      addBoat(TEAMBSHARK, teamBNetSize);
      addBoat(TEAMBSHARK, teamBNetSize);
    }
    _game._offseason.clearAndRefillDock();
  }
  
  void largeCap(bool teamA){
    if(teamA) teamANetSize = LARGENET;
    else teamBNetSize = LARGENET;
    
    for(int i = 0; i < boats.length; i++){
          if(boats[i]._teamA == teamA){
            boats[i].largeCap();
          }
        }
    _game._offseason.clearAndRefillDock();
  }
  
  void smallCap(bool teamA){
    if(teamA) teamANetSize = SMALLNET;
    else teamBNetSize = SMALLNET;
    
      for(int i = 0; i < boats.length; i++){
            if(boats[i]._teamA == teamA){
              boats[i].smallCap();
            }
          }
      _game._offseason.clearAndRefillDock();
    }
  
  void returnBoats() {
    for (int i=0; i<boats.length; i++) {
//      boats[i].returnToDock();
      Point toSet = positionFishPhase(boats[i]);
      boats[i].x = toSet.x;
      boats[i].y = toSet.y;
      if(boats[i]._teamA) boats[i].rotation = 3/4*math.PI;
      else boats[i].rotation = -1/4*math.PI;
      boats[i]._boatReady();
    }
  }
  
  void reactivateBoats() {
    for (int i=0; i<boats.length; i++) {
      if (boats[i].alpha==0);// sellBoat(boats[i]);
      else boats[i].fishingSeasonStart();
    }
  }
  

  void removeBoatsFromTouchables(){
    for(int i = 0; i < boats.length; i++){
      if(_game.tlayer.touchables.contains(boats[i])){
        _game.tlayer.touchables.remove(boats[i]);
      }
    }  
  }
  
  void addBoatsToTouchables(){
    for(int i = 0; i < boats.length; i++){
      _game.tlayer.touchables.add(boats[i]);
    }
  }
  
  Point positionFishPhase(Boat boat){
    
    
    Point position = new Point(0,0);
    int r = 300;
    
    
    if(boat._teamA){
      int aCount = 0;
      for(int i = 0; i < boats.length; i++){
        if(boat == boats[i]){  
          if(aCount ==0){
            position.x = r*math.cos(math.PI/6);
            position.y = r*math.sin(math.PI/6);
          }
          else if(aCount == 1){
            position.x = r*math.cos(2*math.PI/6);
            position.y = r*math.sin(2*math.PI/6);
          }
//          else if(aCount == 2){
//            position.x = 250;
//            position.y = 50;
//          }
          
          return position;
        }
        if(boats[i]._teamA){
          aCount++;
        }
      }
    }
    
    else{
      int bCount = 0;
          for(int i = 0; i < boats.length; i++){
            if(boat == boats[i]){  
              if(bCount ==0){
                position.x = _game.width-r*math.cos(math.PI/6);
                position.y = _game.height - r*math.sin(math.PI/6);
              }
              else if(bCount == 1){
                position.x = _game.width-r*math.cos(2*math.PI/6);
                position.y = _game.height - r*math.sin(2*math.PI/6);
              }
//              else if(bCount == 2){
//                position.x = _game.width-250;
//                position.y = _game.height - 50;
//              }
              
              return position;
            }
            if(!boats[i]._teamA){
              bCount++;
            }
          }
    }
    
    
  return position;
  }
  
}