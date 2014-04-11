part of TOTC;

class Game extends Sprite {
  
  static const WIDTH = 800;
  static const HEIGHT = 600;
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  Game(ResourceManager resourceManager, Juggler juggler) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("Background"));
    Bitmap mask = new Bitmap(_resourceManager.getBitmapData("Mask"));
    var fleet = new Fleet(_resourceManager, _juggler, this);
    var ecosystem = new Ecosystem(_resourceManager, _juggler, fleet);
    
    addChild(background);
    addChild(ecosystem);
    
    addChild(fleet);
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