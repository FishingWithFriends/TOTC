part of TOTC;

class Boat extends Sprite implements Touchable, Animatable {
  
  static const num SPEED = 1.5; //pixels moved every 40ms
  static const num ROT_SPEED = .02;
  static const num PROXIMITY = 40; //finger must be PROXIMITY from boat to move
  static const num NET_CAPACITY = 500;
  static const int RIGHT = 0;
  static const int LEFT = 1;
  static const int STRAIGHT = 2;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Tween _boatMove;
  Tween _boatRotate;
  
  List<Fish> _fishes;
  Ecosystem _ecosystem;
  Fleet _fleet;
  
  int _type;
  int _netMoney;
  var random;
  
  Sprite boat;
  Bitmap _boatImage;
  Bitmap _net;
  Tween _netSkew;
  int _turnMode;
  
  Sprite netHitBox;
  int catchType;
  
  var _mouseDownSubscription;
  bool _dragging = false;
  num _newX, _newY;
  
  Boat(ResourceManager resourceManager, Juggler juggler, int type, Fleet f) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _type = type;
    _fleet = f;
    random = new math.Random();
    
    if (type==Fleet.TEAM1SARDINE || type==Fleet.TEAM2SARDINE) catchType = Ecosystem.SARDINE;
    
    netHitBox = new Sprite();
    addChild(netHitBox);
    _turnMode = STRAIGHT;
    
    boat = new Sprite();
    addChild(boat);
    _setBoatUp();
    _boatImage.addEventListener(Event.ADDED, _bitmapLoaded);
    boat.addChild(_boatImage);
    
    _newX = x;
    _newY = y;
    _mouseDownSubscription = boat.onMouseDown.listen(_mouseDown);
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
      _setNewLocation(newRot);
    }
    return true;
  }
  
  void _mouseDown(MouseEvent e) { _dragging = true; }
  bool containsTouch(Contact e) => _dragging;
   
  bool touchDown(Contact event) {
    _dragging = true;
    
    _newX = event.touchX;
    _newY = event.touchY;
    
    boat.removeChild(_boatImage);
    _setBoatDown();
    boat.addChild(_boatImage);

    return true;
  }
   
  void touchUp(Contact event) {
    _dragging = false;
    _goStraight();
    _juggler.remove(_boatMove);
    _juggler.remove(_boatRotate);
    boat.removeChild(_boatImage);
    
    _setBoatUp();
    boat.addChild(_boatImage);
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
    if (_type==Fleet.TEAM1SARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatAUp"));
    if (_type==Fleet.TEAM2SARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBUp"));
  }
  
  void _setBoatDown() {
    if (_type==Fleet.TEAM1SARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatADown"));
    if (_type==Fleet.TEAM2SARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBDown"));
  }
  
  void _setNewLocation(num rot) {
    num oldX = x;
    num oldY = y;
    x = x+SPEED*math.sin(rotation);
    y = y-SPEED*math.cos(rotation);
    for (int i=0; i<_fleet.boats.length; i++) {
      Boat b = _fleet.boats[i];
      if (b != this) {
        Point p1 = new Point(x+boat.width/2, y+boat.height/2);
        Point p2 = new Point(b.x+b.boat.width/2, b.y+b.boat.height/2);
        if (p1.distanceTo(p2)<PROXIMITY*2.4) {
          x = oldX;
          y = oldY;
        }
        return;
      }  
    }
    return;
  }

  void _turnRight() {
    if (_turnMode != RIGHT) {
      _turnMode = RIGHT;
      _juggler.remove(_netSkew);
      _netSkew = new Tween(_net, .75, TransitionFunction.easeInQuadratic);
      _netSkew.animate.skewX.to(.6);
      _juggler.add(_netSkew);
    }
  }
  void _turnLeft() {
    if (_turnMode != LEFT) {
      _turnMode = LEFT;
      _juggler.remove(_netSkew);
      _netSkew = new Tween(_net, .75, TransitionFunction.easeInQuadratic);
      _netSkew.animate.skewX.to(-.6);
      _juggler.add(_netSkew);
    }
  }
  void _goStraight() {
    if (_turnMode != STRAIGHT) {
      _turnMode = STRAIGHT;
      _juggler.remove(_netSkew);
      _netSkew = new Tween(_net, .75, TransitionFunction.easeInQuadratic);
      _netSkew.animate.skewX.to(0);
      _juggler.add(_netSkew);
    }
  }
}