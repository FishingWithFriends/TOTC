part of TOTC;

class Game extends Sprite implements Animatable{
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  
  int width;
  int height;
  
  TextField teamATextField;
  TextField teamBTextField;
  int teamAMoney = 0;
  int teamBMoney = 0;
  bool moneyChanged;
  
  int timer = 0;
  int timerMax = 3;
  
  Game(ResourceManager resourceManager, Juggler juggler, int w, int h) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    width = w;
    height = h;
    
    moneyChanged = false;
    
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
    
    TextFormat format = new TextFormat("Arial", 40, Color.Green);
    teamATextField = new TextField("\$0", format);
    teamATextField..x = width~/2+10
                  ..y = 60
                  ..rotation = math.PI;
    addChild(teamATextField);
    teamBTextField = new TextField("\$0", format);
    teamBTextField..x = width~/2+10
                  ..y = height-60;
    addChild(teamBTextField);
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
  
  bool advanceTime(num time) {
    if (timer>timerMax) {
      timer = 0;
      if (moneyChanged == true) {
        var x = teamATextField.text.substring(1);
        int a = int.parse(teamATextField.text.substring(1));
        int b = int.parse(teamBTextField.text.substring(1));
        if (a==teamAMoney && b==teamBMoney) {
          moneyChanged = false;
          return true;
        }
        if (a!=teamAMoney) {
          if (a<teamAMoney) a=a+1;
          else a=a-1;
          teamATextField.text = "\$$a";
        }
        if (b!=teamBMoney) {
          if (b<teamBMoney) b=b+1;
          else b=b-1;
          teamBTextField.text = "\$$b";
        }
      }
    } else timer++;
    return true;
  }
}