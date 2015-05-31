part of TOTC;


class FinalSummary extends Sprite implements Animatable{
   ResourceManager _resourceManager;
   Juggler _juggler;
   Game _game;
   Ecosystem _ecosystem;
   
   Sound ui_restartGameSound;
   
   Bitmap summaryBackground;
//   Bitmap endgameIconBottom;
//   Bitmap emptyStars;
   
   MyButton replayButton;
   TextField summaryText;
   TextField informationText;
   
   //SimpleButton replayButton;
   var aboutOpen = false;
   FinalSummary(this._resourceManager, this._juggler, this._game, this._ecosystem) {
    
     summaryBackground = new Bitmap(_resourceManager.getBitmapData("end"));
    

    BitmapData playButtonBitmap = _resourceManager.getBitmapData("replayButton");
     replayButton = new MyButton(_game, _game.width/2 - playButtonBitmap.width/2 , _game.height/2 + 500, 
         playButtonBitmap,
         playButtonBitmap,
    _resourceManager.getBitmapData("replayButtonPressed"),
    _replayButtonPressed);

     
     ui_restartGameSound = _resourceManager.getSound("ui_restartGame");

     
    this.alpha = 0;


    
    addChild(summaryBackground);
    addChild(replayButton);
    
    hide();
    
  }
   
  
   
   void _replayButtonPressed(){
     ui_restartGameSound.play();
       html.window.location.reload();

   }
  
  bool advanceTime(num time){
    return true;
  }
  
  void hide(){
    replayButton.hide();
    
    Tween t1 = new Tween(summaryBackground, .5, TransitionFunction.linear);
     t1.animate.alpha.to(0);
     _juggler.add(t1);
     
     Tween t2 = new Tween(replayButton, .5, TransitionFunction.linear);
      t2.animate.alpha.to(0);
      _juggler.add(t2);
  }
  
  void show(){
    

    
    replayButton.show();
    
    Tween t1 = new Tween(summaryBackground, .5, TransitionFunction.linear);
     t1.animate.alpha.to(1);
     t1.onComplete = showQuestionPrompt;
     _juggler.add(t1);
     
     Tween t2 = new Tween(replayButton, .5, TransitionFunction.linear);
      t2.animate.alpha.to(1);
      _juggler.add(t2);
      

      Tween t3 = new Tween(this, .5, TransitionFunction.linear);
       t3.animate.alpha.to(1);
       _juggler.add(t3);

    
  }
  
  void showQuestionPrompt(){
    TextFormat format = new TextFormat("Arial", 36, Color.LightGray, align: "center", bold: true);
    
    if(_game.round == Game.MAX_ROUNDS){
         summaryText = new TextField("Congratulations, your ecosystem survived for 5 rounds! \n"+
                                      "Try to earn more stars by adjusting your fishing strategy \n"+
                                      "to keep all of your fish populations healthy.", format);
         summaryText..alpha = 0
                    ..width = _game.width*3/4
                    ..height = 250
                    ..x =_game.width/2-summaryText.width/2
                    ..y =_game.height/3;
         addChild(summaryText);
         Tween t1 = new Tween(summaryText, .05, TransitionFunction.linear);
         t1.animate.alpha.to(1);
         _juggler.add(t1);
    }
    else if(_ecosystem._fishCount[Ecosystem.SARDINE]<=0){
      summaryText = new TextField("Sardines were driven to extinction by overfishing and your ecosystem collapsed! \n"+
                                  "Play again and try to maintain a healthy ecosystem by monitoring fish populations \n"+
                                  "and adjusting your fishing strategy.", format);
      summaryText..alpha = 0
                 ..width = _game.width*3/4
                 ..height = 250
                 ..x =_game.width/2-summaryText.width/2
                 ..y =_game.height/3;
      addChild(summaryText);
      Tween t1 = new Tween(summaryText, .05, TransitionFunction.linear);
      t1.animate.alpha.to(1);
      _juggler.add(t1);
    }
    else if(_ecosystem._fishCount[Ecosystem.TUNA]<=0){
      summaryText = new TextField("Tuna were driven to extinction by overfishing and your ecosystem collapsed! \n"+
                                  "Play again and try to maintain a healthy ecosystem by monitoring fish \n"+
                                  "populations and adjusting your fishing strategy.", format);
      summaryText..alpha = 0
                 ..width = _game.width*3/4
                 ..height = 250
                 ..x =_game.width/2-summaryText.width/2
                 ..y =_game.height/3;
      addChild(summaryText);
      Tween t1 = new Tween(summaryText, .05, TransitionFunction.linear);
      t1.animate.alpha.to(1);
      _juggler.add(t1);
    }
    else if(_ecosystem._fishCount[Ecosystem.SHARK]<=0){
      summaryText = new TextField("Sharks were driven to extinction by overfishing and your ecosystem collapsed! \n"+
                                  "Play again and try to maintain a healthy ecosystem by monitoring fish populations \n"+
                                  "and adjusting your fishing strategy.", format);
      summaryText..alpha = 0
                 ..width = _game.width*3/4
                 ..height = 250
                 ..x =_game.width/2-summaryText.width/2
                 ..y =_game.height/3;
      addChild(summaryText);
      Tween t1 = new Tween(summaryText, .05, TransitionFunction.linear);
      t1.animate.alpha.to(1);
      _juggler.add(t1);
    }
    
    informationText = new TextField("Download the Seafood Watch app to learn more about how you can \n"+
                                    "help protect our oceans with your family by eating sustainable seafood!\n\n"+
                                      "http://www.seafoodwatch.org/", format);
    informationText..alpha = 0
               ..width = _game.width*3/4
               ..height = 250
               ..x =_game.width/2-informationText.width/2
               ..y =_game.height*7/12;
    addChild(informationText);
    Tween t2 = new Tween(informationText, .05, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
     
  return;
    
    
  }
  

}

