function create()
{
    stage.stageSprites["black"].cameras = [camHUD];
}

function beatHit(beat:Int) 
{
	if (beat % 4 == 0)  { // Why don't work.... 😭 - Jloor
		FlxTween.tween(stage.stageSprites["BIGOTESBG"], {alpha: 0.75}, 1, {ease: FlxEase.cubeOut, startDelay: 0.2});
	}
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 1:
            stage.stageSprites["black"].alpha = 0;
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, 1);
    }
}