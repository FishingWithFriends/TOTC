part of TOTC;

class Game extends Sprite {
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  int width;
  int height;
  
  Game(ResourceManager resourceManager, Juggler juggler, int w, int h) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    width = w;
    height = h;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Background"));
    Bitmap mask = new Bitmap(_resourceManager.getBitmapData("Mask"));
    var fleet = new Fleet(_resourceManager, _juggler, this);
    var ecosystem = new Ecosystem(_resourceManager, _juggler, this, fleet);
    
    background.width = width;
    background.height = height;
    addChild(background);
    addChild(ecosystem);
    
    addChild(fleet);
    mask.width = width;
    mask.height = height;
    addChild(mask);
    
    this.onEnterFrame.listen(_onEnterFrame);
  }
  num _fpsAverage = null;

  _onEnterFrame(EnterFrameEvent e) {

    if (_fpsAverage == null) {
      _fpsAverage = 1.00 / e.passedTime;
    } else {
      _fpsAverage = 0.05 / e.passedTime + 0.95 * _fpsAverage;
    }

    html.querySelector('#fpsMeter').innerHtml = 'fps: ${_fpsAverage.round()}';
  }

}