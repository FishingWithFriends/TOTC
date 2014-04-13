part of TOTC;

class Fleet extends Sprite {
  static const TEAMASARDINE = 1;
  static const TEAMBSARDINE = 2;
  
  static const DOCK_SEPARATION = 100;
  static const LARGE_DOCK_HEIGHT = 0;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  List<Boat> boats = new List<Boat>();
  Map<int, Dock> dockA = new Map<int, Dock>();
  Map<int, Dock> dockB = new Map<int, Dock>();
  num consoleWidth;
  num dockHeight;
  
  Fleet(ResourceManager resourceManager, Juggler juggler, Game game) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    
    tmanager.registerEvents(_game);
    tmanager.addTouchLayer(tlayer);
    
    BitmapData.load('images/console.png').then((console) {
      consoleWidth = console.width;
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
        addBoat(TEAMASARDINE, _game.width~/2-150, _game.height~/2, math.PI/2);
        addBoat(TEAMBSARDINE, _game.width~/2+150, _game.height~/2, -math.PI/2);
      });
    });
  }
  
  void addBoat(int type, int x, int y, num rot) {
    Boat boat = new Boat(_resourceManager, _juggler, type, _game, this);
    boat.x = x;
    boat.y = y;
    boat.rotation = rot;
    boats.add(boat);
    tlayer.touchables.add(boat);
    addChild(boat);
    _juggler.add(boat);
  }
  
  Point findEmptyNet(teamA) {
    while (dockB[3].location == null) {}
    Dock dock;
    Point ret;
    if (teamA) {
      for (int i=0; i<3; i++) {
        dock = dockA[i];
        if (dock.filled == false) {
          ret = new Point(dock.location.x, dock.location.y+80);
        }
      }
    } else {
      for (int i=0; i<3; i++) {
        dock = dockB[i];
        if (dock.filled == false) {
          ret = new Point(dock.location.x, dock.location.y-80);
        }
      }
    }
    return ret;
  }
}

class Dock extends Sprite{
  Point location;
  bool filled;
  Game _game;
  Fleet _fleet;
  
  Dock(Game game, Fleet fleet, int n, bool teamA) {
    filled = false;
    _game = game;
    _fleet = fleet;
    
    if (teamA) location = new Point(_fleet.consoleWidth/2+Fleet.DOCK_SEPARATION/2+n*Fleet.DOCK_SEPARATION, Fleet.LARGE_DOCK_HEIGHT);
    else location = new Point(_game.width-_fleet.consoleWidth/2-Fleet.DOCK_SEPARATION/2-n*Fleet.DOCK_SEPARATION, _game.height-Fleet.LARGE_DOCK_HEIGHT);
    
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