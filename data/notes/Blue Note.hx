function onNoteCreation(event) {
    if (event.noteType != "Blue Note") return;
    event.cancel(true); // stop continued calls to other script

    event.note.frames = Paths.getFrames(event.noteSprite);
    switch(event.strumID % 4) {
        case 0: event.note.animation.addByPrefix('scroll', 'blue note left');
        case 1: event.note.animation.addByPrefix('scroll', 'blue note down');
        case 2: event.note.animation.addByPrefix('scroll', 'blue note up');
        case 3: event.note.animation.addByPrefix('scroll', 'blue note right');
    }

    event.note.scale.set(event.noteScale, event.noteScale);
    event.note.antialiasing = true;

    event.note.latePressWindow = 0.1;
}

function onPlayerMiss(event)
    if (event.noteType == "Blue Note") event.cancel(true);

function onPlayerHit(event) 
    if (event.noteType == "Blue Note") {
        health -= 9999; event.countAsCombo = event.showSplash = false;
    }