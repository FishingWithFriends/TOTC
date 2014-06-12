part of TOTC;

class DataLogger{
  
  int id;
  int totalTime;
  int teamAFinalScore;
  int teamBFinalScore;
  int totalStars;
  int numOfRound;
  RoundLogger round0;
  RoundLogger round1;
  RoundLogger round2;
  RoundLogger round3;
  RoundLogger round4;
//  RoundLogger round5;
  
  DataLogger(){
    
    id = -1;
    totalTime = -1;
    teamAFinalScore = -1;
    teamBFinalScore = -1;
    totalStars = -1;
    numOfRound = -1;
    
    round0 = new RoundLogger(this,0);    
    round1 = new RoundLogger(this,1);
    round2 = new RoundLogger(this,2);
    round3 = new RoundLogger(this,3);
    round4 = new RoundLogger(this,4);
//    round5 = new RoundLogger(this,5);
  }
  
  void send(){
    var data = "$id, $totalTime, $teamAFinalScore, $teamBFinalScore, $totalStars, $numOfRound, ";
    data += round0.getData();
    data += round1.getData();
    data += round2.getData();
    data += round3.getData();
    data += round4.getData();
//    data += round5.getData();
    
    ws.send(data);
    ws.send("endgame");
  }
  
}

class RoundLogger{
  
  static const OVERPOPULATED = 3;
  static const LEAST_CONCERN = 2;
  static const ENDANGERED = 1;
  static const EXTINCT = 0;
  
  static const SARDINE = 0;
  static const TUNA = 1;
  static const SHARK = 2;
  
  static const NET_LARGE = 1;
  static const NET_SMALL = 0;
  
  DataLogger logger;
  int roundNumber;
  
  int roundTime;
  int starRating;
  int sardineCount;
  int tunaCount;
  int sharkCount;
  int sardineStatus;
  int tunaStatus;
  int sharkStatus;
  int teamANetSize;
  int teamABoatType;
  int teamASeasonProfit;
  int teamANumOfFishCaught;
  int teamBNetSize;
  int teamBBoatType;
  int teamBSeasonProfit;
  int teamBNumOfFishCaught;
  
  RoundLogger(this.logger,this.roundNumber){
    roundTime = -1;
    starRating = -1;
    sardineCount = -1;
    tunaCount = -1;
    sharkCount = -1;
    sardineStatus = -1;
    tunaStatus = -1;
    sharkStatus = -1;
    teamANetSize = -1;
    teamABoatType = -1;
    teamASeasonProfit = -1;
    teamANumOfFishCaught = -1;
    teamBNetSize = -1;
    teamBBoatType = -1;
    teamBSeasonProfit = -1;
    teamBNumOfFishCaught = -1;
    }
  
  String getData(){
    return "${getTime()}, $starRating, $sardineCount, $tunaCount, $sharkCount, $sardineStatus, $tunaStatus, $sharkStatus, $teamANetSize, $teamABoatType, $teamASeasonProfit, $teamANumOfFishCaught, $teamBNetSize, $teamBBoatType, $teamBSeasonProfit, $teamBNumOfFishCaught, ";
  }
  
  int getTime(){
    int time;
    
    if(roundTime != -1){
      if(roundNumber == 0) time = roundTime;
      else if(roundNumber == 1) time = roundTime - logger.round0.roundTime;
      else if(roundNumber == 2) time = roundTime - logger.round1.roundTime;
      else if(roundNumber == 3) time = roundTime - logger.round2.roundTime;
      else if(roundNumber == 4) time = roundTime - logger.round3.roundTime;
//      else if(roundNumber == 5) time = roundTime - logger.round4.roundTime;
      
      return time;
    }
    else return -1;
  }
}