function create()
{
    //stage.stageSprites["black"].cameras = [camHUD];
    stage.stageSprites["pixelblack"].drawComplex(FlxG.camera);
}

function postCreate()
{
    lerpCam = false;
    defaultCamZoom = 1.5;
    FlxG.camera.zoom = 1.5;
    camHUD.alpha = 0.01;
}

function stepHit(step:Int) 
{
    switch (step)
    {
        case 0:
            FlxTween.tween(FlxG.camera, {zoom: 0.72}, (Conductor.stepCrochet / 1000) * 30, {onComplete: function (tween:FlxTween) {defaultCamZoom = 0.72; lerpCam = true;}});
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, 3);
        case 32: FlxTween.tween(camHUD,{alpha: 1},0.5);
        case 1452 | 1580: 
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, 0.1);
            FlxTween.tween(FlxG.camera, {zoom: 1.5}, (Conductor.stepCrochet / 1000) * 3);
            FlxTween.tween(camHUD,{alpha: 0},0.3); 
        case 1456:
            camHUD.alpha = 1;
            stage.stageSprites["black"].alpha = 0;
            camGame.flash(0xFFFFFFFF, 1);

            for (name => sprite in stage.stageSprites)
                sprite.visible = (name == "pixelblack" || name == 'black');

            boyfriend.visible = false;
            isLymanFlying = false;
            removeTrail();
        case 1584:
            camHUD.alpha = 1;
            stage.stageSprites["black"].alpha = 0;
            camGame.flash(0xFFFFFFFF, 1);

            for (name => sprite in stage.stageSprites)
                sprite.visible = name != "pixelblack";
            
            boyfriend.visible = true;
            isLymanFlying = true;
            addTrail();
        case 2256: camGame.visible = camHUD.visible = false;
    }
}