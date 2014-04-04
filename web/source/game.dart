part of TOTC;

class Game extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Game(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Background"));
    var ecosystem = new Ecosystem(_resourceManager, _juggler);
    var fleet = new Fleet(_resourceManager, _juggler, this);
    
    addChild(background);
    addChild(ecosystem);
    addChild(fleet);
  }
}