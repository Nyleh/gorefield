import funkin.backend.shaders.CustomShader;

var ultraCam:FlxCamera;
var chromaticWarpShader:CustomShader;
var glowShader:CustomShader;

function create() {
    for (cam in [camGame, camHUD]) FlxG.cameras.remove(cam, false);

    ultraCam = new FlxCamera(0,FlxG.height/2 - FlxG.width/2, FlxG.width, FlxG.width);
    ultraCam.angle = 90;
    
    chromaticWarpShader = new CustomShader("chromaticWarp");
    chromaticWarpShader.distortion = 3;

    glowShader = new CustomShader("glow");
    glowShader.size = 50.0; glowShader.quality = 10.0;
    glowShader.dim = 0.6; glowShader.directions = 16.0;

    ultraCam.addShader(chromaticWarpShader);
    ultraCam.addShader(glowShader);
    
    FlxG.cameras.add(ultraCam, false);
    for (cam in [camGame, camHUD]) {cam.bgColor = 0x00000000; FlxG.cameras.add(cam, cam == camGame);}
}

function postCreate() {
    for (strum in cpuStrums) {
        strum.x = ((FlxG.width/2) - (Note.swagWidth * 2)) + (Note.swagWidth * cpuStrums.members.indexOf(strum)); 
        strum.y = 0;
        strum.cameras = [ultraCam];
    }
}

var dimTween:FlxTween;
var sizeTween:FlxTween;
function measureHit() {
    for (tween in [dimTween, sizeTween]) if (tween != null) tween.cancel();

    dimTween = FlxTween.num(0.2, 0.6, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {
        glowShader.dim = val;
    });

    sizeTween = FlxTween.num(80.0, 50.0, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {
        glowShader.size = val;
    });
}

function onStrumCreation(strumEvent) if (strumEvent.player == 0) strumEvent.__doAnimation = false;