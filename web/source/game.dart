part of TOTC;

class Game extends Sprite implements Animatable{
  
  static const FISHING_PHASE = 1;
  static const BUY_PHASE = 2;
  static const REGROWTH_PHASE = 3;
  
  static const FISHING_TIMER_WIDTH = 350;
  static const BUY_TIMER_WIDTH = 150;
  static const REGROW_TIMER_WIDTH = 150;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Fleet _fleet;
  Ecosystem _ecosystem;
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  bool gameStarted = false;
  
  int width;
  int height;
  
  Bitmap _mask;
  
  TextField teamATextField;
  TextField teamBTextField;
  int teamAMoney = 0;
  int teamBMoney = 0;
  bool moneyChanged;
  
  Slider _teamASlider, _teamBSlider;
  int sliderPrompt = 6;
  Graph _teamAGraph, _teamBGraph;
  int _graphTimerMax = 25;
  int _graphTimer=0;
  
  Shape teamATimer = new Shape();
  Shape teamBTimer = new Shape();
  TextField teamATimerField, teamBTimerField;
  
  int moneyTimer = 0;
  int moneyTimerMax = 2;
  
  int phase = FISHING_PHASE;
  int timer = 0;
  int fishingTimerTick = 10;
  int buyTimerTick = 15;
  int regrowthTimerTick = 15;
  
  Tween _maskTween;
  
  Game(ResourceManager resourceManager, Juggler juggler, int w, int h) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    width = w;
    height = h+16;
    moneyChanged = false;
    
    tmanager.registerEvents(this);
    tmanager.addTouchLayer(tlayer);
    
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Background"));
    _mask = new Bitmap(_resourceManager.getBitmapData("Mask"));
    _mask.alpha = 0;
    _fleet = new Fleet(_resourceManager, _juggler, this);
    _ecosystem = new Ecosystem(_resourceManager, _juggler, this, _fleet);

    
    background.width = width;
    background.height = height;
    addChild(background);
    addChild(_ecosystem);
    addChild(_mask);
    addChild(_fleet);
    _mask.width = width;
    _mask.height = height;
    
    //this.onEnterFrame.listen(_onEnterFrame);
    
    _loadTextAndShapes();
  }
//  num _fpsAverage = null;
//
//  _onEnterFrame(EnterFrameEvent e) {
//
//    if (_fpsAverage == null) {
//      _fpsAverage = 1.00 / e.passedTime;
//    } else {
//      _fpsAverage = 0.05 / e.passedTime + 0.95 * _fpsAverage;
//    }
//
//    html.querySelector('#fpsMeter').innerHtml = 'fps: ${_fpsAverage.round()}';
//  }
//  
  bool advanceTime(num time) {
    if (gameStarted == false) return true;
    
    if (!_juggler.contains(_maskTween)) {
      int sardineCount = _ecosystem._fishCount[Ecosystem.SARDINE];
      int tunaCount = _ecosystem._fishCount[Ecosystem.TUNA];
      int sharkCount = _ecosystem._fishCount[Ecosystem.SHARK];
      _maskTween = new Tween(_mask, 2.5, TransitionFunction.linear);
      print(sardineCount);print(tunaCount);print(sharkCount);
      if (sardineCount < 50 && tunaCount < 10 && sharkCount<2)
        _maskTween.animate.alpha.to(1);
      else if (sardineCount < Ecosystem.MAX_SARDINE-250 || tunaCount < Ecosystem.MAX_TUNA-40 || sharkCount<2)
        _maskTween.animate.alpha.to(.8);
      else if (sardineCount < Ecosystem.MAX_SARDINE-150 && tunaCount < Ecosystem.MAX_TUNA-25 && sharkCount<3)
        _maskTween.animate.alpha.to(.6);
      else if (sardineCount < Ecosystem.MAX_SARDINE-100 && (tunaCount > Ecosystem.MAX_TUNA-15 || sharkCount>2)) 
        _maskTween.animate.alpha.to(.3);
      else if (tunaCount < Ecosystem.MAX_TUNA-20 && (sardineCount > Ecosystem.MAX_SARDINE-100 || sharkCount>2))
        _maskTween.animate.alpha.to(.3);
      else if (sardineCount < 2 && (tunaCount > Ecosystem.MAX_TUNA-15 || sardineCount>Ecosystem.MAX_SARDINE-100))
        _maskTween.animate.alpha.to(.3);
      else _maskTween.animate.alpha.to(0);
      _juggler.add(_maskTween);
    }
    
    if (moneyTimer>moneyTimerMax) {
      moneyTimer = 0;
      if (moneyChanged == true) {
        var x = teamATextField.text.substring(1);
        int a = int.parse(teamATextField.text.substring(1));
        int b = int.parse(teamBTextField.text.substring(1));
        if (a==teamAMoney) teamATextField.textColor = Color.LightYellow;
        if (b==teamBMoney) teamBTextField.textColor = Color.LightYellow;
        if (a==teamAMoney && b==teamBMoney) {
          moneyChanged = false;
          return true;
        }
        if (a!=teamAMoney) {
          teamATextField.textColor = Color.LightGreen;
          if (a<teamAMoney-5)a=a+5;
          else if (a<teamAMoney) a=a+1;
          else if (a>teamAMoney+5){ 
            a=a-5;
            teamATextField.textColor = Color.Salmon;
          } else if (a>teamAMoney) {
            a=a-1;
            teamATextField.textColor = Color.Salmon;
          }
          teamATextField.text = "\$$a";
        }
        if (b!=teamBMoney) {
          teamBTextField.textColor = Color.LightGreen;
          if (b<teamBMoney-5)b=b+5;
          else if (b<teamBMoney) b=b+1;
          else if (b>teamBMoney+5){ 
            b=b-5;
            teamBTextField.textColor = Color.Salmon;
          } else if (b>teamBMoney) {
            b=b-1;
            teamBTextField.textColor = Color.Salmon;
          }
          teamBTextField.text = "\$$b";
        }
      }
    } else moneyTimer++;
    
    if ((timer>buyTimerTick && phase==BUY_PHASE) || (timer>fishingTimerTick &&  phase==FISHING_PHASE) || (timer>regrowthTimerTick && phase==REGROWTH_PHASE)) {
      timer = 0;
      teamATimer.width = teamATimer.width-2;
      teamATimer.x = teamATimer.x +2;
      teamBTimer.width = teamBTimer.width-2;
    } else timer++;
    if (teamATimer.width<4 || teamBTimer.width<4) {
      if (phase==BUY_PHASE) {
        phase = FISHING_PHASE;
        _fleet.reactivateBoats();
        teamATimer.graphics.fillColor(Color.Green);
        teamBTimer.graphics.fillColor(Color.Green);
        teamATimerField.text = "Fishing season";
        teamBTimerField.text = "Fishing season";
        
        teamATimer.x = width-FISHING_TIMER_WIDTH-50;
        teamATimer.width = FISHING_TIMER_WIDTH;
        teamBTimer.width = FISHING_TIMER_WIDTH;
      } else if (phase==FISHING_PHASE){
        Tween t = new Tween(_mask, 1.5, TransitionFunction.linear);
        t.animate.alpha.to(0);
        _juggler.add(t);
        _teamASlider._promptUser();
        _teamBSlider._promptUser(); 
        phase = REGROWTH_PHASE;
        
        _fleet.returnBoats();
        teamATimer.graphics.fillColor(Color.Salmon);
        teamBTimer.graphics.fillColor(Color.Salmon);
        teamATimerField.text = "Regrowth season";
        teamBTimerField.text = "Regrowth season";
        
        teamATimer.x = width-REGROW_TIMER_WIDTH-50;
        teamATimer.width = REGROW_TIMER_WIDTH;
        teamBTimer.width = REGROW_TIMER_WIDTH;
        
        _regrowthPhase();
      } else {
        _fleet.returnBoats();
        if (_teamASlider._showingPrompt==true)_teamASlider._promptUserFinished();
        if (_teamBSlider._showingPrompt==true)_teamBSlider._promptUserFinished();
        phase = BUY_PHASE;
        teamATimer.graphics.fillColor(Color.DarkRed);
        teamBTimer.graphics.fillColor(Color.DarkRed);
        teamATimerField.text = "Offseason";
        teamBTimerField.text = "Offseason";
        
        teamATimer.x = width-BUY_TIMER_WIDTH-50;
        teamATimer.width = BUY_TIMER_WIDTH;
        teamBTimer.width = BUY_TIMER_WIDTH;
        
        _buyPhase();
      }
    } else {
      if (phase==REGROWTH_PHASE) _regrowthPhase();
    }

    return true;
  }
  
  void _regrowthPhase() {
    teamATextField.alpha = 0;
    teamBTextField.alpha = 0;
    _fleet.alpha = 0;
    
    if (_graphTimer>_graphTimerMax) {
      _graphTimer = 0;
      if (contains(_teamAGraph)) removeChild(_teamAGraph);
      if (contains(_teamBGraph)) removeChild(_teamBGraph);
      _teamAGraph = new Graph(_resourceManager, _juggler, this, _ecosystem, true);
      _teamAGraph.x = width/2 + _teamAGraph.width/2;
      _teamAGraph.y = height/4;
      _teamAGraph.rotation = math.PI;
      _teamBGraph = new Graph(_resourceManager, _juggler, this, _ecosystem, true);
      _teamBGraph.x = width/2 - _teamBGraph.width/2;
      _teamBGraph.y = height*3/4;
      addChild(_teamAGraph);
      addChild(_teamBGraph);
    } else _graphTimer++;
  }
  
  void _buyPhase() {
    teamATextField.alpha = 1;
    teamBTextField.alpha = 1;
    _fleet.alpha = 1;
    
    if (contains(_teamAGraph)) removeChild(_teamAGraph);
    if (contains(_teamBGraph)) removeChild(_teamBGraph);
  }
  
  void _removeMask() {
    if (contains(_mask)) removeChild(_mask);
  }
  
  void _loadTextAndShapes() {

    TextFormat format = new TextFormat("Arial", 40, Color.LightYellow, align: "center", bold:true);
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
    teamATimer.x = width-FISHING_TIMER_WIDTH-50;
    teamATimer.width = FISHING_TIMER_WIDTH;
    teamATimer.y = 20;
    teamATimer.graphics.fillColor(Color.LightGreen);
    addChild(teamATimer);
    
    format = new TextFormat("Arial", 14, Color.LightYellow, align: "left");
    teamATimerField = new TextField("Fishing season", format);
    teamATimerField.x = width-50;
    teamATimerField.y = 55;
    teamATimerField.rotation = math.PI;
    teamATimerField.width = 200;
    addChild(teamATimerField);
    
    teamBTimer.graphics.rect(0, 0, FISHING_TIMER_WIDTH, 10);
    teamBTimer.x = 50;
    teamBTimer.y = height-20;
    teamBTimer.graphics.fillColor(Color.LightGreen);
    addChild(teamBTimer);
    
    teamBTimerField = new TextField("Fishing season", format);
    teamBTimerField.x = 50;
    teamBTimerField.y = height-45;
    teamBTimerField.width = 200;
    addChild(teamBTimerField);
    
    
    _teamASlider = new Slider(_resourceManager, _juggler, _fleet, this, true);
    _teamBSlider = new Slider(_resourceManager, _juggler, _fleet, this, false);
    
    _teamBSlider.x = width-73;
    _teamBSlider.y = height-80;
    tlayer.touchables.add(_teamBSlider);
    
    _teamASlider.x = 73;
    _teamASlider.y = 80;
    _teamASlider.rotation = math.PI;
    tlayer.touchables.add(_teamASlider);
    
    addChild(_teamBSlider);
    addChild(_teamASlider);
  }
}