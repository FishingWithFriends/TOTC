part of TOTC;

class Game extends Sprite implements Animatable{
  
  static const FISHING_TIMER_WIDTH = 350;
  static const BUY_TIMER_WIDTH = 150;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Fleet _fleet;
  Ecosystem _ecosystem;
  
  bool gameStarted = false;
  
  int width;
  int height;
  
  TextField teamATextField;
  TextField teamBTextField;
  int teamAMoney = 0;
  int teamBMoney = 0;
  bool moneyChanged;
  
  Shape teamATimer = new Shape();
  Shape teamBTimer = new Shape();
  TextField teamATimerField, teamBTimerField;
  
  int moneyTimer = 0;
  int moneyTimerMax = 2;
  
  bool buyPhase = false;
  int timer = 0;
  int fishingTimerTick = 3;
  int buyTimerTick = 2;
  
  Game(ResourceManager resourceManager, Juggler juggler, int w, int h) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    width = w;
    height = h;
    
    moneyChanged = false;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Background"));
    Bitmap mask = new Bitmap(_resourceManager.getBitmapData("Mask"));
    _fleet = new Fleet(_resourceManager, _juggler, this);
    _ecosystem = new Ecosystem(_resourceManager, _juggler, this, _fleet);
    
    background.width = width;
    background.height = height;
    addChild(background);
    addChild(_ecosystem);
    
    addChild(_fleet);
    mask.width = width;
    mask.height = height;
    addChild(mask);
    
    this.onEnterFrame.listen(_onEnterFrame);
    
    TextFormat format = new TextFormat("Arial", 40, Color.Green, align: "center", bold:true);
    teamATextField = new TextField("\$0", format);
    teamATextField.width = 300;
    teamATextField.x = width~/2+teamATextField.width~/2;
    teamATextField.y = 60;
    teamATextField.rotation = math.PI;
    addChild(teamATextField);
    
    teamBTextField = new TextField("\$0", format);
    teamBTextField.width = 300;
    teamBTextField.x = width~/2-teamBTextField.width~/2;
    teamBTextField.y = height-60;
    addChild(teamBTextField);
    
    teamATimer.graphics.rect(0, 0, FISHING_TIMER_WIDTH, 10);
    teamATimer.x = width-400;
    teamATimer.y = 20;
    teamATimer.graphics.fillColor(Color.LightGreen);
    addChild(teamATimer);
    
    format = new TextFormat("Arial", 14, Color.LightYellow, align: "left");
    teamATimerField = new TextField("Fishing season", format);
    teamATimerField.x = width-50;
    teamATimerField.y = 55;
    teamATimerField.rotation = math.PI;
    addChild(teamATimerField);
    
    teamBTimer.graphics.rect(0, 0, FISHING_TIMER_WIDTH, 10);
    teamBTimer.x = 50;
    teamBTimer.y = height-20;
    teamBTimer.graphics.fillColor(Color.LightGreen);
    addChild(teamBTimer);
    
    teamBTimerField = new TextField("Fishing season", format);
    teamBTimerField.x = 50;
    teamBTimerField.y = height-45;
    addChild(teamBTimerField);
  }
  num _fpsAverage = null;

  _onEnterFrame(EnterFrameEvent e) {

    if (_fpsAverage == null) {
      _fpsAverage = 1.00 / e.passedTime;
    } else {
      _fpsAverage = 0.05 / e.passedTime + 0.95 * _fpsAverage;
    }

    html.querySelector('#fpsMeter').innerHtml = 'fps: ${_fpsAverage.round()}';
  }
  
  bool advanceTime(num time) {
    if (gameStarted == false) return true;
    
    if (moneyTimer>moneyTimerMax) {
      moneyTimer = 0;
      if (moneyChanged == true) {
        var x = teamATextField.text.substring(1);
        int a = int.parse(teamATextField.text.substring(1));
        int b = int.parse(teamBTextField.text.substring(1));
        if (a==teamAMoney && b==teamBMoney) {
          moneyChanged = false;
          return true;
        }
        if (a!=teamAMoney) {
          if (a<teamAMoney) a=a+1;
          else a=a-1;
          teamATextField.text = "\$$a";
        }
        if (b!=teamBMoney) {
          if (b<teamBMoney) b=b+1;
          else b=b-1;
          teamBTextField.text = "\$$b";
        }
      }
    } else moneyTimer++;
    
    if ((timer>buyTimerTick && buyPhase==true) || (timer>fishingTimerTick && buyPhase==false)) {
      timer = 0;
      teamATimer.width = teamATimer.width-2;
      teamATimer.x = teamATimer.x +2;
      teamBTimer.width = teamBTimer.width-2;
    } else timer++;
    if (teamATimer.width<4 || teamBTimer.width<4) {
      if (buyPhase==true) {
        buyPhase = false;
        _fleet.reactivateBoats();
        teamATimer.graphics.fillColor(Color.LightGreen);
        teamBTimer.graphics.fillColor(Color.LightGreen);
        teamATimerField.text = "Fishing season";
        teamBTimerField.text = "Fishing season";
        
        teamATimer.x = width-FISHING_TIMER_WIDTH-50;
        teamATimer.width = FISHING_TIMER_WIDTH;
        teamBTimer.width = FISHING_TIMER_WIDTH;
      } else {
        buyPhase = true;
        _fleet.returnBoats();
        teamATimer.graphics.fillColor(Color.DarkRed);
        teamBTimer.graphics.fillColor(Color.DarkRed);
        teamATimerField.text = "Time left to buy";
        teamBTimerField.text = "Time left to buy";
        
        teamATimer.x = width-BUY_TIMER_WIDTH-50;
        teamATimer.width = BUY_TIMER_WIDTH;
        teamBTimer.width = BUY_TIMER_WIDTH;
      }
    }
    return true;
  }
}