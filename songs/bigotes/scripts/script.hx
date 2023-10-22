//
function create() {
    stage.stageSprites["pixelblack"].drawComplex(FlxG.camera);
}

function postCreate() {
    lerpCam = false;
    defaultCamZoom = 1.5;
    FlxG.camera.zoom = 1.5;
    camHUD.alpha = 0.01;


    stage.stageSprites["black"].cameras = [camCharacters];
    remove(stage.stageSprites["black"]);
    add(stage.stageSprites["black"]);
}

function stepHit(step:Int) {
    switch (step) {
        case 0:
            FlxTween.tween(FlxG.camera, {zoom: 0.72}, (Conductor.stepCrochet / 1000) * 30, {onComplete: function (tween:FlxTween) {defaultCamZoom = 0.72; lerpCam = true;}});
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * (34+16));

            FlxTween.num(0, 0.4, (Conductor.stepCrochet / 1000) * (34+16), {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.num(1, 1.3, (Conductor.stepCrochet / 1000) * (36+16), {ease: FlxEase.qaudOut}, (val:Float) -> {warpShader.distortion = val;});
        case 32: FlxTween.tween(camHUD,{alpha: 1},0.5);
        case 36: FlxTween.num(1.3, 1.15, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.qaudOut}, (val:Float) -> {warpShader.distortion = val;});
        case 1452 | 1580: 
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, 0.1);
            FlxTween.tween(FlxG.camera, {zoom: 1.5}, (Conductor.stepCrochet / 1000) * 3);
            
            FlxTween.num(.4, 0.0, .3, {}, (val:Float) -> {particleShader.particlealpha = val;});

        case 1456:
            stage.stageSprites["black"].alpha = 0;
            particleShader.particlealpha = 0;
            camGame.flash(0xFFFFFFFF, 1);

            for (name => sprite in stage.stageSprites)
                sprite.visible = (name == "pixelblack" || name == 'black');

            boyfriend.visible = false;
            isLymanFlying = false;
            removeTrail();
        case 1584:
            stage.stageSprites["black"].alpha = 0;
            FlxTween.num(.0, .7, 1.4, {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.num(1.15, 1.4, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.qaudOut}, (val:Float) -> {warpShader.distortion = val;});
            camGame.flash(0xFFFFFFFF, 1);

            for (name => sprite in stage.stageSprites)
                sprite.visible = name != "pixelblack";
            
            boyfriend.visible = true;
            isLymanFlying = true;
            addTrail();
        case 2256: camGame.visible = camHUD.visible = false;
    }
}