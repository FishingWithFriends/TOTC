part of TOTC;


class Title extends Sprite implements Animatable{
   ResourceManager _resourceManager;
   Juggler _juggler;
   Game _game;
   Ecosystem _ecosystem;
   
   Bitmap titleBackground;
   MyButton aboutPage;
//   Bitmap endgameIconBottom;
//   Bitmap emptyStars;
   
   MyButton playButton;
   MyButton aboutButton;
   //SimpleButton replayButton;
   var aboutOpen = false;
  Title(this._resourceManager, this._juggler, this._game, this._ecosystem) {
    
    titleBackground = new Bitmap(_resourceManager.getBitmapData("title"));
    
    aboutPage = new MyButton(_game,0, 0, 
           _resourceManager.getBitmapData("about"),
          _resourceManager.getBitmapData("about"),
          _resourceManager.getBitmapData("about"),
          hideAbout);
    aboutPage.alpha = 0;
    aboutPage.hide();
    
    playButton = new MyButton(_game,_game.width/2, _game.height/2 - 150, 
        _resourceManager.getBitmapData("playButton"),
       _resourceManager.getBitmapData("playButton"),
       _resourceManager.getBitmapData("playButtonPressed"),
       _game._nextSeason);
    
    aboutButton = new MyButton(_game, _game.width/2, _game.height/2 + 150, 
    _resourceManager.getBitmapData("aboutButton"),
    _resourceManager.getBitmapData("aboutButton"),
    _resourceManager.getBitmapData("aboutButtonPressed"),
       showAbout);

    
    addChild(titleBackground);
    addChild(playButton);
    addChild(aboutButton);
    addChild(aboutPage);
//    _game.tlayer.touchables.add(this);

    
    //this.alpha = 0;
  }
  
  bool advanceTime(num time){
    return true;
  }
  
  void hide(){
    playButton.hide();
    aboutButton.hide();
    
    Tween t1 = new Tween(titleBackground, .5, TransitionFunction.linear);
     t1.animate.alpha.to(0);
     _juggler.add(t1);
     
     Tween t2 = new Tween(playButton, .5, TransitionFunction.linear);
      t2.animate.alpha.to(0);
      _juggler.add(t2);
      
      Tween t3 = new Tween(aboutButton, .5, TransitionFunction.linear);
       t3.animate.alpha.to(0);
       _juggler.add(t3);
  }
  
 
  void showAbout(){
    aboutOpen = true;
    playButton.hide();
    aboutButton.hide();
    aboutPage.show();
    print("Width:" + _game.width.toString());
    print("height:" + _game.height.toString());
    
    Tween t1 = new Tween(aboutPage, .5, TransitionFunction.linear);
     t1.animate.alpha.to(1);
     _juggler.add(t1);
    
    Tween t2 = new Tween(playButton, .5, TransitionFunction.linear);
     t2.animate.alpha.to(0);
     _juggler.add(t2);
     
     Tween t3 = new Tween(aboutButton, .5, TransitionFunction.linear);
      t3.animate.alpha.to(0);
      _juggler.add(t3);
 }
  
  void hideAbout(){
    aboutOpen = false;
    playButton.show();
    aboutButton.show();
    aboutPage.hide();
    
    Tween t1 = new Tween(aboutPage, .5, TransitionFunction.linear);
     t1.animate.alpha.to(0);
     _juggler.add(t1);
    
    Tween t2 = new Tween(playButton, .5, TransitionFunction.linear);
     t2.animate.alpha.to(1);
     _juggler.add(t2);
     
     Tween t3 = new Tween(aboutButton, .5, TransitionFunction.linear);
      t3.animate.alpha.to(1);
      _juggler.add(t3);
  
  
  }


//  void showTeamUI(){
//    teamAui.teamFinalScoreText.text = "Final Score: ${_game.teamAMoney}";
//    teamBui.teamFinalScoreText.text = "Final Score: ${_game.teamBMoney}";
//    Tween t1 = new Tween(teamAui, 1.5, TransitionFunction.linear);
//    t1.animate.alpha.to(1);
//
//    
//    Tween t2 = new Tween(teamBui, 1.5, TransitionFunction.linear);
//    t2.animate.alpha.to(1);
//    
//    
//    new Timer(new Duration(seconds:14), () => replayEnable = true);
//    new Timer(new Duration(seconds:15), showReplayButton);
//    
//    _juggler.add(t1);
//    _juggler.add(t2);
//  }
  

  
//  void hideTeamUI(){
//    Tween t1 = new Tween(teamAui, 1.5, TransitionFunction.linear);
//    t1.animate.alpha.to(0);
//    _juggler.add(t1);
//    
//    Tween t2 = new Tween(teamBui, 1.5, TransitionFunction.linear);
//    t2.animate.alpha.to(0);
//    _juggler.add(t2);
//  }
  
//  void showBestScores(){
//    
//    
//    Tween t1 = new Tween(bestScoresA, .5, TransitionFunction.linear);
//    t1.animate.alpha.to(1);
//    _juggler.add(t1);
//    
//    Tween t2 = new Tween(bestScoresB, .5, TransitionFunction.linear);
//    t2.animate.alpha.to(1);
//    _juggler.add(t2);
//    
//  }

}


class MyButton extends Sprite implements Touchable{
  Game _game;
  SimpleButton button;
  var xPos, yPos;
  Function callback;

    
  MyButton(this._game, this.xPos, this.yPos, BitmapData regular, BitmapData onHover, BitmapData onClick, this.callback){
    button = new SimpleButton(
            new Bitmap(regular),
            new Bitmap(onHover),
            new Bitmap(onClick),
            new Bitmap(regular));
    button..x = xPos
                  ..y = yPos;
  
    addChild(button);
    _game.tlayer.touchables.add(this);
  }
  
  void hide(){
    _game.tlayer.touchables.remove(this);
  }
  void show(){
    _game.tlayer.touchables.add(this);
  }
  
  bool containsTouch(Contact e) {
    if(e.touchX > xPos && e.touchX < xPos + button.width && e.touchY > yPos && e.touchY < yPos + button.height){
      return true;
    }
    return false;
  }
   
  bool touchDown(Contact event) {
    callback();
   return true;
  }
   
  void touchUp(Contact event) {


  }
   
  void touchDrag(Contact event) {

  }
   
  void touchSlide(Contact event) { }
}