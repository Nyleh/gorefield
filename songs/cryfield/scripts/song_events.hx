function postCreate(){
    tweenHUD(0,0.0001);
    snapCam();
}

function stepHit(step:Int){
    switch(step){
        case 118:
            tweenHUD(1,(Conductor.stepCrochet / 1000) * 8);
        case 384:
            defaultCamZoom += 0.3;
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 0}, (Conductor.stepCrochet / 1000) * 12);
        case 432 | 496 | 784 | 816 | 840 | 856 | 872 | 888:
            defaultCamZoom += 0.2;
        case 448 | 848 | 800 | 832 | 864 | 880 | 894:
            defaultCamZoom -= 0.2;
        case 512:
            defaultCamZoom -= 0.2;
            camFollowChars = false;
            camFollow.x = boyfriend.x - 50;
        case 526:
            zoomDisabled = true;
            FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.4}, (Conductor.stepCrochet / 1000) * 114);
        case 640:
            zoomDisabled = false;
            camFollowChars = true;
            defaultCamZoom -= 0.3; 
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                FlxTween.tween(spr, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
            
            FlxTween.tween(rain, {alpha: 0.55}, (Conductor.stepCrochet / 1000) * 24);
        case 896:
            stage.stageSprites["black"].alpha = 0;
            stage.stageSprites["black"].visible = stage.stageSprites["black"].active = true;
            FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, (Conductor.stepCrochet / 1000) * 5);
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8);
    }
}