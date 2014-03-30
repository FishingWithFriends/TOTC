part of TOTC;

class Fish extends Bitmap implements Animatable {
  
  num v;
  num rot;
  List<Fish> _fishes;
  int rotateTimer, timerMax;
  var random;
  
  static const MIN_SEPARATION = 15;
  static const ROT_AWAY = math.PI/45;
  static const ROT_SPEED = math.PI/8;
  
  Fish (BitmapData bitmapData, List<Fish> fishes) : super(bitmapData) {
    _fishes = fishes;
    random = new math.Random();
    
    pivotX = width/2;
    pivotY = height/2;
    
    v = 2;
    rot = random.nextDouble()*2*math.PI;
    rotation = rot;
    
    rotateTimer = 0;
    timerMax = random.nextInt(5) + 10;
  }
  
  bool advanceTime(num time) {
    if (rotateTimer < timerMax) rotateTimer++;
    else {
      timerMax = random.nextInt(5) + 10;
      rotateTimer = 0;
      rotation = _rotateTowards(_rotationChange(40));
    }

    var tx = x + math.cos(rotation)*v;
    var ty = y + math.sin(rotation)*v;
    
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
      if (_distanceTo(_fishes[i]) < r && _fishes[i] != this) fishes.add(_fishes[i]);
    }
    if (_tooClose(fishes)) return rotation+(random.nextInt(2) - 1)*ROT_AWAY;
    else return _averageRotation(fishes);
  }
  
  bool _tooClose(List <Fish> fishes) {
    for(int i=0; i<fishes.length; i++) {
      if (_distanceTo(fishes[i]) < MIN_SEPARATION) return true;
    }
    return false;
  }
  
  num _distanceTo(Fish f) {
    Point myP = new Point(x, y);
    return myP.distanceTo(new Point(f.x, f.y));
  }
  
  num _rotateTowards(num angle) {
    num diff = angle-rotation;
    num newAngle, ret;
    if (angle<0) newAngle = angle+2*math.PI-rotation;
    else newAngle = angle-2*math.PI-rotation;
    
    if (diff.abs() < newAngle.abs()) {
      if (diff.abs() < ROT_SPEED) {
        ret = angle;
      } else if (diff > 0) {
        ret = rotation+ROT_SPEED;
      } else {
        ret = rotation-ROT_SPEED;
      }
    } else {
      if (newAngle.abs() < ROT_SPEED) {
        ret = angle;
      } else if (newAngle > 0) {
        ret = rotation+ROT_SPEED;
      } else {
        ret = rotation-ROT_SPEED;
      }
    }
    if (ret<-math.PI) ret = ret + 2*math.PI;
    if (ret>math.PI) ret = ret - 2*math.PI;
    return ret;
  }
}