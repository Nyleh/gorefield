// Shout out to yoshi for first version of script, just changing it a bit lol -lunar

import funkin.ui.FunkinText;
import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;
import funkin.game.ComboRating;
import flixel.math.FlxMath;

var psychScoreTxt:FunkinText;
var scoreTxtTween:FlxTween;
var timeTxt:FunkinText;
var timeBarBG:FlxSprite;
var timeBar:FlxBar;

static var songLength:Float = 0; // just incase we wanna do Uknown suffering v26

function postCreate() {
	comboRatings = [
		new ComboRating(0.2, "You Suck!", 0xFFFF4444),
		new ComboRating(0.4, "Shit", 0xFFFF8844),
		new ComboRating(0.5, "Bad", 0xFFFFAA44),
		new ComboRating(0.6, "Bruh", 0xFFFFFF44),
		new ComboRating(0.7, "Meh", 0xFFAAFF44),
		new ComboRating(0.8, "Good", 0xFF88FF44),
		new ComboRating(0.9, "Great", 0xFF44FFFF),
		new ComboRating(0.99, "Sick", 0xFF44FFFF),
		new ComboRating(1, "Perfect", 0xFF44FFFF),
	];

	curRating = new ComboRating(0, "[N/A]", 0xFF888888);

	scoreTxt.visible = missesTxt.visible = accuracyTxt.visible = false;

	healthBarBG.y = FlxG.height * 0.89;
	healthBar.y = healthBarBG.y + 4;

	psychScoreTxt = new FunkinText(0, healthBarBG.y + 36, FlxG.width, "", 20, true);
	psychScoreTxt.borderSize = 1.25;
	psychScoreTxt.cameras = [camHUD];
	psychScoreTxt.alignment = "center";
	add(psychScoreTxt);

	updateScoreText();

	timeTxt = new FunkinText((FlxG.width - 400) / 2, 19, 400, "0:00", 32);
	timeTxt.cameras = [camHUD];
	timeTxt.alignment = "center";
	timeTxt.alpha = 0;
	timeTxt.borderSize = 2;

	timeBarBG = new FlxSprite().loadGraphic(Paths.image('psych/timeBar'));
	timeBarBG.x = (FlxG.width - timeBarBG.width) / 2;
	timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
	timeBarBG.alpha = 0;
	timeBarBG.cameras = [camHUD];

	var dadColor = (dad != null && dad.xml != null && dad.xml.exists("color")) ? CoolUtil.getColorFromDynamic(dad.xml.get("color")) : 0xFFFFFFFF;

	timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, FlxBarFillDirection.LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), Conductor, 'songPosition', 0, songLength = inst.length);
	timeBar.numDivisions = 800;
	timeBar.createFilledBar(0xFF000000, dadColor);
	timeBar.alpha = timeBar.percent = 0;
	timeBar.cameras = [camHUD];

	add(timeBarBG);
	add(timeBar);
	add(timeTxt);
}

function onSongStart() {
	for(s in [timeTxt, timeBarBG, timeBar]) {
		FlxTween.tween(s, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
	}
}

var lastRemainingSec:Int = 0;

function postUpdate(elapsed:Float) {
	if (lastRemainingSec != (lastRemainingSec = Std.int(Conductor.songPosition / 1000))) {
		timeTxt.text = Std.string(Std.int(lastRemainingSec / 60)) + ":" + CoolUtil.addZeros(Std.string(lastRemainingSec % 60), 2) + ' - '
		+ Std.string(Std.int((songLength / 1000) / 60)) + ":" + CoolUtil.addZeros(Std.string((songLength / 1000) % 60), 2);
	}
}

function onPlayerHit(event) {
	if (!event.note.isSustainNote) {
		if (scoreTxtTween != null)
			scoreTxtTween.cancel();
		psychScoreTxt.scale.set(1.075, 1.075);
		scoreTxtTween = FlxTween.tween(psychScoreTxt.scale, {x: 1, y: 1}, 0.2);
	}

	switch (event.rating) {
		case "sick": sicks++;
		case "good": goods++;
		case "bad": bads++;
		case "shit": shits++;
	}
	updateScoreText();
}

function onPlayerMiss(event) updateScoreText();

var sicks:Int = 0;
var goods:Int = 0;
var bads:Int = 0;
var shits:Int = 0;

function getRatingFC():String {
	var ratingFC = "";
	if (sicks > 0) ratingFC = "MFC";
	if (goods > 0) ratingFC = "GFC";
	if (bads > 0 || shits > 0) ratingFC = "FC";
	if (misses > 0 && misses < 10) ratingFC = "SDCB";
	else if (misses >= 10) ratingFC = "Clear";
	return ratingFC;
}

function updateScoreText() {
	var ratingFC = getRatingFC();
	psychScoreTxt.text = 'Score: ' + songScore
	+ ' | Misses: ' + misses
	+ ' | Rating: ' + (curRating.rating == "[N/A]" ? "?" : curRating.rating)
	+ (curRating.rating == "[N/A]" ? "" : ' (' + Std.string(FlxMath.roundDecimal(get_accuracy() * 100, 2)) + '%)')
	+ (ratingFC == '' ? '' : ' - [' + ratingFC + ']');
}