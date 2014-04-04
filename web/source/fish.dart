part of TOTC;

class Fish extends Bitmap implements Animatable {

  List<Fish> _fishes;
  Ecosystem _ecosystem;
  int _rotateTimer, _timerMax;
  var _random;
  
  num _v, _minSeparation, _eyesightRadius, _rotationSpeed, _dartV, _dartRotationSpeed;
  int type, _hunger, _hungerMax, _foodType, _predType, _chompSize, _dartTimerMax, _dartTimer;
  bool _flocking, _darting, _pouncing;
  Fish ate;
  
  static const MIN_SEPARATION = 15;
  static const ROT_AWAY = math.PI/8;
  static const ROT_SPEED = math.PI/8;
  
  Fish (BitmapData bitmapData, List<Fish> fishes, int t, Ecosystem eco) : super(bitmapData) {
    _fishes = fishes;
    _random = new math.Random();
    type = t;
    _ecosystem = eco;
    
    pivotX = width/2;
    pivotY = height/2;
    _rotateTimer = 0;
    _timerMax = _random.nextInt(5) + 10;
    _dartTimer = 0;
    _darting = false;
    _pouncing = false;
    
    if (type == Ecosystem.TUNA) {
      _v = 1.5;
      _minSeparation = 15;
      _rotationSpeed = math.PI/8;
      _hunger = 0;
      _hungerMax = _ecosystem.random.nextInt(200) + 5000;
      _foodType = Ecosystem.SARDINE;
      _predType = Ecosystem.SHARK;
      _chompSize = -1;
      _eyesightRadius = 150;
      _dartV = 150;
      _dartRotationSpeed = math.PI/2;
      _flocking = true;
      _dartTimerMax = _random.nextInt(5) + 15;
    }
    if (type == Ecosystem.SHARK){
      _v = 1.5;
      _minSeparation = 50;
      _rotationSpeed = math.PI/45;
      _hunger = 0;
      _hungerMax = _ecosystem.random.nextInt(200) + 5000;
      _foodType = Ecosystem.TUNA;
      _predType = -1;
      _chompSize = -1;
      _eyesightRadius = 75;
      _dartV = 20;
      _dartRotationSpeed = math.PI/8;
      _flocking = false;
      _dartTimerMax = _random.nextInt(5) + 75;
    }
  }
  
  bool advanceTime(num time) {
    if (_hunger > _hungerMax) {
      _ecosystem.removeFish(this, Ecosystem.STARVATION);
      return true;
    } else _hunger++;
    
    _dartTimer++;
    if (_rotateTimer < _timerMax) _rotateTimer++;
    else {
      _timerMax = _random.nextInt(5) + 10;
      _rotateTimer = 0;
      
      var newRot = _rotationChange(_eyesightRadius);
      if (_pouncing) {
        _hunger = _hunger - _hungerMax~/100;
        _pouncing = false;
        _darting = false;
        x = ate.x;
        y = ate.y;
        rotation = newRot;
        _ecosystem.removeFish(ate, Ecosystem.EATEN);
        return true;
      }
      if (_darting) {
        _darting = false;
        rotation = newRot;
      }
      else rotation = Movement.rotateTowards(_rotationChange(_eyesightRadius), _rotationSpeed, rotation);
    }
    
    var tx, ty;
    if (_darting) {
      _darting = false;
      tx = x + math.cos(rotation)*_dartV;
      ty = y + math.sin(rotation)*_dartV;
    } else {
      tx = x + math.cos(rotation)*_v;
      ty = y + math.sin(rotation)*_v;
    }
    
    if (tx < 1248 && tx > 0) x = tx;
    else if (tx > 1248) x = 0;
    else x = 1248;
    
    if (ty < 702 && ty > 0) y = ty;
    else if (ty > 702) y = 0;
    else y = 702;
    
    return true;
  }
  
  num _averageRotation(List<Fish> fishes) {
    num rotationSum = 0;
    int counter = 0;
    for (int i=0; i<fishes.length; i++) {
      if (!fishes[i].rotation.isNaN) {
        counter++;
        rotationSum = rotationSum + fishes[i].rotation;
      }
    }
    if (counter>0) return rotationSum/counter;
    else return rotation;
  }

  num _rotationChange(num r) {
    List<Fish> fishes = new List();
    for(int i=0; i<_fishes.length; i++) {
      if (_distanceTo(_fishes[i]) < r 
          && _fishes[i] != this) {
        int fishType = _fishes[i].type;
        if (_hunger > _hungerMax/100 && fishType == _foodType && _dartTimer > _dartTimerMax) {
          _dartTimer = 0;
          _darting = true;
          _pouncing = true;
          ate = _fishes[i];
          var newy = _fishes[i].y;
          var newx = _fishes[i].x;
          return rotation+math.atan(_fishes[i].y-y / _fishes[i].x-x);
        }
        if (fishType == _predType && _dartTimer > _dartTimerMax) {
          _dartTimer = 0;
          _darting = true;
          if (_ecosystem.random.nextInt(1) == 0) return rotation+_dartRotationSpeed;
          else return rotation-_dartRotationSpeed;
        }
        if (fishType == type) {
          if (_flocking) {
            fishes.add(_fishes[i]);
          } else {
            return rotation+_ecosystem.random.nextDouble()*math.PI/2-math.PI/4;
          }
        }
      }
    }
    if (_tooClose(fishes)) return rotation+(_random.nextInt(2) - 1)*ROT_AWAY;
    else return _averageRotation(fishes);
  }
  
  bool _tooClose(List <Fish> fishes) {
    for(int i=0; i<fishes.length; i++) {
      if (_distanceTo(fishes[i]) < _minSeparation) return true;
    }
    return false;
  }
  
  num _distanceTo(Fish f) {
    Point myP = new Point(x, y);
    return myP.distanceTo(new Point(f.x, f.y));
  }
}