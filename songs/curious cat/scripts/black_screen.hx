var black:FlxSprite; // It's not completely black, but weell... -EstoyAburridow
var blackVignette:FlxSprite;

var staticShader:CustomShader;

function create()
{
    if (PlayState.SONG.meta.name.toLowerCase() == "curious cat")
    {
        black = new FlxSprite();
        black.makeSolid(FlxG.width, FlxG.height, 0xFF000000);
        black.cameras = [camHUD];
        insert(0, black);

        stage.stageSprites["BlackVignette"].visible = stage.stageSprites["BlackVignette"].active = true;
        stage.stageSprites["BlackVignette"].alpha = 0;

        stage.stageSprites["BlackVignette"].drawComplex(FlxG.camera);
        stage.stageSprites["BlackVignette"].cameras = [camHUD];

        staticShader = new CustomShader("tvstatic");
        staticShader.time = 0; staticShader.strength = 0;
        staticShader.speed = 20;
        FlxG.camera.addShader(staticShader);
    }
    else
        __script__.didLoad = __script__.active = false;
}

function tweenHUD(fadeIn:Bool, time:Float){ //this is so i dont have to write this every time and also because i cannot use camhud or the cinematic bars will fuck up
    for(i=>strumNote in player.members){
        FlxTween.tween(strumNote,{alpha: fadeIn ? 1 : 0},time);
    }
    for(i=>strumNote in cpu.members){
        FlxTween.tween(strumNote,{alpha: fadeIn ? 1 : 0},time);
    }

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
        FlxTween.tween(spr,{alpha: fadeIn ? 1 : 0},time);
}

var dadXOffset:Float;
function postCreate(){
    dadXOffset = dad.cameraOffset.x;
}

var totalTime:Float = 0;
function update(elapsed:Float) {
    totalTime += elapsed;
    staticShader.time = totalTime;
}

function stepHit(step:Int) 
{
    switch (step) {
        case 140:
            black.active = black.visible = false;
			maxCamZoom = 0;
        case 656:
            tweenHUD(false,1);
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.3}, 15, {ease: FlxEase.qaudInOut});
            FlxTween.tween(dad.cameraOffset, {x: dadXOffset - 260}, 16, {ease: FlxEase.linear});
            FlxTween.tween(stage.stageSprites["BlackVignette"], {alpha: 1},16, {ease: FlxEase.quadOut});
            FlxTween.num(0.0, 1.3, 16, {ease: FlxEase.quadOut}, (val:Float) -> {
                staticShader.strength = val;
            });
            (new FlxTimer()).start(6, function () {camGame.shake(0.0005, 15-6);});
            (new FlxTimer()).start(6+6, function () {camGame.shake(0.0012, 17-6-6);});
        case 780:
            tweenHUD(true, 0.3);
            FlxTween.tween(stage.stageSprites["BlackVignette"], {alpha: 0},1);
            FlxTween.num(1.3, 0., 1, {ease: FlxEase.quadOut}, (val:Float) -> {
                staticShader.strength = val;
            });
        case 783:
            dad.cameraOffset.x = dadXOffset;
            lerpCam = true;
    }
}
