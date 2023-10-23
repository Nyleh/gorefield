//
var heatWaveShader:CustomShader;

function create() {
    FlxG.camera.bgColor = FlxColor.fromRGB(54, 34, 83);

    heatWaveShader = new CustomShader("heatwave");
    heatWaveShader.time = 0; heatWaveShader.speed = 1; 
    heatWaveShader.strength = 1; 
    
    heatWaveShader.data.noise.input = Assets.getBitmapData("assets/shaders/maps/stupidstatic.png");
    heatWaveShader.data.noise.wrap = 2/*REPEAT*/;
    heatWaveShader.data.noise.mipFilter = 0/*MIPLINEAR*/;
    heatWaveShader.data.noise.filter = 4/*LINEAR*/;

    FlxG.camera.addShader(heatWaveShader);
}

var tottalTime:Float = 0;
function update(elapsed:Float) {
    tottalTime += elapsed;
    heatWaveShader.time = tottalTime;
}