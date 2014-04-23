part of TOTC;

class Graph extends Sprite {
  ResourceManager _resourceManager;
  Juggler _juggler;
  Ecosystem _ecosystem;
  Game _game;
  bool _teamA;
  
  num _width, _height;
  num _xTop, _xBottom, _yTop, _yBottom;
  
  Shape _sardineLine, _sharkLine, _tunaLine;
  
  Graph(ResourceManager resourceManager, Juggler juggler, Game game, Ecosystem ecosystem, bool teamA) {
    _resourceManager = resourceManager;
    _juggler = juggler;
    _ecosystem = ecosystem;
    _teamA = teamA;
    _game = game;
    
    _width = _game.width/1.5;
    _height = _game.height/6;
    
    _yTop = 12;
    _yBottom = _height-23;
    _xTop = 35;
    _xBottom = _width-100;
    
    _addGraphics();
    _drawGraph();
  }
  
  void _drawGraph() {
    num xLength = _xBottom-_xTop;
    num yLength = _yBottom-_yTop;
    int xIncr = xLength~/_ecosystem.sardineGraph.length;
    
    num start = 0;
    int lastX = 240;
    if (_ecosystem.sardineGraph.length>lastX) {
      xIncr = xLength~/lastX;
      start = _ecosystem.sardineGraph.length-lastX;
    }
    
    num sardineRatio = (_ecosystem.largestSardinePop-_ecosystem.lowestSardinePop)/yLength;
    _sardineLine = new Shape();
    _sardineLine.graphics.beginPath();
    _sardineLine.graphics.moveTo(_xTop, (_yBottom-_ecosystem.sardineGraph[start]/sardineRatio).toInt());
    for (int i=start+1; i<_ecosystem.sardineGraph.length; i++) 
      _sardineLine.graphics.lineTo(xIncr*i+_xTop, (_yBottom-_ecosystem.sardineGraph[i]/sardineRatio).toInt());
    _sardineLine.graphics.strokeColor(Color.White, 4);
    _sardineLine.graphics.closePath();
    _sardineLine.alpha = .7;
    
    num tunaRatio = (_ecosystem.largestTunaPop-_ecosystem.lowestTunaPop)/yLength;
    _tunaLine = new Shape();
    _tunaLine.graphics.beginPath();
    _tunaLine.graphics.moveTo(_xTop, (_yBottom-_ecosystem.tunaGraph[start]/tunaRatio).toInt());
    for (int i=start+1; i<_ecosystem.tunaGraph.length; i++) 
      _tunaLine.graphics.lineTo(xIncr*i+_xTop, (_yBottom-_ecosystem.tunaGraph[i]/tunaRatio).toInt());
    _tunaLine.graphics.strokeColor(Color.Blue, 4);
    _tunaLine.graphics.closePath();
    _tunaLine.alpha = .3;

    num sharkRatio = (_ecosystem.largestSharkPop-_ecosystem.lowestSharkPop)/yLength;
    _sharkLine = new Shape();
    _sharkLine.graphics.beginPath();
    _sharkLine.graphics.moveTo(_xTop, (_yBottom-_ecosystem.sharkGraph[start]/sharkRatio).toInt());
    for (int i=start+1; i<_ecosystem.sharkGraph.length; i++) 
      _sharkLine.graphics.lineTo(xIncr*i+_xTop, (_yBottom-_ecosystem.sharkGraph[i]/sharkRatio).toInt());
    _sharkLine.graphics.strokeColor(Color.Black, 4);
    _sharkLine.graphics.closePath();
    _sharkLine.alpha = .5;
    
    addChild(_sardineLine);
    addChild(_tunaLine);
    addChild(_sharkLine);
  }
  
  void _addGraphics() {
    
    Bitmap background = new Bitmap(_resourceManager.getBitmapData("GraphBackground"));
    background.width = _width;
    background.height = _height;
    addChild(background);
    
    num h = _height/8;
    TextFormat format = new TextFormat("Arial", 14, Color.LightYellow, align: "left");
    TextField saT = new TextField("Sardine", format);
    saT.x = _width-70;
    saT.y = h;
    TextField tT = new TextField("Tuna", format);
    tT.x = _width-70;
    tT.y = h*3;
    TextField shT = new TextField("Shark", format);
    shT.x = _width-70;
    shT.y = h*5;
    
    addChild(shT);
    addChild(saT);
    addChild(tT);
    
    Shape saS = new Shape();
    saS.graphics.rect(0, 0, 15, 15);
    saS.graphics.fillColor(Color.White);
    saS.x = _width-90;
    saS.y = h+2;
    saS.alpha = .7;
    Shape tS = new Shape();
    tS.graphics.rect(0, 0, 15, 15);
    tS.graphics.fillColor(Color.Blue);
    tS.x = _width-90;
    tS.y = h*3+2;
    tS.alpha = .3;
    Shape shS = new Shape();
    shS.graphics.rect(0, 0, 15, 15);
    shS.graphics.fillColor(Color.Black);
    shS.x = _width-90;
    shS.y = h*5+2;
    shS.alpha = .5;
    
    addChild(saS);
    addChild(tS);
    addChild(shS);
    
    TextField popT = new TextField("Population", format);
    popT.x = 5;
    popT.y = 90;
    popT.rotation = math.PI*3/2;
    TextField timeT = new TextField("Time", format);
    timeT.x = _width/2-50;
    timeT.y = _height-20;
    
    addChild(popT);
    addChild(timeT);
    
    Shape xS = new Shape();
    xS.graphics.beginPath();
    xS.graphics.moveTo(_xTop, _yTop);
    xS.graphics.lineTo(_xTop, _yBottom+11);
    xS.graphics.strokeColor(Color.Black, 5);
    xS.graphics.closePath();
    xS.alpha = .3;
    
    Shape yS = new Shape();
    yS.graphics.beginPath();
    yS.graphics.moveTo(_xTop-15, _yBottom);
    yS.graphics.lineTo(_xBottom, _yBottom);
    yS.graphics.strokeColor(Color.Black, 5);
    yS.graphics.closePath();
    yS.alpha = .3;
    
    addChild(xS);
    addChild(yS);
  }
}