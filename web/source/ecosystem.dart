part of TOTC;

class Ecosystem extends Sprite {
  static const TUNA = 0;
  static const SARDINE = 1;
  static const SHARK = 2;
  static const MAGIC = 3;
  static const EATEN = 4;
  static const STARVATION = 5;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  List<Fish> fishes = new List<Fish>();
  
  var random = new math.Random();
  
  Ecosystem(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    random = new math.Random();

    addFish(2, SHARK);
    addFish(50, TUNA);
    addFish(400, SARDINE);
  }
  
  void addFish(int n, int type) {
    var fishImage;
    if (type == TUNA) fishImage = _resourceManager.getBitmapData("Tuna");
    if (type == SHARK) fishImage = _resourceManager.getBitmapData("Shark");
    if (type == SARDINE) fishImage = _resourceManager.getBitmapData("Sardine");
    
    while (--n >= 0) {
      var fish = new Fish(fishImage, fishes, type, this);
      fish.x = 1248 * random.nextInt(1);
      fish.x = 702 * random.nextInt(1);
      fish.rotation = random.nextDouble()*2*math.PI;;
      
      fishes.add(fish);
      addChild(fish);
      _juggler.add(fish);
    } 
  }
  
  void removeFish(Fish f, int reason) {
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
      blood.graphics.fillColor(Color.Red);
      stage.addChild(blood);
      
      var t = new Tween(blood, 2.0, TransitionFunction.linear);
      t.animate.alpha.to(0);
      t.onComplete = () => blood.removeFromParent();
      
      _juggler.add(t);
      fishes.remove(f);
    }
  } 
}