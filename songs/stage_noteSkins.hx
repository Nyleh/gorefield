var noteSkin:String = "gorefield";
var splashSkin:String = "default";

function create() {
    if (stage != null && stage.stageXML != null) {
        if (stage.stageXML.exists("noteSkin")) noteSkin = stage.stageXML.get("noteSkin");
        if (stage.stageXML.exists("splashSkin")) splashSkin = stage.stageXML.get("splashSkin");
    }
}

function onStrumCreation(strumEvent) strumEvent.sprite = "game/notes/" + noteSkin;
function onNoteCreation(noteEvent) {
    if (noteEvent.noteType != null && Assets.exists(Paths.image("game/notes/types/" + noteEvent.noteType))) 
        noteEvent.noteSprite = "game/notes/types/" + noteEvent.noteType;
    else noteEvent.noteSprite = "game/notes/" + noteSkin;
    noteEvent.note.splash = splashSkin;
}