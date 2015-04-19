part of TOTC;


class FinalSummary extends Sprite implements Animatable{
   ResourceManager _resourceManager;
   Juggler _juggler;
   Game _game;
   Ecosystem _ecosystem;
   
   Bitmap summaryBackground;
//   Bitmap endgameIconBottom;
//   Bitmap emptyStars;
   
   MyButton replayButton;
   //SimpleButton replayButton;
   var aboutOpen = false;
   FinalSummary(this._resourceManager, this._juggler, this._game, this._ecosystem) {
    
     summaryBackground = new Bitmap(_resourceManager.getBitmapData("title"));
    

    
     replayButton = new MyButton(_game, _game.width/2, _game.height/2 + 150, 
    _resourceManager.getBitmapData("aboutButton"),
    _resourceManager.getBitmapData("aboutButton"),
    _resourceManager.getBitmapData("aboutButtonPressed"),
    _replayButtonPressed);

    this.alpha = 0;


    
    addChild(summaryBackground);
    addChild(replayButton);
    
    hide();
    
  }
   
  
   
   void _replayButtonPressed(){
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
     _juggler.add(t1);
     
     Tween t2 = new Tween(replayButton, .5, TransitionFunction.linear);
      t2.animate.alpha.to(1);
      _juggler.add(t2);
      

      Tween t3 = new Tween(this, .5, TransitionFunction.linear);
       t3.animate.alpha.to(1);
       _juggler.add(t3);

    
  }
  

}

