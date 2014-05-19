part of TOTC;

class Game extends Sprite implements Animatable{
  
  static const FISHING_PHASE = 1;
  static const BUY_PHASE = 2;
  static const REGROWTH_PHASE = 3;
  
  static const FISHING_TIMER_WIDTH = 100;
  static const BUY_TIMER_WIDTH = 100;
  static const REGROWTH_TIMER_WIDTH = 100;
  
  static const timerPieRadius = 60;
  static const TUNA = 0;
  static const SARDINE = 1;
  static const SHARK = 2;
  
  //Timer Type
  static const BAR_TIMER = 0;
  static const PIE_TIMER = 1;
  num timerType = PIE_TIMER; // TOGGLE VARIABLE
  Bitmap pieTimerBitmap;
  
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
  int teamARoundProfit = 0;
  int teamBRoundProfit = 0;
  bool moneyChanged = false;
  int moneyTimer = 0;
  int moneyTimerMax = 2;

  //REGROWTH INFO
  static const LINE_GRAPH_INFO = 0;
  static const BADGE_STAR_INFO = 1;
  num regrowthInfoType = BADGE_STAR_INFO; // TOGGLE VARIABLE
  
  Graph _teamAGraph, _teamBGraph;
  int _graphTimerMax = 25;
  int _graphTimer=0;
  
  EcosystemBadge badge;
  
  Shape timerGraphicA,timerGraphicB, timerPie;
  Shape sardineBar, tunaBar, sharkBar;
  TextField timerTextA, timerTextB;
  Bitmap sardineIcon, tunaIcon, sharkIcon;
  
  int phase = FISHING_PHASE;
  int timer = 0;
  int fishingTimerTick = 10;
  int buyTimerTick = 15;
  int regrowthTimerTick = 15;
  
  bool transition;
  
  // Slider _teamASlider, _teamBSlider;
  // int sliderPrompt = 6;
  
  List<DisplayObject> uiObjects = new List<DisplayObject>(); 
  
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

    badge = new EcosystemBadge(_resourceManager, _juggler, this, _ecosystem);
    
    addChild(_background);
    addChild(_ecosystem);
    addChild(_mask);
    addChild(_fleet);

    _loadTextAndShapes();
    
    transition = false;
  }

  bool advanceTime(num time) {
    if (gameStarted == false) return true;
    
    if (moneyTimer>moneyTimerMax && moneyChanged==true) _updateMoney();
    else moneyTimer++;
    
    if (timerGraphicA.width<4 && !transition) _nextSeason();
    else _decreaseTimer();
    
    
    //Display growth information
    if (phase==REGROWTH_PHASE){
      
      if(regrowthInfoType == LINE_GRAPH_INFO){
        if (_graphTimer>_graphTimerMax) _redrawGraph();
        else _graphTimer++;
      }
      else if (regrowthInfoType == BADGE_STAR_INFO){

      }
    }
    
    //Update the population bar graph size
    sardineBar.height = _ecosystem._fishCount[SARDINE]/2;
    sardineIcon.y = sardineBar.y - sardineBar.height - sardineIcon.height;
    
    tunaBar.height = _ecosystem._fishCount[TUNA] * 3;
    tunaIcon.y = tunaBar.y - tunaBar.height - tunaIcon.height;
    
    sharkBar.height = _ecosystem._fishCount[SHARK]* 8;
    sharkIcon.y = sharkBar.y - sharkBar.height - sharkIcon.height;
    
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
      
      timerPie.graphics.clear();
      if (phase==FISHING_PHASE) {

        timerPie..graphics.beginPath()
            ..graphics.lineTo(0, timerPieRadius)
            ..graphics.lineTo(timerPieRadius, timerPieRadius)
            ..graphics.arc(0, timerPieRadius, timerPieRadius, 0, 2*math.PI * (timerGraphicA.width+0.0)/FISHING_TIMER_WIDTH, false)
            ..graphics.closePath();
      }
      else if(phase==BUY_PHASE){

        timerPie..graphics.beginPath()
            ..graphics.lineTo(0, timerPieRadius)
            ..graphics.lineTo(timerPieRadius, timerPieRadius)
            ..graphics.arc(0, timerPieRadius, timerPieRadius, 0, 2*math.PI * (timerGraphicA.width+0.0)/BUY_TIMER_WIDTH, false)
            ..graphics.closePath();
      }
      else if(phase==REGROWTH_PHASE){
        timerPie..graphics.beginPath()
            ..graphics.lineTo(0, timerPieRadius)
            ..graphics.lineTo(timerPieRadius, timerPieRadius)
            ..graphics.arc(0, timerPieRadius, timerPieRadius, 0, 2*math.PI * (timerGraphicA.width+0.0)/REGROWTH_TIMER_WIDTH, false)
            ..graphics.closePath();
      }
      timerPie.graphics.fillColor(Color.Black);

    } else timer++;
    

  }
  
  void _nextSeason() {
    if (phase==FISHING_PHASE) {
      transition = true;
      phase = REGROWTH_PHASE;
      print("growing");
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
      
      badge.alpha = 1;
      addChild(badge);
      badge.showBadge();
      transition = false;
    }
    else if (phase==REGROWTH_PHASE) {
      transition = true;
      phase = BUY_PHASE;
      print("buying");
      
      Tween t1 = new Tween (badge, 2, TransitionFunction.linear);
      t1.animate.alpha.to(0);
      t1.onComplete = toBuyPhaseTransitionStageOne;
      _juggler.add(t1);
      
      Tween t2 = new Tween(_ecosystem, 2, TransitionFunction.linear);
      t2.animate.alpha.to(0);
      _juggler.add(t2);

    } else if (phase==BUY_PHASE) {
      transition = true;
      phase = FISHING_PHASE;
      print("fishing");
      
      teamARoundProfit = 0;
      teamBRoundProfit = 0;
      
      _offseason.hideCircles();
      Tween t1 = new Tween(_offseason.dock, .5, TransitionFunction.linear);
      t1.animate.alpha.to(0);
      t1.onComplete = toFishingPhaseStageOne;
      _juggler.add(t1);
      
    }
  }
  
  void toBuyPhaseTransitionStageOne(){
    _fleet.hideDock();
    
    
    if (contains(badge)) removeChild(badge);
    badge.hideBadge();
    
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
    
    arrangeUILayers();

    
    Tween t1 = new Tween(_offseason, 2.5, TransitionFunction.easeInQuartic);
    t1.animate.y.to(0);
    t1.onComplete = toBuyPhaseTransitionStageTwo;
    Tween t2 = new Tween(_ecosystem, 2.5, TransitionFunction.easeInQuartic);
    t2.animate.y.to(height);
    Tween t3 = new Tween(_background, 2.5, TransitionFunction.easeInQuartic);
    t3.animate.y.to(height);
    _juggler.add(t1);
    _juggler.add(t2);
    _juggler.add(t3);
    
  }
  void toBuyPhaseTransitionStageTwo(){
    _offseason.showCircles();

    Tween t1 = new Tween(teamAMoneyText, .5, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    _juggler.add(t1);
    
    Tween t2 = new Tween(teamBMoneyText, .5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
    
    transition = false;
  }
  
  void toFishingPhaseStageOne(){
    


      timerGraphicA.graphics.fillColor(Color.Green);
      timerGraphicA.width = FISHING_TIMER_WIDTH;
      timerTextA.text = "Fishing season";

      timerGraphicB.graphics.fillColor(Color.Green);
      timerGraphicB.width = FISHING_TIMER_WIDTH;
      timerTextB.text = "Fishing season";

      _offseason.sendBoatsToFish();
      
      Timer timer = new Timer(const Duration(milliseconds: 750), toFishingPhaseStageTwo);

  }
  
  void toFishingPhaseStageTwo(){
     
    Tween t1 = new Tween(_offseason, 2.5, TransitionFunction.easeInQuartic);
    t1.animate.y.to(-height);
    t1.onComplete = _removeOffseason;
    Tween t2 = new Tween(_ecosystem, 2.5, TransitionFunction.easeInQuartic);
    t2.animate.y.to(0);
    t2.onComplete = toFishingPhaseStageThree;
    Tween t3 = new Tween(_background, 2.5, TransitionFunction.easeInQuartic);
    t3.animate.y.to(0);
    _juggler.add(t1);
    _juggler.add(t2);
    _juggler.add(t3);
    transition = false;
      
  }
  
  void toFishingPhaseStageThree(){
    _fleet.reactivateBoats();
    _fleet.showDock();
    Tween t1 = new Tween(_fleet, 1, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    _juggler.add(t1);
    
    Tween t2 = new Tween(_ecosystem, 1, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
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
    teamAMoneyText..width = 150
                  ..x = width~/2+teamAMoneyText.width~/2
                  ..y = 60
                  ..rotation = math.PI;
    addChild(teamAMoneyText);
    uiObjects.add(teamAMoneyText);
    
    teamBMoneyText = new TextField("\$$teamBMoney", format);
    teamBMoneyText..width = 150
                  ..x = width~/2-teamBMoneyText.width~/2
                  ..y = height-60;
    addChild(teamBMoneyText);
    uiObjects.add(teamBMoneyText);
    
    //Text and Shapes for Bar Timers
    timerGraphicA = new Shape();
    timerGraphicA..graphics.rect(0, 0, FISHING_TIMER_WIDTH, 10)
                 ..x = width-FISHING_TIMER_WIDTH-50
                 ..width = FISHING_TIMER_WIDTH
                 ..y = 20
                 ..graphics.fillColor(Color.LightGreen);
    
    
    format = new TextFormat("Arial", 14, Color.LightYellow, align: "left");
    timerTextA = new TextField("Fishing season", format);
    timerTextA..x = width-50
              ..y = 55
              ..rotation = math.PI
              ..width = 200;
    

    timerGraphicB = new Shape();
    timerGraphicB..graphics.rect(0, 0, FISHING_TIMER_WIDTH, 10)
                 ..x = 50
                 ..y = height-20
                 ..graphics.fillColor(Color.LightGreen);
    
    

    timerTextB = new TextField("Fishing season", format);
    timerTextB.x = 50;
    timerTextB.y = height-45;
    timerTextB.width = 200;
    
    
    
    //Text and Shapes for Pie Timer
    
    timerPie = new Shape();
    timerPie..graphics.beginPath()
            ..x = width - 100
            ..y = 50
            ..graphics.lineTo(0, timerPieRadius)
            ..graphics.lineTo(timerPieRadius, timerPieRadius)
            ..graphics.arc(0, timerPieRadius, timerPieRadius, 0, 2*math.PI, false)
            ..graphics.closePath()
            ..graphics.fillColor(Color.Black)
            ..alpha = .70;
        
    pieTimerBitmap = new Bitmap(_resourceManager.getBitmapData("timer"));
    pieTimerBitmap.rotation = math.PI/4;
    pieTimerBitmap.alpha = timerPie.alpha+10;
    pieTimerBitmap.x = timerPie.x +22;
    pieTimerBitmap.y = timerPie.y - 62;

    
    if(timerType == BAR_TIMER){
      addChild(timerGraphicA);
      addChild(timerTextA);
      addChild(timerGraphicB);
      addChild(timerTextB);
      
      uiObjects.add(timerGraphicA);
      uiObjects.add(timerTextA);
      uiObjects.add(timerGraphicB);
      uiObjects.add(timerTextB);
    }
    else if(timerType == PIE_TIMER){
      addChild(timerPie);
      addChild(pieTimerBitmap);
      
      uiObjects.add(timerPie);
      uiObjects.add(pieTimerBitmap);
    }
    
    
    //Text and Shapes for population bar graph
    sardineBar = new Shape();
    sardineBar..graphics.rect(0, 0, 30, -_ecosystem._fishCount[SARDINE]/2)
              ..x  = 20
              ..y = height - 20
              ..alpha = .6
              ..graphics.fillColor(Color.Green);
    addChild(sardineBar);
    uiObjects.add(sardineBar);
    
    sardineIcon = new Bitmap(_resourceManager.getBitmapData("sardineIcon"));
    sardineIcon.x = sardineBar.x;
    sardineIcon.y = sardineBar.y - sardineBar.height - sardineIcon.height; 
    addChild(sardineIcon);
    uiObjects.add(sardineIcon);
    
    
    tunaBar = new Shape();
    tunaBar..graphics.rect(0, 0, 30, -_ecosystem._fishCount[TUNA]*3)
              ..x  = 50
              ..y = height - 20
              ..alpha = .6
              ..graphics.fillColor(Color.Red);
    addChild(tunaBar);
    uiObjects.add(tunaBar);
    
    tunaIcon = new Bitmap(_resourceManager.getBitmapData("tunaIcon"));
    tunaIcon.x = tunaBar.x;
    tunaIcon.y = tunaBar.y - tunaBar.height - tunaIcon.height; 
    addChild(tunaIcon);
    uiObjects.add(tunaIcon);
    
    sharkBar = new Shape();
    sharkBar..graphics.rect(0, 0, 30, -_ecosystem._fishCount[SHARK]*8)
              ..x  = 80
              ..y = height - 20
              ..alpha = .6
              ..graphics.fillColor(Color.Yellow);
    addChild(sharkBar);
    uiObjects.add(sharkBar);
    
    sharkIcon = new Bitmap(_resourceManager.getBitmapData("sharkIcon"));
    sharkIcon.x = sharkBar.x;
    sharkIcon.y = sharkBar.y - sharkBar.height - sharkIcon.height; 
    addChild(sharkIcon);
    uiObjects.add(sharkIcon);
    
  }
  
  void arrangeUILayers(){
    
    num offseasonIndex = getChildIndex(_offseason);
    num minUIelementIndex = offseasonIndex;
    DisplayObject toSwap = null;
    
    for(int i = 0; i < uiObjects.length;i++){
      if(getChildIndex(uiObjects[i]) < minUIelementIndex){
        minUIelementIndex = getChildIndex(uiObjects[i]);
        toSwap = uiObjects[i];
      }
    }
    
    if(toSwap == null) return;
    else{
      swapChildren(_offseason, toSwap);
    }
    
    

  }
}