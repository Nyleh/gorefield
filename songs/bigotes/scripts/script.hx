function create()
{
    stage.stageSprites["black"].cameras = [camHUD];
    stage.stageSprites["pixelblack"].drawComplex(FlxG.camera);
}

function stepHit(step:Int) 
{
    switch (step)
    {
        case 1:
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, 3);
        case 1456:
            camGame.flash('0xFFFFFFFF', 1);
            stage.stageSprites["BIGOTESBG"].visible = false;
            stage.stageSprites["tornado"].visible = false;
            stage.stageSprites["BG1"].visible = false;
            stage.stageSprites["pixelblack"].visible = true;
            stage.stageSprites["BG2"].visible = false;
            boyfriend.visible = false;
            isLymanFlying = false;
            removeTrail();
        case 1584:
            camGame.flash('0xFFFFFFFF', 1);
            stage.stageSprites["pixelblack"].visible = false;
            stage.stageSprites["BIGOTESBG"].visible = true;
            stage.stageSprites["tornado"].visible = true;
            stage.stageSprites["BG1"].visible = true;
            stage.stageSprites["BG2"].visible = true;
            boyfriend.visible = true;
            addTrail();
            isLymanFlying = true;
        case 2224:
            FlxG.camera.zoom += 0.4;
            camHUD.zoom += 0.03;
    }

    if (step >= 160 && step < 284)
    {
        if (step % 4 == 0)
        {
            FlxG.camera.zoom += 0.015;
            camHUD.zoom += 0.03;
        }
    }

    if (step >= 288 && step < 543)
    {
        if (step % 4 == 0)
        {
            FlxG.camera.zoom += 0.04;
            camHUD.zoom += 0.02;
        }
    }

    if (step >= 543 && step < 668)
    {
        if (step % 8 == 0)
        {
            FlxG.camera.zoom += 0.03;
            camHUD.zoom += 0.02;
        }
    }

    if (step >= 672 && step < 800)
    {
        if (step % 4 == 0)
        {
            FlxG.camera.zoom += 0.05;
            camHUD.zoom += 0.03;
        }
    }

    if (step >= 864 && step < 928)
    {
        if (step % 4 == 0)
        {
            FlxG.camera.zoom += 0.04;
            camHUD.zoom += 0.02;
        }
    }

    if (step >= 1184 && step < 1453)
    {
        if (step % 8 == 0)
        {
            FlxG.camera.zoom += 0.03;
            camHUD.zoom += 0.02;
        }
    }

    if (step >= 1584 && step < 1696)
    {
        if (step % 4 == 0)
        {
            FlxG.camera.zoom += 0.04;
            camHUD.zoom += 0.02;
        }
    }

    if (step >= 1712 && step < 1968)
    {
        if (step % 4 == 0)
        {
            FlxG.camera.zoom += 0.05;
            camHUD.zoom += 0.03;
        }
    }

    if (step >= 2096 && step < 2224)
    {
        if (step % 4 == 0)
        {
            FlxG.camera.zoom += 0.02;
            camHUD.zoom += 0.02;
        }
    }
}