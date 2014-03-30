part of TOTC;

class Ecosystem extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  List<Fish> fishes = new List<Fish>();
  
  Ecosystem(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;

    _addFish(100);
  }
  
  void _addFish(int n) {
    var random = new math.Random();
    var fishImage = _resourceManager.getBitmapData("Fish");
    
    while (--n >= 0) {
      var fish = new Fish(fishImage, fishes);
      fish.x = 0 + random.nextInt(1248 - 60);
      fish.y = 0 + random.nextInt(702 - 60);
      
      fishes.add(fish);
      addChild(fish);
      _juggler.add(fish);
    }
  }
  
}