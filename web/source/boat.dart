part of TOTC;

class Boat extends Sprite implements Touchable {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Tween _boatMove;
  Tween _boatRotate;
  
  Bitmap _boat;
  Bitmap _net;
  
  var _mouseDownSubscription;
  bool _dragging = false;
  num _newX, _newY, _cachedX, _cachedY;
  
  static const num SPEED = 5; //pixels moved every 40ms
  static const num PROXIMITY = 5; //finger must be PROXIMITY from boat to move
  
  Boat(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatUp"));
    _boat.addEventListener(Event.ADDED, _bitmapLoaded);
    addChild(_boat);

    _newX = x;
    _cachedX = x;
    _newY = y;
    _cachedY = y;
    rotation = math.PI;
    _mouseDownSubscription = this.onMouseDown.listen(_mouseDown);
  }
  
  void animate() {
    if (_dragging && (_newX-x).abs() > PROXIMITY && (_newY-y).abs() > PROXIMITY) {
      num cx = _newX - x;
      num cy = _newY - y;
      num ang = math.atan2(cy, cx);
      
      //add rotation speed
      rotation = ang+math.PI/2;

      x = x+SPEED*math.sin(rotation);
      y = y-SPEED*math.cos(rotation);
    }
  }
 
  void _bitmapLoaded(Event e) {
    pivotX = width/2;
    pivotY = height/2;
  }
  
  void _mouseDown(MouseEvent e) { _dragging = true; }
  bool containsTouch(Contact e) => _dragging;
   
  bool touchDown(Contact event) {
    _dragging = true;
    
    removeChild(_boat);
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatDown"));
    addChild(_boat);

    return true;
  }
   
  void touchUp(Contact event) {
    _dragging = false;
    _juggler.remove(_boatMove);
    _juggler.remove(_boatRotate);
    removeChild(_boat);
    
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatUp"));
    addChild(_boat);
  }
   
  void touchDrag(Contact event) {
    _newX = event.touchX;
    _newY = event.touchY;
  }
   
  void touchSlide(Contact event) { }
}