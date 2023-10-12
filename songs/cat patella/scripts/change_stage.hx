function create()
{
    stage.stageSprites["sansFieldHUD"].drawComplex(FlxG.camera);
    stage.stageSprites["sansFieldBones"].drawComplex(FlxG.camera);
 
    gf.active = gf.visible = false;
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 1198: // * Black screen
            boyfriend.visible = false;
            dad.visible = false;

            for (name => sprite in stage.stageSprites) 
                sprite.active = sprite.visible = false;
        // * Heart flicking?
        case 1200: // * Stage Change
            stage.stageSprites["sansFieldHUD"].active = stage.stageSprites["sansFieldHUD"].visible = true;
            stage.stageSprites["sansFieldBones"].active = stage.stageSprites["sansFieldBones"].visible = true;

            boyfriend.setPosition(830, -130);
            dad.setPosition(440, -520);
    }
}