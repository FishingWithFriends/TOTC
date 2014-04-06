part of TOTC;

class Fleet extends Sprite {
  static const TEAM1SARDINE = 1;
  static const TEAM2SARDINE = 2;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  List<Boat> boats = new List<Boat>();
  
  Fleet(ResourceManager resourceManager, Juggler juggler, Game game) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    
    tmanager.registerEvents(_game);
    tmanager.addTouchLayer(tlayer);
    
    addBoat(TEAM1SARDINE);
  }
  
  void addBoat(int type) {
    Boat boat = new Boat(_resourceManager, _juggler, type);
    boat.x = 400;
    boat.y = 400;
    boats.add(boat);
    tlayer.touchables.add(boat);
    addChild(boat);
    _juggler.add(boat);
  }
}