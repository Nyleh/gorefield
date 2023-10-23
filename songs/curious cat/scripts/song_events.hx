var blackVignette:FlxSprite;
var staticShader:CustomShader;

var bfShader:CustomShader;

function create()
{
    stage.stageSprites["BlackVignette"].visible = stage.stageSprites["BlackVignette"].active = true;
    stage.stageSprites["BlackVignette"].alpha = 0;

    stage.stageSprites["BlackVignette"].drawComplex(FlxG.camera);
    stage.stageSprites["BlackVignette"].cameras = [camHUD];

    staticShader = new CustomShader("tvstatic");
    staticShader.time = 0; staticShader.strength = 0;
    staticShader.speed = 20;
    FlxG.camera.addShader(staticShader);

    bfShader = new CustomShader("wrath");
    bfShader.uDirection = 0.;
    bfShader.uOverlayOpacity = 0.5;
    bfShader.uDistance = 21.;
    bfShader.uChoke = 10.;
    bfShader.uPower = 1.0;

    bfShader.shadeColor = FlxColor.fromRGB(237, 238, 255);
    bfShader.overlayColor = FlxColor.fromRGB(21, 19, 63);

    boyfriend.shader = bfShader;
}

var totalTime:Float = 0;
function update(elapsed:Float) {
    totalTime += elapsed;
    staticShader.time = totalTime;
}

function stepHit(step:Int) 
{
    switch (step) {
        case 140: maxCamZoom = 0;
        case 656:
            tweenHUD(0, (Conductor.stepCrochet / 1000) * 16);

            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.qaudInOut});
            FlxTween.tween(dad.cameraOffset, {x: dad.cameraOffset.x - 260}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.linear});
            FlxTween.tween(stage.stageSprites["BlackVignette"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.quadOut});
            FlxTween.num(0.0, 1.3, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.quadOut}, (val:Float) -> {
                staticShader.strength = val;
            });
            (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 32, function () {camGame.shake(0.0005, 999999);});
            (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 64, function () {camGame.stopFX(); camGame.shake(0.0012, 999999);});
        case 780:
            tweenStrum(player, 1, (Conductor.stepCrochet / 1000) * 4);
            
        case 784:
            tweenHUD(1, (Conductor.stepCrochet / 1000) * 4); camGame.stopFX();

            FlxTween.tween(stage.stageSprites["BlackVignette"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
            FlxTween.num(1.3, 0., (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {
                staticShader.strength = val;
            });

            FlxTween.cancelTweensOf(dad.cameraOffset); dad.cameraOffset.x += 260; 
            lerpCam = true;
    }
}
