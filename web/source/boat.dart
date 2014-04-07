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
  
  TextureAtlas _nets;
  var _netNames;
  Bitmap _net;
  Tween _netSkew;
  int _turnMode;
  
  Sprite netHitBox;
  Shape _netShapeHitBox;
  int catchType;
  bool canCatch;
  bool _autoMove;
  
  var _mouseDownSubscription, _touchDownSubscription;
  bool _dragging = false;
  num _newX, _newY;
  
  Boat(ResourceManager resourceManager, Juggler juggler, int type, Fleet f) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _type = type;
    _fleet = f;
    _nets = resourceManager.getTextureAtlas('Nets');
    random = new math.Random();
    
    if (type==Fleet.TEAM1SARDINE || type==Fleet.TEAM2SARDINE) catchType = Ecosystem.SARDINE;
    
    _netNames = _nets.frameNames;
    
    netHitBox = new Sprite();
    addChild(netHitBox);
    canCatch = true;
    _netMoney = 0;
    _turnMode = STRAIGHT;
    _autoMove = false;
    
    boat = new Sprite();
    addChild(boat);
    _setBoatUp();
    _boatImage.addEventListener(Event.ADDED, _bitmapLoaded);
    boat.addChild(_boatImage);
    
    _newX = x;
    _newY = y;
    _mouseDownSubscription = boat.onMouseDown.listen(_mouseDown);
    _touchDownSubscription = boat.onTouchBegin.listen(_touchDown);
  }
  
   void _bitmapLoaded(Event e) {
     pivotX = width/2;
     pivotY = height/2;
     
     _net = new Bitmap(_nets.getBitmapData(_netNames[0]));
     _net.addEventListener(Event.ADDED, _netLoaded);
     
     addChild(_net);
   }
   
   void _netLoaded(Event e) {
     _setNetPos();
     if (_netShapeHitBox != null) netHitBox.removeChild(_netShapeHitBox);
     _netShapeHitBox = new Shape();
     _netShapeHitBox.graphics.rect(_net.x, _net.y+20, _net.width, 5);
     _netShapeHitBox.graphics.fillColor(Color.Transparent);
     netHitBox.addChild(_netShapeHitBox);
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
    } else {
      _goStraight();
    }
    if (canCatch == false && _autoMove == false) {
      //_goToDock();
    }
    return true;
  }
  
  void _mouseDown(MouseEvent e) { _dragging = true; }
  void _touchDown(TouchEvent e) { _dragging = true; }
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
  
  void increaseFishNet(int n) {
    int worth;
    if (n==Ecosystem.SARDINE) worth = 5;
    if (n==Ecosystem.TUNA) worth = 100;
    if (n==Ecosystem.SHARK) worth = 250;
    _netMoney = _netMoney + worth;
    
    if (_netMoney > NET_CAPACITY) {
      canCatch = false;
    }
    _changeNetGraphic();
  }
  
  void _goToDock() {
    canCatch = false;
    _autoMove = true;
    Point p1;
    if (_type == Fleet.TEAM1SARDINE) p1 = new Point(100-x, 100-y);
    if (_type == Fleet.TEAM2SARDINE) p1 = new Point(Game.WIDTH-100-x, Game.HEIGHT-100-y);
    
    num newAngle = math.atan2(p1.y, p1.x)+math.PI/2;
    num newRot = Movement.rotateTowards(newAngle, 100, rotation);
    num travelDistance = p1.distanceTo(new Point(x, y));
    num secondsToRot = ((newRot-rotation)/ROT_SPEED).abs()/50;
    num secondsToMove = (travelDistance/SPEED).abs()/50;
    if (newRot>rotation) _turnRight();
    if (newRot<rotation) _turnLeft();

    var t1 = new Tween(this, secondsToRot, TransitionFunction.linear);
    t1.animate.rotation.to(newRot);
    t1.onComplete = _goStraight;
    _juggler.add(t1);
    var t2 = new Tween(this, secondsToMove, TransitionFunction.linear);
    t2.delay = secondsToRot;
    t2.animate.x.to(p1.x+x);
    t2.animate.y.to(p1.y+y);
    t2.onComplete = _depositFishes;
    _juggler.add(t2);
  }
  
  void _changeNetGraphic() {
    num n = NET_CAPACITY/_netNames.length;
    num i = _netMoney~/n;
    if (_netMoney>0 && _netMoney< n+1) i = 1;
    
    if (i<_netNames.length){ 
      removeChild(_net);
      
      _net = new Bitmap(_nets.getBitmapData(_netNames[i]));
      _net.addEventListener(Event.ADDED, _netLoaded);
      
      addChild(_net);
    }
  }
  
  void _depositFishes() {
    _autoMove = false;
    canCatch = true;
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
  
  void _setNetPos() {
    _net.x = boat.width/2-_net.width/2;
    _net.y = boat.height-19;
  }

  void _turnRight() {
    if (_turnMode != RIGHT) {
      _turnMode = RIGHT;
      _juggler.remove(_netSkew);
      _netSkew = new Tween(_net, .75, TransitionFunction.easeInQuadratic);
      _netSkew.animate.skewX.to(.4);
      _juggler.add(_netSkew);
    }
  }
  void _turnLeft() {
    if (_turnMode != LEFT) {
      _turnMode = LEFT;
      _juggler.remove(_netSkew);
      _netSkew = new Tween(_net, .75, TransitionFunction.easeInQuadratic);
      _netSkew.animate.skewX.to(-.4);
      _juggler.add(_netSkew);
    }
  }
  void _goStraight() {
    if (_turnMode != STRAIGHT) {
      _turnMode = STRAIGHT;
      _juggler.remove(_netSkew);
      _netSkew = new Tween(_net, .75, TransitionFunction.easeOutQuadratic);
      _netSkew.animate.skewX.to(0);
      _juggler.add(_netSkew);
    }
  }
}