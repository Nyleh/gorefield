
function create() {
    gf.visible = gf.active = false;
    gf.drawComplex(FlxG.camera); // Gpu bla bla
    dad.forceIsOnScreen = true;
}

function stepHit(step:Int) {
    switch (step){
        case 328: FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
        case 332: FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 3);
        case 912: FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 24);
        case 972: FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
        case 1360:
        {
            gf.visible = gf.active = true;
            tweenHUD(0, (Conductor.stepCrochet / 1000) * 14);
        }
        case 1422: stage.stageSprites["sansFieldBones"].active = stage.stageSprites["sansFieldBones"].visible = false;
        case 1488: camGame.alpha = camHUD.alpha = 0;
    }
}