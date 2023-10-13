// Shout out to yoshi for first version of script, just changing it a bit lol -lunar

import funkin.ui.FunkinText;
import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;
import funkin.game.ComboRating;
import flixel.math.FlxMath;

static var psychScoreTxt:FunkinText;
var scoreTxtTween:FlxTween;
static var timeTxt:FunkinText;
static var timeBarBG:FlxSprite;
static var timeBar:FlxBar;

static var songLength:Float = 0; // just incase we wanna do Uknown suffering v26

var ratingStuff:Array<Dynamic> = [
    ['You Suck!', 0.2], //From 0% to 19%
    ['Shit', 0.4], //From 20% to 39%
    ['Bad', 0.5], //From 40% to 49%
    ['Bruh', 0.6], //From 50% to 59%
    ['Meh', 0.69], //From 60% to 68%
    ['Nice', 0.7], //69%
    ['Good', 0.8], //From 70% to 79%
    ['Great', 0.9], //From 80% to 89%
    ['Sick!', 1], //From 90% to 99%
    ['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
];

function getRating(accuracy:Float):String { // Robbed from Yasher#1987 in codename server cause i am too lazy to port
    if (accuracy < 0) {
        return "?";
    }
    for (rating in ratingStuff) {
        if (accuracy < rating[1]) {
            return rating[0];
        }
    }
    return ratingStuff[ratingStuff.length - 1][0];
}

function postCreate() {
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

	timeBarBG = new FlxSprite().makeSolid(400, 20, 0xFF000000);
	timeBarBG.x = (FlxG.width - timeBarBG.width) / 2;
	timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
	timeBarBG.alpha = 0;
	timeBarBG.cameras = [camHUD];

	var dadColor = (dad != null && dad.xml != null && dad.xml.exists("color")) ? CoolUtil.getColorFromDynamic(dad.xml.get("color")) : 0xFFFFFFFF;

	timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, FlxBarFillDirection.LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), Conductor, 'songPosition', 0, songLength = inst.length);
	timeBar.numDivisions = 800;
	timeBar.createFilledBar(0xFF000000, dadColor);
	timeBar.alpha = 0;
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

function onSongEnd() {
	for(s in [timeTxt, timeBarBG, timeBar]) {
		s.visible = false;
	}
}

function onCountdown(countdownEvent) countdownEvent.scale = 1;

function onPostCountdown(countdownEvent) {
    if (countdownEvent.sprite != null) {
        countdownEvent.sprite.cameras = [camHUD];

        countdownEvent.spriteTween.cancel();
        FlxTween.tween(countdownEvent.sprite, {alpha: 0}, Conductor.crochet / 1000, {ease: FlxEase.cubeInOut});
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
	var rating = getRating(get_accuracy());

	psychScoreTxt.text = 'Score: ' + songScore
	+ ' | Misses: ' + misses
	+ ' | Rating: ' + rating
	+ (rating == "?" ? "" : ' (' + Std.string(FlxMath.roundDecimal(get_accuracy() * 100, 2)) + '%)')
	+ (rating == "?" ? '' : ' - [' + getRatingFC() + ']');
}

function destroy() {
	for(s in [timeTxt, timeBarBG, timeBar, psychScoreTxt]) s.destroy();
	timeTxt = timeBarBG = timeBar = psychScoreTxt = songLength = onHudCreated = null;
}