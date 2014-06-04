part of TOTC;

class Offseason extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Fleet _fleet;
  
  Circle _teamACircle, _teamBCircle;
  Bitmap _background;
  Sprite offseasonDock;
  Sprite teamAHit, teamBHit;
  Map<int, Boat> _boatsA = new Map<int, Boat>();
  Map<int, Boat> _boatsB = new Map<int, Boat>();
  
  Bitmap dock;
  Bitmap sellIslandTop;
  Bitmap sellIslandBottom;
  
  Sound sellBoatSound;
  
  List<Boat> offseasonBoats = new List<Boat>();
  
  Offseason(ResourceManager resourceManager, Juggler juggler, Game game, Fleet fleet) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    _fleet = fleet;

    _background = new Bitmap(_resourceManager.getBitmapData("OffseasonBackground"));
    _background.width = _game.width;
    _background.height = _game.height;
    
    int offset = 70;
    _teamACircle = new Circle(_resourceManager, _juggler, _game, true, _boatsA, _boatsB, _fleet, this);
    _teamBCircle = new Circle(_resourceManager, _juggler, _game, false, _boatsA, _boatsB, _fleet, this);
    _teamACircle.x = offset;
    _teamACircle.y = offset;
    _teamACircle.rotation = math.PI;
    _teamACircle.alpha = 0;
    _teamBCircle.x = _game.width-offset;
    _teamBCircle.y = _game.height-offset;
    _teamBCircle.alpha = 0;
    
    _game.tlayer.touchables.add(_teamBCircle);
    _game.tlayer.touchables.add(_teamACircle);
    
    offseasonDock = new Sprite();
    dock = new Bitmap(_resourceManager.getBitmapData("OffseasonDock"));
    BitmapData.load('images/offseason_dock.png').then((bitmapData) {
      offseasonDock.x = _game.width/2-bitmapData.width/2;
      offseasonDock.y = _game.height/2-bitmapData.height/2;
    });
    
    sellIslandTop = new Bitmap(_resourceManager.getBitmapData("sellIsland"));
    sellIslandTop..x = _game.width/2 + 350
                 ..y = _game.height/2-350
                 ..alpha = 0;
    
    sellIslandBottom = new Bitmap(_resourceManager.getBitmapData("sellIsland"));
    sellIslandBottom..x = _game.width/2 - 350
                 ..y = _game.height/2 + 350
                 ..alpha = 0;
                     
    sellBoatSound = _resourceManager.getSound("chaChing");
    
    addChild(offseasonDock);
    offseasonDock.addChild(dock);
    clearAndRefillDock();
    
    addChild(_background);
//    addChild(sellIslandTop);
//    addChild(sellIslandBottom);
    addChild(offseasonDock);
    addChild(_teamACircle);
    addChild(_teamBCircle);

  }
  
  void clearAndRefillDock() {
//    if (offseasonDock.numChildren>1) offseasonDock.removeChildren(1, offseasonDock.numChildren-1);
    for(int i = 0; i < offseasonBoats.length; i++){
      if(contains(offseasonBoats[i])) removeChild(offseasonBoats[i]);
    }
    offseasonBoats.clear();
    fillDocks();
//    arrangeUICircle();
  }
  
  void arrangeUICircle(){
    if(contains(_teamACircle)) removeChild(_teamACircle);
    if(contains(_teamBCircle)) removeChild(_teamBCircle);
    
    addChild(_teamACircle);
    addChild(_teamBCircle);
  }
  
  void showCircles() {
    
    Tween t1 = new Tween(_teamACircle, .5, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    _juggler.add(t1);
    
    Tween t2 = new Tween(_teamBCircle, .5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
    
    Tween t3 = new Tween(sellIslandTop, .5, TransitionFunction.linear);
    t3.animate.alpha.to(1);
    _juggler.add(t3);
    
    Tween t4 = new Tween(sellIslandBottom, .5, TransitionFunction.linear);
    t4.animate.alpha.to(1);
    _juggler.add(t4);
  }
  
  void hideCircles() {
    
    Tween t1 = new Tween(_teamACircle, .5, TransitionFunction.linear);
    t1.animate.alpha.to(0);
    _juggler.add(t1);
    
    Tween t2 = new Tween(_teamBCircle, .5, TransitionFunction.linear);
    t2.animate.alpha.to(0);
    _juggler.add(t2);
  }
  
  void fillDocks() {
    teamAHit = new Sprite();
    teamBHit = new Sprite();
    Shape aHit = new Shape();
    Shape bHit = new Shape();
    
    teamAHit.x = 0;
    teamAHit.y = 0;
    teamBHit.x = offseasonDock.width/2;
    teamBHit.y = 0;
    aHit.graphics.rect(0, 0, offseasonDock.width/2, offseasonDock.height);
    bHit.graphics.rect(0, 0, offseasonDock.width/2, offseasonDock.height);
    aHit.graphics.fillColor(Color.Transparent);
    bHit.graphics.fillColor(Color.Transparent);
    teamAHit.addChild(aHit);
    teamBHit.addChild(bHit);
    
    BitmapData.load('images/boat_sardine_a.png').then((sardineBoat) {
      BitmapData.load('images/boat_tuna_a.png').then((tunaBoat) {
        BitmapData.load('images/boat_shark_a.png').then((sharkBoat) {
          int aCounter = 0;
          int bCounter = 0;
          num w = _game.width;
          num h = _game.height;
          for (int i=0; i<_fleet.boats.length; i++) {
            Boat fleetBoat = _fleet.boats[i];
            Boat boat = new Boat(_resourceManager, _juggler, fleetBoat._type, _game, _fleet);
            offseasonBoats.add(boat);
            boat.offseasonBoat = true;
            boat.mapIndex = i;
            if (fleetBoat._teamA == true) {
              _boatsA[i] = boat;
              if (fleetBoat._type==Fleet.TEAMASARDINE||fleetBoat._type==Fleet.TEAMBSARDINE) {
                boat.pivotX = sardineBoat.width/2;
                boat.pivotY = sardineBoat.height/2;
              } else if (fleetBoat._type==Fleet.TEAMATUNA||fleetBoat._type==Fleet.TEAMBTUNA) {
                boat.pivotX = tunaBoat.width/2;
                boat.pivotY = tunaBoat.height/2;
              } else if (fleetBoat._type==Fleet.TEAMASHARK||fleetBoat._type==Fleet.TEAMBSHARK) {
                boat.pivotX = sharkBoat.width/2;
                boat.pivotY = sharkBoat.height/2;
              }
              if (aCounter==0) {
                boat.x = w/2-95;
                boat.y = h/2-120;
                boat._newX = w/2-95;
                boat._newY = h/2-120;
                boat.rotation = math.PI*4/5;
              } else if (aCounter==1) {
                boat.x = w/2-150;
                boat.y = h/2-5;
                boat._newX = w/2-150;
                boat._newY = h/2-5;
                boat.rotation = math.PI/2;
              } else if (aCounter==2) {
                boat.x = w/2-85;
                boat.y = h/2 + 115;
                boat._newX = w/2-85;
                boat._newY = h/2+115;
                boat.rotation = math.PI*1/6;
              }
              aCounter++;
            } else {
              _boatsB[i] = boat;
              if (bCounter==0) {
                boat.x = w/2+65;
                boat.y = h/2+100;
                boat._newX = w/2+65;
                boat._newY = h/2+100;
                boat.rotation = -math.PI/5;
              } else if (bCounter==1) {
                boat.x = w/2+120;
                boat.y = h/2+0;
                boat._newX = w/2+120;
                boat._newY = h/2+0;
                boat.rotation = -math.PI/2;
              } else if (bCounter==2) {
                boat.x = w/2+70;
                boat.y = h/2-115;
                boat._newX = w/2+70;
                boat._newY = h/2-115;
                boat.rotation = -math.PI*4/5;
              }
              bCounter++;
            }
            _game.tlayer.touchables.add(boat);
//            offseasonDock.addChild(boat);
            int index = getChildIndex(offseasonDock)+1;
            addChildAt(boat, index+i);
          }
        });
      });
    });
    offseasonDock.addChild(teamAHit);
    offseasonDock.addChild(teamBHit);
  }
  
  void sendBoatsToFish(){
    for(int i = 0; i < offseasonBoats.length; i++){
      Tween t1 = new Tween(offseasonBoats[i], .25, TransitionFunction.linear);
      t1.animate.rotation.to(math.PI);
      _juggler.add(t1);
      
      Tween t2 = new Tween(offseasonBoats[i], 1.25, TransitionFunction.easeInQuadratic);
      t2.animate.y.to(_game.height+100);
      t2.onComplete = hideBoats;
      _juggler.add(t2);
      
    }
    
  }
  
  void hideBoats(){
    for(int i = 0; i < offseasonBoats.length; i++){
      offseasonBoats[i].alpha = 0;
    }
  }
  
  
  void sellBoat(Boat boat){
    int index;
    if(boat._teamA == true){
      _boatsA.forEach((int i, Boat b){
        if(b == boat){
          index = i;

        }
      });
      _boatsA.remove(index);
    }
    else{
      _boatsB.forEach((int i, Boat b){
              if(b == boat){
                index = i;

              }
            });
      _boatsB.remove(index);
    }
    sellBoatSound.play();
    _fleet.sellBoat(index);
    offseasonBoats.remove(boat);
    if(contains(boat)) removeChild(boat);
    clearAndRefillDock();
  }
  
} 

class Circle extends Sprite implements Touchable {
  static const CAPACITY = 1;
  static const SPEED = 2;
  static const TUNA = 3;
  static const SARDINE = 4;
  static const SHARK = 5;
  static const OKAY = 6;
  static const CONFIRM = 7;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Fleet _fleet;
  Offseason _offseason;
  Map<int, Boat> _boatsA, _boatsB;
  
  Bitmap _circle;
  SimpleButton _circleButton, _capacitySmallButton, _capacityLargeButton, _tunaButton, _sardineButton, _sharkButton, _tempButton;
  SimpleButton _yesButton;
  SimpleButton _noButton;
  TextField _confirmText;
  Sprite _box;
  
  TextField pushA, pushB;
  
  Sound clicked;
  Sound swoosh;
  Sound buySplash;
  Sound itemSuction;
  
  bool _teamA;
  bool _teamAA;
  bool _upgradeMode = true;
  
  Tween _rotateTween;
  Tween _rotateTween2;
  num _upgradeRotation;
  
  int _touchMode = 0;
  num _circleWidth;
  
  Boat _touchedBoat = null;
  int _confirmMode = 0;
  int _boxConfirmMode = 0;
  bool _boxUp = false;
  num _boxX, _boxY;
  bool _boxDisplayed = false;
  
  Circle(ResourceManager resourceManager, Juggler juggler, Game game, bool teamA, Map<int, Boat> boatsA, Map<int, Boat> boatsB, Fleet fleet, Offseason offseason) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    _offseason = offseason;
    _fleet = fleet;
    _teamA = teamA;
    _boatsA = boatsA;
    _boatsB = boatsB;
    
    clicked = _resourceManager.getSound("buttonClick");
    swoosh = _resourceManager.getSound("circleUISwoosh");
    buySplash = _resourceManager.getSound("buySplash");
    itemSuction = _resourceManager.getSound("itemSuction");
    
    if (teamA==true) _upgradeRotation = math.PI;
    else _upgradeRotation = 0;
    
    if (_teamA==true){
      _circle = new Bitmap(_resourceManager.getBitmapData("TeamACircle"));
      _circleButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CircleButtonUpA")), 
                                       new Bitmap(_resourceManager.getBitmapData("CircleButtonUpA")),
                                       new Bitmap(_resourceManager.getBitmapData("CircleButtonDownA")), 
                                       new Bitmap(_resourceManager.getBitmapData("CircleButtonDownA")));
      
      BitmapData.load('images/circleUIButtonA.png').then((bitmapData) {
        _circleButton.pivotX = bitmapData.width/2;
        _circleButton.pivotY = bitmapData.height/2;
        _circleButton.rotation = 7*math.PI/4;
      });
    }
    else {
      _circle = new Bitmap(_resourceManager.getBitmapData("TeamBCircle"));
      _circleButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CircleButtonUpB")), 
                                       new Bitmap(_resourceManager.getBitmapData("CircleButtonUpB")),
                                       new Bitmap(_resourceManager.getBitmapData("CircleButtonDownB")), 
                                       new Bitmap(_resourceManager.getBitmapData("CircleButtonDownB")));
      
      BitmapData.load('images/circleUIButtonB.png').then((bitmapData) {
        _circleButton.pivotX = bitmapData.width/2;
        _circleButton.pivotY = bitmapData.height/2;
        _circleButton.rotation = -math.PI/4;
      });
    
    }

    _circleButton.addEventListener(MouseEvent.MOUSE_UP, _circlePressed);
    _circleButton.addEventListener(TouchEvent.TOUCH_TAP, _circlePressed);
    _circleButton.addEventListener(TouchEvent.TOUCH_BEGIN, _circlePressed);

    _capacitySmallButton = _returnCapacityButton();
    _capacitySmallButton.alpha = 1;
    _capacitySmallButton.addEventListener(MouseEvent.MOUSE_DOWN, _capacitySmallButtonPressed);
    _capacitySmallButton.addEventListener(TouchEvent.TOUCH_TAP, _capacitySmallButtonPressed);
    _capacitySmallButton.addEventListener(TouchEvent.TOUCH_BEGIN, _capacitySmallButtonPressed);
    
    _capacityLargeButton = _returnCapacityButtonLarge();
    _capacityLargeButton.alpha = 1;
    _capacityLargeButton.addEventListener(MouseEvent.MOUSE_DOWN, _capacityLargeButtonPressed);
    _capacityLargeButton.addEventListener(TouchEvent.TOUCH_TAP, _capacityLargeButtonPressed);
    _capacityLargeButton.addEventListener(TouchEvent.TOUCH_BEGIN, _capacityLargeButtonPressed);
    
    _tunaButton = _returnTunaButton();
    _tunaButton.alpha = 1;
    _tunaButton.addEventListener(MouseEvent.MOUSE_DOWN, _tunaPressed);
    _tunaButton.addEventListener(TouchEvent.TOUCH_TAP, _tunaPressed);
    _tunaButton.addEventListener(TouchEvent.TOUCH_BEGIN, _tunaPressed);
    
    _sardineButton = _returnSardineButton();
    _sardineButton.alpha = 1;
    _sardineButton.addEventListener(MouseEvent.MOUSE_DOWN, _sardinePressed);
    _sardineButton.addEventListener(TouchEvent.TOUCH_TAP, _sardinePressed);
    _sardineButton.addEventListener(TouchEvent.TOUCH_BEGIN, _sardinePressed);
    
    _sharkButton = _returnSharkButton();
    _sharkButton.alpha = 1;
    _sharkButton.addEventListener(MouseEvent.MOUSE_DOWN, _sharkPressed);
    _sharkButton.addEventListener(TouchEvent.TOUCH_TAP, _sharkPressed);
    _sharkButton.addEventListener(TouchEvent.TOUCH_BEGIN, _sharkPressed);
    
    BitmapData.load('images/teamACircle.png').then((bitmapData) {
       _circle.pivotX = bitmapData.width/2;
       _circle.pivotY = bitmapData.height/2;
       
       num w = bitmapData.width*.375;
       _capacitySmallButton.x = math.cos(math.PI*9/8)*w;
       _capacitySmallButton.y = math.sin(math.PI*9/8)*w;
       _capacityLargeButton.x = math.cos(math.PI*8/6)*w;
       _capacityLargeButton.y = math.sin(math.PI*8/6)*w;
       w = width*.1875;
       _sardineButton.x = math.cos(-math.PI*1/16)*w;
       _sardineButton.y = math.sin(-math.PI*1/16)*w;
       _tunaButton.x = math.cos(math.PI*1.5/6)*w;
       _tunaButton.y = math.sin(math.PI*1.5/6)*w;
       _sharkButton.x = math.cos(math.PI*3.75/6)*w;
       _sharkButton.y = math.sin(math.PI*3.75/6)*w;
     });

    
    addChild(_circle);
    addChild(_circleButton);
    addChild(_capacityLargeButton);
    addChild(_capacitySmallButton);
    addChild(_tunaButton);
    addChild(_sardineButton);
    addChild(_sharkButton);
  }
  
  void _circlePressed(var e) {
    if (_juggler.contains(_rotateTween)) _juggler.remove(_rotateTween);
    if (_juggler.contains(_rotateTween2)) _juggler.remove(_rotateTween2);
    _rotateTween = new Tween(this, .6, TransitionFunction.easeOutBounce);
    _rotateTween2 = new Tween(_circleButton, .6, TransitionFunction.easeOutBounce);
    if (_upgradeMode==true) {
      _upgradeMode = false;
      _rotateTween.animate.rotation.to(_upgradeRotation+math.PI);
      _rotateTween2.animate.rotation.by(-math.PI);
    }
    else {
      _upgradeMode = true;
      _rotateTween.animate.rotation.to(_upgradeRotation);
      _rotateTween2.animate.rotation.by(math.PI);
    }
    _juggler.add(_rotateTween);
    _juggler.add(_rotateTween2);
    swoosh.play();
  }
  
  void _capacityLargeButtonPressed(var e) {
    _touchMode = SPEED;
    _fleet.largeCap(_teamA);
  }
  void _capacitySmallButtonPressed(var e) {
    _touchMode = CAPACITY;
    _fleet.smallCap(_teamA);
  }
  void _tunaPressed(var e) {
    _touchMode = TUNA;
    _fleet.makeTuna(_teamA);
  }
  void _sardinePressed(var e) {
    _touchMode = SARDINE;
    _fleet.makeSardine(_teamA);
  }
  void _sharkPressed(var e) {
    _touchMode = SHARK;
    _fleet.makeShark(_teamA);
  }
  SimpleButton _returnCapacityButtonLarge() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonLarge")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonLarge")),
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonLarge")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonLarge")));
  }
  SimpleButton _returnCapacityButton() {
    return new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonSmall")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonSmall")),
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonSmall")), 
                           new Bitmap(_resourceManager.getBitmapData("CapacityUpgradeButtonSmall")));
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
  
  num _calculateAmount() {
    int mode = _touchMode;
    if (_touchMode == 0) mode = _boxConfirmMode;
    
    if (mode==SPEED) {
//      return (_touchedBoat.speedLevel+1)*200;
      return 100;
    } else if (mode==CAPACITY) {
//      return (_touchedBoat.capacityLevel+1)*300;
      return 100;
    } else if (mode==SARDINE) {
      return 0;
    } else if (mode==SHARK) {
      return 500;
    } else if (mode==TUNA) {
      return 0;
    }
    return 0;
  }
  
  void _clearConsole() {
    if (contains(_box)) removeChild(_box);
    _boxDisplayed = false;
  }
  
  void _yesClicked(var e) {
    if (_confirmMode==OKAY){
      _clearConsole();
      clicked.play();
    }
    else if (_confirmMode==CONFIRM) {
      num amount = _calculateAmount();
      
      int count = 0;
      for (int i=0; i<_fleet.boats.length; i++) {
        if (_fleet.boats[i]._teamA==_teamA) count++;
      }
      if (count>2 && (_boxConfirmMode==SHARK || _boxConfirmMode==TUNA || _boxConfirmMode==SARDINE)) {
        _confirmMode = OKAY;
        _boxUp = false;
        _clearConsole();
        _touchedBoat = null;
        _boxConfirmMode = 0;
        _startWarning("You can only have 3 boats. Maybe sell one!", _boxX, _boxY);
      } else {
        if (_teamA==true) {
          _game.teamAMoney = _game.teamAMoney - amount;
        }
        else {
          _game.teamBMoney = _game.teamBMoney - amount;
        }
        _game.moneyChanged = true;
        if (_boxConfirmMode==SPEED) {
          _touchedBoat.increaseSpeed();
        } else if (_boxConfirmMode==CAPACITY) {
          _touchedBoat.increaseCapacity();
        } else {
          if (_boxConfirmMode==SHARK) {
            if (_teamA==true) _fleet.addBoat(Fleet.TEAMASHARK);
            else _fleet.addBoat(Fleet.TEAMBSHARK);
          } else if (_boxConfirmMode==TUNA) {
            if (_teamA==true) _fleet.addBoat(Fleet.TEAMATUNA);
            else _fleet.addBoat(Fleet.TEAMBTUNA);
          } else if (_boxConfirmMode==SARDINE) {
            if (_teamA==true) _fleet.addBoat(Fleet.TEAMASARDINE);
            else _fleet.addBoat(Fleet.TEAMBSARDINE);
          }
          if (_boxConfirmMode != SPEED && _boxConfirmMode != CAPACITY) 
            _offseason.clearAndRefillDock();
            buySplash.play();
        }
        _boxUp = false;
        clicked.play();
        _clearConsole();
        _touchedBoat = null;
        _boxConfirmMode = 0;
      }
    }
  }
  
  void _noClicked(var e) {
    clicked.play();
    _boxUp = false;
    _touchMode = 0;
    _touchedBoat = null;
    _clearConsole();
  }
  
  void _startWarning(String s, num boxX, num boxY) {
    _clearConsole();
    
    _boxX = boxX;
    _boxY = boxY;
    _boxConfirmMode = _touchMode;
    _touchMode = 0;
    _box = new Sprite();
    _box.addChild(new Bitmap (_resourceManager.getBitmapData("Console")));
    _box.alpha = 1;
    
    TextFormat format = new TextFormat("Arial", 24, Color.Black, align: "center");
    _confirmText = new TextField(s, format);
    
    if (_confirmMode==OKAY) {
      _yesButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("OkayUp")), 
                                    new Bitmap(_resourceManager.getBitmapData("OkayUp")),
                                    new Bitmap(_resourceManager.getBitmapData("OkayDown")), 
                                    new Bitmap(_resourceManager.getBitmapData("OkayDown")));
      _yesButton.addEventListener(MouseEvent.MOUSE_UP, _yesClicked);
      _yesButton.addEventListener(TouchEvent.TOUCH_BEGIN, _yesClicked);
      _yesButton.addEventListener(TouchEvent.TOUCH_TAP, _yesClicked);
      
      _yesButton.x = 110;
      _yesButton.y = 115;
    } else if (_confirmMode==CONFIRM) {
      _yesButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("YesUp")), 
                                     new Bitmap(_resourceManager.getBitmapData("YesUp")),
                                     new Bitmap(_resourceManager.getBitmapData("YesDown")), 
                                     new Bitmap(_resourceManager.getBitmapData("YesDown")));
      _noButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("NoUp")), 
                                     new Bitmap(_resourceManager.getBitmapData("NoUp")),
                                     new Bitmap(_resourceManager.getBitmapData("NoDown")), 
                                     new Bitmap(_resourceManager.getBitmapData("NoDown")));
      _yesButton.addEventListener(MouseEvent.MOUSE_UP, _yesClicked);
      _yesButton.addEventListener(TouchEvent.TOUCH_BEGIN, _yesClicked);
      _yesButton.addEventListener(TouchEvent.TOUCH_TAP, _yesClicked);
      _noButton.addEventListener(MouseEvent.MOUSE_UP, _noClicked);
      _noButton.addEventListener(TouchEvent.TOUCH_BEGIN, _noClicked);
      _noButton.addEventListener(TouchEvent.TOUCH_TAP, _noClicked);
      
      _yesButton.x = 45;
      _yesButton.y = 115;
      _noButton.x = 180;
      _noButton.y = 115;
    }
    BitmapData.load('images/console.png').then((bitmapData) {
      num w = bitmapData.width;
      num h = bitmapData.height;
      
      if (_upgradeMode==true) {
        _box.x = boxX-w/2; 
        _box.y = boxY;
      } else {
        _box.x = -(boxX-w/2);
        _box.y = -boxY;
        _box.rotation = math.PI;
      }
      
      _confirmText.wordWrap = true;
      _confirmText.x = 10;
      _confirmText.y = 15;
      _confirmText.width = w-_confirmText.x*2;
      _confirmText.height = 250;
    });
    
    addChild(_box);
    _box.addChild(_confirmText);
    _box.addChild(_yesButton);
    _boxDisplayed = true;
    if (_confirmMode==CONFIRM) _box.addChild(_noButton);
  }
  
  bool containsTouch(Contact event) {
    if (_touchMode == 0 || _boxUp == true) return false;
    else return true;
  }
  
  bool touchDown(Contact event) {
    
//    if (contains(_tempButton)){removeChild(_tempButton);}
//    if (_touchMode == CAPACITY) _tempButton = _returnCapacityButton();
//    if (_touchMode == SPEED) _tempButton = _returnSpeedButton();
//    if (_touchMode == TUNA) _fleet.makeTuna(_teamA);
//    if (_touchMode == SARDINE) _fleet.makeSardine(_teamA);
//    if (_touchMode == SHARK) _fleet.makeShark(_teamA);
//    _clearConsole();
    return true;
  }

  void touchDrag(Contact event) {
//    _touchedBoat = null;
//    if (contains(_tempButton)){removeChild(_tempButton);}
//    if (_touchMode == CAPACITY) _tempButton = _returnCapacityButton();
//    if (_touchMode == SPEED) _tempButton = _returnSpeedButton();
//    if (_touchMode == TUNA) _tempButton = _returnTunaButton();
//    if (_touchMode == SARDINE) _tempButton = _returnSardineButton();
//    if (_touchMode == SHARK) _tempButton = _returnSharkButton();
//    addChild(_tempButton);
//    
//    if (_upgradeMode==true) {
//      if (_teamA == true) {
//        _tempButton.x = -event.touchX;
//        _tempButton.y = -event.touchY;
//      } else {
//        _tempButton.x = -_game.width+event.touchX;
//        _tempButton.y = -_game.height+event.touchY;
//      }
//    } else {
//      num offset = width/6.5;
//      if (_teamA == true) {
//        _tempButton.x = event.touchX-offset;
//        _tempButton.y = event.touchY-offset;
//      } else {
//        _tempButton.x = _game.width-event.touchX-offset;
//        _tempButton.y = _game.height-event.touchY-offset;
//      }
//    }
//    if (_upgradeMode==true) {
//      if (_teamA==true) {
//        _boatsA.forEach((int i, Boat b) {
//          if (_tempButton.hitTestObject(b.boat)) {
//            _touchedBoat = _fleet.boats[i];
//          }
//        });
//      } else {
//        _boatsB.forEach((int i, Boat b) {
//          if (_tempButton.hitTestObject(b.boat)) {
//            _touchedBoat = _fleet.boats[i];
//          }
//        });
//      }
//      if (_touchedBoat != null) _tempButton.alpha = .5;
//    } else {
//      if (_teamA==true) {
//        if (_tempButton.hitTestObject(_offseason.teamAHit)) {
//          _tempButton.alpha = .5;
//        }
//      } else {
//        if (_tempButton.hitTestObject(_offseason.teamBHit)) {
//          _tempButton.alpha = .5;
//        }
//      }
//    }
  }

  void touchSlide(Contact event) {
    // TODO: implement touchSlide
  }

  void touchUp(Contact event) {
//    if (contains(_tempButton)) removeChild(_tempButton);
////    if (_tempButton==null) return;
//    if (_boxUp == false &&  _tempButton.alpha == .5 && _touchMode != 0) {
//      num touchX, touchY, money;
//      if (_teamA == true) {
//        touchX = -event.touchX;
//        touchY = -event.touchY;
//        money = _game.teamAMoney;
//      } else {
//        touchX = -_game.width+event.touchX;
//        touchY = -_game.height+event.touchY;
//        money = _game.teamBMoney;
//      }
//      num amount = _calculateAmount();
//      if (money<amount) _confirmMode = OKAY;
//      else _confirmMode = CONFIRM;
//      
//      if (_touchedBoat != null) {
//        if (_touchMode==SPEED) {
//          if (money<amount) _startWarning("You need \$$amount to increase speed. Fish more!", touchX, touchY);
//          else _startWarning("Increase speed for \$$amount?", touchX, touchY);
//        } else if (_touchMode==CAPACITY) {
//          if (money<amount) _startWarning("You need \$$amount to increase net size. Fish more!", touchX, touchY);
//          else _startWarning("Increase net size for \$$amount?", touchX, touchY);
//        }
//      } else {
//        if (_touchMode==SARDINE) {
//          if (money<amount) _startWarning("You need \$$amount to buy a sardine boat. Fish more!", touchX, touchY);
//          else _startWarning("Buy sardine boat \$$amount?", touchX, touchY);
//        } else if (_touchMode==SHARK) {
//          if (money<amount) _startWarning("You need \$$amount to buy shark boat. Fish more!", touchX, touchY);
//          else _startWarning("Buy shark boat for \$$amount?", touchX, touchY);
//        } else if (_touchMode==TUNA) {
//          if (money<amount) _startWarning("You need \$$amount to buy tuna boat. Fish more!", touchX, touchY);
//          else _startWarning("Buy tuna boat for \$$amount?", touchX, touchY);
//        }
//      } 
//    } else if (_tempButton.alpha==1) _touchMode = 0;
  }
}