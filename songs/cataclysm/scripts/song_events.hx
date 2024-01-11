import hxvlc.flixel.FlxVideo;
import funkin.game.PlayState;

var controlHealthAlpha:Bool = true;
var curHealthAlpha:Float = 1;

var video:FlxVideo;

function onStartCountdown(event) 
{
    event.cancel(true); 

    video = new FlxVideo();
    video.play(Assets.getPath(Paths.video("GODFIELD_INTRO")));
    video.onEndReached.add(
        function()
        {
            canPause = true;
            startedCountdown = true;

            startTimer = new FlxTimer();

            video.dispose();
        }
    );

    canPause = false;

    startSong();
}

function postCreate() 
{
    var precacheVideo:FlxVideo = new FlxVideo();
    precacheVideo.play(Assets.getPath(Paths.video("GODFIELD_INTRO")));
    precacheVideo.onEndReached.add(
        function()
        {
            precacheVideo.dispose();
        }
    );
    precacheVideo.stop();    
}

function update(elapsed:Float) {
    if (controlHealthAlpha) {
        curHealthAlpha = lerp(curHealthAlpha, curCameraTarget == 1 ? 0.25 : 1, 1/20);
        for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
            spr.alpha = curHealthAlpha;
    }
}

function stepHit(step:Int) {
    switch (step){
        case 1584:
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadIn});
        case 1632:
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1.2}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
            FlxTween.num(0.2, 6, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(1.8, 0.2, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {bloom.dim = val;});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn});
        case 1648:
            controlHealthAlpha = false;

            jonTrail.visible = jonTrail.active = jonFlying = false;
            strumLineDadZoom = 0.9;
            strumLineBfZoom = 1.2;

            stage.stageSprites["BG"].visible = stage.stageSprites["BG2"].visible = stage.stageSprites["ALO"].visible = stage.stageSprites["ALO2"].visible = false;
            stage.stageSprites["PUNISH_BG1"].alpha = stage.stageSprites["PUNISH_TV"].alpha = 1;

            snapCam();

            FlxTween.num(6, 0.2, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
            FlxTween.num(0.2, 1.8, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {bloom.dim = val;});
        case 2175:
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1.4}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn});
            FlxTween.num(0.2, 6, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(1.8, 0.2, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {bloom.dim = val;});
        case 2192:
            stage.stageSprites["PUNISH_BG1"].alpha = stage.stageSprites["PUNISH_TV"].alpha = 0;
            stage.stageSprites["LASAGNA_BG"].alpha = 1;
            forceDefaultCamZoom = true;
            defaultCamZoom = 0.7;
            
            snapCam();

            FlxTween.num(6, 0.2, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
            FlxTween.num(0.2, 1.8, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {bloom.dim = val;});
        case 2720:
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1.5}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
            FlxTween.num(0.2, 6, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.num(1.8, 0.2, (Conductor.stepCrochet / 1000) * 15, {}, (val:Float) -> {bloom.dim = val;});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 15, {ease: FlxEase.quadIn});
        case 2736:
            stage.stageSprites["LASAGNA_BG"].alpha = 0;
            stage.stageSprites["MARCO_BG"].alpha = stage.stageSprites["BONES_SANS"].alpha = 1;
            forceDefaultCamZoom = true;
            defaultCamZoom = 0.6;
            
            snapCam();

            FlxTween.num(6, 0.2, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {chromatic.distortion = val;});
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut});
            FlxTween.num(0.2, 1.8, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {bloom.dim = val;});
    }
}