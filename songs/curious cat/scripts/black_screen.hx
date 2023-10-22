var black:FlxSprite; // It's not completely black, but weell... -EstoyAburridow
var blackVignette:FlxSprite;

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

    FlxTween.tween(gorefieldhealthBarBG,{alpha: fadeIn ? 1 : 0},time);
    FlxTween.tween(gorefieldhealthBar,{alpha: fadeIn ? 1 : 0},time);
    FlxTween.tween(gorefieldiconP1,{alpha: fadeIn ? 1 : 0},time);
    FlxTween.tween(gorefieldiconP2,{alpha: fadeIn ? 1 : 0},time);
    FlxTween.tween(scoreTxt,{alpha: fadeIn ? 1 : 0},time);
    FlxTween.tween(missesTxt,{alpha: fadeIn ? 1 : 0},time);
    FlxTween.tween(accuracyTxt,{alpha: fadeIn ? 1 : 0},time);
}
var dadXOffset:Float;
function postCreate(){
    dadXOffset = dad.cameraOffset.x;
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 140:
            black.active = black.visible = false;

			maxCamZoom = 0;
        case 656:
            tweenHUD(false,1);
            lerpCam = false;
            FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom + 0.7},15);
            FlxTween.tween(dad.cameraOffset, {x: dadXOffset - 260}, 8);
            FlxTween.tween(stage.stageSprites["BlackVignette"], {alpha: 1},16);
            camGame.shake(0.0013, 15);
        case 780:
            tweenHUD(true,0.3);
            FlxTween.tween(stage.stageSprites["BlackVignette"], {alpha: 0},1);
        case 783:
            dad.cameraOffset.x = dadXOffset;
            lerpCam = true;
    }
}
