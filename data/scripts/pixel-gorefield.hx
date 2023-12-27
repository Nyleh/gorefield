import funkin.game.HudCamera;
import funkin.backend.scripting.events.NoteHitEvent;

public var pixelNotesForBF = true;
public var pixelNotesForDad = true;
public var enablePixelUI = true;
public var enablePixelGameOver = true;
public var enableCameraHacks = Options.week6PixelPerfect;

var oldStageQuality = FlxG.game.stage.quality;
static var daPixelZoom = 6;

var noteType:String = "lasagnaBoy";

/**
 * UI
 */
function onNoteCreation(event) {
	if (event.note.strumLine == playerStrums && !pixelNotesForBF) return;
	if (event.note.strumLine == cpuStrums && !pixelNotesForDad) return;

	event.cancel();

	var note = event.note;
	if (event.note.isSustainNote) {
		note.loadGraphic(Paths.image('game/pixel/' + noteType + '/Notes_Assets_End'), true, 7, 6);
		note.animation.add("hold", [event.strumID]);
		note.animation.add("holdend", [4 + event.strumID]);
	} else {
		note.loadGraphic(Paths.image('game/pixel/' + noteType + '/Notes'), true, 17, 17);
		note.animation.add("scroll", [4 + event.strumID]);
	}
	note.scale.set(daPixelZoom, daPixelZoom);
	note.updateHitbox();
}

function onStrumCreation(event) {
	if (event.player == 1 && !pixelNotesForBF) return;
	if (event.player == 0 && !pixelNotesForDad) return;

	event.cancel();

	var strum = event.strum;
	strum.loadGraphic(Paths.image('game/pixel/' + noteType + '/Notes'), true, 17, 17);
	strum.animation.add("static", [event.strumID]);
	strum.animation.add("pressed", [4 + event.strumID, 8 + event.strumID], 12, false);
	strum.animation.add("confirm", [12 + event.strumID, 16 + event.strumID], 24, false);

	strum.scale.set(daPixelZoom, daPixelZoom);
	strum.updateHitbox();
}

/*function onCountdown(event) {
	if (!enablePixelUI) return;

	event.antialiasing = false;
	event.scale = daPixelZoom;
	event.spritePath = switch(event.swagCounter) {
		case 0: null;
		case 1: 'stages/school/ui/ready';
		case 2: 'stages/school/ui/set';
		case 3: 'stages/school/ui/go';
	};
}*/

function onPlayerHit(event:NoteHitEvent) {
	if (!enablePixelUI) return;
	event.ratingPrefix = "game/pixel/" + noteType + "/";
	event.ratingScale = event.numScale = daPixelZoom * 0.7 * 0.8;
	event.numScale *= 1.1;
	event.ratingAntialiasing = false;

	event.numAntialiasing = false;
}

function postCreate() {
	for (spr in [gorefieldhealthBarBG, gorefieldiconP1, gorefieldiconP2])
		spr.antialiasing = false;
	gorefieldhealthBarBG.y -= 2;

	if (enablePixelGameOver) {
		gameOverSong = "gameOvers/lasagna/Gorefield_Gameover_Pixel";
		retrySFX = "gameOvers/lasagna/Continue_Pixel";
	}
}