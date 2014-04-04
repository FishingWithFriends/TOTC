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
}