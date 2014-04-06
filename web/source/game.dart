part of TOTC;

class Game extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Game(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Background"));
    Bitmap mask = new Bitmap(_resourceManager.getBitmapData("Mask"));
    var fleet = new Fleet(_resourceManager, _juggler, this);
    var ecosystem = new Ecosystem(_resourceManager, _juggler, fleet);
    
    addChild(background);
    addChild(ecosystem);
    addChild(mask);
    addChild(fleet);
  }
}