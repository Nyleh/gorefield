function create()
{
	stage.stageSprites["lasagnaCat"].color = 0xFF000000;
	stage.stageSprites["black"].cameras = [camHUD];
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 0:
			maxCamZoom = 0;
		case 1024:
			stage.stageSprites["lasagnaCat"].visible = true;
			stage.stageSprites["lasagnaCat"].animation.play('run');
		case 1056:
			stage.stageSprites["lasagnaCat"].visible = false;
		case 1104 | 1112 | 1168 | 1176 | 1232 | 1240 | 1296 | 1304:
			camHUD.angle -= 10;
			camGame.angle -= 3.5;
			camHUD.y += 5;
			FlxTween.tween(camHUD, {angle: 0, y: 0}, 0.3, {ease: FlxEase.quadOut});
			FlxTween.tween(camGame, {angle: 0}, 0.3, {ease: FlxEase.quadOut});
		case 1108 | 1116 | 1172 | 1180 | 1236 | 1244 | 1300 | 1308:
			camHUD.angle += 10;
			camGame.angle += 3.5;
			camHUD.y -= 5;
			FlxTween.tween(camHUD, {angle: 0, y: 0}, 0.3, {ease: FlxEase.quadOut});
			FlxTween.tween(camGame, {angle: 0}, 0.3, {ease: FlxEase.quadOut});
		case 1568:
			stage.stageSprites["black"].alpha = 0;
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, 1);
    }
}
