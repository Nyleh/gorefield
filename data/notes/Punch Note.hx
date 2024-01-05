import flixel.addons.effects.FlxTrail;

function postCreate() {
    ps = FlxG.save.data.ps_hard ? 2 : 4; FlxG.sound.play(Paths.sound('mechanics/ps'), 0); FlxG.sound.play(Paths.sound('mechanics/punch'), 0); // Preload sound

    psBar = new FlxSprite(230, 560);
    psBar.frames = Paths.getFrames('mechanics/ps');
    psBar.animation.addByPrefix('4', 'LIVE 4 MAIN', 24, false);
    psBar.animation.addByPrefix('4 remove', 'LIVE 3 loose', 24, false);
    psBar.animation.addByPrefix('3 remove', 'LIVE 2 LOSE', 24, false);
    psBar.animation.addByPrefix('2 remove', 'LIVE 1 LOSE', 24, false);
    psBar.scale.set(0.6, 0.6); psBar.updateHitbox();
    psBar.animation.play(Std.string(ps), true);
    psBar.cameras = [camHUD];

    psBarTrail = new FlxTrail(psBar, null, 4, 100, 0.5, 0.069);
    psBarTrail.cameras = [camHUD];
    psBarTrail.color = 0xFFFF0000; psBarTrail.alpha = 0;
    psBarTrail.active = psBarTrail.visible = false;

    if (FlxG.save.data.trails) insert(members.indexOf(gorefieldhealthBarBG), psBarTrail);
    insert(members.indexOf(gorefieldhealthBarBG), psBar);
}

var fullTime:Float = 0;
function update(elapsed:Float) {
    if (ps <= 2) {
        fullTime += elapsed;
        psBar.x = lerp(psBar.x, 230 + (6*FlxMath.fastSin(fullTime)), 1/4) + FlxG.random.float(0, ps == 1 ? .5 : .4);
        psBar.y = lerp(psBar.y, 560 + (4*FlxMath.fastCos(fullTime)), 1/4) + FlxG.random.float(0, ps == 1 ? .5 : .4);
        psBar.color = FlxColor.interpolate(psBar.color, ps == 1 ?0x6CFF6A6A : 0xFFFFC8C8, 1/14);

        psBarTrail.active = psBarTrail.visible = psBar.alpha > 0.01;
        psBarTrail.alpha = lerp(psBarTrail.alpha, 0.4, 1/4);
    }
}

function onNoteCreation(event) {
    if (event.noteType != "Punch Note") return;
    event.cancel(true); // stop continued calls to other script

    if (FlxG.save.data.baby) 
	{
        event.note.strumTime -= 999999;
        event.note.exists = event.note.active = event.note.visible = false;
        return;
    }

    event.note.frames = Paths.getFrames(event.noteSprite);
    switch(event.strumID % 4) {
        case 0: event.note.animation.addByPrefix('scroll', 'PUNCH NOTE');
        case 1: event.note.animation.addByPrefix('scroll', 'PUNCH NOTE');
        case 2: event.note.animation.addByPrefix('scroll', 'PUNCH NOTE');
        case 3: event.note.animation.addByPrefix('scroll', 'PUNCH NOTE');
    }

    event.note.scale.set(event.noteScale, event.noteScale);
    event.note.antialiasing = true;

    event.note.latePressWindow = 0.4;
}

function onPlayerMiss(event)
    if (event.noteType == "Punch Note") {event.cancel(true); event.note.strumLine.deleteNote(event.note);}

function onPlayerHit(event)
    if (event.noteType == "Punch Note") {
        event.countAsCombo = event.showRating = event.showSplash = false;
        event.strumGlowCancelled = true;
        FlxG.sound.play(Paths.sound('mechanics/ps'),0.3);
        FlxG.sound.play(Paths.sound('mechanics/punch'),2);
        health -= FlxG.save.data.ps_hard ? 2/1.5 : 2/6;

        ps -= 2;
        if (ps >= 2) {
            psBar.animation.play(Std.string(ps+1) + " remove", true);

            for (trail in psBarTrail.members)
                trail.animation.play(psBar.animation.name, true);
        } else health -= 9999;
    }