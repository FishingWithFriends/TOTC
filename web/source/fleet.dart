part of TOTC;

class Fleet extends Sprite {
  static const TEAM1SARDINE = 1;
  static const TEAM2SARDINE = 2;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  Boat _boat;
  
  Fleet(ResourceManager resourceManager, Juggler juggler, Game game) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    
    tmanager.registerEvents(_game);
    tmanager.addTouchLayer(tlayer);
    
    addBoat(TEAM1SARDINE);
  }
  
  void addBoat(int type) {
    _boat = new Boat(_resourceManager, _juggler, type);
    _boat.x = 400;
    _boat.y = 400;
    tlayer.touchables.add(_boat);
    addChild(_boat);
    _juggler.add(_boat);
  }
}