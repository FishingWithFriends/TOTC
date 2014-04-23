part of TOTC;

class Ecosystem extends Sprite {
  static const TUNA = 0;
  static const SARDINE = 1;
  static const SHARK = 2;
  static const MAGIC = 3;
  static const EATEN = 4;
  static const STARVATION = 5;
  static const CAUGHT = 6;
  static const MAX_SHARK = 7;
  static const MAX_TUNA = 50;
  static const MAX_SARDINE = 400;
  
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
  
  int tunaBirthTimerMax = 15;
  int tunaBirthTimer = 0;
  int sardineBirthTimerMax = 15;
  int sardineBirthTimer = 15;
  int sharkBirthTimerMax = 45;
  int sharkBirthTimer = 0;

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

    addFish(2, SHARK, true);
    addFish(30, TUNA, true);
    addFish(350, SARDINE, true);
    
    new Timer.periodic(const Duration(seconds : 1), (timer) => _timerTick());
  }
  
  void addFish(int n, int type, bool start) {
    if (n>0) {
      var fishImage;
      if (type == TUNA) {
        fishImage = _resourceManager.getBitmapData("Tuna");
        _fishCount[TUNA] = _fishCount[TUNA]+n;
      }
      if (type == SHARK) {
        fishImage = _resourceManager.getBitmapData("Shark");
        _fishCount[SHARK] = _fishCount[SHARK]+n;
      }
      if (type == SARDINE) {
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
    _juggler.remove(f);    
    fishes.remove(f);
  } 
  
  void _respawnFishes() {
    if (_fishCount[TUNA]<MAX_TUNA && _babies[TUNA]>0) {
      addFish(3, TUNA, false);
      _babies[TUNA] = _babies[TUNA] - 3;
    }
    if (_fishCount[SARDINE]<MAX_SARDINE && _babies[SARDINE]>0) {
      addFish(10, SARDINE, false);
      _babies[SARDINE] = _babies[SARDINE] - 10;
    }
    if (_fishCount[SHARK]<MAX_SHARK && _babies[SHARK]>0) {
      addFish(1, SHARK, false);
      _babies[SHARK] = _babies[SHARK] - 1;
   }
  }
  
  void _birthFish() {
    if (tunaBirthTimer>tunaBirthTimerMax && _babies[TUNA]<MAX_TUNA) {
      _babies[TUNA] = _babies[TUNA]+_fishCount[TUNA]~/2;
      tunaBirthTimer = 0;
    } else tunaBirthTimer++;
    if (sardineBirthTimer>sardineBirthTimerMax && _babies[SARDINE]<MAX_SARDINE) {
      _babies[SARDINE] = _babies[SARDINE]+_fishCount[SARDINE]~/1.2;
      sardineBirthTimer = 0;
    } else sardineBirthTimer++;
    if (sharkBirthTimer>sharkBirthTimerMax && _babies[SHARK]<MAX_SHARK) {
      _babies[SHARK] = _babies[SHARK]+_fishCount[SHARK]~/2;
      sharkBirthTimer = 0;
    } else sharkBirthTimer++;
  }
  
  void _timerTick() {
    _respawnFishes();
    _birthFish();
    
    if (game.gameStarted==true) {
      sardineGraph.add(_fishCount[SARDINE]);    
      tunaGraph.add(_fishCount[TUNA]);    
      sharkGraph.add(_fishCount[SHARK]);    
    }
  }
}