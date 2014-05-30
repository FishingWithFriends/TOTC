part of TOTC;

class Game extends Sprite implements Animatable{
  
  static const FISHING_PHASE = 1;
  static const BUY_PHASE = 2;
  static const REGROWTH_PHASE = 3;
  static const ENDGAME_PHASE = 4;
  
  static const MAX_ROUNDS = 6;
  
  static const FISHING_TIMER_WIDTH = 125;
  static const REGROWTH_TIMER_WIDTH = 125;
  static const BUY_TIMER_WIDTH = 125;
  
  static const FISHING_TIME = 10;
  static const REGROWTH_TIME = 8;
  static const BUYING_TIME = 10;
  
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
  Endgame _endgame;
  
  TouchManager tmanager = new TouchManager();
  TouchLayer tlayer = new TouchLayer();
  
  bool gameStarted = false;
  
  int width;
  int height;
  
  Bitmap _mask;
  Tween _maskTween;
  
  TextField teamAMoneyText, teamBMoneyText;
  TextField teamAScoreText, teamBScoreText;
  TextField roundTitle, roundNumber, seasonTitle;
  
  int teamAMoney = 10000;
  int teamBMoney = 10000;
  int teamAScore = 0;
  int teamBScore = 0;
  int teamARoundProfit = 0;
  int teamBRoundProfit = 0;
  bool moneyChanged = false;
  int moneyTimer = 0;
  int moneyTimerMax = 2;
  int round = 0;

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
  bool timerActive;
  Sound timerSound;
  
  Timer clockUpdateTimer;
  num clockCounter;
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
    _endgame = new Endgame(_resourceManager, _juggler, this, _ecosystem);

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
    addChild(_endgame);

    timerSound = _resourceManager.getSound("timerSound");
    
    _loadTextAndShapes();
    
    transition = false;
    timerActive = false;
  }

  bool advanceTime(num time) {
    if (gameStarted == false){
      sardineBar.height = _ecosystem._fishCount[SARDINE]/2;
      sardineIcon.y = sardineBar.y - sardineBar.height - sardineIcon.height;
      print("${_ecosystem._fishCount[SARDINE]}, ${_ecosystem._fishCount[TUNA]},${ _ecosystem._fishCount[SHARK]}");
      
      tunaBar.height = _ecosystem._fishCount[TUNA] * 3;
      tunaIcon.y = tunaBar.y - tunaBar.height - tunaIcon.height;
      
      sharkBar.height = _ecosystem._fishCount[SHARK]* 8;
      sharkIcon.y = sharkBar.y - sharkBar.height - sharkIcon.height;
      return true;
    }
    if(!timerActive && gameStarted){
      startTimer();
      timerActive = true;
    }

    //Update Team Money
    if (moneyTimer>moneyTimerMax && moneyChanged==true) _updateMoney();
    else moneyTimer++;
    
    //Update Team Score
    teamAScoreText.text = "Score: ${teamAScore}";
    teamBScoreText.text = "Score: ${teamBScore}";
    
    
    //Update Timer and initiate phase change
//    if (timerGraphicA.width<=2 && !transition) _nextSeason();
//    else {
//      if (!transition)_decreaseTimer();
//    }
    
    
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
  
  
  void startTimer(){
    
    clockUpdateTimer = new Timer.periodic(new Duration(milliseconds:250), updateClock);
    
    if(phase == FISHING_PHASE){
      new Timer(new Duration(milliseconds:FISHING_TIME*1000+250), _nextSeason );
      new Timer(new Duration(milliseconds:FISHING_TIME*1000 -5000), timerSound.play);
      clockCounter = FISHING_TIME*1000;
      new Timer(new Duration(milliseconds:FISHING_TIME*1000+250), clockUpdateTimer.cancel);
    }
    else if(phase == REGROWTH_PHASE){
      new Timer(new Duration(milliseconds:REGROWTH_TIME*1000 +250), _nextSeason );
      new Timer(new Duration(milliseconds:REGROWTH_TIME*1000 -5000), timerSound.play);
      clockCounter = REGROWTH_TIME*1000;
      new Timer(new Duration(milliseconds:REGROWTH_TIME*1000+250), clockUpdateTimer.cancel);
    }
    else if(phase == BUY_PHASE){
      new Timer(new Duration(milliseconds:BUYING_TIME*1000+250), _nextSeason );
      new Timer(new Duration(milliseconds:BUYING_TIME*1000 -5000), timerSound.play);
      clockCounter = BUYING_TIME*1000;
      new Timer(new Duration(milliseconds:BUYING_TIME*1000+250), clockUpdateTimer.cancel);
    }
    
//    clockUpdateTimer = new Timer.periodic(new Duration(milliseconds:250), updateClock);
    
  }
  
  void updateClock(Timer updater){
    clockCounter -= 250;
//    if(clockCounter <= 0){
//      updater.cancel();
//      return;
//    }
    timerPie.graphics.clear();
    if (phase==FISHING_PHASE) {

      timerPie..graphics.beginPath()
          ..graphics.lineTo(0, timerPieRadius)
          ..graphics.lineTo(timerPieRadius, timerPieRadius)
          ..graphics.arc(0, timerPieRadius, timerPieRadius, 0, 2*math.PI * (clockCounter+0.0)/(FISHING_TIME*1000), false)
          ..graphics.closePath();
    }
    else if(phase==BUY_PHASE){

      timerPie..graphics.beginPath()
          ..graphics.lineTo(0, timerPieRadius)
          ..graphics.lineTo(timerPieRadius, timerPieRadius)
          ..graphics.arc(0, timerPieRadius, timerPieRadius, 0, 2*math.PI * (clockCounter+0.0)/(BUYING_TIME*1000), false)
          ..graphics.closePath();
    }
    else if(phase==REGROWTH_PHASE){
      timerPie..graphics.beginPath()
          ..graphics.lineTo(0, timerPieRadius)
          ..graphics.lineTo(timerPieRadius, timerPieRadius)
          ..graphics.arc(0, timerPieRadius, timerPieRadius, 0, 2*math.PI * (clockCounter+0.0)/(REGROWTH_TIME*1000), false)
          ..graphics.closePath();
    }
    timerPie.graphics.fillColor(Color.Black);
    arrangeTimerUI();
  }

  
  bool endgame(){
    if(round >=MAX_ROUNDS || _ecosystem._fishCount[SARDINE] <=0 || _ecosystem._fishCount[TUNA] <=0 || _ecosystem._fishCount[SHARK] <=0){
      return true;
    }
    else{
      return false;
    }
  }
  
  void _nextSeason() {
    if (phase==FISHING_PHASE) {
      transition = true;
      phase = REGROWTH_PHASE;
      _fleet.returnBoats();

      _fleet.alpha = 0;
      _fleet.removeBoatsFromTouchables();
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
//      timerActive = false;
      startTimer();
      
      for(int i = 0; i < _fleet.boats.length; i++){
        _fleet.boats[i]._unloadNet();
      }
      
      if(round == 0){
        for(int i = 0; i < _fleet.boats.length; i++){
          _fleet.boats[i]._promptUserFinished();
        }
      }
    }
    else if (phase==REGROWTH_PHASE) {
      
      if(endgame()){
        transition = true;
        phase = ENDGAME_PHASE;
        
        
        
        Tween t1 = new Tween (badge, 2, TransitionFunction.linear);
        t1.animate.alpha.to(0);
        t1.onComplete = toEndGameTransitionStageOne;
        _juggler.add(t1);
        
        Tween t2 = new Tween(_ecosystem, 2, TransitionFunction.linear);
        t2.animate.alpha.to(0);
        _juggler.add(t2);
        
        for(int i = 0; i < uiObjects.length; i++){
          Tween t3 = new Tween(uiObjects[i], 2, TransitionFunction.linear);
          t3.animate.alpha.to(0);
          _juggler.add(t3);
        }
        
      }
      else{
        
        transition = true;
        phase = BUY_PHASE;
        
        Tween t1 = new Tween (badge, 2, TransitionFunction.linear);
        t1.animate.alpha.to(0);
        t1.onComplete = toBuyPhaseTransitionStageOne;
        _juggler.add(t1);
        
        Tween t2 = new Tween(_ecosystem, 2, TransitionFunction.linear);
        t2.animate.alpha.to(0);
        _juggler.add(t2);
      }

    } else if (phase==BUY_PHASE) {
      transition = true;
      phase = FISHING_PHASE;
      
      teamARoundProfit = 0;
      teamBRoundProfit = 0;
      
      _offseason.hideCircles();
      Tween t1 = new Tween(_offseason.dock, .5, TransitionFunction.linear);
      t1.animate.alpha.to(0);
      t1.onComplete = toFishingPhaseStageOne;
      _juggler.add(t1);
      
      Tween t2 = new Tween(_offseason.sellIslandTop, .5, TransitionFunction.linear);
      t2.animate.alpha.to(0);
      _juggler.add(t2);
      
      Tween t3 = new Tween(_offseason.sellIslandBottom, .5, TransitionFunction.linear);
      t3.animate.alpha.to(0);
      _juggler.add(t3);
    }
    
    else if(phase == ENDGAME_PHASE){

      
      
    }
  }
  
  void toBuyPhaseTransitionStageOne(){
//    _fleet.hideDock();
    
    
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
//    timerActive = false;
    startTimer();
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
      
      Tween t1 = new Tween(roundNumber, .5, TransitionFunction.linear);
      t1.animate.alpha.to(0);
      _juggler.add(t1);

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
    
    round++;
    roundNumber.text = "${round}";
    
    Tween t4 = new Tween(roundNumber, .5, TransitionFunction.linear);
    t4.animate.alpha.to(.7);
    
    
    _juggler.add(t1);
    _juggler.add(t2);
    _juggler.add(t3);
    _juggler.add(t4);

      
  }
  
  void toFishingPhaseStageThree(){
    _fleet.reactivateBoats();
    _fleet.returnBoats();
//    _fleet.showDock();
    _fleet.addBoatsToTouchables();
    Tween t1 = new Tween(_fleet, 1, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    _juggler.add(t1);
    
    Tween t2 = new Tween(_ecosystem, 1, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
    transition = false;
//    timerActive = false;
    startTimer();
  }
 
  void toEndGameTransitionStageOne(){
    _endgame.alpha = 1;
    _endgame.showGameOverReason();
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
    
    //Text Elements for Team Money
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
    
    //Text Elements for Team Cummulative Score
    teamAScoreText = new TextField("Score: ${teamAScore}", format);
    teamAScoreText..width = 200
                  ..x = width/2 - teamAMoneyText.width/2+10
                  ..y = 60
                  ..rotation = math.PI;
//    addChild(teamAScoreText);
//    uiObjects.add(teamAScoreText);

    teamBScoreText = new TextField("Score: ${teamAScore}", format);
    teamBScoreText..width = 200
                  ..x = width/2 + teamBMoneyText.width/2+10
                  ..y = height - 60;
//    addChild(teamBScoreText);
//    uiObjects.add(teamBScoreText);
    
    
    
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
    
    format = new TextFormat("Arial", 15, Color.White, align: "center", bold:true);
    
    roundTitle = new TextField("Round:", format);
    roundTitle..x = width - 65
              ..y = 75
              ..alpha = .7
              ..width = 300
              ..pivotX = roundTitle.width/2
              ..rotation = math.PI/4;
    
    format = new TextFormat("Arial", 50, Color.White, align: "center", bold:true);
    roundNumber = new TextField("${round}", format);
    roundNumber..x = width - 75
               ..y = 85
               ..alpha = .7
               ..width = 300
               ..pivotX = roundNumber.width/2
               ..rotation = math.PI/4; 
    
    format = new TextFormat("Arial", 15, Color.White, align: "center", bold:true);
    seasonTitle = new TextField("season here", format);
    seasonTitle..x = width - 115
               ..y = 125
               ..alpha = .7
               ..width = 300
               ..pivotX = seasonTitle.width/2
               ..rotation = math.PI/4; 
    
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
      addChild(roundTitle);
      addChild(roundNumber);
      addChild(seasonTitle);
      
      uiObjects.add(timerPie);
      uiObjects.add(pieTimerBitmap);
      uiObjects.add(roundTitle);
      uiObjects.add(roundNumber);
      uiObjects.add(seasonTitle);
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
  void arrangeTimerUI(){
    int min = getChildIndex(timerPie);
    DisplayObject lowest;
    if( min > getChildIndex(pieTimerBitmap)){
      min = getChildIndex(pieTimerBitmap);
      lowest = pieTimerBitmap;
    }
    if(min >  getChildIndex(roundNumber)){
      min = getChildIndex(roundNumber);
      lowest = roundNumber;
    }
    if(min > getChildIndex(seasonTitle)){
      min = getChildIndex(seasonTitle);
      lowest = seasonTitle;
    }
    if(min > getChildIndex(roundTitle)){
      min = getChildIndex(roundTitle);
      lowest = roundTitle;
      
    }
    if(lowest != null){
      swapChildren(timerPie, lowest);
    }
  }
}