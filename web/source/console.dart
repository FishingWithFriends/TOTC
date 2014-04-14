part of TOTC;

class Console extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Fleet _fleet;
  Boat _boat;
  
  SimpleButton _sellButton;
  SimpleButton _speedButton;
  SimpleButton _capacityButton;
  
  TextField _speedText;
  TextField _capacityText;
  
  int _consoleWidth;
  
  Console(ResourceManager resourceManager, Juggler juggler, Game g, Fleet fleet, Boat boat) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _fleet = fleet;
    _game = g;
    _boat = boat;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Console"));
    addChild(background);
    
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
    addChild(_capacityButton);
    addChild(_speedButton);
    addChild(_sellButton);
    
    _sellButton.addEventListener(MouseEvent.MOUSE_UP, _sellButtonClicked);
    _sellButton.addEventListener(TouchEvent.TOUCH_TAP, _sellButtonClicked);
    _capacityButton.addEventListener(MouseEvent.MOUSE_UP, _capacityButtonClicked);
    _capacityButton.addEventListener(TouchEvent.TOUCH_TAP, _capacityButtonClicked);
    _speedButton.addEventListener(MouseEvent.MOUSE_UP, _speedButtonClicked);
    _speedButton.addEventListener(TouchEvent.TOUCH_TAP, _speedButtonClicked);
    
    TextFormat format = new TextFormat("Arial", 12, Color.Black, align: "left", bold:true);
    _speedText = new TextField("Speed: 1", format);
    _speedText.width = 60;
    _speedText.x = 100;
    _speedText.y = 35;
    addChild(_speedText); 
    _capacityText = new TextField("Net Size: 1", format);
    _capacityText.width = 60;
    _capacityText.x = 100;
    _capacityText.y = 115;
    addChild(_capacityText);
  }
  
  void _sellButtonClicked(var e) {
    
  }
  void _capacityButtonClicked(var e) {
    print("c clicked");
  }
  void _speedButtonClicked(var e) {
    print("s clicked");
  }
}