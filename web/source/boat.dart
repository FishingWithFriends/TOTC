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
  num _newX, _newY;
  
  static const num SPEED = 5; //pixels moved every 40ms
  static const num ROT_SPEED = .1;
  static const num PROXIMITY = 5; //finger must be PROXIMITY from boat to move
  
  Boat(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    _boat = new Bitmap(_resourceManager.getBitmapData("BoatUp"));
    _boat.addEventListener(Event.ADDED, _bitmapLoaded);
    addChild(_boat);

    _newX = x;
    _newY = y;
    _mouseDownSubscription = this.onMouseDown.listen(_mouseDown);
  }
  
   void _bitmapLoaded(Event e) {
     pivotX = width/2;
     pivotY = height/2;
     
     _net = new Bitmap(_resourceManager.getBitmapData("Net"));
     _net.addEventListener(Event.ADDED, _netLoaded);
     addChild(_net);
   }
   
   void _netLoaded(Event e) {
     _net.x = x-_net.width/2+_boat.width/2;
     _net.y = y+_boat.height;
   }
   
   void animate() {
    if (_dragging && ((_newX-x).abs() > PROXIMITY || (_newY-y).abs() > PROXIMITY)) {
      num cx = _newX - x;
      num cy = _newY - y;
      num newAngle = math.atan2(cy, cx)+math.PI/2;
      _rotateTowards(newAngle);

      x = x+SPEED*math.sin(rotation);
      y = y-SPEED*math.cos(rotation);
    }
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
    _net.skewX = 0;
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
  
  void _rotateTowards(num angle) {
    num diff = angle-rotation;
    num newAngle;
    if (angle<0) newAngle = angle+2*math.PI-rotation;
    else newAngle = angle-2*math.PI-rotation;
    
    if (diff.abs() < newAngle.abs()) {
      if (diff.abs() < ROT_SPEED) {
        rotation = angle;
        _net.skewX = 0;
      } else if (diff > 0) {
        _turnRight();
      } else {
        _turnLeft();
      }
    } else {
      if (newAngle.abs() < ROT_SPEED) {
        rotation = angle;
        _net.skewX = 0;
      } else if (newAngle > 0) {
        _turnRight();
      } else {
        _turnLeft();
      }
    }
    if (rotation<-math.PI) rotation = rotation + 2*math.PI;
    if (rotation>math.PI) rotation = rotation - 2*math.PI; 
  }
  
  void _turnRight() {
    _net.skewX = 50;
    rotation = rotation + ROT_SPEED;
  }
  void _turnLeft() {
    _net.skewX = -50;
    rotation = rotation - ROT_SPEED;
  }
}