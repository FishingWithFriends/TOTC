part of TOTC;

class EcosystemBadge extends Sprite implements Animatable{
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  Bitmap foodWeb;
  Bitmap stars0;
  Bitmap stars1;
  Bitmap stars2;
  Bitmap stars3;
  
  
  var _sardineStatusText;
  var _tunaStatusText;
  var _sharkStatusText;
  
  TextField _sardineStatusTextFieldTop;
  TextField _tunaStatusTextFieldTop;
  TextField _sharkStatusTextFieldTop;

  TextField _sardineStatusTextFieldBottom;
  TextField _tunaStatusTextFieldBottom;
  TextField _sharkStatusTextFieldBottom;
  
  ScoreCounter teamACounter;
  ScoreCounter teamBCounter;
  
  int rating, animatedRating;
      
  EcosystemBadge(this._resourceManager, this._juggler, this._game, this._ecosystem) {
  
    teamACounter = new ScoreCounter(_resourceManager, _juggler, _game, this, TEAMA);
    teamBCounter = new ScoreCounter(_resourceManager, _juggler, _game, this, TEAMB);
    addChild(teamACounter);
    addChild(teamBCounter);
    initalizeObjects();

  }
  
  bool advanceTime(num time){
    return true;
  }
  
  void showBadge(){
    
    rating = determineRating();
    animatedRating = 0;
    Tween t1 = new Tween(foodWeb, 1, TransitionFunction.linear);
          t1.animate.alpha.to(1);
    Tween t2 = new Tween(stars0, 1, TransitionFunction.linear);
          t2.animate.alpha.to(1);
          t2.onComplete = showStars;
    _juggler.add(t1);
    _juggler.add(t2);
    
    
  }
  
  void hideBadge(){
    foodWeb.alpha = 0;
    stars0.alpha = 0;
    stars1.alpha = 0;
    stars2.alpha = 0;
    stars3.alpha = 0;
    
    teamACounter.hideCounter();
    teamBCounter.hideCounter();
  }
  
  void showStars(){
    if(animatedRating == rating) showText();
    else{
      
      Bitmap toShow;
      
      if(animatedRating == 0) toShow = stars1;
      else if(animatedRating == 1) toShow = stars2;
      else if(animatedRating == 2) toShow = stars3;
      
      Tween t1 = new Tween(toShow, 1, TransitionFunction.easeInOutQuadratic);
      t1.animate.alpha.to(1);
      t1.onComplete = showStars;
      _juggler.add(t1);
      animatedRating++;
    }
    
  }
  
  void showText(){

    _sardineStatusTextFieldTop.text = _sardineStatusText;
    _tunaStatusTextFieldTop.text = _tunaStatusText;
    _sharkStatusTextFieldTop.text = _sharkStatusText;
    
    _sardineStatusTextFieldBottom.text = _sardineStatusText;
    _tunaStatusTextFieldBottom.text = _tunaStatusText;
    _sharkStatusTextFieldBottom.text = _sharkStatusText;
    
    Tween t1 = new Tween(_sardineStatusTextFieldTop, 1, TransitionFunction.easeInOutQuadratic);
    t1.animate.alpha.to(1);
    
    Tween t2 = new Tween(_tunaStatusTextFieldTop, 1, TransitionFunction.easeInOutQuadratic);
    t2.animate.alpha.to(1);
        
    Tween t3 = new Tween(_sharkStatusTextFieldTop, 1, TransitionFunction.easeInOutQuadratic);
    t3.animate.alpha.to(1);
    
    Tween t4 = new Tween(_sardineStatusTextFieldBottom, 1, TransitionFunction.easeInOutQuadratic);
    t4.animate.alpha.to(1);
    
    Tween t5 = new Tween(_tunaStatusTextFieldBottom, 1, TransitionFunction.easeInOutQuadratic);
    t5.animate.alpha.to(1);
    
    Tween t6 = new Tween(_sharkStatusTextFieldBottom, 1, TransitionFunction.easeInOutQuadratic);
    t6.animate.alpha.to(1);
            
    
    t1.onComplete = teamACounter.showCounter;
    t2.onComplete = teamBCounter.showCounter;
    
    _juggler.add(t1);
    _juggler.add(t2);
    _juggler.add(t3);
    _juggler.add(t4);
    _juggler.add(t5);
    _juggler.add(t6);
    
  }
  
  int determineRating(){
    int rating = 3;
    
    int sardineCount = _ecosystem._fishCount[Ecosystem.SARDINE];
    int tunaCount = _ecosystem._fishCount[Ecosystem.TUNA];
    int sharkCount = _ecosystem._fishCount[Ecosystem.SHARK];

    if (sardineCount < 50){
      _sardineStatusText = "Sardine populuation is endangered";
      rating--;
    }
    else if (sardineCount > Ecosystem.MAX_SARDINE-250){
      _sardineStatusText = "Sardines are overpopulated";
      rating--;
    }
    else
      _sardineStatusText = "";
    
    if (tunaCount < 50){
      _tunaStatusText = "Tuna populuation is endangered";
      rating--;
    }
    else if (tunaCount > Ecosystem.MAX_TUNA-15){
      _tunaStatusText = "Tunas are overpopulated";
      rating--;
    }
    else
      _tunaStatusText = "";
    
    if (sharkCount < 50){
      _sharkStatusText = "Shark populuation is endangered";
      rating--;
    }
    else if (sharkCount > Ecosystem.SHARK-1){
      _sharkStatusText = "Sharks are overpopulated";
      rating--;
    }
    else
      _sharkStatusText = "";
    

    return rating;
  }
  
  
  void initalizeObjects(){
    foodWeb = new Bitmap(_resourceManager.getBitmapData('foodWeb'));
    foodWeb..pivotX = foodWeb.width/2
           ..pivotY = foodWeb.height/2
           ..x = _game.width/2 -100
           ..y = _game.height/2
           ..alpha = 0;
    addChild(foodWeb);
    
    stars0 = new Bitmap(_resourceManager.getBitmapData('stars0'));
    stars0..pivotX = stars0.width/2
           ..pivotY = stars0.height/2
           ..x = _game.width/2
           ..y = _game.height/2
           ..alpha = 0;
    addChild(stars0);
    
    
    stars1 = new Bitmap(_resourceManager.getBitmapData('stars1'));
    stars1..pivotX = stars1.width/2
           ..pivotY = stars1.height/2
           ..x = _game.width/2
           ..y = _game.height/2
           ..alpha = 0;
    addChild(stars1);
    
    
    stars2 = new Bitmap(_resourceManager.getBitmapData('stars2'));
    stars2..pivotX = stars2.width/2
           ..pivotY = stars2.height/2
           ..x = _game.width/2
           ..y = _game.height/2
           ..alpha = 0;
    addChild(stars2);
    
    stars3 = new Bitmap(_resourceManager.getBitmapData('stars3'));
    stars3..pivotX = stars3.width/2
           ..pivotY = stars3.height/2
           ..x = _game.width/2
           ..y = _game.height/2
           ..alpha = 0;
    addChild(stars3);
    
    TextFormat format = new TextFormat("Arial", 22, Color.Red, align: "left", bold: true);
    
    _sardineStatusTextFieldTop = new TextField("", format);
    _sardineStatusTextFieldTop..width = 1000
                           ..alpha = 0
                           ..x = _game.width/2-215
                           ..y = _game.height/2-200;
    addChild(_sardineStatusTextFieldTop);
    
    _tunaStatusTextFieldTop = new TextField("", format);
    _tunaStatusTextFieldTop..width = 1000
                           ..alpha = 0
                           ..x = _game.width/2-215
                           ..y = _game.height/2-220;
    addChild(_tunaStatusTextFieldTop);
    
    _sharkStatusTextFieldTop = new TextField("", format);
    _sharkStatusTextFieldTop..width = 1000
                           ..alpha = 0
                           ..x = _game.width/2-215
                           ..y = _game.height/2-240;
    addChild(_sharkStatusTextFieldTop);

    
    _sardineStatusTextFieldBottom = new TextField("", format);
    _sardineStatusTextFieldBottom..width = 1000
                           ..alpha = 0
                           ..rotation = math.PI
                           ..x = _game.width/2+215
                           ..y = _game.height/2+200;
    addChild(_sardineStatusTextFieldBottom);
    
    _tunaStatusTextFieldBottom = new TextField("", format);
    _tunaStatusTextFieldBottom..width = 1000
                           ..alpha = 0
                           ..rotation = math.PI
                           ..x = _game.width/2+215
                           ..y = _game.height/2+220;
    addChild(_tunaStatusTextFieldBottom);
    
    _sharkStatusTextFieldBottom = new TextField("", format);
    _sharkStatusTextFieldBottom..width = 1000
                           ..alpha = 0
                           ..rotation = math.PI
                           ..x = _game.width/2+215
                           ..y = _game.height/2+240;
    addChild(_sharkStatusTextFieldBottom);
    
  }
  
}

class ScoreCounter extends Sprite{
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  EcosystemBadge _ecosystemBadge;
  
  int teamType;
  
  Shape uiBox;
  TextField scorePrompt;
  TextField multiplier;
  TextField total;
  
  int profit, starMult, totalVal;
  
  ScoreCounter(this._resourceManager, this._juggler, this._game, this._ecosystemBadge, this.teamType){
    
    num rotationVal;
    int boxX, boxY, r1,r2,r3, offsetX, offsetY;
    
    
    if(teamType == TEAMA){
      rotationVal = 3*math.PI/4;
      boxX = 500;
      boxY = 75;
      r1 = 250;
      r2 = 225;
      r3 = 200;
      offsetX = 0;
      offsetY = 0;
    }
    else if(teamType == TEAMB){
      rotationVal = -math.PI/4;
      boxX = _game.width - 500;
      boxY = _game.height - 75;
      r1 = 250;
      r2 = 225;
      r3 = 200;
      offsetX = _game.width;
      offsetY = _game.height;
    }    
      
    uiBox = new Shape();
    uiBox..graphics.rect(300, 200, 300, 100)
         ..graphics.fillColor(Color.Black)
         ..pivotX = uiBox.width/2
         ..pivotY = uiBox.height/2
         ..rotation = rotationVal
         ..x = boxX
         ..y = boxY
         ..alpha = 0;
   addChild(uiBox);
   
   TextFormat format = new TextFormat("Arial", 18, Color.White, align: "right", bold: true);
   
   scorePrompt = new TextField("", format);
   scorePrompt..alpha = 0
              ..width = uiBox.width
              ..pivotX = scorePrompt.width/2
              ..rotation = rotationVal
              ..x =offsetX - r1*math.cos(rotationVal)
              ..y =offsetY + r1*math.sin(rotationVal);
   addChild(scorePrompt);
   
   multiplier = new TextField("", format);
   multiplier..alpha = 0
             ..width = uiBox.width
             ..pivotX = multiplier.width/2
             ..rotation = rotationVal
             ..x = offsetX - r2*math.cos(rotationVal)
             ..y = offsetY + r2*math.sin(rotationVal);
   addChild(multiplier);
   
   total = new TextField("", format);
   total..alpha = 0
        ..width = uiBox.width
        ..pivotX = total.width/2
        ..rotation = rotationVal
        ..x =offsetX - r3*math.cos(rotationVal)
        ..y =offsetY + r3*math.sin(rotationVal);
   addChild(total);
  }
  
  void showCounter(){
    
    Tween t1 = new Tween(uiBox, 1, TransitionFunction.linear);
    t1.animate.alpha.to(.6);
    _juggler.add(t1);
    
    
    if(teamType == TEAMA) profit = _game.teamARoundProfit;
    else if(teamType == TEAMB) profit = _game.teamBRoundProfit;
    
    scorePrompt.text = "Profit from previous season: ${profit}";
    Tween t2 = new Tween(scorePrompt, 1, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    t2.onComplete = showMultiplier;
    _juggler.add(t2);
    
  }
  
  void showMultiplier(){
    starMult = _ecosystemBadge.rating;
    multiplier.text = "Ecosystem Star Health: x ${starMult}";
    Tween t1 = new Tween(multiplier, 1, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    t1.onComplete = showTotal;
    _juggler.add(t1);
  }
  
  void showTotal(){
    totalVal = profit * starMult;
    total.text = "Total:  ${totalVal}";
    Tween t1 = new Tween(total, 1, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    _juggler.add(t1);
  }
  
  void hideCounter(){
    uiBox.alpha = 0;
    scorePrompt.alpha = 0;
    multiplier.alpha = 0;
    total.alpha = 0;
  }
  
  
}