part of TOTC;

class Slider extends Sprite implements Touchable{
  static const RADIUS = 70;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  Fleet _fleet;
  bool _teamA;
  
  Shape _bigCircle, _smallCircle, _sardineLine, _tunaLine, _sharkLine;
  TextField _sardineText, _tunaText, _sharkText;
  num lX, lY;
  num _sardineLength, _tunaLength, _sharkLength;
  
  Slider(ResourceManager resourceManager, Juggler juggler, Fleet fleet, bool teamA) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _fleet = fleet;
    _teamA = teamA;
    
    _bigCircle = new Shape();
    _bigCircle.graphics.circle(0, 0, RADIUS);
    _bigCircle.graphics.fillColor(Color.Black);
    _bigCircle.alpha = .5;
    _smallCircle = new Shape();
    _smallCircle.graphics.circle(0, 0, 5);
    _smallCircle.graphics.fillColor(Color.Red);
    _smallCircle.alpha = 1;
    
    addChild(_bigCircle);
    addChild(_smallCircle);
    
    TextFormat format = new TextFormat("Arial", 12, Color.LightYellow, align: "left", bold:true);
    TextField intro = new TextField("You are catching:", format);
    intro.width = RADIUS*2;
    intro.x = -RADIUS+10;
    intro.y = -RADIUS-80;
    addChild(intro);
    
    format.bold = false;
    _sardineText = new TextField("100% Sardine", format);
    _sardineText.width = RADIUS*2;
    _sardineText.x = -RADIUS+13;
    _sardineText.y = -RADIUS-60;
    addChild(_sardineText);
    
    _tunaText = new TextField("0% Tuna", format);
    _tunaText.width = RADIUS*2;
    _tunaText.x = -RADIUS+13;
    _tunaText.y = -RADIUS-45;
    addChild(_tunaText);
    
    _sharkText = new TextField("0% Shark", format);
    _sharkText.width = RADIUS*2;
    _sharkText.x = -RADIUS+13;
    _sharkText.y = -RADIUS-30;
    addChild(_sharkText);
    
    lX = RADIUS*math.cos(math.PI*3/4);
    lY = RADIUS*math.sin(math.PI*3/4);
    
    _drawLines();
  }
  
  void _drawLines() {
    if (contains(_sardineLine)) removeChild(_sardineLine);
    if (contains(_tunaLine)) removeChild(_tunaLine);
    if (contains(_sharkLine)) removeChild(_sharkLine);
    
    _sardineLine = new Shape();
    _sardineLine.graphics.beginPath();
    _sardineLine.graphics.moveTo(0, -RADIUS);
    _sardineLine.graphics.lineTo(_smallCircle.x, _smallCircle.y);
    _sardineLine.graphics.strokeColor(Color.Yellow);
    _sardineLine.graphics.closePath();
    _sardineLine.alpha = .5;
    addChildAt(_sardineLine, 1);
    _sardineLength = math.sqrt(math.pow((_smallCircle.x-0).abs(), 2) + math.pow((_smallCircle.y-RADIUS*-1).abs(), 2));
    
    _tunaLine = new Shape();
    _tunaLine.graphics.beginPath();
    _tunaLine.graphics.moveTo(-lX, lY);
    _tunaLine.graphics.lineTo(_smallCircle.x, _smallCircle.y);
    _tunaLine.graphics.strokeColor(Color.LightBlue);
    _tunaLine.graphics.closePath();
    _tunaLine.alpha = .5;
    addChildAt(_tunaLine, 1);
    _tunaLength = math.sqrt(math.pow((_smallCircle.x-lX*-1).abs(), 2) + math.pow((_smallCircle.y-lY).abs(), 2));
    
    _sharkLine = new Shape();
    _sharkLine.graphics.beginPath();
    _sharkLine.graphics.moveTo(lX, lY);
    _sharkLine.graphics.lineTo(_smallCircle.x, _smallCircle.y);
    _sharkLine.graphics.strokeColor(Color.Gray);
    _sharkLine.graphics.closePath();
    _sharkLine.alpha = .5;
    addChildAt(_sharkLine, 1);
    _sharkLength = math.sqrt(math.pow((_smallCircle.x-lX).abs(), 2) + math.pow((_smallCircle.y-lY).abs(), 2));
  }

  @override
  bool containsTouch(Contact event) {
    if ((event.touchX-_smallCircle.x-x).abs()<15 && (event.touchY-_smallCircle.y-y).abs()<15)
      return true;
    else return false;
  }

  @override
  bool touchDown(Contact event) {
    
    return true;
  }

  @override
  void touchDrag(Contact event) {
    num touchX = event.touchX-x;
    num touchY = event.touchY-y;

    num hyp = math.sqrt(math.pow((touchX-0).abs(), 2) + (math.pow((touchY-0).abs(), 2)));
    
    if (hyp<RADIUS) {
      if (_teamA) {
        _smallCircle.x = (event.touchX-x)*-1;
        _smallCircle.y = (event.touchY-y)*-1;
      } else {
        _smallCircle.x = event.touchX-x;
        _smallCircle.y = event.touchY-y;
      }
      _drawLines();

      num sa = _sardineLength;
      num sh = _sharkLength;
      num t = _tunaLength;
      num prox = 20;
      
      if (_sardineLength>(_tunaLength + prox) && _sardineLength>(_sharkLength + prox)) sa = sa*3;
      if (_tunaLength>(_sardineLength + prox) && _tunaLength>(_sharkLength + prox)) t = t*3;
      if (_sharkLength>(_tunaLength + prox) && _sharkLength>(_sardineLength + prox)) sh = sh*3;
      num sum = sa + t + sh;
      
      num saP = (sa/sum*100).toInt();
      num tP = (t/sum*100).toInt();
      num shP = (sh/sum*100).toInt();

      _sardineText.text = "$saP% Sardine";
      _tunaText.text = "$tP% Tuna";
      _sharkText.text = "$shP% Shark";
      
      if (_teamA) {
        _fleet.teamASardinePercent = saP;
        _fleet.teamATunePercent = tP;
        _fleet.teamASharkPercent = shP;
      } else {
        _fleet.teamBSardinePercent = saP;
        _fleet.teamBTunePercent = tP;
        _fleet.teamBSharkPercent = shP;
      }
      
    }
  }

  @override
  void touchSlide(Contact event) {
    // TODO: implement touchSlide
  }

  @override
  void touchUp(Contact event) {
    // TODO: implement touchUp
  }
}