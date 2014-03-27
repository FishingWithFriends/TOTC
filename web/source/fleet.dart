part of TOTC;

class Fleet extends Sprite {
  
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

    addBoat();
  }
  
  void addBoat() {
    _boat = new Boat(_resourceManager, _juggler);
    _boat.x = 400;
    _boat.y = 400;
    tlayer.touchables.add(_boat);
    addChild(_boat);
  }
}