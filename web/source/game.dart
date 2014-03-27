part of TOTC;

class Game extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  var _mouseDownSubscription;
  
  Game(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Background"));
    background.x = 0;
    background.y = 0;
    addChild(background);
    
    var fleet = new Fleet(_resourceManager, _juggler);
    addChild(fleet);
  }
}