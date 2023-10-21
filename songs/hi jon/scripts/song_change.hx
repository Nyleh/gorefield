import flixel.addons.effects.FlxTrail;

var gfTrail:FlxTrail = null;
var bloom:CustomShader = null;
var blackandwhite:CustomShader = null;

function create() {
    FlxG.sound.play(Paths.sound('explosionsound'), 0); // Preload sound

    stage.stageSprites["bgFinal"].active = stage.stageSprites["bgFinal"].visible = false;
    stage.stageSprites["bgFinal"].drawComplex(FlxG.camera); // Push to GPU

    for (char in [gf, boyfriend, dad]) char.visible = char.active = false;
    for (char in [boyfriend, dad]) char.alpha = 0;

    gfTrail = new FlxTrail(gf, null, 10, 4, 0.3, 0.1);
    gfTrail.beforeCache = gf.beforeTrailCache;
    gfTrail.afterCache = () -> {gf.afterTrailCache();}
    gfTrail.visible = gfTrail.active = false;
    if (FlxG.save.data.trails) insert(members.indexOf(gf), gfTrail);
    gf.colorTransform.color = 0xFFFF0000;

    bloom = new CustomShader("glow");
    bloom.size = 20.0; bloom.dim = 0.9;

    blackandwhite = new CustomShader("bw");

    stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
    stage.stageSprites["black_overlay"].active = stage.stageSprites["black_overlay"].visible = true;

    stage.stageSprites["red_overlay"].active = stage.stageSprites["red_overlay"].visible = true;
    stage.stageSprites["red_overlay"].alpha = 0;
}

function postCreate() {
    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, psBar, scoreTxt, missesTxt, accuracyTxt])
        spr.alpha = 0;
    for (strumLine in strumLines)
        for (strum in strumLine.members) strum.alpha = 0;
}

function update(elapsed:Float) {
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60));

    for (i=>trail in gfTrail.members) {
        if (!gfTrail.active) break;
        var scale = FlxMath.bound(1 + ((curStep < 384 ? .3 : .15) * Math.sin(_curBeat/2 + (i * (Conductor.stepCrochet / 1000)))), 1, 999);
        trail.colorTransform.color = curStep < 384 ? 0xFF7E0000 : 0xFFFF0000;

        trail.x = gf.x + ((20 * Math.sin(_curBeat + (i * (Conductor.stepCrochet / 1000)))) * scale);
        trail.y = gf.y + ((20 * Math.cos(_curBeat + (i * (Conductor.stepCrochet / 1000)))) * scale);

        trail.scale.set(scale, scale);
    }
    if (curStep > 120 && curStep < 384) {
        gf.colorTransform.color = 0xFFFF0000;
        boyfriend.colorTransform.color = 0xFF5B50D3;
        dad.colorTransform.color = 0xFFD44D29;
    }
}

function stepHit(step:Int) {
    switch (step) {
        case 0:
            lerpCam = false; FlxG.camera.zoom = 0.45;

            if (FlxG.save.data.bloom) camGame.addShader(bloom);
            gf.visible = gf.active = gfTrail.visible = gfTrail.active = true;

            gf.cameraOffset.x -= 140;
            camGame.snapToTarget();

            FlxTween.tween(FlxG.camera, {zoom: 0.825}, (Conductor.stepCrochet / 1000) * 128);
            FlxG.camera.shake(0.003, 999999);

            FlxTween.tween(stage.stageSprites["red_overlay"], {alpha: 0.25}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/});
        case 124:
            lerpCam = true;
            for (strum in cpu)
                FlxTween.tween(strum, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
        case 128:
            FlxG.camera.stopFX();

            stage.stageSprites["red_overlay"].active = stage.stageSprites["red_overlay"].visible = false;
            FlxTween.cancelTweensOf(stage.stageSprites["red_overlay"]);

            dad.visible = dad.active = true; dad.alpha = 0;
            FlxTween.tween(dad, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4, {onComplete: function (_) {
                boyfriend.colorTransform.color = 0xFF5B50D3;
            }});
        case 190:
            for (strum in player)
                FlxTween.tween(strum, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
        case 192:
            boyfriend.visible = boyfriend.active = true; boyfriend.alpha = 0;
            FlxTween.tween(boyfriend, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4, {onComplete: function (_) {
                dad.colorTransform.color = 0xFFD44D29;
            }});
        case 384:
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = false;
            stage.stageSprites["black_overlay"].active = stage.stageSprites["black_overlay"].visible = false;
            gfTrail.active = gfTrail.visible = false;

            for (spr in [gf, boyfriend, dad])
                spr.colorTransform = null;
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, psBar, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 1}, 1.5);

            if (FlxG.save.data.bloom) camGame.removeShader(bloom);
        case 1024:
            gfTrail.active = gfTrail.visible = true;
            gfTrail.color = 0xFFFF0000;
            
            stage.stageSprites["red_overlay"].active = stage.stageSprites["red_overlay"].visible = true;
            FlxTween.tween(stage.stageSprites["red_overlay"], {alpha: 0.7}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/});
        case 1136: // ! Fade Infront Stuff
            for (sprite in [dad, boyfriend])
                FlxTween.tween(sprite, {alpha: 0.3}, (Conductor.stepCrochet / 1000) * 4);
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, psBar, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);

            devControlBotplay = !(player.cpu = true);
            for (strumLine in strumLines) {
                for (strum in strumLine.members)
                    FlxTween.tween(strum, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
                strumLine.notes.forEach(function (n) {
                    FlxTween.tween(n, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
                });
            }
        case 1140: // ! Zoom
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1.2}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {defaultCamZoom = 1.2;}});
        case 1152: // ! Stage Change
            lerpCam = true;
            FlxG.camera.bgColor = 0xFFFFFFFF;
            for (spr in [psBar, gorefieldhealthBar])
                spr.shader = blackandwhite;
            maxCamZoom = 9999999; // woah

            (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 8, function () {
                devControlBotplay = !(player.cpu = false);
            });
            player.cpu = true;
            for (strumLine in strumLines) {
                for (strum in strumLine.members)
                    FlxTween.tween(strum, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
                strumLine.notes.forEach(function (n) {
                    FlxTween.tween(n, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
                });
            }

            stage.stageSprites["red_overlay"].active = stage.stageSprites["red_overlay"].visible = false;
            FlxTween.cancelTweensOf(stage.stageSprites["red_overlay"]);

            gf.visible = gf.active = gfTrail.active = gfTrail.visible = false;

            stage.stageSprites["black_overlay"].active = stage.stageSprites["black_overlay"].visible = true;
            stage.stageSprites["black_overlay"].alpha = 1;
            remove(stage.stageSprites["black_overlay"]);
            add(stage.stageSprites["black_overlay"]);

            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = name == "bgFinal";
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, psBar, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
            for (strum in cpu)
                FlxTween.tween(strum, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);

            FlxG.sound.play(Paths.sound('explosionsound'), 3);
            FlxG.camera.shake(0.006, 3.6);
            camHUD.shake(0.009, 3.6); // sorry (not sorry -lunar)
            FlxG.camera.zoom += 2;

            (new FlxTimer()).start(3.6, function () {
                FlxG.camera.shake(0.0015, 999999);
                camHUD.shake(0.002, 999999);
            });

            camGame.snapToTarget();
        case 1664:
            FlxG.camera.stopFX();
            camHUD.stopFX();

            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            stage.stageSprites["black"].cameras = [camHUD];
            stage.stageSprites["black"].alpha = 0;

            remove(stage.stageSprites["black"]);
            insert(0, stage.stageSprites["black"]);

            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 32);
        case 1712:
            camHUD.visible = FlxG.camera.visible = false;
    }
}

function onStrumCreation(_) _.__doAnimation = false;
function onPlayerHit(event) if (event.noteType == null) event.showRating = !(curStep > 120 && curStep < 384) && curStep < 1024;
function onDadHit(event) if (curStep > 1170) FlxG.camera.shake(0.003, 0.1);