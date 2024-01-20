function onNoteCreation(event) {
    if (event.noteType != "Orange Note") return;
    event.cancel(true); // stop continued calls to other scripts

    if (FlxG.save.data.baby) {
        event.note.strumTime -= 999999;
        event.note.exists = event.note.active = event.note.visible = false;
        return;
    }

    event.note.frames = Paths.getFrames(event.noteSprite);
    switch(event.strumID % 4) {
        case 0: event.note.animation.addByPrefix('scroll', 'orange arrow left');
        case 1: event.note.animation.addByPrefix('scroll', 'orange arrow DOWN');
        case 2: event.note.animation.addByPrefix('scroll', 'orange arrow up');
        case 3: event.note.animation.addByPrefix('scroll', 'orange arrow right');
    }

    event.note.scale.set(event.noteScale, event.noteScale);
    event.note.antialiasing = true;

    if (FlxG.save.data.orange_hard)
        event.note.alpha = 0.5;

    event.note.latePressWindow *= FlxG.save.data.orange_hard ? 0.3 : 0.5; 
    event.note.earlyPressWindow *= FlxG.save.data.orange_hard ? 0.3 : 0.5;
}

function onPlayerHit(event)
    if (event.noteType == "Orange Note") {event.showSplash = false; event.strumGlowCancelled = true;}

function onPlayerMiss(event)
    if (event.noteType == "Orange Note") {trace(health); health -= FlxG.save.data.orange_hard ? 0.35 : 2/3; trace(health); event.cancel(true);}