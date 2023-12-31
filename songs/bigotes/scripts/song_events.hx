//
function create() {
    stage.stageSprites["pixelblack"].drawComplex(FlxG.camera);
}

function postCreate() {
    lerpCam = false;
    defaultCamZoom = 1.5;
    FlxG.camera.zoom = 1.5;
    camHUD.alpha = 0; maxCamZoom = 99999;

    stage.stageSprites["black"].cameras = [camCharacters];
    remove(stage.stageSprites["black"]);
    add(stage.stageSprites["black"]);
}

function stepHit(step:Int) {
    switch (step) {
        case 0:
            FlxG.camera.shake(0.003, 999999);
            FlxTween.tween(FlxG.camera, {zoom: 0.72}, (Conductor.stepCrochet / 1000) * 32, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {
                defaultCamZoom = 0.72; lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
            FlxTween.tween(FlxG.camera, {_fxShakeIntensity: 0.004}, (Conductor.stepCrochet / 1000) * 32);

            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * (32));

            FlxTween.num(0, 0.2, (Conductor.stepCrochet / 1000) * (34+16), {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.num(1, 1.3, (Conductor.stepCrochet / 1000) * (36+16), {ease: FlxEase.quadOut}, (val:Float) -> {warpShader.distortion = val;});
        case 32: FlxTween.tween(camHUD,{alpha: 1},0.5); FlxG.camera.stopFX();
        case 36: FlxTween.num(1.3, 1.15, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {warpShader.distortion = val;});
        case 288: 
            FlxTween.num(.2, 0.5, (Conductor.stepCrochet / 1000) * 16, {}, (val:Float) -> {particleShader.particlealpha = val;});
            camCharacters.flash(0xFF7403A1, (Conductor.stepCrochet / 1000) * 16);

            sineSat = bgFlashes = true;
        case 668:
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + .3}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.15;
            }});

            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 2);
        case 672:
            FlxTween.num(1.7, 1.3, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {warpShader.distortion = val;});
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = false;
            camCharacters.flash(0xFF7403A1, (Conductor.stepCrochet / 1000) * 16);
            scaleTrail = true; FlxTween.num(.5, .75, (Conductor.stepCrochet / 1000) * 16, {}, (val:Float) -> {particleShader.particlealpha = val;});
        case 928: 
            FlxTween.num(.75, .5, (Conductor.stepCrochet / 1000) * 16, {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.num(1.3, 1.15, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {warpShader.distortion = val;});
        case 1312: 
            for (name => sprite in stage.stageSprites)
                FlxTween.color(sprite, (Conductor.stepCrochet / 1000) * 12, 0xFFFFFFFF, 0xFF636363);
        case 1440:
            for (name => sprite in stage.stageSprites)
                FlxTween.color(sprite, (Conductor.stepCrochet / 1000) * 8, 0xFF636363, 0xFFBCBCBC);
        case 1568: 
            for (name => sprite in stage.stageSprites)
                FlxTween.color(sprite, (Conductor.stepCrochet / 1000) * 6, 0xFFBCBCBC, 0xFFFFFFFF);
        case 1580 | 1708:
            lerpCam = controlHealthAlpha = false;
            FlxTween.cancelTweensOf(FlxG.camera);
            FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom > 1.5 ? FlxG.camera.zoom + .2 : 1.5}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {lerpCam = true;}});

            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            stage.stageSprites["black"].alpha = 0;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 2);

            if (step == 1708)
                for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                    FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 2);
            else
                tweenHUD(0, (Conductor.stepCrochet / 1000) * 2);
        case 1584:
            stage.stageSprites["black"].alpha = particleShader.particlealpha = 0;
            camCharacters.flash(0x1f0d37, (Conductor.stepCrochet / 1000) * 8);

            for (name => sprite in stage.stageSprites)
                sprite.visible = (name == "pixelblack" || name == 'black');

            boyfriend.visible = isLymanFlying = jonTrail.visible = jonTrail.active = false;
            tweenStrum(player, 1, (Conductor.stepCrochet / 1000) * 8);
        case 1712:
            FlxTween.cancelTweensOf(stage.stageSprites["black"]);
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = false;
            stage.stageSprites["black"].alpha = 0;
            
            FlxTween.num(.0, 1, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.num(1.15, 1.3, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.quadOut}, (val:Float) -> {warpShader.distortion = val;});
            camCharacters.flash(0xFF7403A1, (Conductor.stepCrochet / 1000) * 16);

            for (name => sprite in stage.stageSprites)
                sprite.visible = name != "pixelblack" && name != "black";
            
            boyfriend.visible = isLymanFlying = jonTrail.visible = jonTrail.active = true;
            controlHealthAlpha = true; curHealthAlpha = 0;
            for (strum in player) strum.alpha = 1;

            for (name => sprite in stage.stageSprites)
                FlxTween.color(sprite, (Conductor.stepCrochet / 1000) * 112-16, 0xFFFFFFFF, 0xFF654974, {ease: FlxEase.linear});
        case 1840:
            FlxTween.num(1.3, 1.8, (Conductor.stepCrochet / 1000) * (112-8), {ease: FlxEase.quadOut}, (val:Float) -> {warpShader.distortion = val;});
        case 2096:
            for (name => sprite in stage.stageSprites)
                FlxTween.color(sprite, (Conductor.stepCrochet / 1000) * 112, 0xFF654974, 0xFFFFFFFF, {ease: FlxEase.linear});
            FlxTween.num(1.8, 1.3, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadOut}, (val:Float) -> {warpShader.distortion = val;});
            FlxTween.num(1, .6, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {particleShader.particlealpha = val;});

        case 2384: for (cam in [camJonTrail, camCharacters, camGame, camHUD]) cam.visible = false; remove(jonTrail);
    }
} 