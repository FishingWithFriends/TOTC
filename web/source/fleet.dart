part of TOTC;

class Fleet extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Boat _boat;
  
  Fleet(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;

    addBoat();
  }
  
  void addBoat() {
    _boat = new Boat(_resourceManager, _juggler);
    _boat.x = 400;
    _boat.y = 400;
    addChild(_boat);
  }
}