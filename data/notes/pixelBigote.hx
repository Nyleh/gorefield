function onNoteCreation(event) {
    if (event.noteType != "pixelBigote") return;
    event.noteSprite = "game/notes/pixel_orange";
    //event.note.splash = "gorefield_bw";
}