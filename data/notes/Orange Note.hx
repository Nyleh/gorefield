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
        case 0: event.note.animation.addByPrefix('scroll', 'orange note left');
        case 1: event.note.animation.addByPrefix('scroll', 'orange note down');
        case 2: event.note.animation.addByPrefix('scroll', 'orange note up');
        case 3: event.note.animation.addByPrefix('scroll', 'orange note right');
    }

    event.note.scale.set(event.noteScale, event.noteScale);
    event.note.antialiasing = true;
}

function onPlayerHit(event)
    if (event.noteType == "Orange Note") {event.showSplash = false; event.strumGlowCancelled = true;}

function onPlayerMiss(event)
    if (event.noteType == "Orange Note") {health -= 9999; event.cancel(true);}