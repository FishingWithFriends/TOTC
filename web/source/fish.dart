part of TOTC;

class Fish extends Bitmap implements Animatable {

  List<Fish> _fishes;
  Ecosystem _ecosystem;
  Fleet _fleet;
  List<Boat> _boats;
  int _rotateTimer, _timerMax;
  int _magicTimer, _magicTimerMax;
  
  num _v, _minSeparation, _eyesightRadius, _rotationSpeed, _dartV, _dartRotationSpeed;
  int type, _hunger, _hungerMax, _foodType, _predType, _dartTimerMax, _dartTimer;
  bool _flocking, _darting, _pouncing;
  Fish ate;
  
  int _catchTimer = 0;
  int _catchTimerMax = 80;
  
  var _random = new math.Random();
  
  Fish (BitmapData bitmapData, List<Fish> fishes, int t, Ecosystem eco, Fleet fleet, List<Boat> boats) : super(bitmapData) {
    _fishes = fishes;
    type = t;
    _ecosystem = eco;
    _fleet = fleet;
    _boats = boats;
    
    pivotX = width/2;
    pivotY = height/2;
    _rotateTimer = 0;
    _timerMax = _random.nextInt(5) + 10;
    _dartTimer = 0;
    _darting = false;
    _pouncing = false;
    
    if (type == Ecosystem.TUNA) {
      _v = 1;
      _minSeparation = 15;
      _rotationSpeed = math.PI/60;
      _hunger = 0;
      _hungerMax = _random.nextInt(200) + 1000;
      _foodType = Ecosystem.SARDINE;
      _predType = Ecosystem.SHARK;
      _eyesightRadius = 60;
      _dartV = 150;
      _dartRotationSpeed = math.PI/2;
      _flocking = true;
      _dartTimerMax = _random.nextInt(50) + 50;
    }
    if (type == Ecosystem.SHARK) {
      _v = .6;
      _minSeparation = 50;
      _rotationSpeed = math.PI/60;
      _hunger = 0;
      _hungerMax = _random.nextInt(200) + 1500;
      _foodType = Ecosystem.TUNA;
      _predType = -1;
      _eyesightRadius = 100;
      _dartV = 20;
      _dartRotationSpeed = math.PI/8;
      _flocking = false;
      _dartTimerMax = _random.nextInt(100) + 50;
    }
    if (type == Ecosystem.SARDINE) {
      _v = 1.5;
      _minSeparation = 1;
      _rotationSpeed = math.PI/8;
      _hunger = 0;
      _hungerMax = _random.nextInt(200) + 500;
      _foodType = Ecosystem.MAGIC;
      _predType = Ecosystem.TUNA;
      _eyesightRadius = 75;
      _dartV = 75;
      _dartRotationSpeed = math.PI/2;
      _flocking = true;
      _dartTimerMax = _random.nextInt(5) + 30;
      _magicTimer = 0;
      _magicTimerMax = _random.nextInt(550) + 50;
    }
  }
  
  bool advanceTime(num time) {
    for (int i=0; i<_boats.length; i++) {
      Boat b = _boats[i];
      num rotDiff = (b.netHitBox.rotation-rotation).abs();
      if (_catchTimer>_catchTimerMax) {
      if (b.canCatch && hitTestObject(b.netHitBox) && _ecosystem.game.gameStarted==true) {
        _catchFish(b);
        _catchTimer = 0;
        return true;
        } 
      } else _catchTimer++;
    }
    if (_hunger > _hungerMax) {
      _ecosystem.removeFish(this, Ecosystem.STARVATION);
      return true;
    } else _hunger++;
    if (_foodType == Ecosystem.MAGIC) {
      if (_magicTimer > _magicTimerMax) {
        _hunger = 0;
        _magicTimerMax = _ecosystem.random.nextInt(550) + 50;
        _magicTimer = 0;
      } else _magicTimer++;
    }
    
    _dartTimer++;
    if (_rotateTimer < _timerMax) _rotateTimer++;
    else {
      _timerMax = _random.nextInt(5) + 10;
      _rotateTimer = 0;
      
      var newRot = _rotationChange(_eyesightRadius);
      if (_pouncing) {
        _hunger = 0;
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
    
    if (tx < _ecosystem.game.width && tx > 0) x = tx;
    else if (tx > _ecosystem.game.width) x = 0;
    else x = _ecosystem.game.width;
    
    if (ty < _ecosystem.game.height && ty > 0) y = ty;
    else if (ty > _ecosystem.game.height) y = 0;
    else y = _ecosystem.game.height;
    
    return true;
  }
  
  void _catchFish(Boat b) {
    num shP, saP, tP;
    if (b._teamA==true) {
      shP = _fleet.teamASharkPercent;
      saP = _fleet.teamASardinePercent;
      tP = _fleet.teamATunaPercent;
    } else {
      shP = _fleet.teamBSharkPercent;
      saP = _fleet.teamBSardinePercent;
      tP = _fleet.teamBTunaPercent;
    }
    bool caught = false;
    int caughtType = 0;
    int r = _random.nextInt(100);
    if (type==Ecosystem.SARDINE) {
      if (r<saP) {
        b.increaseFishNet(Ecosystem.SARDINE);
        _ecosystem.removeFish(this, Ecosystem.CAUGHT);
      }
    } else if (type==Ecosystem.SHARK) {
      if (r<shP) {
        b.increaseFishNet(Ecosystem.SHARK);
        _ecosystem.removeFish(this, Ecosystem.CAUGHT);
      }
    } else if (type==Ecosystem.TUNA) {
      if (r<tP) {
        b.increaseFishNet(Ecosystem.TUNA);
        _ecosystem.removeFish(this, Ecosystem.CAUGHT);
      }
  }
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
        if (_hunger > _hungerMax~/8 && fishType == _foodType && _dartTimer > _dartTimerMax) {
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
          if (_random.nextInt(1) == 0) return rotation+_dartRotationSpeed;
          else return rotation-_dartRotationSpeed;
        }
        if (fishType == type) {
          if (_flocking) {
            fishes.add(_fishes[i]);
          } else {
            return rotation;
          }
        }
      }
    }
    if (_tooClose(fishes)) return rotation+(_random.nextInt(2) - 1)*_rotationSpeed;
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