import funkin.backend.shaders.CustomShader;

public var particleShader:CustomShader; // yes it is a shader

function create() {
    particleShader = new CustomShader("particles");
    particleShader.time = 0; particleShader.particlealpha = 1;
	particleShader.res = [FlxG.width, FlxG.height];
    particleShader.particleXY = [0, 0];
    particleShader.particleColor = [0.1,0.1,0.1];
    particleShader.particleDirection = [-1.2, -0.5];
    particleShader.particleZoom = 1;
    particleShader.particlealpha = 0;
    if (FlxG.save.data.particles) FlxG.camera.addShader(particleShader);

    stage.stageSprites["black"].alpha = 1;
    stage.stageSprites["BG1"].zoomFactor = 0.7;
}

function postCreate() {
    controlHealthAlpha = false;
    tweenHUD(0,0.01);

    lerpCam = false;
    FlxG.camera.zoom = 1.5;
    defaultCamZoom = 0.35;
}

function stepHit(step:Int) {
    switch(step){
        case 0:
            boyfriend.cameraOffset.x -= 190;
            boyfriend.cameraOffset.y += 80;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 128);
            FlxTween.num(0, 3, (Conductor.stepCrochet / 1000) * 92, {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.tween(FlxG.camera, {zoom: 0.8}, (Conductor.stepCrochet / 1000) * 128, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
            }});
        case 128:
            boyfriend.cameraOffset.x += 190;
            boyfriend.cameraOffset.y -= 30;
            tweenHUD(1,(Conductor.stepCrochet / 1000) * 8);
        case 136: controlHealthAlpha = true;
        case 1024:
            controlHealthAlpha = false;
            tweenHealthBar(0,(Conductor.stepCrochet / 1000) * 8);
        case 1088 | 1216 | 1344:
            forceDefaultCamZoom = true;
            camFollowChars = false;
            FlxTween.num(3, 10, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {particleShader.particlealpha = val;});
            camFollow.x = 700;
            camFollow.y = 400;
        case 1152 | 1280 | 1408:
            FlxTween.num(10, 3, (Conductor.stepCrochet / 1000) * 8, {}, (val:Float) -> {particleShader.particlealpha = val;});
            forceDefaultCamZoom = false;
            camFollowChars = true;
        case 1476: for (strumLine in strumLines) tweenStrum(strumLine, 0, (Conductor.stepCrochet / 1000) * 18);
        case 1576: for (strumLine in strumLines) tweenStrum(strumLine, 1, (Conductor.stepCrochet / 1000) * 5);
        case 1600: camHUD.visible = camGame.visible = false;
    }
}

function update(elapsed:Float) {
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));

    particleShader.time = _curBeat * 2;
    particleShader.particleZoom = FlxG.camera.zoom*.6;
}

function onStrumCreation(_) _.__doAnimation = false;
function onPlayerHit(event) {event.showRating = false; songScore += event.score;}
function onDadHit(event) FlxG.camera.shake(0.005, 0.1);