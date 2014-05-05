part of TOTC;

class Game extends Sprite implements Animatable{
  
  static const FISHING_PHASE = 1;
  static const BUY_PHASE = 2;
  static const REGROWTH_PHASE = 3;
  
  static const FISHING_TIMER_WIDTH = 50;
  static const BUY_TIMER_WIDTH = 150;
  static const REGROWTH_TIMER_WIDTH = 50;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Fleet _fleet;
  Ecosystem _ecosystem;
  Offseason _offseason;
  Bitmap _background;
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  bool gameStarted = false;
  
  int width;
  int height;
  
  Bitmap _mask;
  Tween _maskTween;
  
  TextField teamAMoneyText;
  TextField teamBMoneyText;
  int teamAMoney = 10000;
  int teamBMoney = 10000;
  bool moneyChanged = false;
  int moneyTimer = 0;
  int moneyTimerMax = 2;

  Graph _teamAGraph, _teamBGraph;
  int _graphTimerMax = 25;
  int _graphTimer=0;
  
  Shape timerGraphicA,timerGraphicB;
  TextField timerTextA, timerTextB;
  
  int phase = FISHING_PHASE;
  int timer = 0;
  int fishingTimerTick = 10;
  int buyTimerTick = 15;
  int regrowthTimerTick = 15;
  
  // Slider _teamASlider, _teamBSlider;
  // int sliderPrompt = 6;
  
  Game(ResourceManager resourceManager, Juggler juggler, int w, int h) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    width = w;
    height = h+16;
    
    tmanager.registerEvents(this);
    tmanager.addTouchLayer(tlayer);
    
    _background = new Bitmap(_resourceManager.getBitmapData("Background"));
    _mask = new Bitmap(_resourceManager.getBitmapData("Mask"));
    _fleet = new Fleet(_resourceManager, _juggler, this);
    _ecosystem = new Ecosystem(_resourceManager, _juggler, this, _fleet);

    _background.width = width;
    _background.height = height;
    _mask.alpha = 0;
    _mask.width = width;
    _mask.height = height;

    addChild(_background);
    addChild(_ecosystem);
    addChild(_mask);
    addChild(_fleet);

    _loadTextAndShapes();
  }

  bool advanceTime(num time) {
    if (gameStarted == false) return true;
    
    if (moneyTimer>moneyTimerMax && moneyChanged==true) _updateMoney();
    else moneyTimer++;
    
    if (timerGraphicA.width<4) _nextSeason();
    else _decreaseTimer();
    
    if (phase==REGROWTH_PHASE)
      if (_graphTimer>_graphTimerMax) _redrawGraph();
      else _graphTimer++;
    
    return true;
  }
  
  void _setMask() {
    num a = _ecosystem.ecosystemGrade()[0];
    a = 1-a;
    
    _maskTween = new Tween(_mask, 2);
    _maskTween.animate.alpha.to(a);
    _juggler.add(_maskTween);
  }
  
  void _updateMoney() {
    moneyTimer = 0;
    int a = int.parse(teamAMoneyText.text.substring(1));
    int b = int.parse(teamBMoneyText.text.substring(1));

    if (a==teamAMoney) teamAMoneyText.textColor = Color.LightYellow;
    if (b==teamBMoney) teamBMoneyText.textColor = Color.LightYellow;
    
    if (a==teamAMoney && b==teamBMoney) moneyChanged = false;
    else {
      if (a<teamAMoney) {
        teamAMoneyText.textColor = Color.LightGreen;
        if (a<teamAMoney-5) a=a+5;
        else a=a+1;
      } else if (a>teamAMoney){
        teamAMoneyText.textColor = Color.Salmon;
        if (a>teamAMoney+5) a=a-5;
        else a=a-1;
      }
      teamAMoneyText.text = "\$$a";
      
      if (b<teamBMoney) {
        teamBMoneyText.textColor = Color.LightGreen;
        if (b<teamBMoney-5)b=b+5;
        else b=b+1;
      } else if (b>teamBMoney){
        teamBMoneyText.textColor = Color.Salmon;
        if (b>teamBMoney+5) b=b-5;
        else b=b-1;
      }
      teamBMoneyText.text = "\$$b";
    }
  }
  
  void _decreaseTimer() {
    if ((phase==FISHING_PHASE && timer>fishingTimerTick) || 
        (phase==BUY_PHASE && timer>buyTimerTick) || 
        (phase==REGROWTH_PHASE && timer>regrowthTimerTick)) {
      timerGraphicA.width -= 2;
      timerGraphicA.x += 2;
      timerGraphicB.width -= 2;
      timer = 0;
    } else timer++;
  }
  
  void _nextSeason() {
    if (phase==FISHING_PHASE) {
      phase = REGROWTH_PHASE;
      _fleet.returnBoats();

      _fleet.alpha = 0;
      _graphTimer = 0;

      timerGraphicA.graphics.fillColor(Color.DarkRed);
      timerGraphicA.width = REGROWTH_TIMER_WIDTH;
      timerGraphicA.x = width-REGROWTH_TIMER_WIDTH-50;
      timerTextA.text = "Regrowth season";
      
      timerGraphicB.graphics.fillColor(Color.DarkRed);
      timerGraphicB.width = REGROWTH_TIMER_WIDTH;
      timerTextB.text = "Regrowth season";
    }
    else if (phase==REGROWTH_PHASE) {
      phase = BUY_PHASE;
      
      teamAMoneyText.alpha = 1;
      teamBMoneyText.alpha = 1;
      _fleet.alpha = 1;
      
      if (contains(_teamAGraph)) removeChild(_teamAGraph);
      if (contains(_teamBGraph)) removeChild(_teamBGraph);
      
      timerGraphicA.graphics.fillColor(Color.Green);
      timerGraphicA.width = BUY_TIMER_WIDTH;
      timerGraphicA.x = width-BUY_TIMER_WIDTH-50;
      timerTextA.text = "Offseason";
      
      timerGraphicB.graphics.fillColor(Color.Green);
      timerGraphicB.width = BUY_TIMER_WIDTH;
      timerTextB.text = "Offseason";
    
      _removeOffseason();
      _offseason.y = -height;
      addChild(_offseason);
      swapChildren(_offseason, teamAMoneyText);
      swapChildren(teamAMoneyText, teamBMoneyText);
      
      Tween t1 = new Tween(_offseason, 2.5, TransitionFunction.easeInQuartic);
      t1.animate.y.to(0);
      t1.onComplete = _offseason.showCircles;
      Tween t2 = new Tween(_ecosystem, 2.5, TransitionFunction.easeInQuartic);
      t2.animate.y.to(height);
      Tween t3 = new Tween(_background, 2.5, TransitionFunction.easeInQuartic);
      t3.animate.y.to(height);
      _juggler.add(t1);
      _juggler.add(t2);
      _juggler.add(t3);
    } else if (phase==BUY_PHASE) {
      phase = FISHING_PHASE;
      _fleet.reactivateBoats();
      
      timerGraphicA.graphics.fillColor(Color.Green);
      timerGraphicA.width = FISHING_TIMER_WIDTH;
      timerTextA.text = "Fishing season";

      timerGraphicB.graphics.fillColor(Color.Green);
      timerGraphicB.width = FISHING_TIMER_WIDTH;
      timerTextB.text = "Fishing season";

      Tween t1 = new Tween(_offseason, 2.5, TransitionFunction.easeInQuartic);
      t1.animate.y.to(-height);
      t1.onComplete = _removeOffseason;
      Tween t2 = new Tween(_ecosystem, 2.5, TransitionFunction.easeInQuartic);
      t2.animate.y.to(0);
      Tween t3 = new Tween(_background, 2.5, TransitionFunction.easeInQuartic);
      t3.animate.y.to(0);
      _juggler.add(t1);
      _juggler.add(t2);
      _juggler.add(t3);
    }
  }
  
  void _removeOffseason() {
    if (contains(_offseason)) removeChild(_offseason);
          _offseason = new Offseason(_resourceManager, _juggler, this, _fleet);
  }
  
  void _redrawGraph() {
    if (contains(_teamAGraph)) removeChild(_teamAGraph);
    if (contains(_teamBGraph)) removeChild(_teamBGraph);
    _teamAGraph = new Graph(_resourceManager, _juggler, this, _ecosystem, true);
    _teamAGraph.x = width/2 + _teamAGraph.width/2;
    _teamAGraph.y = height/4;
    _teamAGraph.rotation = math.PI;
    _teamBGraph = new Graph(_resourceManager, _juggler, this, _ecosystem, true);
    _teamBGraph.x = width/2 - _teamBGraph.width/2;
    _teamBGraph.y = height*3/4;
    _graphTimer = 0;
    addChild(_teamAGraph);
    addChild(_teamBGraph);
  }
  
  void _loadTextAndShapes() {
    TextFormat format = new TextFormat("Arial", 40, Color.LightYellow, align: "center", bold:true);
    teamAMoneyText = new TextField("\$$teamAMoney", format);
    teamAMoneyText..width = 300
                  ..x = width~/2+teamAMoneyText.width~/2
                  ..y = 60
                  ..rotation = math.PI;
    addChild(teamAMoneyText);
    
    teamBMoneyText = new TextField("\$$teamBMoney", format);
    teamBMoneyText..width = 300
                  ..x = width~/2-teamBMoneyText.width~/2
                  ..y = height-60;
    addChild(teamBMoneyText);
    
    timerGraphicA = new Shape();
    timerGraphicA..graphics.rect(0, 0, FISHING_TIMER_WIDTH, 10)
                 ..x = width-FISHING_TIMER_WIDTH-50
                 ..width = FISHING_TIMER_WIDTH
                 ..y = 20
                 ..graphics.fillColor(Color.LightGreen);
    addChild(timerGraphicA);
    
    format = new TextFormat("Arial", 14, Color.LightYellow, align: "left");
    timerTextA = new TextField("Fishing season", format);
    timerTextA..x = width-50
              ..y = 55
              ..rotation = math.PI
              ..width = 200;
    addChild(timerTextA);

    timerGraphicB = new Shape();
    timerGraphicB..graphics.rect(0, 0, FISHING_TIMER_WIDTH, 10)
                 ..x = 50
                 ..y = height-20
                 ..graphics.fillColor(Color.LightGreen);
    addChild(timerGraphicB);
    
    timerTextB = new TextField("Fishing season", format);
    timerTextB.x = 50;
    timerTextB.y = height-45;
    timerTextB.width = 200;
    addChild(timerTextB);
  }
}