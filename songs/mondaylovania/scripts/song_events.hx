
function create() {
    gf.visible = gf.active = false;
    gf.drawComplex(FlxG.camera); // Gpu bla bla
}

function stepHit(step:Int) {
    switch (step) {
        case 1360:  gf.visible = gf.active = true;
    }
}