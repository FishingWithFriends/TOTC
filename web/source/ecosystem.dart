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
  static const MAX_TUNA = 70;
  static const MAX_SARDINE = 425;
  
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
  int largestSardinePop = 0, lowestSardinePop = 0, largestTunaPop = 0, lowestTunaPop = 0, largestSharkPop = 0, lowestSharkPop = 0;
  
  BitmapData _tunaBloodData, _sardineBloodData;

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
    addFish(250, SARDINE, true);
    
    new Timer.periodic(const Duration(seconds : 1), (timer) => _addToGraph());
    new Timer.periodic(const Duration(seconds : 15), (timer) => _respawnFishes());
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
    if (_babies[TUNA]+_fishCount[TUNA]>MAX_TUNA) {
      addFish(MAX_TUNA-_fishCount[TUNA], TUNA, false);
    }
    else {
      addFish(_babies[TUNA], TUNA, false);
    }
    if (_babies[SARDINE]+_fishCount[SARDINE]>MAX_SARDINE) {
      addFish(MAX_SARDINE-_fishCount[SARDINE], SARDINE, false);
    }
    else {
      addFish(_babies[SARDINE], SARDINE, false);
    }
    if (_babies[SHARK]+_fishCount[SHARK]>MAX_SHARK) {
      addFish(MAX_SHARK-_fishCount[SHARK], SHARK, false);
    }
    else {
      addFish(_babies[SHARK], SHARK, false);
    }
    _babies[TUNA] = _fishCount[TUNA]~/2;
    _babies[SARDINE] = _fishCount[SARDINE]~/2;
    _babies[SHARK] = _fishCount[SHARK]~/2;
  }
  
  void _addToGraph() {
    if (_fishCount[SARDINE]>largestSardinePop) largestSardinePop=_fishCount[SARDINE];
    if (_fishCount[TUNA]>largestTunaPop) largestTunaPop=_fishCount[TUNA];
    if (_fishCount[SHARK]>largestSharkPop) largestSharkPop=_fishCount[SHARK];
    if (_fishCount[SARDINE]<lowestSardinePop) lowestSardinePop=_fishCount[SARDINE];
    if (_fishCount[TUNA]<lowestTunaPop) lowestTunaPop=_fishCount[TUNA];
    if (_fishCount[SHARK]<lowestSharkPop) lowestSharkPop=_fishCount[SHARK];
    
    if (game.gameStarted==true) {
      sardineGraph.add(_fishCount[SARDINE]);    
      tunaGraph.add(_fishCount[TUNA]);    
      sharkGraph.add(_fishCount[SHARK]);    
    }
  }
}