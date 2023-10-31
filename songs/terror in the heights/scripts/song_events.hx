//
var bloom:CustomShader = null;

function create(){
    remove(dad); remove(boyfriend);
    add(boyfriend); add(dad);
    camHUD.alpha = 0;
}

var cooShit:Bool = false;
function stepHit(step:Int) {
    switch (step) {
        case 0: FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * (124));
        case 124:
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * (4));
        case 128: coolSineX = true; camZoomMult *= .97; glitchShader.glitchAmount = .6;
        case 516: camZoomMult *= .8; coolSineY = true; cloudSpeed = 1.6; coolSineMulti = 1.8; coolShit = true; glitchShader.glitchAmount = .8; 
        case 768:  camZoomMult = 1; coolSineY = false; cloudSpeed = 1; coolSineMulti *= .8; coolShit = false; glitchShader.glitchAmount = .4; 
        case 1544:
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * (8));
        case 1568: camHUD.alpha = camGame.alpha = 0;
    }

    if (step%4 == 0 && coolShit) cool();
}