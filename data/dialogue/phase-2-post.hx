//

function create() {
    dialscript.menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
    dialscript.clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);

    // for future refernce, set this to the first portiat you want, THEN use switch portriat -lunar
    dialscript.cloudPortaitName = "Clown";

    dialscript.dialogueList = [
        {
            message_en: "Back so soon??&& You didn't even find the joke!", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "%How am I meant to read you a joke if you didn't even find it?!", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("smug", true);
                }
            }
        },
        {
            message_en: "%You know... &%Why am I even reading you these jokes in the first place??", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
                event: function (count:Int) {
                    switch (count) {
                        case 0: dialscript.eyes.animation.play("normal", true);
                        case 1: dialscript.eyes.animation.play("confused", true);
                    }
                }
        },
        {
            message_en: "Can't you read? &&%You were speaking fluent english just a moment ago...", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("left", true);
                }
            }
        },
        {
            message_en: "%Either way...&\nReminder,& the note is in a rain alleyway.&&\nThe clown left it for a crying cat.", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("normal", true);
                }
            }
        },
        {
            message_en: "Go find it so we can continue hunting for more jokes...", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        }
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