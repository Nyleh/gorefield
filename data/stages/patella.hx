function create() {
    stage.stageSprites["snowStorm"].cameras = [camHUD];
}

var iceTween:FlxTween;

function beatHit() {
    if (iceTween != null && !iceTween?.finished) return;
    if (!FlxG.random.bool(10)) return;

    stage.stageSprites["ice"].setPosition(-700, 400); 
    FlxTween.tween(stage.stageSprites["ice"], {x: 2400}, 2.5);
}