import funkin.backend.shaders.CustomShader;

var ultraCam:FlxCamera;
var chromaticWarpShader:CustomShader;
var glowShader:CustomShader;

function create() {
    for (cam in [camGame, camHUD]) FlxG.cameras.remove(cam, false);

    ultraCam = new FlxCamera(0,FlxG.height/2 - FlxG.width/2, FlxG.width, FlxG.width);
    ultraCam.angle = 90; ultraCam.visible = false;

    chromaticWarpShader = new CustomShader("warp");
    chromaticWarpShader.distortion = 3;

    glowShader = new CustomShader("glow");
    glowShader.size = 20.0;
    glowShader.dim = 0.6;

    if (FlxG.save.data.warp) ultraCam.addShader(chromaticWarpShader);
    if (FlxG.save.data.bloom) ultraCam.addShader(glowShader);
    
    FlxG.cameras.add(ultraCam, false);
    for (cam in [camGame, camHUD]) {cam.bgColor = 0x00000000; FlxG.cameras.add(cam, cam == camGame);}
}

function onStrumCreation(strumEvent) if (strumEvent.player == 0) strumEvent.__doAnimation = false;

function postCreate() {
    ultraNotes();

    /*
    for (strum in playerStrums) {strum.visible = false; strum.alpha = 0;}

    for (spr in [psychScoreTxt, timeTxt, timeBarBG, timeBar, gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2])
        {spr.visible = false; spr.alpha = 0;}
    */
}

function ultraNotes() {
    ultraCam.visible = true;

    for (strum in cpuStrums) {
        strum.x = ((FlxG.width/2) - (Note.swagWidth * 2)) + (Note.swagWidth * cpuStrums.members.indexOf(strum)); 
        strum.y = 0;
        strum.cameras = [ultraCam];
    }
}

var doUltraFlashes:Bool = true;

var dimTween:FlxTween;
var sizeTween:FlxTween;
var distortTween:FlxTween;
function measureHit() {
    if (!doUltraFlashes) return;

    for (tween in [dimTween, sizeTween, distortTween]) if (tween != null) tween.cancel();

    dimTween = FlxTween.num(0.2, 0.7, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {
        glowShader.dim = val;
    });

    sizeTween = FlxTween.num(40.0, 20.0, (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.quadOut}, (val:Float) -> {
        glowShader.size = val;
    });

    distortTween = FlxTween.num(4.5, 3.0, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {
        chromaticWarpShader.distortion = val;
    });
}

function beatHit(beat:Int) {
    switch (beat) {
        case 64, 192: camZoomingInterval = 2; camZoomingStrength = 4;
        case 128, 256: camZoomingInterval = 4; camZoomingStrength = 2;
    }

    // Still do the normal bumps cause they cool
    if (camZoomingStrength > 0 && camZoomingInterval != 4) {
        if (camZooming && FlxG.camera.zoom < maxCamZoom && curBeat % 4 == 0)
            {
                FlxG.camera.zoom += 0.015 * camZoomingStrength;
                camHUD.zoom += 0.03;
            }
    }
}