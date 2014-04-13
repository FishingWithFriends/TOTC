part of TOTC;

class Movement {
  static num rotateTowards(num angle, num speed, num rotation) {
    num diff = angle-rotation;
    num newAngle, ret;
    if (angle<0) newAngle = angle+2*math.PI-rotation;
    else newAngle = angle-2*math.PI-rotation;
    
    if (diff.abs() < newAngle.abs()) {
      if (diff.abs() < speed) {
        ret = angle;
      } else if (diff > 0) {
        ret = rotation+speed;
      } else {
        ret = rotation-speed;
      }
    } else {
      if (newAngle.abs() < speed) {
        ret = angle;
      } else if (newAngle > 0) {
        ret = rotation+speed;
      } else {
        ret = rotation-speed;
      }
    }
    if (ret<-math.PI) ret = ret + 2*math.PI;
    if (ret>math.PI) ret = ret - 2*math.PI;
    return ret;
  }
  
  static num findMinimumAngle(num rotation, num newAngle) {
    num ret;
    
    num newAngle1 = newAngle;
    num newAngle2 = newAngle1 - math.PI*2;
    num newAngle3 = newAngle1 + math.PI*2;
    num diff1 = (rotation-newAngle1).abs();
    num diff2 = (rotation-newAngle2).abs();
    num diff3 = (rotation-newAngle3).abs();
    if (diff1<diff2 && diff1<diff3) ret = newAngle1;
    if (diff2<diff1 && diff2<diff3) ret = newAngle2;
    if (diff3<diff1 && diff3<diff2) ret = newAngle3;
    return ret;
  }
}