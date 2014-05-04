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
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  List<Boat> boats = new List<Boat>();
  Map<int, Dock> dockA = new Map<int, Dock>();
  Map<int, Dock> dockB = new Map<int, Dock>();
  num dockHeight;
  int touchReminders = 4;

  Fleet(ResourceManager resourceManager, Juggler juggler, Game game) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;

    BitmapData.load("images/dock.png").then((bitmapData) {
      dockHeight = bitmapData.height;
      for (int i=0;i<4;i++) {
        dockA[i] = new Dock(_game, this, i, true);
        addChild(dockA[i]);
      }
      for (int i=0;i<4;i++) {
        dockB[i] = new Dock(_game, this, i, false);
        addChild(dockB[i]);
      }
      addBoat(TEAMASARDINE);
      addBoat(TEAMBSARDINE);
    });
  }
  
  void sellBoat(Boat boat) {
    for (int i=0; i<boats.length; i++) {
      if (boats[i]._teamA==boat._teamA && boats[i].alpha==0 && boats[i] != boat) sellBoat(boats[i]);
    }
    removeChild(boat);
    _juggler.remove(boat);
    _game.tlayer.touchables.remove(boat);
    if (boat._dock != null) 
      boat._dock.filled = false;
    boat.clearConsole();
    boats.remove(boat);
  }
  
  Boat addBoat(int type) {
    Boat boat = new Boat(_resourceManager, _juggler, type, _game, this);
    Dock emptyDock;
    if (type==TEAMASARDINE||type==TEAMASHARK||type==TEAMATUNA) {
      emptyDock = findEmptyDock(true);
      boat.x = emptyDock.location.x+5;
      boat.y = emptyDock.location.y+dockHeight/2;
      boat.rotation = math.PI;
    }
    else {
      emptyDock = findEmptyDock(false);
      boat.x = emptyDock.location.x+5;
      boat.y = emptyDock.location.y-dockHeight/2;
      boat.rotation = 0;
    }
    boat._dock = emptyDock;
    boat._dock.filled=true;
    boats.add(boat);
    _game.tlayer.touchables.add(boat);
    addChild(boat);
    boat._promptUser();
    _juggler.add(boat);
    
    return boat;
  }
  
  void returnBoats() {
    for (int i=0; i<boats.length; i++) {
      boats[i].returnToDock();
    }
  }
  
  void reactivateBoats() {
    for (int i=0; i<boats.length; i++) {
      if (boats[i].alpha==0) sellBoat(boats[i]);
      else boats[i].fishingSeasonStart();
    }
  }
  
  Dock findEmptyDock(teamA) {
    while (dockB[3].location == null) {}
    Dock dock;
    if (teamA) {
      for (int i=0; i<3; i++) {
        dock = dockA[i];
        if (dock.filled == false) {
          dock.filled = true;
          return dock;
        }
      }
    } else {
      for (int i=0; i<3; i++) {
        dock = dockB[i];
        if (dock.filled == false) {
          dock.filled = true;
          return dock;
        }
      }
    }
  }
}

class Dock extends Sprite{
  Point location;
  bool filled;
  Game _game;
  Fleet _fleet;
  int pos;
  
  Dock(Game game, Fleet fleet, int n, bool teamA) {
    filled = false;
    _game = game;
    _fleet = fleet;
    
    pos = n;
    
    if (teamA) location = new Point(Fleet.DOCK_SEPARATION+n*Fleet.DOCK_SEPARATION, Fleet.LARGE_DOCK_HEIGHT);
    else location = new Point(_game.width-Fleet.DOCK_SEPARATION-n*Fleet.DOCK_SEPARATION, _game.height-Fleet.LARGE_DOCK_HEIGHT);
    
    BitmapData.load('images/dock.png').then((bitmapData) {
      Bitmap bitmap = new Bitmap(bitmapData);
      if (teamA == true) {
        bitmap.x = location.x-Fleet.DOCK_SEPARATION/2;
        bitmap.y = location.y;
      } else {
        bitmap.x = location.x+Fleet.DOCK_SEPARATION/2;
        bitmap.y = location.y-_fleet.dockHeight;
      }
      addChild(bitmap);
      
      if (n == 3) filled = true;
    });
  }
}