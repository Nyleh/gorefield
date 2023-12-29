function stepHit(step:Int) {
    switch (step){
        case 1648:
            jonTrail.visible = jonTrail.active = jonFlying = false;
            strumLineDadZoom = 0.9;
            strumLineBfZoom = 1.2;

            stage.stageSprites["BG"].visible = stage.stageSprites["BG2"].visible = stage.stageSprites["ALO"].visible = stage.stageSprites["ALO2"].visible = false;
            stage.stageSprites["PUNISH_BG1"].alpha = stage.stageSprites["PUNISH_TV"].alpha = 1;
    }
}