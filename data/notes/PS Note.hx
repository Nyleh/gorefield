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
    psBarTrail.color = 0xFFFF0000; psBarTrail.alpha = 0;
    psBarTrail.active = psBarTrail.visible = false;

    add(psBarTrail);
    add(psBar);
}

function onNoteCreation(event)
    if (event.noteType == "PS Note") event.note.latePressWindow = 0.1;

var fullTime:Float = 0;
function update(elapsed:Float) {
    if (ps <= 2) {
        fullTime += elapsed;
        psBar.x = lerp(psBar.x, 60 + (6*Math.sin(fullTime)), 1/4) + FlxG.random.float(0, ps == 1 ? .5 : .4);
        psBar.y = lerp(psBar.y, 385 + (4*Math.cos(fullTime)), 1/4) + FlxG.random.float(0, ps == 1 ? .5 : .4);
        psBar.color = FlxColor.interpolate(psBar.color, ps == 1 ?0x6CFF6A6A : 0xFFFFC8C8, 1/14);

        psBarTrail.active = psBarTrail.visible = true;
        psBarTrail.alpha = lerp(psBarTrail.alpha, 0.4, 1/4);
    } // latePressWindow
}

function onPlayerMiss(event)
    if (event.noteType == "PS Note") event.cancel(true);

function onPlayerHit(event)
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