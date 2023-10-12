import flixel.addons.effects.FlxTrail;

static var psBar:Character = null;
static var psBarTrail:FlxTrail = null;

static var ps:Int = 4;

function postCreate() {
    ps = 4; FlxG.sound.play(Paths.sound('mechanics/ps'), 0); // Preload sound

    psBar = new Character(60, 385, "ps");
    psBar.cameras = [camHUD];
    psBar.playAnim(Std.string(ps));

    psBarTrail = new FlxTrail(psBar, null, 4, 100, 0.5, 0.069);
    psBarTrail.cameras = [camHUD];
    psBarTrail.color = 0xFFFF0000;
    psBarTrail.active = psBarTrail.visible = false;

    add(psBarTrail);
    add(psBar);
} //

var fullTime:Float = 0;
function update(elapsed:Float) {
    if (ps <= 2) {
        fullTime += elapsed;
        psBar.x = 60 + (6*Math.sin(fullTime)) + FlxG.random.float(0,1.5);
        psBar.y = 385 + (4*Math.cos(fullTime)) + FlxG.random.float(0,1.4);
        psBarTrail.active = psBarTrail.visible = true;
    }
}

function onPlayerMiss(event)
    if (event.noteType == "PS Note") event.cancel(true);

function onPlayerHit(event)  {
    if (event.noteType == "PS Note") {
        event.countAsCombo = event.showRating = event.showSplash = false;
        event.strumGlowCancelled = true;
        FlxG.sound.play(Paths.sound('mechanics/ps'));

        if (ps >= 2) {
            psBar.playAnim(Std.string(ps) + " remove", true);
            ps -= 1;

            for (trail in psBarTrail.members)
                trail.animation.play(psBar.animation.name);
        } else health -= 9999;
    }
}
