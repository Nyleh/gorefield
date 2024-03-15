//

function create() {
    dialscript.menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
    dialscript.clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);

    // for future refernce, set this to the first portiat you want, THEN use switch portriat -lunar
    dialscript.cloudPortaitName = "Clown";

    dialscript.dialogueList = [
        {
            message_en: "HI LEAN", 
            message_es: "spanish text here", 
            typingSpeed: 0.06, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}  
        },
    ];

    dialscript.endingCallback = function () {
        dialscript.fadeOut = dialscript.fastFirstFade = true; dialscript.blackTime = 0;
        dialscript.menuMusic.fadeOut(2); dialscript.introSound.volume = 0.3;
        dialscript.eyes.animation.play("normal", true);
        (new FlxTimer()).start(2/8, function () dialscript.introSound.play(), 8);
        (new FlxTimer()).start(2.2, function () {FlxG.switchState(new StoryMenuState());});
    };
}

function postCreate() {
    dialscript.fastFirstFade = true; 
    dialscript.introSound = FlxG.sound.load(Paths.sound('easteregg/snd_test'), 0.4);
	(new FlxTimer()).start(2/8, function () dialscript.introSound.play(), 8);
	if (FlxG.save.data.arlenePhase == -1 || !FlxG.save.data.canVisitArlene) return;
	(new FlxTimer()).start(4.2, function () FlxG.sound.play(Paths.sound('easteregg/mus_sfx_cinematiccut'), 0.1));
	(new FlxTimer()).start(6, dialscript.progressDialogue);

    trace("ARLENE DIALOGUE PHASE 2 LOADED");
}