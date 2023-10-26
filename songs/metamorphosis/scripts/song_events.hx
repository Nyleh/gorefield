var oldBfIndex:Int;

function postCreate() {
    lerpCam = false;
    defaultCamZoom = 1.5;
    FlxG.camera.zoom = 1.5;

    stage.stageSprites["black"].active = stage.stageSprites["black"].visible = true;
    remove(stage.stageSprites["black"]);
    add(stage.stageSprites["black"]);
    camHUD.alpha = 0;

    oldBfIndex = members.indexOf(boyfriend);
}

function tweenHUD2(a:Float, time:Float){ //hi psbar
    tweenHUD(a,time);
    FlxTween.tween(psBar,{alpha: a},time);
}

function stepHit(step:Int){
    switch (step){
        case 0:
            tweenHUD(0,0.0001);
            camHUD.alpha = 1;
            psBar.alpha = 0;
            //initialize bla bla

            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 128);
            FlxTween.tween(FlxG.camera, {zoom: 0.75}, (Conductor.stepCrochet / 1000) * 124, {onComplete: function (tween:FlxTween) {
                defaultCamZoom = 0.75; 
                lerpCam = true;
                tweenHUD2(1,(Conductor.stepCrochet / 1000) * 2);
            }});
        case 268: tweenHUD2(0,(Conductor.stepCrochet / 1000) * 4);
        case 272:
            remove(stage.stageSprites["black"]);
            insert(members.indexOf(dad),stage.stageSprites["black"]);
            remove(boyfriend);
            insert(members.indexOf(stage.stageSprites["black"]) - 1,boyfriend);

            FlxTween.tween(stage.stageSprites["black"], {alpha: 0.88}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quadOut});
        case 287: tweenHUD2(1,(Conductor.stepCrochet / 1000) * 1);
        case 288: 
            remove(boyfriend);
            insert(oldBfIndex,boyfriend);

            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 1, {ease: FlxEase.quadOut});
        case 928:
            remove(stage.stageSprites["black"]);
            insert(members.indexOf(gf) + 1,stage.stageSprites["black"]);
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0.88}, (Conductor.stepCrochet / 1000) * 24);

            for (spr in [gorefieldhealthBarBG, psBar, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr,{alpha: 0},(Conductor.stepCrochet / 1000) * 24);
        case 1052:
            FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * 4);

            for (spr in [gorefieldhealthBarBG, psBar, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr,{alpha: 1},(Conductor.stepCrochet / 1000) * 4);
        case 1320:
            remove(stage.stageSprites["black"]);
            insert(999,stage.stageSprites["black"]);

            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
            tweenStrum(cpu,0,(Conductor.stepCrochet / 1000) * 8);
            for (spr in [gorefieldhealthBarBG, psBar, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr,{alpha: 0},(Conductor.stepCrochet / 1000) * 8);
    }
}