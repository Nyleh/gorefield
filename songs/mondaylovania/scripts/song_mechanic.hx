
/*
var strumColors:Array<Int> = [];

function update(elapsed:Float) {
    for (i in 0...4) {
        var strumColor = 0xFFFFFFFF;
        for (note in strumLines.members[1].notes.members) {
            if (note.noteData != i && !(note.strumTime > Conductor.songPosition - (hitWindow * note.latePressWindow))) continue;
            if (note.noteType == "Orange Note") {strumColor = 0xFFFF8400; break;}
            if (note.noteType == "Blue Note") {strumColor = 0xFF00DDFF; break;}
        }
        strumColors[i] = strumColor;
    }

    for (i => strum in player.members)
        strum.color = FlxColor.interpolate(strum.color, strumColors[i], 1/14);
}
*/