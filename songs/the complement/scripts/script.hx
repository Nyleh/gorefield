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
    particleShader.layers = 10;
    particleShader.particlealpha = 0;
    if (FlxG.save.data.particles) FlxG.camera.addShader(particleShader);
    stage.stageSprites["BG1"].zoomFactor = 0.7;

    stage.stageSprites["black"].alpha = 1;
}

function postCreate() {
    for (i=>strumLine in strumLines.members){
        switch (i){
            case 0:
                strumLine.onHit.add(function(e:NoteHitEvent) {FlxG.camera.shake(0.004, 0.1);});
        }
    }

    camHUD.alpha = 0;
    lerpCam = false;
    FlxG.camera.zoom = 2;
}

function stepHit(step:Int) {
    switch(step){
        case 0:
            camZoomingStrength = 2;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 256);
            FlxTween.num(0, 3, (Conductor.stepCrochet / 1000) * 92, {}, (val:Float) -> {particleShader.particlealpha = val;});
            FlxTween.tween(FlxG.camera, {zoom: 0.6}, (Conductor.stepCrochet / 1000) * 256, {ease: FlxEase.quadInOut, onComplete: function (tween:FlxTween) {
                lerpCam = true; FlxG.camera.zoom += 0.25;
                FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4);
            }});
        }
}

function update(elapsed:Float) {
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));

    particleShader.time = _curBeat * 2;
    particleShader.particleZoom = FlxG.camera.zoom*.6;
}

function onPlayerHit(event) {event.showRating = false; songScore += event.score;}