var distortionShader:CustomShader = null;

function create()
{
    distortionShader = new CustomShader("chromaticWarp");
    distortionShader.distortion = 0;
    if (FlxG.save.data.warp) FlxG.game.addShader(distortionShader);
}

var boogie:Bool = false;
function stepHit(step:Int) 
{
    switch (step) {
        case 770:
            gf.visible = true;
            cpuStrums.visible = false;
        case 1396:
            boogie = false;
        case 1412:
            boogie = true;
        case 1280:
            boogie = true;
        case 1542:
            boogie = false;
            FlxTween.num(0, 0, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
    }

    if (boogie && step % 4 == 0) 
    {
        FlxTween.num(0, 1, 0.1, {}, (val:Float) -> {distortionShader.distortion = val;}); if (curStep > 1410) FlxTween.num(0, 2, 0.1, {}, (val:Float) -> {distortionShader.distortion = val;});
    }
}

function onDadHit(event) if (curStep > 770) FlxG.camera.shake(0.003, 0.1); if (curStep > 1282) FlxG.camera.shake(0.006, 0.1);