part of TOTC;


class Title extends Sprite implements Animatable, Touchable{
   ResourceManager _resourceManager;
   Juggler _juggler;
   Game _game;
   Ecosystem _ecosystem;
   
   Bitmap titleBackground;
//   Bitmap endgameIconBottom;
//   Bitmap emptyStars;
   
   SimpleButton playButton;
   SimpleButton aboutButton;
   //SimpleButton replayButton;
     
  Title(this._resourceManager, this._juggler, this._game, this._ecosystem) {
    
    titleBackground = new Bitmap(_resourceManager.getBitmapData("title"));

    playButton = new SimpleButton(
        new Bitmap(_resourceManager.getBitmapData("playButton")),
        new Bitmap(_resourceManager.getBitmapData("playButton")),
        new Bitmap(_resourceManager.getBitmapData("playButtonPressed")),
        new Bitmap(_resourceManager.getBitmapData("playButton")));
    playButton..x = _game.width/2
              ..y = _game.height/2 - 150;
    
    aboutButton = new SimpleButton(
        new Bitmap(_resourceManager.getBitmapData("aboutButton")),
        new Bitmap(_resourceManager.getBitmapData("aboutButton")),
        new Bitmap(_resourceManager.getBitmapData("aboutButtonPressed")),
        new Bitmap(_resourceManager.getBitmapData("aboutButton")));
    aboutButton..x = _game.width/2
              ..y = _game.height/2 + 150;
    
//    replayButton = new SimpleButton(
//                new Bitmap(_resourceManager.getBitmapData("replayButton")),
//                new Bitmap(_resourceManager.getBitmapData("replayButton")),
//                new Bitmap(_resourceManager.getBitmapData("replayButton")),
//                new Bitmap(_resourceManager.getBitmapData("replayButton")));
//    replayButton..alpha = 0
//                ..x = _game.width/2
//                ..y = 25;
//    replayEnable = false;
    
    addChild(titleBackground);
    addChild(playButton);
    addChild(aboutButton);
//    _game.tlayer.touchables.add(this);

    
    //this.alpha = 0;
  }
  
  bool advanceTime(num time){
    return true;
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
  bool containsTouch(Contact e) {
    return true;
  }
   
  bool touchDown(Contact event) {
    _game._nextSeason();
   return true;
  }
   
  void touchUp(Contact event) {


  }
   
  void touchDrag(Contact event) {

  }
   
  void touchSlide(Contact event) { }
}