part of TOTC;

class Ecosystem extends Sprite {
  static const TUNA = 0;
  static const SARDINE = 1;
  static const SHARK = 2;
  static const MAGIC = 3;
  static const EATEN = 4;
  static const STARVATION = 5;
  static const CAUGHT = 6;
  static const MAX_SHARK = 3;
  static const MAX_TUNA = 60;
  static const MAX_SARDINE = 400;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Game game;
  Fleet _fleet;
  List<Fish> fishes = new List<Fish>();
  List<int> _babies = new List<int>(3);
  List<int> _fishCount = new List<int>(3);
  
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

    addFish(0, SHARK);
    addFish(0, TUNA);
    addFish(300, SARDINE);
    
    new Timer.periodic(const Duration(seconds : 15), (timer) => _respawnFishes());
  }
  
  void addFish(int n, int type) {
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
        var fish = new Fish(fishImage, fishes, type, this, _fleet.boats);
        fish.x = random.nextInt(1)*game.width;
        fish.y = random.nextInt(1)*game.height;
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
      addFish(MAX_TUNA-_fishCount[TUNA], TUNA);
    }
    else {
      addFish(_babies[TUNA], TUNA);
    }
    if (_babies[SARDINE]+_fishCount[SARDINE]>MAX_SARDINE) {
      addFish(MAX_SARDINE-_fishCount[SARDINE], SARDINE);
    }
    else {
      addFish(_babies[SARDINE], SARDINE);
    }
    if (_babies[SHARK]+_fishCount[SHARK]>MAX_SHARK) {
      addFish(MAX_SHARK-_fishCount[SHARK], SHARK);
    }
    else {
      addFish(_babies[SHARK], SHARK);
    }
    _babies[TUNA] = _fishCount[TUNA]~/2;
    _babies[SARDINE] = _fishCount[SARDINE]~/2;
    _babies[SHARK] = _fishCount[SHARK]~/2;
  }
}