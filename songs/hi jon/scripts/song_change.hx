function create() {
    stage.stageSprites["bgFinal"].active = stage.stageSprites["bgFinal"].visible = false;
    stage.stageSprites["bgFinal"].drawComplex(FlxG.camera); // Push to GPU
}

function stepHit(step:Int) {
    switch (step) {
        case 1140: // ! Zoom
            FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {defaultCamZoom = 1.2;}});
        case 1152: // ! Stage Change
            gf.visible = false;
            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = name == "bgFinal";
            defaultCamZoom = FlxG.camera.zoom = 1.5;
            strumLineZooms = [1.3,1.55,1.5];
    }
}