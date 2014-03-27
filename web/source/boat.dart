part of TOTC;

class Boat extends Sprite implements Touchable {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Bitmap _boat;
  Bitmap _net;
  
  bool _dragging = false;
  
  Boat(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatUp"));
    addChild(_boat);
  }
  
  bool containsTouch(Contact e) {
    return (e.touchX >= this.x &&
            e.touchX <= this.x+this.width &&
            e.touchY >= this.y &&
            e.touchY <= this.y+this.height);
  }
   
  bool touchDown(Contact event) {
    _dragging = true;
    removeChild(_boat);
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatDown"));
    addChild(_boat);
    return true;
  }
   
  void touchUp(Contact event) {
    removeChild(_boat);
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatUp"));
    addChild(_boat);
  }
   
  void touchDrag(Contact event) {
    
  }
   
  void touchSlide(Contact event) {
    
  }
}