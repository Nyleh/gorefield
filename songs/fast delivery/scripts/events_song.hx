var lasagnaCat:FlxSprite;
var black:FlxSprite;

function create()
{
	if (PlayState.SONG.meta.name.toLowerCase() == "fast delivery")
	{
		lasagnaCat = new FlxSprite(-1600, 60);
		lasagnaCat.frames = Paths.getSparrowAtlas('stages/pixelLasagna/LASAGNA_CAT_BG');
		lasagnaCat.animation.addByPrefix('run', 'LASAGNA CAT RUN BG', 12, false);
		lasagnaCat.visible = false;
		lasagnaCat.flipX = true;
		lasagnaCat.color = 0xFF000000;
		add(lasagnaCat);

		black = new FlxSprite();
        black.makeSolid(FlxG.width, FlxG.height, 0xFF000000);
        black.cameras = [camHUD];
        insert(0, black);
	}
	else
		__script__.didLoad = __script__.active = false;
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 1:
			maxCamZoom = 0;
		case 1024:
			lasagnaCat.visible = true;
			lasagnaCat.animation.play('run', false);
		case 1056:
			lasagnaCat.visible = false;
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
			FlxTween.tween(camHUD, {alpha: 1}, 1);
    }
}
