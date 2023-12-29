var scaryTime:Bool = false;
function stepHit(step:Int) {
    camGame.shake(scaryTime ? 0.006 : 0,0.1);
    camHUD.shake(scaryTime ? 0.005 : 0,0.1);
    switch (step){
        case 1232:
            rain.visible = false;
            rain2.visible = scaryTime = true;
    }
}