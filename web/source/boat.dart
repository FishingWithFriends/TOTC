part of TOTC;

class Boat extends Sprite implements Touchable, Animatable {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Tween _boatMove;
  Tween _boatRotate;
  
  List<Fish> _fishes;
  Ecosystem _ecosystem;
  Fleet _fleet;
  
  int _type;
  int _netMoney;
  
  Bitmap boat;
  Bitmap _net;
  Tween _netSkew;
  
  Sprite netHitBox;
  
  var _mouseDownSubscription;
  bool _dragging = false;
  num _newX, _newY;
  
  static const num SPEED = 2; //pixels moved every 40ms
  static const num ROT_SPEED = .03;
  static const num PROXIMITY = 5; //finger must be PROXIMITY from boat to move
  static const num NET_CAPACITY = 500;
  
  Boat(ResourceManager resourceManager, Juggler juggler, int type, Fleet f) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _type = type;
    
    netHitBox = new Sprite();
    addChild(netHitBox);
    
    _setBoatUp();
    boat.addEventListener(Event.ADDED, _bitmapLoaded);
    addChild(boat);
    
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
     _net.x = x-_net.width/2+boat.width/2;
     _net.y = y+boat.height;
     
     var shape = new Shape();
     shape.graphics.rect(_net.x, _net.y+20, _net.width, 5);
     shape.graphics.fillColor(Color.Red);
     netHitBox.addChild(shape);
   }
   
   bool advanceTime(num time) {
    if (_dragging && ((_newX-x).abs() > PROXIMITY || (_newY-y).abs() > PROXIMITY)) {
      num cx = _newX - x;
      num cy = _newY - y;
      num newAngle = math.atan2(cy, cx)+math.PI/2;
      num newRot = Movement.rotateTowards(newAngle, ROT_SPEED, rotation);
      if ((newRot-rotation).abs() > ROT_SPEED/2) {
        if (newRot>rotation) _turnRight();
        if (newRot<rotation) _turnLeft();
      } else {
        _goStraight();
      }
      
      rotation = newRot;
      x = x+SPEED*math.sin(rotation);
      y = y-SPEED*math.cos(rotation);
    }
    return true;
  }
  
  void _mouseDown(MouseEvent e) { _dragging = true; }
  bool containsTouch(Contact e) => _dragging;
   
  bool touchDown(Contact event) {
    _dragging = true;
    
    removeChild(boat);
    _setBoatDown();
    addChild(boat);

    return true;
  }
   
  void touchUp(Contact event) {
    _dragging = false;
    _goStraight();
    _juggler.remove(_boatMove);
    _juggler.remove(_boatRotate);
    removeChild(boat);
    
    _setBoatUp();
    addChild(boat);
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
  
  void _increaseFishNet(int n) {
    
  }
  
  void _setBoatUp(){
    if (_type==Fleet.TEAM1SARDINE) boat = new Bitmap(_resourceManager.getBitmapData("BoatAUp"));
    if (_type==Fleet.TEAM2SARDINE) boat = new Bitmap(_resourceManager.getBitmapData("BoatBUp"));
  }
  
  void _setBoatDown() {
    if (_type==Fleet.TEAM1SARDINE) boat = new Bitmap(_resourceManager.getBitmapData("BoatADown"));
    if (_type==Fleet.TEAM2SARDINE) boat = new Bitmap(_resourceManager.getBitmapData("BoatBDown"));
  }

  void _turnRight() {
    _juggler.remove(_netSkew);
    _netSkew = new Tween(_net, 1.5, TransitionFunction.linear);
    _netSkew.animate.skewX.to(.4);
    _juggler.add(_netSkew);
  }
  void _turnLeft() {
    _juggler.remove(_netSkew);
    _netSkew = new Tween(_net, 1.5, TransitionFunction.linear);
    _netSkew.animate.skewX.to(-.4);
    _juggler.add(_netSkew);
  }
  void _goStraight() {
    _juggler.remove(_netSkew);
    _netSkew = new Tween(_net, 1.0, TransitionFunction.linear);
    _netSkew.animate.skewX.to(0);
    _juggler.add(_netSkew);
    }
}