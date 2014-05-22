part of TOTC;

class Console extends Sprite {
  
  static const SPEED_CONFIRM = 1;
  static const NET_CONFIRM = 2;
  static const BUY_CONFIRM = 3;
  static const SELL_CONFIRM = 4;
  static const ONLY_CONFIRM = 5;
  static const ONLY_CONFIRM_DESTROY = 6;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Fleet _fleet;
  Boat _boat;
  
  int _confirmMode;
  
  SimpleButton _sellButton;
  SimpleButton _speedButton;
  SimpleButton _capacityButton;
  SimpleButton _yesButton;
  SimpleButton _noButton;
  
  TextField _confirmText;
  TextField _speedText;
  TextField _capacityText;
  
  Console(ResourceManager resourceManager, Juggler juggler, Game g, Fleet fleet, Boat boat) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _fleet = fleet;
    _game = g;
    _boat = boat;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Console"));
    addChild(background);
 
    startBuy();
  }
  
  void clearConsole() {
    if (_fleet.contains(_yesButton)) removeChild(_yesButton);
    if (_fleet.contains(_noButton)) removeChild(_noButton);
    if (_fleet.contains(_confirmText)) removeChild(_confirmText);
    if (_fleet.contains(_capacityButton)) removeChild(_capacityButton);
    if (_fleet.contains(_speedButton)) removeChild(_speedButton);
    if (_fleet.contains(_sellButton)) removeChild(_sellButton);
    if (_fleet.contains(_speedText)) removeChild(_speedText);
    if (_fleet.contains(_capacityText)) removeChild(_capacityText);
  }
  
  void startBuy() {
    clearConsole();

    _sellButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SellUp")), 
                                   new Bitmap(_resourceManager.getBitmapData("SellUp")),
                                   new Bitmap(_resourceManager.getBitmapData("SellDown")), 
                                   new Bitmap(_resourceManager.getBitmapData("SellDown")));
    _speedButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("SpeedUp")), 
                                   new Bitmap(_resourceManager.getBitmapData("SpeedUp")),
                                   new Bitmap(_resourceManager.getBitmapData("SpeedDown")), 
                                   new Bitmap(_resourceManager.getBitmapData("SpeedDown")));
    _capacityButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("CapacityUp")), 
                                   new Bitmap(_resourceManager.getBitmapData("CapacityUp")),
                                   new Bitmap(_resourceManager.getBitmapData("CapacityDown")), 
                                   new Bitmap(_resourceManager.getBitmapData("CapacityDown")));
    
    _capacityButton.x = 20;
    _capacityButton.y = 90;
    _speedButton.x = 20;
    _speedButton.y = 10;
    _sellButton.x = 195;
    _sellButton.y = 60;
    
    _sellButton.addEventListener(MouseEvent.MOUSE_UP, _sellButtonClicked);
    _sellButton.addEventListener(TouchEvent.TOUCH_BEGIN, _sellButtonClicked);
    _sellButton.addEventListener(TouchEvent.TOUCH_TAP, _sellButtonClicked);
    _capacityButton.addEventListener(MouseEvent.MOUSE_UP, _capacityButtonClicked);
    _capacityButton.addEventListener(TouchEvent.TOUCH_BEGIN, _capacityButtonClicked);
    _capacityButton.addEventListener(TouchEvent.TOUCH_TAP, _capacityButtonClicked);
    _speedButton.addEventListener(MouseEvent.MOUSE_UP, _speedButtonClicked);
    _speedButton.addEventListener(TouchEvent.TOUCH_BEGIN, _speedButtonClicked);
    _speedButton.addEventListener(TouchEvent.TOUCH_TAP, _speedButtonClicked);
    
    TextFormat format = new TextFormat("Arial", 12, Color.Black, align: "left", bold:true);
    int sLevel = _boat.speedLevel+1;
    _speedText = new TextField("Speed: $sLevel", format);
    _speedText.width = 60;
    _speedText.x = 100;
    _speedText.y = 35;
    
    int cLevel = _boat.capacityLevel+1;
    _capacityText = new TextField("Net Size: $cLevel", format);
    _capacityText.width = 60;
    _capacityText.x = 100;
    _capacityText.y = 115;
    
    addChild(_capacityButton);
    addChild(_speedButton);
    addChild(_sellButton);
    addChild(_speedText);
    addChild(_capacityText);
  }
  
  void startWarning(String s) {
    clearConsole();
    
    TextFormat format = new TextFormat("Arial", 24, Color.Yellow, align: "center");
    _confirmText = new TextField(s, format);
    _yesButton = new SimpleButton(new Bitmap(_resourceManager.getBitmapData("OkayUp")), 
                                  new Bitmap(_resourceManager.getBitmapData("OkayUp")),
                                  new Bitmap(_resourceManager.getBitmapData("OkayDown")), 
                                  new Bitmap(_resourceManager.getBitmapData("OkayDown")));
    _yesButton.addEventListener(MouseEvent.MOUSE_UP, _yesClicked);
    _yesButton.addEventListener(TouchEvent.TOUCH_BEGIN, _yesClicked);
    _yesButton.addEventListener(TouchEvent.TOUCH_TAP, _yesClicked);
    
    if (_confirmMode != ONLY_CONFIRM_DESTROY) _confirmMode = ONLY_CONFIRM;
    
    _confirmText.wordWrap = true;
    _confirmText.x = 10;
    _confirmText.y = 15;
    _confirmText.width = this.width-_confirmText.x*2;
    _confirmText.height = 250;
    _yesButton.x = 110;
    _yesButton.y = 125;
    
    addChild(_confirmText);
    addChild(_yesButton);
  }

  void startConfirm(String s, int confirmMode) {
    clearConsole();

    _confirmMode = confirmMode;
    
    TextFormat format = new TextFormat("Arial", 24, Color.Yellow, align: "center");
    _confirmText = new TextField(s, format);
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
    
    _confirmText.x = 10;
    _confirmText.y = 45;
    _confirmText.width = this.width-_confirmText.x*2;
    _confirmText.height = 150;
    _yesButton.x = 45;
    _yesButton.y = 125;
    _noButton.x = 180;
    _noButton.y = 125;
    
    addChild(_confirmText);
    addChild(_yesButton);
    addChild(_noButton);
  }
  
  void _yesClicked(var e) {
    if (_confirmMode == ONLY_CONFIRM) startBuy();
    if (_confirmMode == ONLY_CONFIRM_DESTROY) {
//      _fleet.sellBoat(_boat);
    }
    if (_confirmMode == SELL_CONFIRM) {
      if (_boat._teamA==true) _game.teamAMoney = _game.teamAMoney+700;
      else _game.teamBMoney = _game.teamBMoney+700;
      _game.moneyChanged = true;
//      _fleet.sellBoat(_boat);
    }
    if (_confirmMode == SPEED_CONFIRM) {
      num amount = (_boat.speedLevel+1)*200;
      if (_boat._teamA==true) {
        if (_game.teamAMoney<amount) startWarning("Fish more! You don't have enough money for this upgrade");
        else {
          _boat.increaseSpeed();
          _game.teamAMoney = _game.teamAMoney-amount;
          startBuy();
        }
      } else {
        if (_game.teamBMoney<amount) startWarning("Fish more! You don't have enough money for this upgrade.");
        else {
          _boat.increaseSpeed();
          _game.teamBMoney = _game.teamBMoney-amount;
          startBuy();
        }
      }
    }
    if (_confirmMode == NET_CONFIRM) {
      num amount = (_boat.capacityLevel+1)*300;
      if (_boat._teamA==true) {
        if (_game.teamAMoney<amount) startWarning("Fish more! You don't have enough money for this upgrade");
        else {
          _boat.increaseCapacity();
          _game.teamAMoney = _game.teamAMoney-amount;
          startBuy();
        }
      } else {
        if (_game.teamBMoney<amount) startWarning("Fish more! You don't have enough money for this upgrade.");
        else {
          _boat.increaseCapacity();
          _game.teamBMoney = _game.teamBMoney-amount;
          startBuy();
        }
      }
    }
    if (_confirmMode == BUY_CONFIRM) {
      if (_boat._teamA==true) {
        if (_game.teamAMoney<700) {
          _confirmMode = ONLY_CONFIRM_DESTROY;
          startWarning("Fish more! You don't have enough money to buy this boat.");
        }
        else {
          _game.teamAMoney = _game.teamAMoney-700;
          _boat.alpha = 1;
          _boat._canLoadConsole = true;
//          _fleet.addButtons();
          startBuy();
        }
      } else {
        if (_game.teamBMoney<700) {
          _confirmMode = ONLY_CONFIRM_DESTROY;
          startWarning("Fish more! You don't have enough money to buy this boat.");
        }
        else {
          _game.teamBMoney = _game.teamBMoney-700;
          _boat.alpha = 1;
          _boat._canLoadConsole = true;
//          _fleet.addButtons();
          startBuy();
        }
      }
    }
    _game.moneyChanged = true;
  }
  
  void _noClicked(var e) {
    if (_confirmMode == BUY_CONFIRM) {
//      _fleet.sellBoat(_boat);
    }
    else startBuy();
  }
  
  void _sellButtonClicked(var e) {
    startConfirm("Sell this boat for \$700?", SELL_CONFIRM);
  }
  void _capacityButtonClicked(var e) {
    num amount = (_boat.capacityLevel+1)*300;
    startConfirm("Upgrade net size for \$$amount?", NET_CONFIRM);
  }
  void _speedButtonClicked(var e) {
    num amount = (_boat.speedLevel+1)*200;
    startConfirm("Upgrade speed for \$$amount?", SPEED_CONFIRM);
  }
}