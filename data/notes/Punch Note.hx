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
        event.strumGlowCancelled = true; health -= 0.35;
    }