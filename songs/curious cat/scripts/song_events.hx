var black_overlay:FlxSprite;
var staticShader:CustomShader;
var saturationShader:CustomShader = null;

function create()
{
	stage.stageSprites["black_overlay"].visible = stage.stageSprites["black_overlay"].active = true;
	stage.stageSprites["black_overlay"].alpha = 0.5;

	stage.stageSprites["black"].visible = stage.stageSprites["black"].active = true;
	stage.stageSprites["black"].alpha = 1;

	staticShader = new CustomShader("tvstatic");
	staticShader.time = 0; staticShader.strength = 0.2;
	staticShader.speed = 20;
	FlxG.camera.addShader(staticShader);

	saturationShader = new CustomShader("saturation");
	saturationShader.sat = 1;
	FlxG.camera.addShader(saturationShader);
	camHUD.addShader(saturationShader);

	camHUD.visible = false; maxCamZoom = 0;
	dad.cameraOffset.x -= 260;

	/*bfShader = new CustomShader("wrath");
	bfShader.uDirection = 0.;
	bfShader.uOverlayOpacity = 0.5;
	bfShader.uDistance = 21.;
	bfShader.uChoke = 10.;
	bfShader.uPower = 1.0;

	bfShader.uShadeColor = [237 / 255, 238 / 255, 255 / 255];
	bfShader.uOverlayColor = [21 / 255, 19 / 255, 63 / 255];

	boyfriend.shader = bfShader;*/

	for (strum in strumLines)
		for (char in strum.characters) {char.color = 0xFF3C3C3C; char.danceOnBeat = false;}
	for (name => sprite in stage.stageSprites)
		if (name != "black_overlay") sprite.color = 0xFF2B2B2B;
}

var totalTime:Float = 0;
function update(elapsed:Float) {
	totalTime += elapsed;
	staticShader.time = totalTime;
}

/*function draw(e) {
	//if(FlxG.keys.pressed.SPACE)
	//	e.cancel();
	var uv = boyfriend.frame.uv;
	bfShader.applyRect = [uv.x, uv.y, uv.width, uv.height];
}*/

function stepHit(step:Int) 
{
	switch (step) {
		case 0:
			lerpCam = false;
			FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 64);

			FlxG.camera.zoom = 1.4; FlxG.camera.shake(0.0006, 999999);
			FlxTween.tween(FlxG.camera, {_fxShakeIntensity: 0.0017}, (Conductor.stepCrochet / 1000) * (140-16));
			FlxTween.num(0.2, .7, (Conductor.stepCrochet / 1000) * 140-16, {}, (val:Float) -> {
				staticShader.strength = val;
			});
			FlxTween.tween(FlxG.camera, {zoom: .8}, (Conductor.stepCrochet / 1000) * (140));
		case 64: dad.cameraOffset.x += 260;
		case 140: 
			staticShader.strength = stage.stageSprites["black_overlay"].alpha = 0;
			camHUD.visible = lerpCam = true; FlxG.camera.stopFX();
			for (strum in strumLines)
				for (char in strum.characters) {char.color = 0xFFFFFFFF; char.danceOnBeat = true;}
			for (name => sprite in stage.stageSprites)
				sprite.color = 0xFFFFFFFF;
		case 656:
			tweenHUD(0, (Conductor.stepCrochet / 1000) * 16);

			lerpCam = false;
			FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.qaudInOut});
			FlxTween.tween(dad.cameraOffset, {x: dad.cameraOffset.x - 260}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.linear});
			FlxTween.tween(stage.stageSprites["black_overlay"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.quadOut});
			FlxTween.num(0.0, 1.3, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.quadOut}, (val:Float) -> {
				staticShader.strength = val;
			});
			FlxG.camera.shake(0.0002, 999999);
			FlxTween.tween(FlxG.camera, {_fxShakeIntensity: 0.002}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.quadOut});
		case 780:
			tweenStrum(player, 1, (Conductor.stepCrochet / 1000) * 4);
			
		case 784:
			tweenHUD(1, (Conductor.stepCrochet / 1000) * 4); camGame.stopFX();

			FlxTween.tween(stage.stageSprites["black_overlay"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
			FlxTween.num(1.3, 0., (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.quadOut}, (val:Float) -> {
				staticShader.strength = val;
			});

			FlxTween.cancelTweensOf(dad.cameraOffset); dad.cameraOffset.x += 260; 
			lerpCam = true;
		case 912: 
			FlxTween.num(1., 1.2, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadOut}, (val:Float) -> {
				saturationShader.sat = val;
			});
		case 1040: 
			lerpCam = FlxG.camera.visible = false;
			FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 24, {startDelay: (Conductor.stepCrochet / 1000) * 8});
			FlxTween.tween(camHUD, {zoom: 1.05}, (Conductor.stepCrochet / 1000) * 32, {startDelay: (Conductor.stepCrochet / 1000) * 8, ease: FlxEase.quadOut});
	}
}
