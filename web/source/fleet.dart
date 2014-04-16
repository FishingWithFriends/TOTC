part of TOTC;

class Fleet extends Sprite {
  static const TEAMASARDINE = 1;
  static const TEAMBSARDINE = 2;
  
  static const DOCK_SEPARATION = 100;
  static const LARGE_DOCK_HEIGHT = 0;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  List<Boat> boats = new List<Boat>();
  Map<int, Dock> dockA = new Map<int, Dock>();
  Map<int, Dock> dockB = new Map<int, Dock>();
  num consoleWidth;
  num dockHeight;
  
  List<SimpleButton> buttonsA = new List<SimpleButton>(3);
  List<SimpleButton> buttonsB = new List<SimpleButton>(3);
  
  Fleet(ResourceManager resourceManager, Juggler juggler, Game game) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _game = game;
    
    BitmapData.load('images/console.png').then((console) {
      consoleWidth = console.width;
      BitmapData.load("images/dock.png").then((bitmapData) {
        dockHeight = bitmapData.height;
        for (int i=0;i<4;i++) {
          dockA[i] = new Dock(_game, this, i, true);
          addChild(dockA[i]);
        }
        for (int i=0;i<4;i++) {
          dockB[i] = new Dock(_game, this, i, false);
          addChild(dockB[i]);
        }
        addBoat(TEAMASARDINE, dockA[0].location.x+5, dockA[0].location.y+dockHeight/2, math.PI);
        addBoat(TEAMBSARDINE, dockB[0].location.x+5, dockB[0].location.y-dockHeight/2, 0);
        
        _setupButtons();
      });
    });
  }
  
  void sellBoat(Boat boat) {
    removeChild(boat);
    _juggler.remove(boat);
    _game.tlayer.touchables.remove(boat);
    if (boat._dock != null) 
      boat._dock.filled = false;
    boat.clearConsole();
    boats.remove(boat);
    addButtons();
  }
  
  Boat addBoat(int type, num x, num y, num rot) {
    Boat boat = new Boat(_resourceManager, _juggler, type, _game, this);
    boat.x = x;
    boat.y = y;
    boat.rotation = rot;
    if (type==TEAMASARDINE) boat._dock = findEmptyDock(true);
    else boat._dock = findEmptyDock(false);
    boat._dock.filled=true;
    boats.add(boat);
    _game.tlayer.touchables.add(boat);
    addChild(boat);
    _juggler.add(boat);
    
    return boat;
  }
  
  void clearOtherConsoles(bool teamA) {
    for (int i=0; i<boats.length; i++) {
      if (boats[i]._teamA==teamA) boats[i].clearConsole();
    }
  }
  
  void clearBuyButtons() {
    for (int i=0; i<3; i++) {
      if (this.contains(buttonsA[i])) removeChild(buttonsA[i]);
      if (this.contains(buttonsB[i])) removeChild(buttonsB[i]);
    }
  }
  
  void returnBoats() {
    for (int i=0; i<boats.length; i++) {
      boats[i].returnToDock();
    }
  }
  
  void reactivateBoats() {
    clearBuyButtons();
    for (int i=0; i<boats.length; i++) {
      if (boats[i].alpha==0) sellBoat(boats[i]);
      else boats[i].fishingSeasonStart();
    }
  }
  
  void addButtons() {
    clearBuyButtons();
    for (int i=0; i<3; i++) {
      if (dockA[i].filled==false) addChild(buttonsA[i]);
      if (dockB[i].filled==false) addChild(buttonsB[i]);
    }
  }
  
  void _buyBoat(bool teamA, int i) {
    if (teamA==true) {
      Boat b = addBoat(TEAMASARDINE, dockA[i].location.x+5, dockA[i].location.y+dockHeight/2, math.PI);
      b.alpha = 0;
      b._dock.filled = false;
      b._dock = dockA[i];
      b._dock.filled = true;
      b._teamA = true;
      
      Console c = b._loadConsole();
      c.startConfirm("Buy a new boat for \$700?", Console.BUY_CONFIRM);
    }
    else {
      Boat b = addBoat(TEAMBSARDINE, dockB[i].location.x+5, dockB[i].location.y-dockHeight/2, 0);
      b.alpha = 0;
      b._dock.filled = false;
      b._dock = dockB[i];
      b._dock.filled = true;
      b._teamA = false;
      
      Console c = b._loadConsole();
      c.startConfirm("Buy a new boat for \$700?", Console.BUY_CONFIRM);
    }
  }
  
  void _buyBoatA0(var e) => _buyBoat(true, 0);
  void _buyBoatA1(var e) => _buyBoat(true, 1);
  void _buyBoatA2(var e) => _buyBoat(true, 2);
  void _buyBoatB0(var e) => _buyBoat(false, 0);
  void _buyBoatB1(var e) => _buyBoat(false, 1);
  void _buyBoatB2(var e) => _buyBoat(false, 2);
  
  Dock findEmptyDock(teamA) {
    while (dockB[3].location == null) {}
    Dock dock;
    if (teamA) {
      for (int i=0; i<3; i++) {
        dock = dockA[i];
        if (dock.filled == false) {
          dock.filled = true;
          return dock;
        }
      }
    } else {
      for (int i=0; i<3; i++) {
        dock = dockB[i];
        if (dock.filled == false) {
          dock.filled = true;
          return dock;
        }
      }
    }
  }
  void _setupButtons() {
    while (dockB[3].location == null) {}
    for (int i=0;i<3;i++) {
      buttonsA[i] = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("BuyUp")), 
                                     new Bitmap(_resourceManager.getBitmapData("BuyUp")),
                                     new Bitmap(_resourceManager.getBitmapData("BuyDown")), 
                                     new Bitmap(_resourceManager.getBitmapData("BuyDown")));
      buttonsA[i].x = dockA[i].location.x-28;
      buttonsA[i].y = dockA[i].location.y+30;
      buttonsB[i] = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("BuyUp")), 
                                     new Bitmap(_resourceManager.getBitmapData("BuyUp")),
                                     new Bitmap(_resourceManager.getBitmapData("BuyDown")), 
                                     new Bitmap(_resourceManager.getBitmapData("BuyDown")));
      buttonsB[i].x = dockB[i].location.x-28;
      buttonsB[i].y = dockB[i].location.y-120;
    }
    buttonsA[0].addEventListener(MouseEvent.MOUSE_UP, _buyBoatA0);
    buttonsA[0].addEventListener(TouchEvent.TOUCH_TAP, _buyBoatA0);
    buttonsA[1].addEventListener(MouseEvent.MOUSE_UP, _buyBoatA1);
    buttonsA[1].addEventListener(TouchEvent.TOUCH_TAP, _buyBoatA1);
    buttonsA[2].addEventListener(MouseEvent.MOUSE_UP, _buyBoatA2);
    buttonsA[2].addEventListener(TouchEvent.TOUCH_TAP, _buyBoatA2);
    buttonsB[0].addEventListener(MouseEvent.MOUSE_UP, _buyBoatB0);
    buttonsB[0].addEventListener(TouchEvent.TOUCH_TAP, _buyBoatB0);
    buttonsB[1].addEventListener(MouseEvent.MOUSE_UP, _buyBoatB1);
    buttonsB[1].addEventListener(TouchEvent.TOUCH_TAP, _buyBoatB1);
    buttonsB[2].addEventListener(MouseEvent.MOUSE_UP, _buyBoatB2);
    buttonsB[2].addEventListener(TouchEvent.TOUCH_TAP, _buyBoatB2);
  }
}

class Dock extends Sprite{
  Point location;
  bool filled;
  Game _game;
  Fleet _fleet;
  int pos;
  
  Dock(Game game, Fleet fleet, int n, bool teamA) {
    filled = false;
    _game = game;
    _fleet = fleet;
    
    pos = n;
    
    if (teamA) location = new Point(_fleet.consoleWidth/2+Fleet.DOCK_SEPARATION/2+n*Fleet.DOCK_SEPARATION, Fleet.LARGE_DOCK_HEIGHT);
    else location = new Point(_game.width-_fleet.consoleWidth/2-Fleet.DOCK_SEPARATION/2-n*Fleet.DOCK_SEPARATION, _game.height-Fleet.LARGE_DOCK_HEIGHT);
    
    BitmapData.load('images/dock.png').then((bitmapData) {
      Bitmap bitmap = new Bitmap(bitmapData);
      if (teamA == true) {
        bitmap.x = location.x-Fleet.DOCK_SEPARATION/2;
        bitmap.y = location.y;
      } else {
        bitmap.x = location.x+Fleet.DOCK_SEPARATION/2;
        bitmap.y = location.y-_fleet.dockHeight;
      }
      addChild(bitmap);
      
      if (n == 3) filled = true;
    });
  }
}