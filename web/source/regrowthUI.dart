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
  
  Bitmap badgeSardine;
  Bitmap badgeTuna;
  Bitmap badgeShark;
  
  
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
  
  Sound badgeSound;
  Sound starSound;
  
  bool showStatusText = false;
  
  EcosystemBadge(this._resourceManager, this._juggler, this._game, this._ecosystem) {
  
    teamACounter = new ScoreCounter(_resourceManager, _juggler, _game, this, TEAMA);
    teamBCounter = new ScoreCounter(_resourceManager, _juggler, _game, this, TEAMB);
    addChild(teamACounter);
    addChild(teamBCounter);
    initalizeObjects();
    
    badgeSound = _resourceManager.getSound("badgeSound");
    starSound = _resourceManager.getSound("starSound");
  }
  
  bool advanceTime(num time){
    return true;
  }
  
  void showBadge(){
    
    rating = determineRating();
    animatedRating = 0;
    Tween t1 = new Tween(foodWeb, .5, TransitionFunction.linear);
          t1.animate.alpha.to(1);
    Tween t2 = new Tween(stars0, .5, TransitionFunction.linear);
          t2.animate.alpha.to(1);
          t2.onComplete = showText;
    _juggler.add(t1);
    _juggler.add(t2);
    
    
  }
  
  void hideBadge(){
    foodWeb.alpha = 0;
    stars0.alpha = 0;
    stars1.alpha = 0;
    stars2.alpha = 0;
    stars3.alpha = 0;
    
    badgeSardine.alpha = 0;
    badgeTuna.alpha = 0;
    badgeShark.alpha = 0;
    
    teamACounter.hideCounter();
    teamBCounter.hideCounter();
  }
  
  void showStars(){
    if(animatedRating == rating){
      Timer temp = new Timer(const Duration(seconds:1), teamBCounter.showCounter);
      Timer temp2 = new Timer(const Duration(seconds:1), teamACounter.showCounter);
    }
    else{
      
      Bitmap toShow;
      _game.starCount++;
      if(animatedRating == 0) toShow = stars1;
      else if(animatedRating == 1) toShow = stars2;
      else if(animatedRating == 2) toShow = stars3;
      
      Tween t1 = new Tween(toShow, .5, TransitionFunction.easeInOutQuadratic);
      t1.animate.alpha.to(1);
      starSound.play();
      t1.onComplete = showStars;
      _juggler.add(t1);
      animatedRating++;
    }
    
  }
  
  void showText(){

    
    if(showStatusText){

      _sardineStatusTextFieldTop.text = _sardineStatusText;
      
      _sardineStatusTextFieldBottom.text = _sardineStatusText;
      
      Tween t1 = new Tween(_sardineStatusTextFieldTop, .5, TransitionFunction.easeInOutQuadratic);
      t1.animate.alpha.to(1);
      
      Tween t4 = new Tween(_sardineStatusTextFieldBottom, .5, TransitionFunction.easeInOutQuadratic);
      t4.animate.alpha.to(1);
      
      
      _juggler.add(t1);
      _juggler.add(t4);
    }
            
    Tween t7 = new Tween(badgeSardine, .5, TransitionFunction.easeInOutQuartic);
    t7.animate.alpha.to(1);
    badgeSound.play();
    t7.onComplete = showTextTwo;
    _juggler.add(t7);
    
  }
  void showTextTwo(){

    
    if(showStatusText){
      _tunaStatusTextFieldTop.text = _tunaStatusText;
      _tunaStatusTextFieldBottom.text = _tunaStatusText;
      
      Tween t2 = new Tween(_tunaStatusTextFieldTop, .5, TransitionFunction.easeInOutQuadratic);
      t2.animate.alpha.to(1);
          
      Tween t5 = new Tween(_tunaStatusTextFieldBottom, .5, TransitionFunction.easeInOutQuadratic);
      t5.animate.alpha.to(1);
      _juggler.add(t2);
      _juggler.add(t5);
    }
    
    Tween t8 = new Tween(badgeTuna, .5, TransitionFunction.easeInOutQuadratic);
    t8.animate.alpha.to(1);
    badgeSound.play();
    t8.onComplete = showTextThree;
    
    _juggler.add(t8);    
  }
  void showTextThree(){

    
    if(showStatusText){
      _sharkStatusTextFieldTop.text = _sharkStatusText;
      _sharkStatusTextFieldBottom.text = _sharkStatusText;
      Tween t3 = new Tween(_sharkStatusTextFieldTop, .5, TransitionFunction.easeInOutQuadratic);
      t3.animate.alpha.to(1);
      
      Tween t6 = new Tween(_sharkStatusTextFieldBottom, .5, TransitionFunction.easeInOutQuadratic);
      t6.animate.alpha.to(1);
      
      _juggler.add(t3);
      _juggler.add(t6);
    }
            
    Tween t9 = new Tween(badgeShark, .5, TransitionFunction.easeInOutQuadratic);
    t9.animate.alpha.to(1);
    badgeSound.play();
    t9.onComplete = showStars;

    _juggler.add(t9);
    
  }
  
  int determineRating(){
    int rating = 3;
    
    int sardineCount = _ecosystem._fishCount[Ecosystem.SARDINE];
    int tunaCount = _ecosystem._fishCount[Ecosystem.TUNA];
    int sharkCount = _ecosystem._fishCount[Ecosystem.SHARK];

    if (sardineCount < 150 && sardineCount > 0){
      _sardineStatusText = "Sardine populuation is endangered";
      badgeSardine.bitmapData = _resourceManager.getBitmapData("badgeEndangered");
      rating--;
    }
    else if (sardineCount > Ecosystem.MAX_SARDINE-50){
      _sardineStatusText = "Sardines are overpopulated";
      badgeSardine.bitmapData = _resourceManager.getBitmapData("badgeOverpopulated");
      rating--;
    }
    else if(sardineCount <= 0){
      _sardineStatusText = "Sardines are extinct";
      badgeSardine.bitmapData = _resourceManager.getBitmapData("badgeExtinct");
      rating--;
    }
    else{
      _sardineStatusText = "";
      badgeSardine.bitmapData = _resourceManager.getBitmapData("badgeLeastConcern");
    }
    
    
    if (tunaCount < 35 && tunaCount > 0){
      _tunaStatusText = "Tuna populuation is endangered";
      badgeTuna.bitmapData = _resourceManager.getBitmapData("badgeEndangered");
      rating--;
    }
    else if (tunaCount > Ecosystem.MAX_TUNA-25){
      _tunaStatusText = "Tunas are overpopulated";
      badgeTuna.bitmapData = _resourceManager.getBitmapData("badgeOverpopulated");
      rating--;
    }
    else if (tunaCount <= 0){
      _tunaStatusText = "Tunas are extinct!";
      badgeTuna.bitmapData = _resourceManager.getBitmapData("badgeExtinct");
      rating--;
    }
    else{
      _tunaStatusText = "";
      badgeTuna.bitmapData = _resourceManager.getBitmapData("badgeLeastConcern");
    }
    
    
    if (sharkCount < 5 && sharkCount > 0){
      _sharkStatusText = "Shark populuation is endangered";
      badgeShark.bitmapData = _resourceManager.getBitmapData("badgeEndangered");
      rating--;
    }
    else if (sharkCount > 12){
      _sharkStatusText = "Sharks are overpopulated";
      badgeShark.bitmapData = _resourceManager.getBitmapData("badgeOverpopulated");
      rating--;
    }
    else if(sharkCount <= 0){
      _sharkStatusText = "Sharks are extinct";
      badgeShark.bitmapData = _resourceManager.getBitmapData("badgeExtinct");
      rating--;
    }
    else{
      _sharkStatusText = "";
      badgeShark.bitmapData = _resourceManager.getBitmapData("badgeLeastConcern");
    }

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
           ..x = _game.width/2+15
           ..y = _game.height/2
           ..alpha = 0;
    addChild(stars0);
    
    
    stars1 = new Bitmap(_resourceManager.getBitmapData('stars1'));
    stars1..pivotX = stars1.width/2
           ..pivotY = stars1.height/2
           ..x = _game.width/2+15
           ..y = _game.height/2
           ..alpha = 0;
    addChild(stars1);
    
    
    stars2 = new Bitmap(_resourceManager.getBitmapData('stars2'));
    stars2..pivotX = stars2.width/2
           ..pivotY = stars2.height/2
           ..x = _game.width/2+15
           ..y = _game.height/2
           ..alpha = 0;
    addChild(stars2);
    
    stars3 = new Bitmap(_resourceManager.getBitmapData('stars3'));
    stars3..pivotX = stars3.width/2
           ..pivotY = stars3.height/2
           ..x = _game.width/2+15
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
   
    badgeSardine = new Bitmap(_resourceManager.getBitmapData("badgeLeastConcern"));
    badgeSardine..pivotX = badgeSardine.width/2
                ..pivotY = badgeSardine.height/2
                ..x = _game.width/2
                ..y = _game.height/2+150
                ..alpha = 0
                ..rotation = -math.PI/4;
    addChild(badgeSardine);
    

    badgeTuna = new Bitmap(_resourceManager.getBitmapData("badgeLeastConcern"));
    badgeTuna..pivotX = badgeTuna.width/2
                ..pivotY = badgeTuna.height/2
                ..x = _game.width/2 - 150
                ..y = _game.height/2+30
                ..alpha = 0
                ..rotation = -math.PI/4;
    addChild(badgeTuna);
    

    badgeShark = new Bitmap(_resourceManager.getBitmapData("badgeLeastConcern"));
    badgeShark..pivotX = badgeShark.width/2
                ..pivotY = badgeShark.height/2
                ..x = _game.width/2+ 30
                ..y = _game.height/2-140
                ..alpha = 0
                ..rotation = -math.PI/4;
    addChild(badgeShark);
    
    
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
  
  Shape uiBox, teamBase;
  TextField scorePrompt;
  TextField multiplier;
  TextField total;
  TextField sum;
  
  int profit, starMult, totalVal;
  
  ScoreCounter(this._resourceManager, this._juggler, this._game, this._ecosystemBadge, this.teamType){
    
    num rotationVal;
    int boxX, boxY, r1,r2,r3, r4, offsetX, offsetY;
    int baseX, baseY;
    int fillColor;

        if(teamType == TEAMA){
          baseX = 0;
          baseY = 0;
          r1 = 400;
          fillColor = Color.Green;
         
        }
        else if(teamType == TEAMB){
          baseX = _game.width;
          baseY = _game.height;
          r1 = 400;
          fillColor = Color.Red;
              
        }    
        
   teamBase = new Shape();
   teamBase..graphics.arc(baseX, baseY, r1, 0, 2*math.PI, false)
            ..graphics.fillColor(fillColor)
            ..alpha = 0;
   addChild(teamBase);
   
   if(teamType == TEAMA){
     rotationVal = 3*math.PI/4;
     boxX = 500;
     boxY = 75;
     r1 = 250;
     r2 = 210;
     r3 = 200;
     r4 = 150;
     offsetX = 0;
     offsetY = 0;
   }
   else if(teamType == TEAMB){
     rotationVal = -math.PI/4;
     boxX = _game.width - 500;
     boxY = _game.height - 75;
     r1 = 250;
     r2 = 210;
     r3 = 200;
     r4 = 150;
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
//   addChild(uiBox);

       
       
   TextFormat format = new TextFormat("Arial", 36, Color.White, align: "right", bold: true);
   
   scorePrompt = new TextField("", format);
   scorePrompt..alpha = 0
              ..width = uiBox.width+50
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
   
   sum = new TextField("", format);
   sum..alpha = 0
        ..width = uiBox.width
        ..pivotX = total.width/2
        ..rotation = rotationVal
        ..x =offsetX - r4*math.cos(rotationVal)
        ..y =offsetY + r4*math.sin(rotationVal);
   addChild(sum);

  }
  
  void showCounter(){
    
    Tween t1 = new Tween(uiBox, .5, TransitionFunction.linear);
    t1.animate.alpha.to(.6);
    _juggler.add(t1);
    
    Tween t3 = new Tween(teamBase, .5, TransitionFunction.linear);
    t3.animate.alpha.to(.6);
    _juggler.add(t3);
    
    
    if(teamType == TEAMA) profit = _game.teamARoundProfit;
    else if(teamType == TEAMB) profit = _game.teamBRoundProfit;
    
    scorePrompt.text = "Season Profit: ${profit}";
    Tween t2 = new Tween(scorePrompt, .5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    t2.onComplete = showTotalProfit;
    _juggler.add(t2);
    
  }
  
  void showTotalProfit(){
    if(teamType == TEAMA){
      _game.teamATotalProfit += profit;
      multiplier.text = "Total: ${_game.teamATotalProfit}";
    }
    else if(teamType == TEAMB){
      _game.teamBTotalProfit += profit;
      multiplier.text = "Total: ${_game.teamBTotalProfit}";
    }
    
    Tween t2 = new Tween(multiplier, .5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
//    t2.onComplete = showTotalProfit;
    _juggler.add(t2);
    
  }
  
  void showMultiplier(){
    starMult = _ecosystemBadge.rating;
    multiplier.text = "Ecosystem Star Health: x ${starMult}";
    Tween t1 = new Tween(multiplier, .5, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    t1.onComplete = showTotal;
    _juggler.add(t1);
  }
  
  void showTotal(){
    totalVal = profit * starMult;
    num val = addToTotal();
    total.text = "Round Total:  ${totalVal}";
    sum.text = "Current Score: ${val}";

    Tween t1 = new Tween(total, .5, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    _juggler.add(t1);
    
    Tween t2 = new Tween(sum, .5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
        
  }
  
  num addToTotal(){
    num val;
    if(teamType == TEAMA){
      val = _game.teamAScore += totalVal;
    }
    else if (teamType == TEAMB){
      val = _game.teamBScore += totalVal;
    }
    else{
      val = 0;
    }
    return val;
  }
  
  void hideCounter(){
    uiBox.alpha = 0;
    teamBase.alpha = 0;
    scorePrompt.alpha = 0;
    multiplier.alpha = 0;
    total.alpha = 0;
    sum.alpha = 0;
  }
  
  
}