part of TOTC;


class Endgame extends Sprite implements Animatable{
  
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  EndGameTeamUI teamAui;
  EndGameTeamUI teamBui;
  
  BestScores bestScoresA;
  BestScores bestScoresB;
  
  Bitmap endgameIconTop;
  Bitmap endgameIconBottom;
  Bitmap emptyStars;
  
  SimpleButton replayButton;
  bool replayEnable;

  int animatedRating;
  Sound star0Sound;
  Sound star1Sound;
  Sound star2Sound;
  Sound star3Sound;
  Sound star4Sound;
  Sound star5Sound;
  Sound star6Sound;
  Sound star7Sound;
  Sound star8Sound;
  Sound star9Sound;
  Sound star10Sound;
  Sound star11Sound;
  Sound star12Sound;
  Sound star13Sound;
  Sound star14Sound;
  
  Bitmap OldStar;
  Bitmap CurrentStar;
  
  Endgame(this._resourceManager, this._juggler, this._game, this._ecosystem) {
    
    animatedRating = 0;
    
    teamAui = new EndGameTeamUI(this._resourceManager, this._juggler, this._game, TEAMA);
    teamAui.alpha = 0;
    teamBui = new EndGameTeamUI(this._resourceManager, this._juggler, this._game, TEAMB);
    teamBui.alpha = 0;
    
    bestScoresA = new BestScores(this._resourceManager, this._juggler, this._game, TEAMA);
    bestScoresA.alpha = 0;
    bestScoresB = new BestScores(this._resourceManager, this._juggler, this._game, TEAMB);
    bestScoresB.alpha = 0;
    
    endgameIconTop = new Bitmap(_resourceManager.getBitmapData("endgameSardineIcon"));
    endgameIconTop..alpha = 0
               ..pivotX = endgameIconTop.width/2
               ..pivotY = endgameIconTop.height/2
               ..rotation = math.PI/4
               ..x = _game.width-150
               ..y = 150;
    
    endgameIconBottom = new Bitmap(_resourceManager.getBitmapData("endgameSardineIcon"));
    endgameIconBottom..alpha = 0
               ..pivotX = endgameIconBottom.width/2
               ..pivotY = endgameIconBottom.height/2
               ..rotation = -3*math.PI/4
               ..x = 150
               ..y = _game.height -150;
    
    emptyStars = new Bitmap(_resourceManager.getBitmapData("ecosystemScore0"));
    emptyStars..alpha = 0
               ..pivotX = emptyStars.width/2
               ..pivotY = emptyStars.height/2
               ..rotation = -math.PI/4
               ..x = _game.width/2
               ..y = _game.height/2;
    
    replayButton = new SimpleButton(
                new Bitmap(_resourceManager.getBitmapData("replayButton")),
                new Bitmap(_resourceManager.getBitmapData("replayButton")),
                new Bitmap(_resourceManager.getBitmapData("replayButton")),
                new Bitmap(_resourceManager.getBitmapData("replayButton")));
    replayButton..alpha = 0
                ..x = _game.width/2
                ..y = 25;
    replayEnable = false;
    
    addChild(replayButton);
    
    addChild(teamAui);
    addChild(teamBui);
    addChild(bestScoresA);
    addChild(bestScoresB);
    addChild(endgameIconTop);
    addChild(endgameIconBottom);
    
    this.alpha = 0;
    
    star0Sound = _resourceManager.getSound('star0Sound');
    star1Sound = _resourceManager.getSound('star1Sound');
    star2Sound = _resourceManager.getSound('star2Sound');
    star3Sound = _resourceManager.getSound('star3Sound');
    star4Sound = _resourceManager.getSound('star4Sound');
    star5Sound = _resourceManager.getSound('star5Sound');
    star6Sound = _resourceManager.getSound('star6Sound');
    star7Sound = _resourceManager.getSound('star7Sound');
    star8Sound = _resourceManager.getSound('star8Sound');
    star9Sound = _resourceManager.getSound('star9Sound');
    star10Sound = _resourceManager.getSound('star10Sound');
    star11Sound = _resourceManager.getSound('star11Sound');
    star12Sound = _resourceManager.getSound('star12Sound');
    star13Sound = _resourceManager.getSound('star13Sound');
    star14Sound = _resourceManager.getSound('star14Sound');
    
  }
  
  bool advanceTime(num time){
    return true;
  }
  
  void showStars(){
     if(animatedRating == _game.starCount){
//       Timer temp = new Timer(const Duration(seconds:1), teamBCounter.showCounter);
       Timer temp2 = new Timer(const Duration(seconds:1), showTeamUI);
     }
     else{
       Sound toPlay;
       Bitmap toShow;
       if(animatedRating == 0){
         if(_game.starCount == 0){
           toPlay = star0Sound;
         }
         else if(_game.starCount == 1){
           toPlay = star1Sound;
         }
         else if(_game.starCount == 2){
           toPlay = star2Sound;
         }
         else if(_game.starCount == 3){
           toPlay = star3Sound;
         }
         else if(_game.starCount == 4){
           toPlay = star4Sound;
         }
         else if(_game.starCount == 5){
           toPlay = star5Sound;
         }
         else if(_game.starCount == 6){
           toPlay = star6Sound;
         }
         else if(_game.starCount == 7){
           toPlay = star7Sound;
         }
         else if(_game.starCount == 8){
           toPlay = star8Sound;
         }
         else if(_game.starCount == 9){
           toPlay = star8Sound;
         }
         else if(_game.starCount == 10){
           toPlay = star10Sound;
         }
         else if(_game.starCount == 11){
           toPlay = star11Sound;
         }
         else if(_game.starCount == 12){
           toPlay = star12Sound;
         }
         else if(_game.starCount == 13){
           toPlay = star13Sound;
         }
         else if(_game.starCount == 14){
           toPlay = star14Sound;
         }
         toPlay.play();
       }
       
       var showString;
       if(animatedRating == 0){
         showString = 'ecosystemScore1';
       }
       else if(animatedRating == 1){
         showString = 'ecosystemScore2';
       }
       else if(animatedRating == 2){
         showString = 'ecosystemScore3';
       }
       else if(animatedRating == 3){
         showString = 'ecosystemScore4';
       }
       else if(animatedRating == 4){
         showString = 'ecosystemScore5';
       }
       else if(animatedRating == 5){
         showString = 'ecosystemScore6';
       }
       else if(animatedRating == 6){
         showString = 'ecosystemScore7';
       }
       else if(animatedRating == 7){
         showString = 'ecosystemScore8';
       }
       else if(animatedRating == 8){
         showString = 'ecosystemScore9';
       }
       else if(animatedRating == 9){
         showString = 'ecosystemScore10';
       }
       else if(animatedRating == 10){
         showString = 'ecosystemScore11';
       }
       else if(animatedRating == 11){
         showString = 'ecosystemScore12';
       }
       else if(animatedRating == 12){
         showString = 'ecosystemScore13';
       }
       else if(animatedRating == 13){
         showString = 'ecosystemScore14';
       }
       else if(animatedRating == 14){
         showString = 'ecosystemScore15';
       }
       else return;
       
       toShow = new Bitmap(_resourceManager.getBitmapData(showString));
       toShow..pivotX = toShow.width/2
              ..pivotY = toShow.height/2
              ..x = _game.width/2+15
              ..y = _game.height/2
              ..rotation = -math.PI/4
              ..alpha = 0;
       addChild(toShow);
       
       
       
       Tween t1 = new Tween(toShow, .18, TransitionFunction.easeInOutQuadratic);
       t1.animate.alpha.to(1);
       t1.onComplete = showStars;
       _juggler.add(t1);
       animatedRating++;
       
       if(OldStar != null){
         Tween t2 = new Tween(OldStar, .18, TransitionFunction.easeInOutQuadratic);
         t2.animate.alpha.to(0);
         _juggler.add(t2);
       }
       if(CurrentStar != null){
         OldStar = CurrentStar;
       }
       CurrentStar = toShow;
     }
     
   }
  
  void showGameOverReason(){
    if(_game.round == Game.MAX_ROUNDS){
      Tween t1 = new Tween(endgameIconTop, .05, TransitionFunction.linear);
      t1.animate.alpha.to(0);
      t1.onComplete = showStars;
      _juggler.add(t1);
      return;
    }
    else if(_ecosystem._fishCount[Ecosystem.SARDINE]<=0){
      endgameIconTop.bitmapData = _resourceManager.getBitmapData("endgameSardineIcon");
      endgameIconBottom.bitmapData = _resourceManager.getBitmapData("endgameSardineIcon");
    }
    else if(_ecosystem._fishCount[Ecosystem.TUNA]<=0){
      endgameIconTop.bitmapData = _resourceManager.getBitmapData("endgameTunaIcon");    
      endgameIconBottom.bitmapData = _resourceManager.getBitmapData("endgameTunaIcon");    
    }
    else if(_ecosystem._fishCount[Ecosystem.SHARK]<=0){
      endgameIconTop.bitmapData = _resourceManager.getBitmapData("endgameSharkIcon");
      endgameIconBottom.bitmapData = _resourceManager.getBitmapData("endgameSharkIcon");
    }
    
    Tween t1 = new Tween(endgameIconTop, .75, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    t1.onComplete = showStars;
    _juggler.add(t1);
    
    Tween t2 = new Tween(endgameIconBottom, .75, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
    
    
  }

  void showTeamUI(){
    teamAui.teamFinalScoreText.text = "Final Score: ${_game.teamAMoney}";
    teamBui.teamFinalScoreText.text = "Final Score: ${_game.teamBMoney}";
    Tween t1 = new Tween(teamAui, 1.5, TransitionFunction.linear);
    t1.animate.alpha.to(1);

    
    Tween t2 = new Tween(teamBui, 1.5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    
    
    new Timer(new Duration(seconds:14), () => replayEnable = true);
    new Timer(new Duration(seconds:15), showReplayButton);
    
    _juggler.add(t1);
    _juggler.add(t2);
  }
  
  void showReplayButton(){
//    Tween t1 = new Tween(replayButton, .5, TransitionFunction.linear);
//    t1.animate.alpha.to(1);
//    _juggler.add(t1);
//    replayButton.addEventListener(MouseEvent.MOUSE_DOWN, _replayButtonPressed);
//    replayButton.addEventListener(TouchEvent.TOUCH_TAP, _replayButtonPressed);
//    replayButton.addEventListener(TouchEvent.TOUCH_BEGIN, _replayButtonPressed);
//    
    _game._nextSeason();
  }
  
  void _replayButtonPressed(var e){
    if(replayEnable){
      html.window.location.reload();
    }
    else{
      return;
    }
  }
  
  void hideTeamUI(){
    Tween t1 = new Tween(teamAui, 1.5, TransitionFunction.linear);
    t1.animate.alpha.to(0);
    _juggler.add(t1);
    
    Tween t2 = new Tween(teamBui, 1.5, TransitionFunction.linear);
    t2.animate.alpha.to(0);
    _juggler.add(t2);
  }
  
  void showBestScores(){
    
    
    Tween t1 = new Tween(bestScoresA, .5, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    _juggler.add(t1);
    
    Tween t2 = new Tween(bestScoresB, .5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    _juggler.add(t2);
    
  }
  
  void hide(){
    hideTeamUI();

    Tween t1 = new Tween(this, .5, TransitionFunction.linear);
    t1.animate.alpha.to(0);
    _juggler.add(t1);
    
  }
  
}

class EndGameTeamUI extends Sprite{
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  Ecosystem _ecosystem;
  
  int teamType;
  
  int teamScore;
  
  Bitmap teamBase;
  TextField teamGameOverText;
  TextField teamFinalScoreText;
  
  EndGameTeamUI(this._resourceManager, this._juggler, this._game, this.teamType){
    intializeObjects();
  }
  
  void intializeObjects(){
    num rotationVal;
    int baseX, baseY, r1,r2,r3, offsetX, offsetY;
    int fillColor;
    var teamBaseText;
    int offset = 70;
            if(teamType == TEAMA){
              baseX = offset;
              baseY = offset;
              r1 = 400;
              fillColor = Color.Green;
              teamBaseText = "teamAScoreCircle";
             
            }
            else if(teamType == TEAMB){
              baseX = _game.width - offset;
              baseY = _game.height - offset;
              r1 = 400;
              fillColor = Color.Red;
              teamBaseText = "teamBScoreCircle";
                  
            }    
            
         teamBase = new Bitmap(_resourceManager.getBitmapData(teamBaseText));
         teamBase..alpha = 1
                 ..pivotX = teamBase.width/2
                 ..pivotY = teamBase.height/2
                 ..x  = baseX
                 ..y = baseY;
         
       addChild(teamBase);
    
    
    if(teamType == TEAMA){
      rotationVal = 3*math.PI/4;
      baseX = 0;
      baseY = 0;
      r1 = 400;
      r2 = 445;
      r3 = 200;
      offsetX = 0;
      offsetY = 0;
      fillColor = Color.Green;
      teamScore = _game.teamAScore;
     
    }
    else if(teamType == TEAMB){
      rotationVal = -math.PI/4;
      baseX = _game.width;
      baseY = _game.height;
      r1 = 400;
      r2 = 445;
      r3 = 200;
      offsetX = _game.width;
      offsetY = _game.height;
      fillColor = Color.Red;
      teamScore = _game.teamBScore;
          
    }    
    
//    teamBase = new Shape();
//    teamBase..graphics.arc(baseX, baseY, r1, 0, 2*math.PI, false)
//             ..graphics.fillColor(fillColor)
//             ..alpha = 0.6;
//    addChild(teamBase);

    TextFormat format = new TextFormat("Arial", 36, Color.White, align: "center", bold: true);
       
    teamGameOverText = new TextField("GAME OVER", format);
    teamGameOverText..alpha = 1
                  ..width = 300
                  ..pivotX = teamGameOverText.width/2
                  ..rotation = rotationVal
                  ..x =offsetX - r2*math.cos(rotationVal)
                  ..y =offsetY + r2*math.sin(rotationVal);
   addChild(teamGameOverText);
    
   teamFinalScoreText = new TextField("Final Score: ${teamScore}", format);
   teamFinalScoreText..alpha = 1
                 ..width = 300
                 ..pivotX = teamFinalScoreText.width/2
                 ..rotation = rotationVal
                 ..x =offsetX - r3*math.cos(rotationVal)
                 ..y =offsetY + r3*math.sin(rotationVal);
      addChild(teamFinalScoreText);
    
  }
}


class BestScores extends Sprite{
  static const TEAMA = 0;
  static const TEAMB = 1;
  
  var scores = {
    1:1540,
    2:1239,
    3:975,
    4: 858,
    5:821
  };
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game _game;
  
  int teamType;
  
  TextField bestScoreTitle;
  TextField bestScores;
  
  BestScores(this._resourceManager, this._juggler, this._game, this.teamType){
    intializeObjects();
  }
  
  void intializeObjects(){
    num rotationVal;
    int baseX, baseY, r1,r2,r3, offsetX, offsetY, teamScore;
    int fillColor;
    
    if(teamType == TEAMA){
      rotationVal = 3*math.PI/4;
      baseX = 0;
      baseY = 0;
      r1 = 640;
      r2 = 610;
      r3 = 200;
      offsetX = 0;
      offsetY = 0;
      fillColor = Color.Green;
      teamScore = _game.teamAScore;
     
    }
    else if(teamType == TEAMB){
      rotationVal = -math.PI/4;
      baseX = _game.width;
      baseY = _game.height;
      r1 = 640;
      r2 = 610;
      r3 = 200;
      offsetX = _game.width;
      offsetY = _game.height;
      fillColor = Color.Red;
      teamScore = _game.teamBScore;
          
    }    
    

    TextFormat format = new TextFormat("Arial", 24, Color.White, align: "center", bold: true);
       
    bestScoreTitle = new TextField("Today's Top Scores", format);
    bestScoreTitle..alpha = 1
                  ..width = 300
                  ..pivotX = bestScoreTitle.width/2
                  ..rotation = rotationVal
                  ..x =offsetX - r1*math.cos(rotationVal)
                  ..y =offsetY + r1*math.sin(rotationVal);
   addChild(bestScoreTitle);
    
   format = new TextFormat("Arial", 18, Color.White, align: "center", bold: true);
   
   bestScores = new TextField("#1: ${scores[1]}\n #2: ${scores[2]}\n #3: ${scores[3]}\n #4: ${scores[4]}\n #5: ${scores[5]}", format);
   bestScores..alpha = 1
                 ..width = 300
                 ..height = 150
                 ..pivotX = bestScores.width/2
                 ..rotation = rotationVal
                 ..x =offsetX - r2*math.cos(rotationVal)
                 ..y =offsetY + r2*math.sin(rotationVal);
      addChild(bestScores);
    
  }
}