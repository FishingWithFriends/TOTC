part of TOTC;

class Ecosystem extends Sprite {
  static const TUNA = 0;
  static const SARDINE = 1;
  static const SHARK = 2;
  static const MAGIC = 3;
  static const EATEN = 4;
  static const STARVATION = 5;
  static const MAX_SHARK = 3;
  static const MAX_TUNA = 60;
  static const MAX_SARDINE = 400;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  List<Fish> fishes = new List<Fish>();
  List<int> _babies = new List<int>(3);
  List<int> _fishCount = new List<int>(3);
  
  var random = new math.Random();
  
  Ecosystem(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    random = new math.Random();
    
    _babies[TUNA] = 0;
    _babies[SARDINE] = 0;
    _babies[SHARK] = 0;
    _fishCount[TUNA] = 0;
    _fishCount[SARDINE] = 0;
    _fishCount[SHARK] = 0;

    addFish(3, SHARK);
    addFish(80, TUNA);
    addFish(400, SARDINE);
    
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
        var fish = new Fish(fishImage, fishes, type, this);
        fish.x = random.nextInt(1)*1248;
        fish.y = random.nextInt(1)*702;
        fish.rotation = random.nextDouble()*2*math.PI;;
        
        fishes.add(fish);
        this.addChild(fish);
        _juggler.add(fish);
      }
    }
  }
  
  void removeFish(Fish f, int reason) {
    _juggler.remove(f);
    this.removeChild(f);
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
      t.onComplete = () => f.removeFromParent();
      
      _juggler.add(t);
      fishes.remove(f);
    }
    if (reason == EATEN) {
      f.removeFromParent();
      var blood = new Shape();
      blood.graphics.circle(f.x, f.y, 5);
      blood.graphics.fillColor(Color.DarkRed);
      stage.addChild(blood);
      
      var t = new Tween(blood, 2.0, TransitionFunction.linear);
      t.animate.alpha.to(0);
      t.onComplete = () => blood.removeFromParent();
      
      _juggler.add(t);
      fishes.remove(f);
    }
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