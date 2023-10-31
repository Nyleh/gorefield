//
var heatWaveShader:CustomShader;

function create() {
    FlxG.camera.bgColor = FlxColor.fromRGB(54, 34, 83);

    heatWaveShader = new CustomShader("heatwave");
    heatWaveShader.time = 0; heatWaveShader.speed = 5; 
    heatWaveShader.strength = 0.38; 

    if (FlxG.save.data.heatwave) FlxG.camera.addShader(heatWaveShader);

	comboGroup.x += 500;
    comboGroup.y = 200;
}

var tottalTime:Float = 0;
function update(elapsed:Float) {
    tottalTime += elapsed;
    heatWaveShader.time = tottalTime;
}