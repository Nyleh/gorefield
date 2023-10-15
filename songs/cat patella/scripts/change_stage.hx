function create()
{
    stage.stageSprites["sansFieldHUD"].drawComplex(FlxG.camera);
    stage.stageSprites["sansFieldBones"].drawComplex(FlxG.camera);
 
    gf.active = gf.visible = false;
}

var shakeAmount:Float = 1;

function stepHit(step:Int) 
{
    // No heart flicker? :sob:
    switch (step) 
    {
        case 637 | 638 | 639 | 640: // * Black screen flickering
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = !stage.stageSprites["black"].visible;

            if (step != 640) return; // * Stage Change
            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = name == "sansFieldHUD" || name == "sansFieldBones";

            boyfriend.setPosition(830, -130);
            dad.setPosition(440, -520);

            camFollow.setPosition(802, 295);
            camGame.snapToTarget();
        case 655: dad.cameraOffset.x = -250;
        case 694 | 696 | 698 | 700 | 702 | 704:
            vocals.volume = 1; // ! UH OH!!!!

            FlxG.camera.shake(0.02 * Math.max(shakeAmount, 0.05), ((Conductor.crochet / 4) / 1000)/2);
            shakeAmount -= 0.15;

            if (step == 694) {
                gf.active = gf.visible = true;
                FlxTween.tween(camHUD, {alpha: 0}, (Conductor.crochet) / 1000);
            }
                
        case 733: FlxG.camera.zoom += 0.13; camZoomingStrength = 0;
        case 748: FlxG.camera.zoom += 0.04;
        case 760: FlxG.camera.zoom += 0.02;
        case 768: FlxTween.tween(camHUD, {alpha: 1}, (Conductor.crochet * 2) / 1000);
        case 965: gf.active = gf.visible = false; camZoomingStrength = 1;
    }
}