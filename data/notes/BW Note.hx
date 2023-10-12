function onNoteCreation(event) {
    if (event.noteType != "BW Note") return;
    event.noteSprite = "game/notes/gorefield_bw";
    // TODO: ADD SPLASHES WHEN THEY GET DRAWN
}