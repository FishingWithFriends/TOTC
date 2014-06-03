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
  
  Bitmap endgameIcon;

  
  Endgame(this._resourceManager, this._juggler, this._game, this._ecosystem) {
    
    teamAui = new EndGameTeamUI(this._resourceManager, this._juggler, this._game, TEAMA);
    teamAui.alpha = 0;
    teamBui = new EndGameTeamUI(this._resourceManager, this._juggler, this._game, TEAMB);
    teamBui.alpha = 0;
    
    bestScoresA = new BestScores(this._resourceManager, this._juggler, this._game, TEAMA);
    bestScoresA.alpha = 0;
    bestScoresB = new BestScores(this._resourceManager, this._juggler, this._game, TEAMB);
    bestScoresB.alpha = 0;
    
    
    endgameIcon = new Bitmap(_resourceManager.getBitmapData("endgameWinIcon"));
    endgameIcon..alpha = 0
               ..pivotX = endgameIcon.width/2
               ..pivotY = endgameIcon.height/2
               ..rotation = -math.PI/4
               ..x = _game.width/2
               ..y = _game.height/2;
    
    addChild(teamAui);
    addChild(teamBui);
    addChild(bestScoresA);
    addChild(bestScoresB);
    addChild(endgameIcon);
    
    this.alpha = 0;
  }
  
  bool advanceTime(num time){
    return true;
  }
  
  void showGameOverReason(){
    if(_game.round == Game.MAX_ROUNDS){
      
    }
    else if(_ecosystem._fishCount[Ecosystem.SARDINE]<=0){
      endgameIcon.bitmapData = _resourceManager.getBitmapData("endgameSardineIcon");
    }
    else if(_ecosystem._fishCount[Ecosystem.TUNA]<=0){
      endgameIcon.bitmapData = _resourceManager.getBitmapData("endgameTunaIcon");    
    }
    else if(_ecosystem._fishCount[Ecosystem.SHARK]<=0){
      endgameIcon.bitmapData = _resourceManager.getBitmapData("endgameSharkIcon");
    }
    
    Tween t1 = new Tween(endgameIcon, 1.5, TransitionFunction.linear);
    t1.animate.alpha.to(1);
    t1.onComplete = showTeamUI;
    _juggler.add(t1);
    
  }

  void showTeamUI(){
    teamAui.teamFinalScoreText.text = "Final Score: ${_game.teamAScore}";
    teamBui.teamFinalScoreText.text = "Final Score: ${_game.teamBScore}";
    Tween t1 = new Tween(teamAui, 1.5, TransitionFunction.linear);
    t1.animate.alpha.to(1);

    
    Tween t2 = new Tween(teamBui, 1.5, TransitionFunction.linear);
    t2.animate.alpha.to(1);
    t2.onComplete = showBestScores;
    
    _juggler.add(t1);
    _juggler.add(t2);
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
  
  Shape teamBase;
  TextField teamGameOverText;
  TextField teamFinalScoreText;
  
  EndGameTeamUI(this._resourceManager, this._juggler, this._game, this.teamType){
    intializeObjects();
  }
  
  void intializeObjects(){
    num rotationVal;
    int baseX, baseY, r1,r2,r3, offsetX, offsetY;
    int fillColor;
    
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
    
    teamBase = new Shape();
    teamBase..graphics.arc(baseX, baseY, r1, 0, 2*math.PI, false)
             ..graphics.fillColor(fillColor)
             ..alpha = 0.6;
    addChild(teamBase);

    TextFormat format = new TextFormat("Arial", 18, Color.White, align: "center", bold: true);
       
    teamGameOverText = new TextField("GAME OVER", format);
    teamGameOverText..alpha = 1
                  ..width = 150
                  ..pivotX = teamGameOverText.width/2
                  ..rotation = rotationVal
                  ..x =offsetX - r2*math.cos(rotationVal)
                  ..y =offsetY + r2*math.sin(rotationVal);
   addChild(teamGameOverText);
    
   teamFinalScoreText = new TextField("Final Score: ${teamScore}", format);
   teamFinalScoreText..alpha = 1
                 ..width = 150
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