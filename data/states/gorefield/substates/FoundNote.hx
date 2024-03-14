import funkin.backend.utils.FunkinParentDisabler;
import flixel.text.FlxTextBorderStyle;

var parentDisabler:FunkinParentDisabler;
var daCamera:FlxCamera;
function postCreate() {
    add(parentDisabler = new FunkinParentDisabler());
    for (camera in FlxG.cameras.list) camera.active = false;

    paintingsScript = PlayState.instance.scripts.getByPath("assets/data/scripts/easteregg/paintings.hx");
    var note_data = paintingsScript.interp.publicVariables.get("note_data");
    
    var note_sprite:FlxSprite = new FlxSprite();
    note_sprite.loadGraphic(Paths.image("easteregg/" + note_data.sprite));
    note_sprite.setGraphicSize(400);
    note_sprite.updateHitbox();
    note_sprite.screenCenter();
    add(note_sprite);

    var foundNoteText:FlxText = new FlxText(0, 520, 0, FlxG.save.data.spanish ? "NOTA ENCONTRADA" : "english text here");
    foundNoteText.setFormat(Paths.font("pixelart.ttf"), 55, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    foundNoteText.borderSize = 4;
    foundNoteText.screenCenter(FlxAxes.X);
    add(foundNoteText);

    var arleneText:FlxText = new FlxText(0, 600, 0, FlxG.save.data.spanish ? "Visita a Arlene" : "english text here");
    arleneText.setFormat(Paths.font("Harbinger_Caps.otf"), 40, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    arleneText.borderSize = 4;
    arleneText.screenCenter(FlxAxes.X);
    add(arleneText);

    //! No uses "camera" directamente como el PauseSubState!!!! -EstoyAburridow
    daCamera = new FlxCamera();
    daCamera.bgColor = 0x60000000;
    FlxG.cameras.add(daCamera, false);
    cameras = [daCamera];

    new FlxTimer().start(5, function() {
        FlxG.save.data.arlenePhase = 1;
        FlxG.save.flush();
        close();
    });
}

function destroy() {
    if(FlxG.cameras.list.contains(daCamera))
        FlxG.cameras.remove(daCamera, true);

    for (camera in FlxG.cameras.list) camera.active = false;
}