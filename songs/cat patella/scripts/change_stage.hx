function create()
{
    stage.stageSprites["sansFieldHUD"].drawComplex(FlxG.camera);
    stage.stageSprites["sansFieldBones"].drawComplex(FlxG.camera);
 
    gf.active = gf.visible = false;
}

function onCameraMove(event)
{
    playerStrums.cpu = true;
}

function stepHit(step:Int) 
{
    // No heart flicker? :sob:
    switch (step) 
    {
        case 637 | 638 | 639 | 640 | 641: // * Black screen flickering
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = !stage.stageSprites["black"].visible;
        case 643: // * Stage Change
            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = name == "sansFieldHUD" || name == "sansFieldBones";

            boyfriend.setPosition(830, -130);
            dad.setPosition(440, -520);

            camFollow.setPosition(802, 295);
            camGame.snapToTarget();
        case 655:
            dad.cameraOffset.x = -250;
        case 694:
            gf.active = gf.visible = true;
        case 965:
            gf.active = gf.visible = false;
    }
}