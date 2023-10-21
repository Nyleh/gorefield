var dodgeCat:Character;

function create()
{
	dodgeCat = new Character(-335, -200, "dodge-lasagna-cat");
	dodgeCat.visible = false;
	dodgeCat.playAnim('idle', true);
	add(dodgeCat);

	stage.stageSprites["lasagnaCat"].color = 0xFF000000;
	stage.stageSprites["lasagnaCat"].drawComplex(FlxG.camera);
	
	stage.stageSprites["black"].cameras = [camHUD];
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 0:
			maxCamZoom = 0;
		case 1024:
			function fadeShit(alpha:Float) {
				for (strumLine in strumLines)
					for (strum in strumLine.members)
						FlxTween.tween(strum, {alpha: alpha}, (Conductor.stepCrochet / 1000) * 4);
				for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
					FlxTween.tween(spr, {alpha: alpha}, (Conductor.stepCrochet / 1000) * 4);
			}
			stage.stageSprites["lasagnaCat"].animation.play('run', true);
			stage.stageSprites["lasagnaCat"].visible = true;
			
			stage.stageSprites["lasagnaCat"].animation.finishCallback = function () {
				stage.stageSprites["lasagnaCat"].visible = false;
				fadeShit(1);
			};
			fadeShit(0);
		case 1056:
			dodgeCat.visible = true;
		case 1104 | 1112 | 1168 | 1176 | 1232 | 1240 | 1296 | 1304:
			camHUD.angle -= 10;
			camGame.angle -= 3.5;
			camHUD.y += 5;
			FlxTween.tween(camHUD, {angle: 0, y: 0}, 0.3, {ease: FlxEase.quadOut});
			FlxTween.tween(camGame, {angle: 0}, 0.3, {ease: FlxEase.quadOut});

			dodgeCat.playAnim('attack', true);
		case 1108 | 1116 | 1172 | 1180 | 1236 | 1244 | 1300 | 1308:
			camHUD.angle += 10;
			camGame.angle += 3.5;
			camHUD.y -= 5;
			FlxTween.tween(camHUD, {angle: 0, y: 0}, 0.3, {ease: FlxEase.quadOut});
			FlxTween.tween(camGame, {angle: 0}, 0.3, {ease: FlxEase.quadOut});

			dodgeCat.playAnim('attack', true);
		case 1312:
			dodgeCat.playAnim('scape', true);
			dodgeCat.animation.finishCallback = (name:String) -> {if (name == 'scape') dodgeCat.visible = false;};
		case 1568:
			stage.stageSprites["black"].alpha = 0;
            stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, 1);
    }
}
