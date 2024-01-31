import hxvlc.flixel.FlxVideo;
import funkin.backend.MusicBeatState;
var vhs:CustomShader;

var video:FlxVideo;
var blackOverlay:FlxSprite;

function create() 
{
    blackOverlay = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xff231118);
	blackOverlay.updateHitbox();
	blackOverlay.screenCenter();
	blackOverlay.scrollFactor.set();
    blackOverlay.alpha = 0;
	insert(9, blackOverlay);
}

function postCreate()
{
    comboGroup.x -= 500;
    comboGroup.y += 300;

    gorefieldiconP2.visible = false;

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2])
        spr.alpha = 0;

    if (!FlxG.save.data.vhs)
        return;

    vhs = new CustomShader("vhs");
    vhs.time = 0; 
    vhs.noiseIntensity = 0.002;
    vhs.colorOffsetIntensity = 0.5;
    FlxG.camera.addShader(vhs);
    camCharacters.addShader(vhs);

    staticShader = new CustomShader("tvstatic");
	staticShader.time = 0; staticShader.strength = 0.3;
	staticShader.speed = 20;
	if (FlxG.save.data.static)
        FlxG.camera.addShader(staticShader);

    video = new FlxVideo();
	video.load(Assets.getPath(Paths.video("takemejon")));
	video.onEndReached.add(
		function()
		{
            MusicBeatState.skipTransOut = true;
            FlxG.switchState(new PlayState());
		}
	); 
}

function tweenCamera(in:Bool){
	boyfriend.cameraOffset.x -= in ? 430 : -430;
	FlxTween.cancelTweensOf(camCharacters);
	FlxTween.tween(camCharacters,{x: in ? 0 : -800},(Conductor.stepCrochet / 1000) * 5, {ease: FlxEase.quadInOut});
    
    FlxTween.num(0.3, 10, (Conductor.stepCrochet / 1000) * 3, {onComplete: function(){
        FlxTween.num(10, 0.3, (Conductor.stepCrochet / 1000) * 5, {}, (val:Float) -> {
            staticShader.strength = val;
            vhs.noiseIntensity = val - 0.298;
        });
    }
    }, (val:Float) -> {
        staticShader.strength = val;
        vhs.noiseIntensity = val - 0.298;
    });
}

var boogie:Bool = false;
function stepHit(step:Int) {
    switch (step) {
        case 238:
            tweenCamera(true);
        case 368:
            tweenCamera(false);

            stage.stageSprites["B2"].visible = stage.stageSprites["B2"].active = false;

            for (sprite in ["fondo2", "mesa"])
                stage.stageSprites[sprite].alpha = 1;

            snapCam();
        case 432:
            stage.stageSprites["fondo3"].alpha = 1;

            for (sprite in ["fondo2", "mesa"])
                stage.stageSprites[sprite].alpha = 0;

            snapCam();
        case 496:
            FlxTween.tween(blackOverlay, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
        case 528:
            FlxTween.tween(blackOverlay, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);
        case 656:
            boogie = true;
        case 784:
            boogie = false;
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 5);
        case 788:
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet / 1000) * 60);
        case 848:
            camGame.visible = camHUD.visible = camCharacters.visible = false;
    }
    if (boogie && step%2==0) {
        noiseIntensity = 0.03;
        FlxG.camera.zoom += 0.1;
        camHUD.zoom += 0.03;
        colorOffsetIntensity = 2;

        if (step%4==0){
            FlxG.camera.angle = 8;
            camHUD.angle = 2;
        }
        else if (step%4 == 2){
            FlxG.camera.angle = -8;
            camHUD.angle = -2;
        }
    }
}

var totalTime:Float = 0;
var noiseIntensity:Float = 0; 
var colorOffsetIntensity:Float = 0;
function update(elapsed){
    totalTime += elapsed;

    FlxG.camera.angle = lerp(FlxG.camera.angle, 0, .1);
    camHUD.angle = lerp(camHUD.angle, 0, .1);

    for (spr in [gorefieldiconP1, gorefieldiconP2])
        spr.alpha = 0;

    if (FlxG.save.data.static)
        staticShader.time = totalTime;
    
    if (!FlxG.save.data.vhs)
        return;
    vhs.time = totalTime;
    vhs.noiseIntensity = noiseIntensity = lerp(noiseIntensity, 0.002, .1);
    vhs.colorOffsetIntensity = colorOffsetIntensity = lerp(colorOffsetIntensity, 0.5, .1);
}

function onGameOver(event){
    event.cancel(true);
    persistentUpdate = false;
    persistentDraw = false;
    paused = true;
    canPause = false;

    vocals.stop();
    if (FlxG.sound.music != null)
        FlxG.sound.music.stop();

    video.play();
} 