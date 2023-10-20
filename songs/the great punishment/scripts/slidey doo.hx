var previousX;
function create(){
    previousX = dad.x;
    dad.x += -1500;
}

function beatHit(beat:Int) {
    switch (beat) {
        case 16: FlxTween.tween(dad, {x: previousX}, 6.4);
    }
}