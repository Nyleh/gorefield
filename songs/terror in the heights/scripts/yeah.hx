function create(){
    remove(dad);
    remove(boyfriend);
    add(boyfriend);
    add(dad);
    camHUD.alpha = 0;
}

function postCreate(){
    remove(stage.stageSprites["cloudScroll1"]);
    insert(999999,stage.stageSprites["cloudScroll1"]);
}

function stepHit(step:Int) {
    switch (step) {
        case 0: FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, (Conductor.stepCrochet / 1000) * (124));
        case 124:
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * (4));
        case 1544:
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * (8));
        case 1568:
            camHUD.alpha = camGame.alpha = 0;
    }
}

function update(elapsed:Float){
    dad.y -= 35 * elapsed;
    boyfriend.y -= 35 * elapsed;

    stage.stageSprites["cloudScroll1"].y += 700 * elapsed;
    stage.stageSprites["cloudScroll2"].y += 550 * elapsed;
    stage.stageSprites["cloudScroll3"].y += 350 * elapsed;
    stage.stageSprites["cloudScroll4"].y += 250 * elapsed;
    stage.stageSprites["cloudScroll5"].y += 100 * elapsed;
    if(stage.stageSprites["cloudScroll1"].y > 1300){stage.stageSprites["cloudScroll1"].y = -1000; stage.stageSprites["cloudScroll1"].x = FlxG.random.float(-100,100);}
    if(stage.stageSprites["cloudScroll2"].y > 1300){stage.stageSprites["cloudScroll2"].y = -1900; stage.stageSprites["cloudScroll2"].x = FlxG.random.float(-300,600);}
    if(stage.stageSprites["cloudScroll3"].y > 1300){stage.stageSprites["cloudScroll3"].y = -2100; stage.stageSprites["cloudScroll3"].x = FlxG.random.float(-100,700);}
    if(stage.stageSprites["cloudScroll4"].y > 1300){stage.stageSprites["cloudScroll4"].y = -1700; stage.stageSprites["cloudScroll4"].x = FlxG.random.float(-100,700);}
    if(stage.stageSprites["cloudScroll5"].y > 1300){stage.stageSprites["cloudScroll5"].y = -1900; stage.stageSprites["cloudScroll5"].x = FlxG.random.float(-300,600);}
}