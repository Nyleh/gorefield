var distortionShader:CustomShader = null;

function create()
{
    distortionShader = new CustomShader("chromaticWarp");
    distortionShader.distortion = 0;
    if (FlxG.save.data.warp) FlxG.game.addShader(distortionShader);
}

function stepHit(step:Int) 
{
    switch (step) {
        case 770:
            gf.visible = true;
            cpuStrums.visible = false;
        case 1280:
            FlxTween.num(0, 1, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
        case 1410:
            FlxTween.num(0, 2, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
        case 1542:
            FlxTween.num(0, 0, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
    }
}

function onDadHit(event) if (curStep > 770) FlxG.camera.shake(0.003, 0.1); if (curStep > 1282) FlxG.camera.shake(0.006, 0.1);