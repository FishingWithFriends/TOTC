part of TOTC;

class EcosystemBadge extends Sprite implements Animatable{
  
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
  
  int rating, animatedRating;
      
  EcosystemBadge(this._resourceManager, this._juggler, this._game, this._ecosystem) {
  
    initalizeObjects();

  }
  
  bool advanceTime(num time){
    return true;
  }
  
  void showBadge(){
    
    rating = 2;
    animatedRating = 0;
    Tween t1 = new Tween(foodWeb, 1, TransitionFunction.linear);
          t1.animate.alpha.to(1);
    Tween t2 = new Tween(stars0, 1, TransitionFunction.linear);
          t2.animate.alpha.to(1);
          t2.onComplete = showStars;
    _juggler.add(t1);
    _juggler.add(t2);
    
    
    
    for(int i = 0; i < rating; i++){
      
    }
    
  }
  
  void hideBadge(){
//    if(contains(foodWeb)) removeChild(foodWeb);
  }
  
  void showStars(){
    if(animatedRating == rating) return;
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
  
  int determineRating(){
    int rating;
    
    int sardineCount = _ecosystem._fishCount[Ecosystem.SARDINE];
    int tunaCount = _ecosystem._fishCount[Ecosystem.TUNA];
    int sharkCount = _ecosystem._fishCount[Ecosystem.SHARK];

    if (sardineCount < 50)
      _sardineStatusText = "Sardine populuation is endangered";
    else if (sardineCount > Ecosystem.MAX_SARDINE-250)
      _sardineStatusText = "Sardines are overpopulated";
    else
      _sardineStatusText = null;
    
    if (tunaCount < 50)
      _tunaStatusText = "Tuna populuation is endangered";
    else if (tunaCount > Ecosystem.MAX_TUNA-250)
      _tunaStatusText = "Tunas are overpopulated";
    else
      _tunaStatusText = null;
    
    if (sharkCount < 50)
      _sharkStatusText = "Shark populuation is endangered";
    else if (sharkCount > Ecosystem.MAX_SARDINE-250)
      _sharkStatusText = "Sharks are overpopulated";
    else
      _sharkStatusText = null;
    
    
    
    return 2;
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
    
  }
}