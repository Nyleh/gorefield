//

var bloom:CustomShader = null;
var distortionShader:CustomShader = null;

function create() {
    gf.visible = gf.active = boyfriend.visible = false;
    gf.drawComplex(FlxG.camera); // Gpu bla bla
    dad.forceIsOnScreen = true;

    bloom = new CustomShader("glow");
    bloom.size = 0; bloom.dim = 2.5;
    if (FlxG.save.data.bloom) FlxG.game.addShader(bloom);

    distortionShader = new CustomShader("chromaticWarp");
    distortionShader.distortion = 0;
    if (FlxG.save.data.warp) FlxG.game.addShader(distortionShader);

    dad.cameraOffset.y += 90;
}

function postCreate() {
    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt]) spr.alpha = 0;
    for (strum in player.members) strum.alpha = 0;
    for (spr in stage.stageSprites) spr.alpha = 0;
    dad.alpha = camHUD.alpha = 0;
}

function stepHit(step:Int) {
    switch (step){
        case 16 | 20 | 24 | 28: dad.alpha += 0.25; if (step == 28) dad.cameraOffset.y -= 90;
        case 32:
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
        case 96:
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
            for (spr in stage.stageSprites) FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
            for (spr in player.members) FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
            boyfriend.visible = true;

            FlxTween.num(2.5, 2.1, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.dim = val;});
            FlxTween.num(0, 8, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.size = val;});
            FlxTween.num(0, .25, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
        case 104 | 120 | 136 | 232 | 248 | 264:
            FlxTween.num(.25, 1 + FlxG.random.float(-0.3, .3), (Conductor.stepCrochet / 1000) * 2, {ease: FlxEase.qaudIn}, (val:Float) -> {distortionShader.distortion = val;});
        case 112 | 128 | 152 | 240 | 256 | 280:
            FlxTween.num(1, .25, (Conductor.stepCrochet / 1000) * 6, {ease: FlxEase.qaudOut}, (val:Float) -> {distortionShader.distortion = val;});
        case 160:
            FlxTween.num(2.1, 2.5, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.dim = val;});
            FlxTween.num(8, 0, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.size = val;});
            FlxTween.num(.25, .1, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
        case 224:
            boyfriend.cameraOffset.x += 80; boyfriend.cameraOffset.y += 90;
            FlxTween.num(2.5, 2.1, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.dim = val;});
            FlxTween.num(0, 8, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.size = val;});
            FlxTween.num(.25, .75, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
        case 288:
            boyfriend.cameraOffset.x -= 80; boyfriend.cameraOffset.y -= 90;
            FlxTween.num(2.1, 2.5, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.dim = val;});
            FlxTween.num(8, 0, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {bloom.size = val;});
            FlxTween.num(.75, .1, (Conductor.stepCrochet / 1000) * 4, {}, (val:Float) -> {distortionShader.distortion = val;});
        case 920: FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 24);
        case 1052: FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
        case 1312:
        {
            gf.visible = gf.active = true;
            tweenHUD(0, (Conductor.stepCrochet / 1000) * 14);
        }
        case 1376: stage.stageSprites["sansFieldBones"].active = stage.stageSprites["sansFieldBones"].visible = false;
    }
}

function onStrumCreation(_) _.__doAnimation = false;
function destroy() {FlxG.game.setFilters([]);}