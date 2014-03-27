part of TOTC;

class Boat extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Bitmap _boat;
  Bitmap _net;
  
  var _mouseDownSubscription;
  var _mouseUpSubscription;
  var _mouseMoveSubscription;
  
  bool _dragging = false;
  
  Boat(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatUp"));
    addChild(_boat);
    
    _mouseDownSubscription = this.onMouseDown.listen(_mouseClickDown);
    _mouseUpSubscription = this.onMouseUp.listen(_mouseClickUp);
    _mouseMoveSubscription = this.onMouseOut.listen(_mouseMove);
  }
  
  void _mouseClickDown(MouseEvent e) {
    print("3");
    _dragging = true;
    removeChild(_boat);
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatDown"));
    addChild(_boat);
  }
  
  void _mouseClickUp(MouseEvent e) {
    print("2");
    removeChild(_boat);
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatUp"));
    addChild(_boat);
  }
  
  void _mouseMove(MouseEvent e) {
    print("1");
  }
}