import flixel.addons.effects.FlxTrail;

var gfTrail:FlxTrail = null;
var bloom:CustomShader = null;

function create() {
    stage.stageSprites["bgFinal"].active = stage.stageSprites["bgFinal"].visible = false;
    stage.stageSprites["bgFinal"].drawComplex(FlxG.camera); // Push to GPU

    for (char in [gf, boyfriend, dad]) char.visible = char.active = false;
    for (char in [boyfriend, dad]) char.alpha = 0;

    gfTrail = new FlxTrail(gf, null, 10, 4, 0.3, 0.1);
    gfTrail.beforeCache = gf.beforeTrailCache;
    gfTrail.afterCache = () -> {gf.afterTrailCache();}
    gfTrail.visible = gfTrail.active = false;
    insert(members.indexOf(gf), gfTrail);

    gf.colorTransform.color = 0xFFFF0000;

    bloom = new CustomShader("glow");
    bloom.size = 20.0; bloom.dim = 0.9;

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

    boyfriend.colorTransform.color = 0xFF5B50D3;
    dad.colorTransform.color = 0xFFD44D29;
}

function update(elapsed:Float) {
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60));

    for (i=>trail in gfTrail.members) {
        if (!gfTrail.active) break;
        var scale = FlxMath.bound(1 + (.3 * Math.sin(_curBeat/2 + (i * (Conductor.stepCrochet / 1000)))), 1, 999);
        trail.colorTransform.color = 0xFF7E0000;

        trail.x = gf.x + ((20 * Math.sin(_curBeat + (i * (Conductor.stepCrochet / 1000)))) * scale);
        trail.y = gf.y + ((20 * Math.cos(_curBeat + (i * (Conductor.stepCrochet / 1000)))) * scale);

        trail.scale.set(scale, scale);
    }
    if (curStep > 120 && curStep < 384) {
        boyfriend.colorTransform.color = 0xFF5B50D3;
        dad.colorTransform.color = 0xFFD44D29;
    }
}

function stepHit(step:Int) {
    switch (step) {
        case 0:
            lerpCam = false; FlxG.camera.zoom = 0.45;

            camGame.addShader(bloom);
            gf.visible = gf.active = gfTrail.visible = gfTrail.active = true;

            gf.cameraOffset.x -= 140;
            camGame.snapToTarget();

            FlxTween.tween(FlxG.camera, {zoom: 0.825}, (Conductor.stepCrochet / 1000) * 128);
            FlxG.camera.shake(0.005, (Conductor.stepCrochet / 1000) * 128);

            FlxTween.tween(stage.stageSprites["red_overlay"], {alpha: 0.1}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/});
        case 124:
            lerpCam = true;
            for (strum in cpu)
                FlxTween.tween(strum, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
        case 128:
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

            camGame.removeShader(bloom);

        case 1136: // ! Fade Infront Stuff
            for (sprite in [dad, boyfriend])
                FlxTween.tween(sprite, {alpha: 0.4}, (Conductor.stepCrochet / 1000) * 8);
        case 1140: // ! Zoom
            FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {defaultCamZoom = 1.2;}});
        case 1152: // ! Stage Change
            gf.visible = false;
            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = name == "bgFinal";
    }
}

function onStrumCreation(_) _.__doAnimation = false;
function onPlayerHit(event) if (event.noteType == null) event.showRating = !(curStep > 120 && curStep < 384);