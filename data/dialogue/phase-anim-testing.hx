//

function create() {
    dialscript.menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
    dialscript.clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);

    dialscript.dialogueList = [
        {
            message: "ANIMATION TEST 1\nANIMATION TEST 1\nANIMATION TEST 1\nANIMATION TEST 1\nANIMATION TEST 1", 
            typingSpeed: 0.04, startDelay: 2,
            onEnd: function () {dialscript.switchPortrait(.8, "Clown");},
            event: function (char:Int) {
                if (char == 0) {dialscript.showCloud(true); dialscript.wind.stop(); dialscript.menuMusic.play();}
            }
        },
        {
            message: "ANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST ", 
            typingSpeed: 0.04, startDelay: 1,
            onEnd: function () {dialscript.switchPortrait(.8, "Emote");},
            event: function (char:Int) {}
        },
        {
            message: "ANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST ", 
            typingSpeed: 0.04, startDelay: 1,
            onEnd: function () {dialscript.switchPortrait(.8, "cryfieldSecret");},
            event: function (char:Int) {}
        },
        {
            message: "ANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST ", 
            typingSpeed: 0.04, startDelay: 1,
            onEnd: function () {dialscript.switchPortrait(.8, "Furniture");},
            event: function (char:Int) {}
        },
        {
            message: "ANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST ", 
            typingSpeed: 0.04, startDelay: 1,
            onEnd: function () {dialscript.switchPortrait(.8, "Explosion");},
            event: function (char:Int) {}
        },
        {
            message: "ANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST ", 
            typingSpeed: 0.04, startDelay: 1,
            onEnd: function () {dialscript.switchPortrait(.8, "chart");},
            event: function (char:Int) {}
        },
        {
            message: "ANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST ", 
            typingSpeed: 0.04, startDelay: 1,
            onEnd: function () {dialscript.switchPortrait(.8, "Note");},
            event: function (char:Int) {}
        },
        {
            message: "ANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST \nANIMATION TEST ", 
            typingSpeed: 0.04, startDelay: 1,
            onEnd: function () {dialscript.switchPortrait(.8, "Note_Green");},
            event: function (char:Int) {}
        }
    ];
}

function postCreate() {
    dialscript.fastFirstFade = false; 
    dialscript.introSound = FlxG.sound.load(Paths.sound('easteregg/snd_test'), 0.4);
	(new FlxTimer()).start(4/8, function () dialscript.introSound.play(), 8);
	if (FlxG.save.data.arlenePhase == -1 || !FlxG.save.data.canVisitArlene) return;
	(new FlxTimer()).start(6.2, function () FlxG.sound.play(Paths.sound('easteregg/mus_sfx_cinematiccut'), 0.1));
	(new FlxTimer()).start(8, dialscript.progressDialogue);
}