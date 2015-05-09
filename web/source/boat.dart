part of TOTC;

class Boat extends Sprite implements Touchable, Animatable {

  static const num PROXIMITY = 100;
  static const int RIGHT = 0;
  static const int LEFT = 1;
  static const int STRAIGHT = 2;
  static const num BASE_SPEED = 8;
  static const num BASE_ROT_SPEED = .09;
  static const num BASE_NET_CAPACITY = 25000;
  
  static const int SMALL_NET_SARDINE_CAPACITY = 100;
  static const int LARGE_NET_SARDINE_CAPACITY = 200;
  static const int SMALL_NET_TUNA_CAPACITY = 15;
  static const int LARGE_NET_TUNA_CAPACITY = 30;
  static const int SMALL_NET_SHARK_CAPACITY = 3;
  static const int LARGE_NET_SHARK_CAPACITY = 8;
  

  
  
  static const int SMALLNET = 0;
  static const int LARGENET = 1;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Tween _boatMove;
  Tween _boatRotate;
  
  List<Fish> _fishes;
  Ecosystem _ecosystem;
  Fleet _fleet;
  Game _game;
  
  bool _teamA;
  bool nothing = false;
  
  Sprite _console;
  
  int _type;
  int _netMoney;
  int _netCapacity;
  
  var random;
//  Dock _dock;
  
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
//  bool _inDock;
  bool _canLoadConsole = false;
//  bool _leavingDock;
  
  bool _showingFullPrompt = false;
  bool _showingPrompt = false;
  Bitmap _arrow;
  TextField _text, _fullText;
  
  bool _dragging = false;
  bool _touched = false;
  num _newX, _newY;
  
  bool offseasonBoat = false;
  
  var particleConfig;
  ParticleEmitter particleEmitter;
  
  int mapIndex = null;
  
  int netSize;
  
  Sound boatFullSound;
 
  Boat(ResourceManager resourceManager, Juggler juggler, int type, Game game, Fleet f, this.netSize) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _type = type;
    _fleet = f;
    _game = game;

    random = new math.Random();
    
    particleConfig = {
                      "maxParticles": 50,
                      "duration": 0,
                      "lifeSpan": 1.95,
                      "lifespanVariance": 0,
                      "startSize": 24,
                      "startSizeVariance": 20,
                      "finishSize": 70,
                      "finishSizeVariance": 0,
                      "shape": "circle",
                      "emitterType": 0,
                      "location": {
                        "x": 0,
                        "y": 0
                      },
                      "locationVariance": {
                        "x": 5,
                        "y": 0
                      },
                      "speed": 25,
                      "speedVariance": 0,
                      "angle": 90,
                      "angleVariance": 21,
                      "gravity": {
                        "x": 0,
                        "y": 0
                      },
                      "radialAcceleration": 0,
                      "radialAccelerationVariance": 0,
                      "tangentialAcceleration": 0,
                      "tangentialAccelerationVariance": 0,
                      "minRadius": 0,
                      "maxRadius": 100,
                      "maxRadiusVariance": 0,
                      "rotatePerSecond": 0,
                      "rotatePerSecondVariance": 0,
                      "compositeOperation": "source-over",
                      "startColor": {
                        "red": 0.9,
                        "green": 0.9,
                        "blue": 1,
                        "alpha": 0.25
                      },
                      "finishColor": {
                        "red": 0.9,
                        "green": 0.9,
                        "blue": 1,
                        "alpha": 0
                      }
                    };
    particleEmitter = new ParticleEmitter(particleConfig);
    
    
//    _inDock = true;
    canCatch = false;
    _canMove = true;
    _autoMove = false;
    
    speedLevel = 0;
    capacityLevel = 0;
    speed = BASE_SPEED;
    rotSpeed = BASE_ROT_SPEED;
    netCapacityMax = BASE_NET_CAPACITY;
    
    if (type==Fleet.TEAMASARDINE || type==Fleet.TEAMBSARDINE){
      catchType = Ecosystem.SARDINE;
      if(netSize == LARGENET){
        _nets = resourceManager.getTextureAtlas('sardineNets');
        netCapacityMax = LARGE_NET_SARDINE_CAPACITY;
      }
      else if(netSize == SMALLNET){
        _nets = resourceManager.getTextureAtlas('sardineNetsSmall');
        netCapacityMax = SMALL_NET_SARDINE_CAPACITY;
      }
    }
    if (type==Fleet.TEAMATUNA || type==Fleet.TEAMBTUNA){
      catchType = Ecosystem.TUNA;
      if(netSize == LARGENET){
        _nets = resourceManager.getTextureAtlas('tunaNets');
        netCapacityMax = LARGE_NET_TUNA_CAPACITY;
      }
      else if(netSize == SMALLNET){
        _nets = resourceManager.getTextureAtlas('tunaNetsSmall');
        netCapacityMax = SMALL_NET_TUNA_CAPACITY;
      }
    }
    if (type==Fleet.TEAMASHARK || type==Fleet.TEAMBSHARK){
      catchType = Ecosystem.SHARK;
      if(netSize == LARGENET){
        _nets = resourceManager.getTextureAtlas('sharkNets');
        netCapacityMax = LARGE_NET_SHARK_CAPACITY;
      }
      else if(netSize == SMALLNET){
        _nets = resourceManager.getTextureAtlas('sharkNetsSmall');
        netCapacityMax = SMALL_NET_SHARK_CAPACITY;
      }
    }
    if (type==Fleet.TEAMASARDINE || type==Fleet.TEAMATUNA || type==Fleet.TEAMASHARK) _teamA = true;
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
    particleEmitter.setEmitterLocation(x+boat.width/2, y+boat.height/2);
    
    boatFullSound = _resourceManager.getSound("boatFull");
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
//      _leavingDock = false;
      _canMove = false;
//      _goToDock();
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
    
    if (n==Ecosystem.SARDINE){
      _netCapacity = _netCapacity + 1;
      if(netSize == SMALLNET){
        if(_netCapacity > SMALL_NET_SARDINE_CAPACITY){
          _promptBoatFull();
        }
      }
      else{
        if(_netCapacity > LARGE_NET_SARDINE_CAPACITY){
          _promptBoatFull();
        }
      }
    }
    if (n==Ecosystem.TUNA){
      _netCapacity = _netCapacity + 1;
      if(netSize == SMALLNET){
        if(_netCapacity > SMALL_NET_TUNA_CAPACITY){
          _promptBoatFull();
        }
      }
      else{
        if(_netCapacity > LARGE_NET_TUNA_CAPACITY){
          _promptBoatFull();
        }
      }
    }
    if (n==Ecosystem.SHARK) {
      _netCapacity = _netCapacity + 1;
      if(netSize == SMALLNET){
        if(_netCapacity > SMALL_NET_SHARK_CAPACITY){
          _promptBoatFull();
        }
      }
      else{
        if(_netCapacity > LARGE_NET_SHARK_CAPACITY){
          _promptBoatFull();
        }
      }
    }
    
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
      
      if(_turnMode == LEFT){
        _net.skewX = -.4;
      }
      else if(_turnMode == RIGHT){
        _net.skewX = .4;
      }
      else if (_turnMode == STRAIGHT){

      }
      
    }
  }
  
  void _unloadNet() {
    _goStraight();
    _canMove = false;
    canCatch = false;
//    _autoMove = true;
//    _inDock = true;

    
    
    if (_teamA==true){
      _game.teamAMoney = _game.teamAMoney+_netMoney;
      _game.teamARoundProfit += _netMoney;
      _fleet.teamACaught += _netCapacity;
    }
    else{
      _game.teamBMoney = _game.teamBMoney+_netMoney;
      _game.teamBRoundProfit += _netMoney;
      _fleet.teamBCaught += _netCapacity;
    }
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
    canCatch = false;
    _canMove = true;
  }
  
  void _boatReady() {
    _goStraight();
//    _inDock = false;
    _canMove = true;
    canCatch = false;
    _autoMove = false;
  }
  
//  void _leaveDock() {
//    _leavingDock = true;
//    _canMove = false;
//    _autoMove = true;
//    _inDock = false;
//    canCatch = false;
//    if (_teamA) {
//      _moveTo(x, y+250, 1.25, 0, null);
//      num newRot = Movement.findMinimumAngle(rotation, math.PI*3/4);
//      _rotateTo(newRot, (rotation-newRot).abs()/1.25, 1.25, _boatReady);
//    }
//    else {
//      _moveTo(x, y-250, 1.25, 0, null);
//      num newRot = Movement.findMinimumAngle(rotation, -math.PI*1/4);
//      _rotateTo(newRot, (rotation-newRot).abs()/1.25, 1.25, _boatReady);
//    }
//  }
  
  void fishingSeasonStart() {
//    _inDock = true;
    canCatch = true;
    _canLoadConsole = false;
    clearConsole();
  }
  
//  void returnToDock() {
//    _juggler.removeTweens(this);
//    if(_showingPrompt==true) _promptUserFinished();
//       
//    Tween t1 = new Tween(this, 0, TransitionFunction.linear);
//    t1.animate.alpha.to(0);
//    _juggler.add(t1);
//    Point frontOfDock = new Point(0,0);
//    Tween t2 = new Tween(this, 0, TransitionFunction.linear);
//    t2.animate.x.to(frontOfDock.x+5);
//    t2.animate.y.to(frontOfDock.y);
//    if (_teamA) {
//      t2.animate.rotation.to(math.PI);
//      t2.animate.y.to(frontOfDock.y+_fleet.dockHeight/2);
//    }
//    else { 
//      t2.animate.rotation.to(0);
//      t2.animate.y.to(frontOfDock.y-_fleet.dockHeight/2);
//    }
//    t2.delay = 0;
//    t2.animate.alpha.to(1);
//    t2.onComplete = _unloadNet;
//    _juggler.add(t2);
//  }
  
  void _setBoatUp(){
    if (_type==Fleet.TEAMASARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatASardineUp"));
    if (_type==Fleet.TEAMBSARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBSardineUp"));
    if (_type==Fleet.TEAMATUNA) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatATunaUp"));
    if (_type==Fleet.TEAMBTUNA) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBTunaUp"));
    if (_type==Fleet.TEAMASHARK) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatASharkUp"));
    if (_type==Fleet.TEAMBSHARK) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBSharkUp"));
  }
  
  void _setBoatDown() {
    if (_type==Fleet.TEAMASARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatASardineDown"));
    if (_type==Fleet.TEAMBSARDINE) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBSardineDown"));
    if (_type==Fleet.TEAMATUNA) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatATunaDown"));
    if (_type==Fleet.TEAMBTUNA) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBTunaDown"));
    if (_type==Fleet.TEAMASHARK) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatASharkDown"));
    if (_type==Fleet.TEAMBSHARK) _boatImage = new Bitmap(_resourceManager.getBitmapData("BoatBSharkDown"));
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
    
//    if (_collisionDetected()) {
//      x = oldX;
//      y = oldY;
//      rotation = Movement.rotateTowards(newAngle, rotSpeed, rotation);
//      return true;
//    } else {
//      return true;
//    }
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
//    if ((x>0 && x<Fleet.DOCK_SEPARATION+Fleet.DOCK_SEPARATION*2 && y<_fleet.dockHeight*1.3 && y>0) ||
//        (x<_game.width && x>_game.width-Fleet.DOCK_SEPARATION-Fleet.DOCK_SEPARATION*2 && y>_game.height-_fleet.dockHeight*1.3 && y<_game.height))
//      return true;
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
    if (_fleet.touchReminders>=1 && _showingPrompt==false) {
      _fleet.touchReminders--;
      _showingPrompt = true;
      
      _arrow = new Bitmap(_resourceManager.getBitmapData("Arrow"));
      _arrow.alpha = .6;
      _arrow.pivotX = _arrow.width/2;
      _arrow.pivotY = _arrow.height/2;

      
      if (_teamA==true) {
        _arrow.y = this.y + this.y/3;//100*math.sin(math.atan2(this.y, this.x));
        _arrow.x = this.x + this.x/3;//100*math.cos(math.atan2(this.y, this.x));
        _arrow.rotation = -math.PI/2 + this.rotation + math.PI;

      } else {
        _arrow.y =  this.y - this.y/12;
        _arrow.x =  this.x - this.x/10+20;
        _arrow.rotation = math.PI/2+ this.rotation;

      }
      _fleet.addChild(_arrow);
    }
  }
  
  void _promptUserFinished() {
    _showingPrompt=false;
    Tween t = new Tween(_arrow, 1, TransitionFunction.linear);
    t.animate.alpha.to(0);
    _fleet._juggler.add(t);
    t.onComplete = _removePrompt;
  }
  
  void _removePrompt() {
    _showingPrompt = false;
    if (contains(_arrow)) _fleet.removeChild(_arrow);
  }
  
  void _promptBoatFull() {
    boatFullSound.play();
    if (_showingFullPrompt==false) {
      _showingFullPrompt = true;
      print("trying to be full");
      TextFormat format = new TextFormat("Arial", 20, Color.LightYellow, align: "left");
      _fullText = new TextField("Your boat is full!", format);
//      if (_leavingDock==true) _fullText.text = "Leaving dock!";
      _fullText.width = 200;
      _fullText.alpha = 1;

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
      Tween t2 = new Tween(_fullText, 1.5, TransitionFunction.linear);
      t2.animate.alpha.to(0);
      t2.onComplete = _promptBoatFullDone;
      _fleet._juggler.add(t2);
    }
  }
  
  void _promptBoatFullDone() {
    _showingFullPrompt = false;
    if (_fleet.contains(_fullText)) _fleet.removeChild(_fullText);
  }
  
  void smallCap(){
    netSize = SMALLNET;
    if (_type==Fleet.TEAMASARDINE || _type==Fleet.TEAMBSARDINE){
      _nets = _resourceManager.getTextureAtlas('sardineNetsSmall');
      netCapacityMax = SMALL_NET_SARDINE_CAPACITY;
    }
    if (_type==Fleet.TEAMATUNA || _type==Fleet.TEAMBTUNA){
      _nets = _resourceManager.getTextureAtlas('tunaNetsSmall');
      netCapacityMax = SMALL_NET_TUNA_CAPACITY;
    }
    if (_type==Fleet.TEAMASHARK || _type==Fleet.TEAMBSHARK){
      _nets = _resourceManager.getTextureAtlas('sharkNetsSmall');
      netCapacityMax = SMALL_NET_SHARK_CAPACITY;
    }
    _netNames = _nets.frameNames;
    _changeNetGraphic();
    return;
  }
  
  void largeCap(){
    netSize = LARGENET;
    
    if (_type==Fleet.TEAMASARDINE || _type==Fleet.TEAMBSARDINE){
      _nets = _resourceManager.getTextureAtlas('sardineNets');
      netCapacityMax = LARGE_NET_SARDINE_CAPACITY;
    }
    if (_type==Fleet.TEAMATUNA || _type==Fleet.TEAMBTUNA){
      _nets = _resourceManager.getTextureAtlas('tunaNets');
      netCapacityMax = LARGE_NET_TUNA_CAPACITY;
    }
    if (_type==Fleet.TEAMASHARK || _type==Fleet.TEAMBSHARK){
      _nets = _resourceManager.getTextureAtlas('sharkNets');
      netCapacityMax = LARGE_NET_SHARK_CAPACITY;
    }
    _netNames = _nets.frameNames;
    _changeNetGraphic();
    return;  
  }
  
   
  bool containsTouch(Contact e) {
    
    if(_game.phase == Game.TITLE_PHASE){
      return false;
    }
    if (nothing==false && !offseasonBoat) {
      if (_inProximity(e.touchX, e.touchY, PROXIMITY)) {
        return true;
      } else {
        if (_game.phase==Game.FISHING_PHASE || _game.gameStarted == false);
        return false;
      }
    } //else return false;
    
    if(offseasonBoat){
      if (_inProximity(e.touchX, e.touchY, PROXIMITY)) {
        return true;
      }
      else{
        return false;
      }
    }
    else return false;
  }
   
  bool touchDown(Contact event) {
    
//    if(offseasonBoat){
//          if(_teamA){
//            if(!_game._offseason._teamACircle._boxDisplayed){
//              x = event.touchX;
//              y = event.touchY;
//            }
//
//          }
//          else{
//            if(!_game._offseason._teamBCircle._boxDisplayed){
//              x = event.touchX;
//              y = event.touchY;
//            }
//          }
//        
//        }
//    else{
    
      if (!_game.gameStarted && _game.phase==Game.FISHING_PHASE) {
        _game.gameStarted = true;
        if(_showingPrompt==true) _promptUserFinished();
  //      _leaveDock();
  //      return true;
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
        
//        addChild(particleEmitter);
//        swapChildren(boat, particleEmitter);
//        _juggler.add(particleEmitter);
        
      }
      if (canCatch==false && _canMove==false) _promptBoatFull();

//    }

    
    return true;
  }
   
  void touchUp(Contact event) {
    _dragging = false;
    
//    if(offseasonBoat){
//      
//      if( _inProximity(_game._offseason.sellIslandTop.x, _game._offseason.sellIslandTop.y, _game._offseason.sellIslandTop.width)
//          ||  _inProximity(_game._offseason.sellIslandBottom.x, _game._offseason.sellIslandBottom.y, _game._offseason.sellIslandBottom.width)){
//        _game._offseason.sellBoat(this);
//      }
//      else{
//        Tween t1 = new Tween(this, .25, TransitionFunction.easeInOutQuadratic);
//        t1.animate.x.to(_newX);
//        t1.animate.y.to(_newY);
//        _juggler.add(t1);
//      }
//    }
//    else{
      canCatch = false;
      _goStraight();
      _juggler.remove(_boatMove);
      _juggler.remove(_boatRotate);
      boat.removeChild(_boatImage);
      
//      if(contains(particleEmitter)) removeChild(particleEmitter);
//      _juggler.remove(particleEmitter);
      
      _setBoatUp();
      boat.addChild(_boatImage);
//    }
    

  }
   
  void touchDrag(Contact event) {
    if (_canMove==true && _dragging==true) {
      _newX = event.touchX;
      _newY = event.touchY;
    }
    
//    if(offseasonBoat){
//      if(_teamA){
//        if(!_game._offseason._teamACircle._boxDisplayed){
//          x = event.touchX;
//          y = event.touchY;
//        }
//
//      }
//      else{
//        if(!_game._offseason._teamBCircle._boxDisplayed){
//          x = event.touchX;
//          y = event.touchY;
//        }
//      }
//    
//    }
  }
   
  void touchSlide(Contact event) { }
}