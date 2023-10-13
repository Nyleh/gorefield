function create() {
    stage.stageSprites["bgFinal"].active = stage.stageSprites["bgFinal"].visible = false;
    stage.stageSprites["bgFinal"].drawComplex(FlxG.camera); // Push to GPU
}

function stepHit(step:Int) {
    switch (step) {
        case 1136: // ! Fade Infront Stuff
            for (sprite in [dad])
                FlxTween.tween(sprite, {alpha: 0.7}, (Conductor.stepCrochet / 1000) * 8);
        case 1140: // ! Zoom
            FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {defaultCamZoom = 1.2;}});
        case 1152: // ! Stage Change
            gf.visible = false;
            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = name == "bgFinal";
    }
}