import funkin.game.ComboRating;

public var breakingHeart:FlxSprite = null;

function create(){
	scripts.getByName("ui_healthbar.hx").call("disableScript");
}

function postCreate() {
	healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
	camFollowChars = false;
	hudBeatGame = true;
	camFollow.setPosition(642,358);

	for (strum in strumLines)
        for (i=>strumNotes in strum.members)
            strumNotes.x -= 78 * i; //scale arrows 1.5 hud position: 0.91,72

	breakingHeart = new FlxSprite(90, 100);
    breakingHeart.frames = Paths.getFrames('stages/breaking/BREAKING_LIFES');
    breakingHeart.animation.addByPrefix('4', 'LIFES 4', 24, false);
    breakingHeart.animation.addByPrefix('4 remove', 'LIFES MINUS 3', 24, false);
    breakingHeart.animation.addByPrefix('3 remove', 'LIFES MINUS 2', 24, false);
    breakingHeart.animation.addByPrefix('2 remove', 'LIFES MINUS 1', 24, false);
	breakingHeart.animation.play('4');
	add(breakingHeart);
}

function onStrumCreation(_) _.__doAnimation = false;