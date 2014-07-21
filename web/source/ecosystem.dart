part of TOTC;

class Ecosystem extends Sprite {
  static const TUNA = 0;
  static const SARDINE = 1;
  static const SHARK = 2;
  static const MAGIC = 3;
  static const EATEN = 4;
  static const STARVATION = 5;
  static const CAUGHT = 6;
  static const MAX_SHARK = 25;
  static const MAX_TUNA = 100;
  static const MAX_SARDINE = 350;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game game;
  Fleet _fleet;
  List<Fish> fishes = new List<Fish>();
  List<int> _babies = new List<int>(3);
  List<int> _fishCount = new List<int>(3);
  
  List<int> sardineGraph = new List<int>();
  List<int> tunaGraph = new List<int>();
  List<int> sharkGraph = new List<int>();
  int largestSardinePop = MAX_SARDINE+30, lowestSardinePop = 0, largestTunaPop = MAX_TUNA+10, lowestTunaPop = 0, largestSharkPop = MAX_SHARK+2, lowestSharkPop = 0;
  
  BitmapData _tunaBloodData, _sardineBloodData;
  
  int tunaBirthTimerMax = 13;
  int tunaBirthTimer = 0;
  int sardineBirthTimerMax = 15;
  int sardineBirthTimer = 15;
  int sharkBirthTimerMax = 45;
  int sharkBirthTimer = 0;

  int planktonCount;
  int tunaFoodCount;
  int sharkFoodCount;
  
  var random = new math.Random();
  
  Ecosystem(ResourceManager resourceManager, Juggler juggler, Game g, Fleet fleet) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _fleet = fleet;
    game = g;
    
    random = new math.Random();
    
    _tunaBloodData = _resourceManager.getBitmapData("TunaBlood");
    _sardineBloodData = _resourceManager.getBitmapData("SardineBlood");
    
    _babies[TUNA] = 0;
    _babies[SARDINE] = 0;
    _babies[SHARK] = 0;
    _fishCount[TUNA] = 0;
    _fishCount[SARDINE] = 0;
    _fishCount[SHARK] = 0;

    planktonCount = 0;
    tunaFoodCount = 0;
    sharkFoodCount = 0;
    
    addFish(8, SHARK, true);
//    addFish(0, SHARK, true);
    addFish(45, TUNA, true);
    addFish(350, SARDINE, true);
    
    new Timer.periodic(const Duration(milliseconds : 1000), (timer) => _timerTick());
  }
  
  void addFish(int n, int type, bool start) {
    if(!game.timerActive && !game.gameStarted){
      return;
    }
    if (n>0) {
      var fishImage;
      if (type == TUNA) {
        if(_fishCount[TUNA] >= MAX_TUNA){
          return;
        }
        fishImage = _resourceManager.getBitmapData("Tuna");
        _fishCount[TUNA] = _fishCount[TUNA]+n;
      }
      if (type == SHARK) {
        if(_fishCount[SHARK] >= MAX_SHARK){
          return;
        }
        fishImage = _resourceManager.getBitmapData("Shark");
        _fishCount[SHARK] = _fishCount[SHARK]+n;
      }
      if (type == SARDINE) {
        if(_fishCount[SARDINE] >= MAX_SARDINE){
          return;
        }
        fishImage = _resourceManager.getBitmapData("Sardine");
        _fishCount[SARDINE] = _fishCount[SARDINE]+n;
      }
      
      while (--n >= 0) {
        var fish = new Fish(fishImage, fishes, type, this, _fleet, _fleet.boats);
        
        if (start==true) {
          fish.x = random.nextInt(game.width);
          fish.y = random.nextInt(game.height);
        } else {
          fish.x = random.nextInt(1)*game.width;
          fish.y = random.nextInt(1)*game.height;
        }
        fish.rotation = random.nextDouble()*2*math.PI;;
        
        fishes.add(fish);
        this.addChild(fish);
        _juggler.add(fish);
      }
    }
  }
  
  void removeFish(Fish f, int reason) {
    if (f.type == TUNA) {
      _fishCount[TUNA]--;
    }
    if (f.type == SHARK) {
      _fishCount[SHARK]--;
    }
    if (f.type == SARDINE) {
      _fishCount[SARDINE]--;
    }
    if (reason == STARVATION) {
      var t = new Tween(f, 2.0, TransitionFunction.linear);
      t.animate.alpha.to(0);
      t.onComplete = () => removeChild(f);
      _juggler.add(t);
    } else if (reason == EATEN) {
      Bitmap blood = new Bitmap();
      if (f.type==SARDINE) blood.bitmapData = _sardineBloodData;
      if (f.type==TUNA) blood.bitmapData = _tunaBloodData;
      blood.x = f.x;
      blood.y = f.y;
      addChild(blood);
      
      var t = new Tween(blood, 2.0, TransitionFunction.linear);
      t.animate.alpha.to(0);
      t.onComplete = () => removeChild(blood);
      _juggler.add(t);
      removeChild(f);
    } else {
      removeChild(f);
    }
    f.hungerTimer.cancel();
    _juggler.remove(f);    
    fishes.remove(f);
  } 
  
  List ecosystemGrade() {
    int sardineCount = _fishCount[Ecosystem.SARDINE];
    int tunaCount = _fishCount[Ecosystem.TUNA];
    int sharkCount = _fishCount[Ecosystem.SHARK];
    
    num grade;
    String string;
    List ret = new List(2);
    if (sardineCount < 50 && tunaCount < 8 && sharkCount<2) {
      string = "You have destroyed the ecosystem.";
      grade = 0;
    }
    else if (sardineCount < 200 || tunaCount < 15 || sharkCount<2) {
      string = "Your ecosystem is about to collapse!";
      grade = .2;
    }
    else if (sardineCount < 350 && tunaCount < 40 && sharkCount<3) {
      string = "Your ecosystem is not doing well! Let the fish grow more!";
      grade = .4;
    }
    else if (sardineCount < 350 && (tunaCount > 40 || sharkCount>2)) { 
      string = "There are not enough sardines! The tuna will starve.";
      grade = .7;
    }
    else if (tunaCount < 40 && (sardineCount > 350 || sharkCount>2)) {
      string = "There are not enough tuna! The sharks will starve.";
      grade = .7;
    }
    else if (sharkCount < 2 && (tunaCount > 40 || sardineCount>350)) {
      string = "There are not enough sharks! The sardines will starve.";
      grade = .7;
    }
    else  {
      string = "You're doing great! The ecosystem is healthy.";
      grade = 1;
    }
    ret[0] = grade;
    ret[1] = string;
    return ret;
  }
  
  void _respawnFishes() {
    
//    if (_fishCount[SARDINE]<MAX_SARDINE && random.nextInt(100)<99) {
//      addFish((_fishCount[SARDINE]*.05).floor(), SARDINE, false);
//    }
////      _babies[SARDINE] = _babies[SARDINE] - (_fishCount[SARDINE]*.025).floor();
//    if (_fishCount[TUNA]<MAX_TUNA && random.nextInt(100)<30) {
//      addFish((_fishCount[TUNA]*.035).floor(), TUNA, false);
////      _babies[TUNA] = _babies[TUNA] - (_fishCount[TUNA]*.025).floor();
//    }
//    if (_fishCount[SHARK]<MAX_SHARK && random.nextInt(100)<2) {
//      if(random.nextInt(10)< 5){
//        addFish((_fishCount[SHARK]*.1).ceil(), SHARK, false);
//      }
//      else{
//        addFish((_fishCount[SHARK]*.1).floor(), SHARK, false);
//      }
////      _babies[SHARK] = _babies[SHARK] - (_fishCount[SHARK]*.1).ceil();
//   }
  }
  
  void _birthFish() {
    
    _babies[SARDINE]=1;
    _babies[TUNA]=1;
    _babies[SHARK]=1;
                    
    
//    if (tunaBirthTimer>tunaBirthTimerMax && _babies[TUNA]<MAX_TUNA) {
//      _babies[TUNA] = _babies[TUNA]+_fishCount[TUNA]~/2;
//      tunaBirthTimer = 0;
//    } else tunaBirthTimer++;
//    if (sardineBirthTimer>sardineBirthTimerMax && _babies[SARDINE]<MAX_SARDINE) {
//      _babies[SARDINE] = _babies[SARDINE]+_fishCount[SARDINE]~/1.2;
//      sardineBirthTimer = 0;
//    } else sardineBirthTimer++;
//    if (sharkBirthTimer>sharkBirthTimerMax && _babies[SHARK]<MAX_SHARK) {
//      _babies[SHARK] = _babies[SHARK]+_fishCount[SHARK]~/2;
//      if (_babies[SHARK]==0 && _fishCount[SHARK]!=0) _babies[SHARK]=1;
//      sharkBirthTimer = 0;
//    } else sharkBirthTimer++;
  }
  
  void updateEcosystem(){
    
    
  }
  
  
  void _timerTick() {
    _respawnFishes();
    _birthFish();
    
    planktonCount += 300;
    tunaFoodCount += 60;
    sharkFoodCount += 10;
    
    if (game.gameStarted==true) {
      sardineGraph.add(_fishCount[SARDINE]);    
      tunaGraph.add(_fishCount[TUNA]);    
      sharkGraph.add(_fishCount[SHARK]);    
    }
  }
  
  void timerSkipped(){
    

      
    if(_fishCount[SHARK] > 0) addFish(1, SHARK, true);
    if(_fishCount[TUNA] > 0) addFish(10, TUNA, true);
    if(_fishCount[SARDINE] > 0) addFish(30, SARDINE, true);

  }
}