part of TOTC;

class Offseason extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Fleet _fleet;
  
  Circle _teamACircle, _teamBCircle;
  Bitmap _background;
  Sprite _offseasonDock;
  Map<int, Boat> _boatsA = new Map<int, Boat>();
  Map<int, Boat> _boatsB = new Map<int, Boat>();
  
  Offseason(ResourceManager resourceManager, Juggler juggler, Game game, Fleet fleet) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    _fleet = fleet;

    _background = new Bitmap(_resourceManager.getBitmapData("OffseasonBackground"));
    _background.width = _game.width;
    _background.height = _game.height;
    
    _offseasonDock = new Sprite();
    Bitmap dock = new Bitmap(_resourceManager.getBitmapData("OffseasonDock"));
    BitmapData.load('images/offseason_dock.png').then((bitmapData) {
      _offseasonDock.x = _game.width/2-bitmapData.width/2;
      _offseasonDock.y = _game.height/2-bitmapData.height/2;
    });
    
    int offset = 70;
    _teamACircle = new Circle(_resourceManager, _juggler, _game, true, _boatsA, _boatsB, _fleet);
    _teamBCircle = new Circle(_resourceManager, _juggler, _game, false, _boatsA, _boatsB, _fleet);
    _teamACircle.x = offset;
    _teamACircle.y = offset;
    _teamACircle.rotation = math.PI;
    _teamBCircle.x = _game.width-offset;
    _teamBCircle.y = _game.height-offset;
    
    _game.tlayer.touchables.add(_teamACircle);
    _game.tlayer.touchables.add(_teamBCircle);
    
    addChild(_background);
    addChild(_offseasonDock);
    addChild(_teamACircle);
    addChild(_teamBCircle);
    _offseasonDock.addChild(dock);
    
    _fillDocks();
  }
  
  void _fillDocks() {
    int aCounter = 0;
    int bCounter = 0;
    for (int i=0; i<_fleet.boats.length; i++) {
      Boat fleetBoat = _fleet.boats[i];
      Boat boat = new Boat(_resourceManager, _juggler, fleetBoat._type, _game, _fleet);
      if (fleetBoat._teamA == true) {
        _boatsA[i] = boat;
        if (aCounter==0) {
          boat.x = _offseasonDock.width/2-100;
          boat.y = _offseasonDock.height/2-135;
          boat.rotation = math.PI*4/5;
        } else if (aCounter==1) {
          boat.x = _offseasonDock.width/2-165;
          boat.y = _offseasonDock.height/2-10;
          boat.rotation = math.PI/2;
        } else if (aCounter==2) {
          boat.x = _offseasonDock.width/2-110;
          boat.y = _offseasonDock.height/2+110;
          boat.rotation = math.PI*2.7/8;
        }
        aCounter++;
      } else {
        _boatsB[i] = boat;
        if (bCounter==0) {
          boat.x = _offseasonDock.width/2+50;
          boat.y = _offseasonDock.height/2+70;
          boat.rotation = -math.PI/5;
        } else if (bCounter==1) {
          boat.x = _offseasonDock.width/2+95;
          boat.y = _offseasonDock.height/2-65;
          boat.rotation = -math.PI/2;
        } else if (bCounter==2) {
          boat.x = _offseasonDock.width/2+55;
          boat.y = _offseasonDock.height/2-175;
          boat.rotation = -math.PI*4/5;
        }
        bCounter++;
      }
      _offseasonDock.addChild(boat);
    }
  }
} 

class Circle extends Sprite implements Touchable {
  static const CAPACITY = 1;
  static const SPEED = 2;
  static const TUNA = 3;
  static const SARDINE = 4;
  static const SHARK = 5;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Fleet _fleet;
  Map<int, Boat> _boatsA, _boatsB;
  
  Bitmap _circle;
  SimpleButton _circleButton, _capacityButton, _speedButton, _tunaButton, _sardineButton, _sharkButton, _tempButton;
  
  bool _teamA;
  bool _upgradeMode = true;
  
  Tween _rotateTween;
  num _upgradeRotation;
  
  int _touchMode = 0;
  num _circleWidth;
  
  Boat _touchedBoat = null;
  
  Circle(ResourceManager resourceManager, Juggler juggler, Game game, bool teamA, Map<int, Boat> boatsA, Map<int, Boat> boatsB, Fleet fleet) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    _fleet = fleet;
    _teamA = teamA;
    _boatsA = boatsA;
    _boatsB = boatsB;
    
    if (teamA==true) _upgradeRotation = math.PI;
    else _upgradeRotation = 0;
    
    if (_teamA==true) _circle = new Bitmap(_resourceManager.getBitmapData("TeamACircle"));
    else _circle = new Bitmap(_resourceManager.getBitmapData("TeamBCircle"));
    
    _circleButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CircleButtonUp")), 
                                     new Bitmap(_resourceManager.getBitmapData("CircleButtonUp")),
                                     new Bitmap(_resourceManager.getBitmapData("CircleButtonDown")), 
                                     new Bitmap(_resourceManager.getBitmapData("CircleButtonDown")));
    _circleButton.addEventListener(MouseEvent.MOUSE_UP, _circlePressed);
    _circleButton.addEventListener(TouchEvent.TOUCH_TAP, _circlePressed);
    _circleButton.addEventListener(TouchEvent.TOUCH_BEGIN, _circlePressed);

    _capacityButton = _returnCapacityButton();
    _capacityButton.addEventListener(MouseEvent.MOUSE_DOWN, _capacityPressed);
    _capacityButton.addEventListener(TouchEvent.TOUCH_TAP, _capacityPressed);
    _capacityButton.addEventListener(TouchEvent.TOUCH_BEGIN, _capacityPressed);
    
    _speedButton = _returnSpeedButton();
    _speedButton.addEventListener(MouseEvent.MOUSE_DOWN, _speedPressed);
    _speedButton.addEventListener(TouchEvent.TOUCH_TAP, _speedPressed);
    _speedButton.addEventListener(TouchEvent.TOUCH_BEGIN, _speedPressed);
    
    _tunaButton = _returnTunaButton();
    _tunaButton.addEventListener(MouseEvent.MOUSE_DOWN, _tunaPressed);
    _tunaButton.addEventListener(TouchEvent.TOUCH_TAP, _tunaPressed);
    _tunaButton.addEventListener(TouchEvent.TOUCH_BEGIN, _tunaPressed);
    
    _sardineButton = _returnSardineButton();
    _sardineButton.addEventListener(MouseEvent.MOUSE_DOWN, _sardinePressed);
    _sardineButton.addEventListener(TouchEvent.TOUCH_TAP, _sardinePressed);
    _sardineButton.addEventListener(TouchEvent.TOUCH_BEGIN, _sardinePressed);
    
    _sharkButton = _returnSharkButton();
    _sharkButton.addEventListener(MouseEvent.MOUSE_DOWN, _sharkPressed);
    _sharkButton.addEventListener(TouchEvent.TOUCH_TAP, _sharkPressed);
    _sharkButton.addEventListener(TouchEvent.TOUCH_BEGIN, _sharkPressed);
    
    
    BitmapData.load('images/teamACircle.png').then((bitmapData) {
       _circle.pivotX = bitmapData.width/2;
       _circle.pivotY = bitmapData.height/2;
       
       num w = width/1.3;
       _capacityButton.x = math.cos(math.PI*9/8)*w;
       _capacityButton.y = math.sin(math.PI*9/8)*w;
       _speedButton.x = math.cos(math.PI*8/6)*w;
       _speedButton.y = math.sin(math.PI*8/6)*w;
       w = width/2;
       _tunaButton.x = math.cos(0)*w;
       _tunaButton.y = math.sin(0)*w;
       _sardineButton.x = math.cos(math.PI*1/6.5)*w;
       _sardineButton.y = math.sin(math.PI*1/6.5)*w;
       _sharkButton.x = math.cos(math.PI*2/6)*w;
       _sharkButton.y = math.sin(math.PI*2/6)*w;
     });
     BitmapData.load('images/circleUIButton.png').then((bitmapData) {
       _circleButton.pivotX = bitmapData.width/2;
       _circleButton.pivotY = bitmapData.height/2;
     });
    
    addChild(_circle);
    addChild(_circleButton);
    addChild(_speedButton);
    addChild(_capacityButton);
    addChild(_tunaButton);
    addChild(_sardineButton);
    addChild(_sharkButton);
  }
  
  void _circlePressed(var e) {
    if (_juggler.contains(_rotateTween)) _juggler.remove(_rotateTween);
    _rotateTween = new Tween(this, 1, TransitionFunction.easeOutBounce);
    if (_upgradeMode==true) {
      _upgradeMode = false;
      _rotateTween.animate.rotation.to(_upgradeRotation+math.PI);
    }
    else {
      _upgradeMode = true;
      _rotateTween.animate.rotation.to(_upgradeRotation);
    }
    _juggler.add(_rotateTween);
  }
  
  void _speedPressed(var e) {
    _touchMode = SPEED;
  }
  void _capacityPressed(var e) {
    _touchMode = CAPACITY;
  }
  void _tunaPressed(var e) {
    _touchMode = TUNA;
  }
  void _sardinePressed(var e) {
    _touchMode = SARDINE;
  }
  void _sharkPressed(var e) {
    _touchMode = SHARK;
  }
  SimpleButton _returnSpeedButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")),
                           new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SpeedUpgradeButton")));
  }
  SimpleButton _returnCapacityButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")),
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButton")));
  }
  SimpleButton _returnTunaButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")),
                            new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("TunaBoatButton")));
  }
  SimpleButton _returnSharkButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")),
                           new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")), 
                           new Bitmap(_resourceManager.getBitmapData("SharkBoatButton")));
  }
  SimpleButton _returnSardineButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")),
                            new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")), 
                            new Bitmap(_resourceManager.getBitmapData("SardineBoatButton")));
  }
  
  Boat _boatTouched() {print("called");
    if (_teamA==true) {
      _boatsA.forEach((int i, Boat b) {
        if (_tempButton.hitTestObject(b)) {
          return _fleet.boats[i];
        }
      });
    } else {
      _boatsB.forEach((int i, Boat b) {
        if (_tempButton.hitTestObject(b)) {print(_fleet.boats[i]);
          return _fleet.boats[i];
        }
      });
    }
    return null;
  }
  
  bool containsTouch(Contact event) {
    if (_touchMode == 0) return false;
    else return true;
  }
  
  bool touchDown(Contact event) {
    return true;
  }

  void touchDrag(Contact event) {
    _touchedBoat = null;
    if (contains(_tempButton)) removeChild(_tempButton);
    if (_touchMode == CAPACITY) _tempButton = _returnCapacityButton();
    if (_touchMode == SPEED) _tempButton = _returnSpeedButton();
    if (_touchMode == TUNA) _tempButton = _returnTunaButton();
    if (_touchMode == SARDINE) _tempButton = _returnSardineButton();
    if (_touchMode == SHARK) _tempButton = _returnSharkButton();
    addChild(_tempButton);
    
    if (_upgradeMode==true) {
      if (_teamA == true) {
        _tempButton.x = -event.touchX;
        _tempButton.y = -event.touchY;
      } else {
        _tempButton.x = -_game.width+event.touchX;
        _tempButton.y = -_game.height+event.touchY;
      }
    } else {
      num offset = width/6.5;
      if (_teamA == true) {
        _tempButton.x = event.touchX-offset;
        _tempButton.y = event.touchY-offset;
      } else {
        _tempButton.x = _game.width-event.touchX-offset;
        _tempButton.y = _game.height-event.touchY-offset;
      }
    }
    if (_teamA==true) {
      _boatsA.forEach((int i, Boat b) {
        if (_tempButton.hitTestObject(b.boat)) {
          _touchedBoat = _fleet.boats[i];
        }
      });
    } else {
      _boatsB.forEach((int i, Boat b) {
        if (_tempButton.hitTestObject(b.boat)) {
          _touchedBoat = _fleet.boats[i];
        }
      });
    }
    if (_touchedBoat != null) _tempButton.alpha = .5;
  }

  void touchSlide(Contact event) {
    // TODO: implement touchSlide
  }

  void touchUp(Contact event) {
    if (contains(_tempButton)) removeChild(_tempButton);
    
    if (_touchedBoat != null) {
      if (_touchMode != 0) {
        if (_touchMode==SPEED) _touchedBoat.increaseSpeed();
      }
    }
    _touchMode = 0;
  }
}