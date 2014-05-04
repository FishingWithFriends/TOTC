part of TOTC;

class Boat extends Sprite implements Touchable, Animatable {

  static const num PROXIMITY = 75;
  static const int RIGHT = 0;
  static const int LEFT = 1;
  static const int STRAIGHT = 2;
  static const num BASE_SPEED = 3;
  static const num BASE_ROT_SPEED = .03;
  static const num BASE_NET_CAPACITY = 250;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Tween _boatMove;
  Tween _boatRotate;
  
  List<Fish> _fishes;
  Ecosystem _ecosystem;
  Fleet _fleet;
  Game _game;
  
  bool _teamA;
  
  Sprite _console;
  
  int _type;
  int _netMoney;
  int _netCapacity;
  
  var random;
  Dock _dock;
  
  num speedLevel;
  num capacityLevel;
  num speed;
  num rotSpeed;
  num netCapacityMax;
  
  Sprite boat;
  Bitmap _boatImage;
  
  Bitmap _tempNet;
  TextureAtlas _nets;
  var _netNames;
  Bitmap _net;
  Tween _netSkew;
  int _turnMode;
  
  Sprite netHitBox;
  Shape _netShapeHitBox;
  int catchType;
  bool canCatch;
  bool _canMove;
  bool _autoMove;
  bool _inDock;
  bool _canLoadConsole = false;
  bool _leavingDock;
  
  bool _showingFullPrompt = false;
  bool _showingPrompt = false;
  Bitmap _arrow;
  TextField _text, _fullText;
  
  bool _dragging = false;
  bool _touched = false;
  num _newX, _newY;
  
  Boat(ResourceManager resourceManager, Juggler juggler, int type, Game game, Fleet f) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _type = type;
    _fleet = f;
    _game = game;
    _nets = resourceManager.getTextureAtlas('Nets');
    random = new math.Random();
    
    _inDock = true;
    canCatch = false;
    _canMove = false;
    _autoMove = false;
    
    speedLevel = 0;
    capacityLevel = 0;
    speed = BASE_SPEED;
    rotSpeed = BASE_ROT_SPEED;
    netCapacityMax = BASE_NET_CAPACITY;
    
    if (type==Fleet.TEAMASARDINE || type==Fleet.TEAMBSARDINE) catchType = Ecosystem.SARDINE;
    if (type==Fleet.TEAMASARDINE) _teamA = true;
    else _teamA = false;
    
    _netNames = _nets.frameNames;
    netHitBox = new Sprite();
    addChild(netHitBox);
    _netMoney = 0;
    _netCapacity = 0;
    _turnMode = STRAIGHT;
    
    boat = new Sprite();
    addChild(boat);
    _setBoatUp();
    _boatImage.addEventListener(Event.ADDED, _bitmapLoaded);
    boat.addChild(_boatImage);
    
    _newX = x;
    _newY = y;
  }
  
  void setX(num newX) {
    x = newX;
  }
  void setY(num newY) {
    y = newY;
  }
  void setRot(num newRot) {
    rotation = newRot;
  }
  
   void _bitmapLoaded(Event e) {
     pivotX = width/2;
     pivotY = height/2;
     
     _net = new Bitmap(_nets.getBitmapData(_netNames[0]));
     _net.addEventListener(Event.ADDED, _netLoaded);
     
     addChildAt(_net, 0);
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
    if (_canMove == false) {
      _goStraight();
      return true;
    }
    if (_netCapacity > netCapacityMax) {
      canCatch = false;
      _leavingDock = false;
      _canMove = false;
      _goToDock();
      return true;
    }
    if (_dragging && !_inProximity(_newX, _newY, PROXIMITY*.8)) {
      _setNewLocation();
    } else {
      _goStraight();
    }
    return true;
  }
  
  void increaseSpeed() {
    speedLevel++;
    speed = BASE_SPEED + speedLevel;
    rotSpeed = BASE_ROT_SPEED + .01*speedLevel;
  }
  
  void increaseCapacity() {
    capacityLevel++;
    netCapacityMax = BASE_NET_CAPACITY + 100*capacityLevel;
  }
  
  void clearConsole() {
    if (_fleet.contains(_console)) _fleet.removeChild(_console);
  }
  
  void increaseFishNet(int n) {
    int worth;
    if (n==Ecosystem.SARDINE) worth = 5;
    if (n==Ecosystem.TUNA) worth = 20;
    if (n==Ecosystem.SHARK) worth = 100;
    _netMoney = _netMoney + worth;
    
    if (n==Ecosystem.SARDINE) _netCapacity = _netCapacity + 5;
    if (n==Ecosystem.TUNA) _netCapacity = _netCapacity + 15;
    if (n==Ecosystem.SHARK) _netCapacity = _netCapacity + 50;
    _changeNetGraphic();
  }

  void _changeNetGraphic() {
    num n = netCapacityMax/_netNames.length;
    num i = _netCapacity~/n;
    if (_netCapacity>0 && _netCapacity< n+1) i = 1;
    
    if (i<_netNames.length){
      removeChild(_net);
      
      _net = new Bitmap(_nets.getBitmapData(_netNames[i]));
      _net.addEventListener(Event.ADDED, _netLoaded);
      addChildAt(_net, 0);
    }
  }
  
  void _unloadNet() {
    _goStraight();
    _canMove = false;
    _autoMove = true;
    _inDock = true;
    canCatch = false;
    
    if (_teamA==true) _game.teamAMoney = _game.teamAMoney+_netMoney;
    else _game.teamBMoney = _game.teamBMoney+_netMoney;
    _game.moneyChanged = true;
    
    _tempNet = new Bitmap(_nets.getBitmapData(_netNames[0]));
    _tempNet.x = _net.x;
    _tempNet.y = _net.y;
    addChildAt(_tempNet, 0);
    
    Tween t = new Tween(_net, 2, TransitionFunction.linear);
    t.animate.alpha.to(0);
    t.onComplete = _netUnloaded;
    _juggler.add(t);
  }
  
  void _netUnloaded() {
    if (_fleet.contains(_tempNet)) removeChild(_tempNet);
    _netMoney = 0;
    _netCapacity = 0;
    _changeNetGraphic();
  }
  
  void _boatReady() {
    _goStraight();
    _inDock = false;
    _canMove = true;
    _autoMove = false;
    if (_dock != null) 
      _dock.filled = false;
    _dock = null;
  }
  
  void _leaveDock() {
    _leavingDock = true;
    _canMove = false;
    _autoMove = true;
    _inDock = false;
    canCatch = false;
    if (_teamA) {
      _moveTo(x, y+250, 1.25, 0, null);
      num newRot = Movement.findMinimumAngle(rotation, math.PI*3/4);
      _rotateTo(newRot, (rotation-newRot).abs()/1.25, 1.25, _boatReady);
    }
    else {
      _moveTo(x, y-250, 1.25, 0, null);
      num newRot = Movement.findMinimumAngle(rotation, -math.PI*1/4);
      _rotateTo(newRot, (rotation-newRot).abs()/1.25, 1.25, _boatReady);
    }
  }
  
  void fishingSeasonStart() {
    _inDock = true;
    canCatch = false;
    _canLoadConsole = false;
    clearConsole();
  }
  
  void returnToDock() {
    _juggler.removeTweens(this);
    if(_showingPrompt==true) _promptUserFinished();
    if (_dock != null) _dock.filled = false;
    _dock = null;
    
    Tween t1 = new Tween(this, 0, TransitionFunction.linear);
    t1.animate.alpha.to(0);
    _juggler.add(t1);
    
    _dock = _fleet.findEmptyDock(_teamA);
    Point frontOfDock = new Point(_dock.location.x, _dock.location.y);
    Tween t2 = new Tween(this, 0, TransitionFunction.linear);
    t2.animate.x.to(frontOfDock.x+5);
    t2.animate.y.to(frontOfDock.y);
    if (_teamA) {
      t2.animate.rotation.to(math.PI);
      t2.animate.y.to(frontOfDock.y+_fleet.dockHeight/2);
    }
    else { 
      t2.animate.rotation.to(0);
      t2.animate.y.to(frontOfDock.y-_fleet.dockHeight/2);
    }
    t2.delay = 0;
    t2.animate.alpha.to(1);
    t2.onComplete = _unloadNet;
    _juggler.add(t2);
  }
  
  void _setBoatUp(){
    if (_type==Fleet.TEAMASARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatAUp"));
    if (_type==Fleet.TEAMBSARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBUp"));
  }
  
  void _setBoatDown() {
    if (_type==Fleet.TEAMASARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatADown"));
    if (_type==Fleet.TEAMBSARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBDown"));
  }
  
  bool _setNewLocation() {
    num cx = _newX - x;
    num cy = _newY - y;
    num newAngle = math.atan2(cy, cx)+math.PI/2;
    num newRot = Movement.rotateTowards(newAngle, rotSpeed, rotation);
    if ((newRot-rotation).abs() > rotSpeed/2) {
      if (newRot>rotation) _turnRight();
      if (newRot<rotation) _turnLeft();
    } else {
      _goStraight();
    }
    num oldX = x;
    num oldY = y;
    
    rotation = newRot;
    x = x+speed*math.sin(rotation);
    y = y-speed*math.cos(rotation);
    
    if (_collisionDetected()) {
      x = oldX;
      y = oldY;
      rotation = Movement.rotateTowards(newAngle, rotSpeed, rotation);
      return true;
    } else {
      return true;
    }
  }
  
  bool _collisionDetected() {
    for (int i=0; i<_fleet.boats.length; i++) {
      Boat b = _fleet.boats[i];
      if (b != this) {
        if (_inProximity(b.x, b.y, PROXIMITY)) {
          return true;
        }
      }  
    }
    if ((x>0 && x<Fleet.DOCK_SEPARATION+Fleet.DOCK_SEPARATION*2 && y<_fleet.dockHeight*1.3 && y>0) ||
        (x<_game.width && x>_game.width-Fleet.DOCK_SEPARATION-Fleet.DOCK_SEPARATION*2 && y>_game.height-_fleet.dockHeight*1.3 && y<_game.height))
      return true;
    return false;
  }
  
  bool _inProximity(num myX, num myY, num p) {
    Point p1 = new Point(x, y);
    Point p2 = new Point(myX, myY);
    if (p1.distanceTo(p2)<p) return true;
    else return false;
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
  void _goToDock() {
    _autoMove = true;
    _dragging = false;
    _goStraight();
    _juggler.remove(_boatMove);
    _juggler.remove(_boatRotate);
    boat.removeChild(_boatImage);
    _setBoatUp();
    boat.addChild(_boatImage);
    
    num totalSeconds = 0;
    num nextX = x;
    num nextY = y;
    num nextRot = rotation;
    if ((_teamA == true && y<_fleet.dockHeight) ||
        (_teamA == false && y>_game.height-_fleet.dockHeight)) {
      Point aboveDockP;
      num newRot;
      if (_teamA) {
        aboveDockP = new Point(x, _fleet.dockHeight+80);
        newRot = math.PI;
      }
      else {
        aboveDockP = new Point(x, _game.height-_fleet.dockHeight-80);
        newRot = 0;
      }
      num secondsToRot = (rotation-newRot).abs()/rotSpeed/35;
      _rotateTo(newRot, secondsToRot, 0, null);
      
      num travelDistance = new Point(x, y).distanceTo(new Point(aboveDockP.x, aboveDockP.y));
      num secondsToMove = (travelDistance/speed).abs()/30;
      _moveTo(aboveDockP.x, aboveDockP.y, secondsToMove, secondsToRot, null);
      
      nextX = aboveDockP.x;
      nextY = aboveDockP.y;
      nextRot = newRot;
      totalSeconds = totalSeconds+secondsToRot+secondsToMove;
    }
    
    _dock = _fleet.findEmptyDock(_teamA);
    Point frontOfDock = new Point(_dock.location.x, _dock.location.y);
    if (_teamA) {
      frontOfDock.y = _fleet.dockHeight+80;
      frontOfDock.x = frontOfDock.x;
    }
    else {
      frontOfDock.y = _game.height-_fleet.dockHeight-80;
      frontOfDock.x = frontOfDock.x;
    }
    num cx = frontOfDock.x - nextX;
    num cy = frontOfDock.y - nextY;
    num newAngle = Movement.findMinimumAngle(nextRot, math.atan2(cy, cx)+math.PI/2);
    num secondsToRot = (nextRot-newAngle).abs()/rotSpeed/35;
    _rotateTo(newAngle, secondsToRot, totalSeconds, null);
    
    num travelDistance = new Point(nextX, nextY).distanceTo(new Point(frontOfDock.x, frontOfDock.y));
    num secondsToMove = (travelDistance/speed).abs()/30;
    _moveTo(frontOfDock.x, frontOfDock.y, secondsToMove, totalSeconds+secondsToRot, null);
    
    nextX = frontOfDock.x;
    nextY = frontOfDock.y;
    nextRot = newAngle;
    totalSeconds = totalSeconds+secondsToRot+secondsToMove;
    
    Point insideDock;
    if (_teamA) {
      insideDock = new Point(nextX+5, nextY-140);
      newAngle = 0;
    }
    else {
      insideDock = new Point(nextX+5, nextY+140);
      newAngle = math.PI;
    }
    newAngle = Movement.findMinimumAngle(nextRot, newAngle);
    secondsToRot = (nextRot-newAngle).abs()/rotSpeed/35;
    _rotateTo(newAngle, secondsToRot, totalSeconds, null);
    
    travelDistance = new Point(nextX, nextY).distanceTo(new Point(insideDock.x, insideDock.y));
    secondsToMove = (travelDistance/speed).abs()/30;
    _moveTo(insideDock.x, insideDock.y, secondsToMove, totalSeconds+secondsToRot, _unloadNet);
  }
  
  void _rotateTo(num newRot, num secondsToRot, num delay, var fnc) {
    Tween t1 = new Tween(this, secondsToRot, TransitionFunction.linear);
    t1.animate.rotation.to(newRot);
    t1.delay = delay;
    t1.onComplete = fnc;
    if (newRot>rotation) _turnLeft();
    else _turnRight();
    _juggler.add(t1);
  }
  
  void _moveTo(num newX, num newY, num secondsToMove, num delay, var fnc) {
    Tween t2 = new Tween(this, secondsToMove, TransitionFunction.linear);
    t2.delay = delay;
    t2.animate.x.to(newX);
    t2.animate.y.to(newY);
    if (fnc!=null) t2.onComplete = fnc;
    _juggler.add(t2);
  }
  
  void _promptUser() {
    if (_fleet.touchReminders>1 && _inDock==true && _showingPrompt==false) {
      _fleet.touchReminders--;
      _showingPrompt = true;
      
      _arrow = new Bitmap(_resourceManager.getBitmapData("Arrow"));
      TextFormat format = new TextFormat("Arial", 20, Color.Red, align: "left");
      _text = new TextField("Touch boat to begin!", format);
      _text.width = 200;
      
      if (_teamA==true) {
        _arrow.y = y+240;
        _arrow.x = x-80;
        _arrow.rotation = -math.PI/2;
        _text.x = x+90;
        _text.y = y+260;
        _text.rotation = math.PI;
      } else {
        _arrow.y = y-240;
        _arrow.x = x+80;
        _arrow.rotation = math.PI/2;
        _text.x = x-90;
        _text.y = y-260;
        _text.rotation = 0;
      }
      _fleet.addChild(_text);
      _fleet.addChild(_arrow);
    }
  }
  
  void _promptUserFinished() {
    _showingPrompt=false;
    Tween t = new Tween(_arrow, 1, TransitionFunction.linear);
    t.animate.alpha.to(0);
    _fleet._juggler.add(t);
    Tween t2 = new Tween(_text, 1, TransitionFunction.linear);
    t2.animate.alpha.to(0);
    _fleet._juggler.add(t2);
    t2.onComplete = _removePrompt;
  }
  
  void _removePrompt() {
    _showingPrompt = false;
    if (_fleet.contains(_text)) _fleet.removeChild(_text);
    if (_fleet.contains(_arrow)) _fleet.removeChild(_arrow);
  }
  
  void _promptBoatFull() {
    if (_showingFullPrompt==false) {
      _showingFullPrompt = true;

      TextFormat format = new TextFormat("Arial", 20, Color.LightYellow, align: "left");
      _fullText = new TextField("Your boat is full!", format);
      if (_leavingDock==true) _fullText.text = "Leaving dock!";
      _fullText.width = 200;

      if (_teamA==true) {
        _fullText.x = x+50;
        _fullText.y = y+75;
        _fullText.rotation = math.PI;
      } else {
        _fullText.x = x-50;
        _fullText.y = y-75;
        _fullText.rotation = 0;
      }
      _fleet.addChild(_fullText);
      Tween t2 = new Tween(_fullText, 1, TransitionFunction.linear);
      t2.animate.alpha.to(0);
      t2.onComplete = _promptBoatFullDone;
      _fleet._juggler.add(t2);
    }
  }
  
  void _promptBoatFullDone() {
    _showingFullPrompt = false;
    if (_fleet.contains(_fullText)) _fleet.removeChild(_fullText);
  }
   
  bool containsTouch(Contact e) {
    if (_inProximity(e.touchX, e.touchY, PROXIMITY)) {
      return true;
    } else {
      if (_game.phase==Game.FISHING_PHASE || _game.gameStarted == false) _promptUser();
      return false;
    }
  }
   
  bool touchDown(Contact event) {
    if (_inDock==true && _game.phase==Game.FISHING_PHASE) {
      _game.gameStarted = true;
      if(_showingPrompt==true) _promptUserFinished();
      _leaveDock();
      return true;
    }
    if (_canMove==true) {
      if(_showingPrompt==true) _promptUserFinished();
      canCatch = true;
      _newX = event.touchX;
      _newY = event.touchY;
      
      boat.removeChild(_boatImage);
      _setBoatDown();
      boat.addChild(_boatImage);
      _dragging = true;
    }
    if (canCatch==false && _canMove==false) _promptBoatFull();
    return true;
  }
   
  void touchUp(Contact event) {
    _dragging = false;
    canCatch = false;
    _goStraight();
    _juggler.remove(_boatMove);
    _juggler.remove(_boatRotate);
    boat.removeChild(_boatImage);
    
    _setBoatUp();
    boat.addChild(_boatImage);
  }
   
  void touchDrag(Contact event) {
    if (_canMove==true && _dragging==true) {
      _newX = event.touchX;
      _newY = event.touchY;
    }
  }
   
  void touchSlide(Contact event) { }
}