import hxvlc.flixel.FlxVideo;
import funkin.game.PlayState;
import flixel.addons.effects.FlxTrail;

var controlHealthAlpha:Bool = true;
var curHealthAlpha:Float = 1;

var videos:Array<FlxVideo> = [];

function create() 
{
    for (path in ["GODFIELD_INTRO", "CINEMATIC_LAYER", "GODFIELD_CINEMATIC_2"])
    {
        video = new FlxVideo();
        video.load(Assets.getPath(Paths.video(path)));
        video.onEndReached.add(
            function()
            {
                canPause = true;
                startedCountdown = true;

                if (startTimer == null)
                    startTimer = new FlxTimer();
    
                videos[0].dispose();
                videos.shift();   

                FlxG.camera.flash(FlxColor.WHITE);
            }
        );
        videos.push(video);
    } 
}

function postCreate() {
    snapCam();
}

function onStartCountdown(event) {
    event.cancel(true); 

    new FlxTimer().start(0.001, function(_)
    {
        videos[0].play();

        canPause = false;

        startSong();
    });
}

function update(elapsed:Float) {
    if (controlHealthAlpha) {
        curHealthAlpha = lerp(curHealthAlpha, curCameraTarget == 1 ? 0.25 : 1, 1/20);
        for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
            spr.alpha = curHealthAlpha;
    }
}

function stepHit(step:Int) {
    switch (step) {
        case 1052:
            FlxTween.tween(camHUD, {alpha: 0}, 0.5);
        case 1059:
            remove(jonTrail);
            jonTrail = new FlxTrail(dad, null, 4, 10, 0.3, 0.0052);
            jonTrail.beforeCache = dad.beforeTrailCache;
            jonTrail.afterCache = () -> {
                dad.afterTrailCache();
                jonTrail.members[0].x += FlxG.random.float(-1, 4);
                jonTrail.members[0].y += FlxG.random.float(-1, 4);
            }
            jonTrail.color = 0xFFB3B1D8;
            if (FlxG.save.data.trails) insert(members.indexOf(dad), jonTrail);
        case 1070:
            FlxTween.tween(camHUD, {alpha: 1}, 0.5);
        case 1585:
            videos[0].play();
            canPause = false;
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
        case 3532:
            videos[0].play();
            canPause = false;
        case 3856:
            boyfriend.playAnim("idle", true, "DANCE");

            stage.stageSprites["MARCO_BG"].alpha = stage.stageSprites["BONES_SANS"].alpha = 0;
            stage.stageSprites["RAYO_DIVISOR"].alpha = stage.stageSprites["viento"].alpha = 1;
            forceDefaultCamZoom = true;
            defaultCamZoom = 0.7;

            camFollowChars = false; camFollow.setPosition(-50, -320);

            snapCam();
        case 3857:
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                spr.alpha = 0.2;
            
        case 4312:
            for (sprite in ["RAYO_DIVISOR", "viento"])
                FlxTween.tween(stage.stageSprites[sprite], {alpha: 0}, 0.4, {
                    onComplete: function() {
                        stage.stageSprites[sprite].active = false;
                    }
                });

            FlxTween.tween(dad, {y: dad.y + 600}, 0.7, {startDelay: 0.2});
            FlxTween.tween(boyfriend, {y: boyfriend.y + 240}, 0.7, {startDelay: 0.2});
        case 4320:
            gorefieldiconP1.alpha = 0.2;
        case 4369:
            gorefieldiconP2.alpha = 0.2;
            dad.y = -330;

            FlxG.camera.zoom = defaultCamZoom = 0.85;
            boyfriend.playAnim("idle", true, "DANCE");
            dad.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int){
                if(frameNumber == 0 && name != 'idle')
                    FlxG.camera.shake(0.005, .15);
                switch(name){
                    case 'singUP':
                        switch(frameNumber){
                            case 0 | 1:
                                boyfriend.setPosition(dad.x - 15,dad.y + 971 + -15);
                            case 2 | 3:
                                boyfriend.setPosition(dad.x - 15,dad.y + 971 + -12);
                            case 4 | 5 | 6:
                                boyfriend.setPosition(dad.x - 15,dad.y + 971 + -11);
                        }
                    case 'singDOWN':
                        switch(frameNumber){
                            case 0 | 1:
                                boyfriend.setPosition(dad.x - 27,dad.y + 977 + -15);
                            case 2 | 3:
                                boyfriend.setPosition(dad.x - 27,dad.y + 977 + -10);
                            case 4 | 5 | 6:
                                boyfriend.setPosition(dad.x - 27,dad.y + 977 + -9);
                        }
                    case 'singLEFT':
                        switch(frameNumber){
                            case 0 | 1 | 2 | 3 | 4 | 5 | 6:
                                boyfriend.setPosition(dad.x - 29,dad.y + 981 + 4);
                        }
                    case 'singRIGHT':
                        switch(frameNumber){
                            case 0 | 1:
                                boyfriend.setPosition(dad.x - 21 + 2,dad.y + 977 + 4);
                            case 2 | 3:
                                boyfriend.setPosition(dad.x - 24 + 2,dad.y + 977 + 4);
                            case 4:
                                boyfriend.setPosition(dad.x - 25 + 2,dad.y + 977 + 4);
                        }
                    case 'idle':
                        switch(frameNumber){
                            case 0 | 1 | 2 | 3 | 25:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981);
                            case 4 | 5:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 4);
                            case 6 | 7:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 7);
                            case 8 | 9:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 9);
                            case 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 10);
                            case 19 | 20:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 7);
                            case 21 | 22:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 4);
                            case 23 | 24:
                                boyfriend.setPosition(dad.x - 18,dad.y + 981 + 2);
                        }
                }
            };
    }
}