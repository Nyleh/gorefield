//

function create() {
    dialscript.menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
    dialscript.clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);

    // for future refernce, set this to the first portiat you want, THEN use switch portriat -lunar
    dialscript.cloudPortaitName = "Clown";

    dialscript.dialogueList = [
        {
            message: "Hello??? && Who are you??? &&&\nHow did you get trapped down here???", 
            typingSpeed: 0.065, startDelay: 2,
            onEnd: function () {},
            event: function (char:Int)
                if (char == 0) {dialscript.wind.volume = 0.5; dialscript.eyes.animation.play("confused", true);}
            
        },
        {
            message: "I mean you don't look trapped... &&&You look funny... &&&&&\nAre you from that stupid clown???", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (dialscript.isCharPhrase(char, "I mean you don't look trapped... &&&")) dialscript.eyes.animation.play("left", true);
                if (dialscript.isCharPhrase(char, "I mean you don't look trapped... &&&You look funny... &&&&&\n")) dialscript.eyes.animation.play("smug", true);
            }
        },
        {
            message: "I'm sorry...,&&&  I'm Sorry. &&&\nI didn't mean it that way.", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int)
                if (char == 0) {dialscript.eyes.animation.play("normal", true); dialscript.wind.stop(); dialscript.menuMusic.play();}
        },
        {
            message: "Guess being alone down here so long has made me a bit,&&&\nirritable...", 
            typingSpeed: 0.054, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "Guess being alone down here so long has made me a bit,&&&\n")) dialscript.eyes.animation.play("smug", true);
            }
        },
        {
            message: "I might as well introduce myself,&&& since I'm already spewing my life story...", 
            typingSpeed: 0.058, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "I might as well introduce myself,&&&")) dialscript.eyes.animation.play("smug", true);
    
            }
        },
        {
            message: "My name is Arlene,&&&\nand I'm Garfields girlfriend.", 
            typingSpeed: 0.052, startDelay: 0,
            onEnd: function () {
                (new FlxTimer()).start(.9, function () dialscript.eyes.animation.play("confused", true)); __canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
            }
        },
        {
            message: "Huh? &&&&&&You want to know how I got down here?", 
            typingSpeed: 0.05, startDelay: 1.6,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("confused", true);}
            }
        },
        {
            message: "To be honest I've got no clue...&&&&&&\nI just went to bed one night and woke up here...", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0; dialscript.eyes.animation.play("normal", true); __canAccept = false;
                (new FlxTimer()).start(.6, function () dialscript.eyes.animation.play("left", true));
            },
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("confused", true);}
                if (dialscript.isCharPhrase(char, "To be honest I've got no clue...&&&&&&\n")) dialscript.eyes.animation.play("normal", true);
            }
        },
        {
            message: "Hey,&&& since you're down here already...&&&&\nCan you get a hold of Nermal or Garfield for me?", 
            typingSpeed: 0.05, startDelay: 0.9,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("left", true);}
                if (dialscript.isCharPhrase(char, "Hey,&&& since you're down here already...&&&&\n")) dialscript.eyes.animation.play("confused", true);
            }
        },
        {
            message: "I've been trying to reach them for the longest time...&&&&\nBut they never seem to notice for some reason.&", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.eyes.animation.play("normal", true); __canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "I've been trying to reach them for the longest time...&&&&\n")) dialscript.eyes.animation.play("left", true);
            }
        }
        {
            message: "I'm still so thankful you came down here,&&&&& I finally have someone to talk to...", 
            typingSpeed: 0.054, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "I'm still so thankful you came down here,&&&&&")) dialscript.eyes.animation.play("left", true);
            }
        },
        {
            message: "Being locked up for awhile has made me a bit,...&&&& \nuh,& observant...", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("left", true);}
                if (dialscript.isCharPhrase(char, "Being locked up for awhile has made me a bit,...&&&& \n")) dialscript.eyes.animation.play("normal", true);
            }
        },
        {
            message: "Like why are you carrying a microphone with you???&&&\nWhat do you want to sing together or something???", 
            typingSpeed: 0.048, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int)
                if (char == 0) {dialscript.eyes.animation.play("confused", true);}
        },
        {
            message: "Reminds me of the other day...&&&&\nI think I heard a clown's voice somewhere...", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.showCloud(true); __canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("left", true);}
                if (dialscript.isCharPhrase(char, "Reminds me of the other day...&&&&\n")) dialscript.eyes.animation.play("normal", true);
            }
        },
        {
            message: "The clown was saying that a blue haired dwarf,&& and a delivery man,&& are going to stop a monsterous cat.", 
            typingSpeed: 0.055, startDelay: 2.1,
            onEnd: function () {},
            event: function (char:Int)
                if (char == 0) {dialscript.eyes.animation.play("confused", true);}
        },
        {
            message: "Yeah I know right!&&&\nBiggest lies I've ever heard...", 
            typingSpeed: 0.045, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "Yeah I know right!&&&\n")) dialscript.eyes.animation.play("smug", true);
            }
        },
        {
            message: "That clown is crazy...&&\nSo crazy that he hides his jokes???", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "That clown is crazy...&&\n")) dialscript.eyes.animation.play("confused", true);
            }
        },
        {
            message: "Why would a clown do that???&&&\nDoesn't that defeat the purpose of being funny???", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("smug", true);}
                if (dialscript.isCharPhrase(char, "Why would a clown do that???&&&\n")) dialscript.eyes.animation.play("left", true);
            }
        },
        {
            message: "He said he hid it behind a very particular painting...&&&&\nI still don't know where,&& he wasn't very specific.", 
            typingSpeed: 0.045, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "He said he hid it behind a very particular painting...&&&&\n")) dialscript.eyes.animation.play("confused", true);
            }
        },
        {
            message: "Find the joke for me,&&\nand I will reward you with an adventure&&.&.&.&&&&& Of finding more jokes...", 
            typingSpeed: 0.045, startDelay: 0,
            onEnd: function () {dialscript.showCloud(false); dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0; __canAccept = false;},
            event: function (char:Int){
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "Find the joke for me,&&\nand I will reward you with an adventure&&.&.&.&&&&&")) dialscript.eyes.animation.play("smug", true);
            }
        },
        {
            message: "Anyways,& thanks for visiting me.&&& \nOne more day down here,& and I would have went insane like that clown.", 
            typingSpeed: 0.045, startDelay: 1.5,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "Anyways,& thanks for visiting me.&&& \n")) dialscript.eyes.animation.play("left", true);
            }
        },
        {
            message: "Just please come back okay???&&&\nI don't want to end up losing my own sanity stuck in this wretched cage.", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "Just please come back okay???&&&\n")) dialscript.eyes.animation.play("left", true);
            }
        },
        {
            message: "And,&& If you can.&& Bring back the joke to me,&&\nit would be at least entertaining i'd hope.", 
            typingSpeed: 0.06, startDelay: 0,
            onEnd: function () {},
            event: function (char:Int) {
                if (char == 0) {dialscript.eyes.animation.play("normal", true);}
                if (dialscript.isCharPhrase(char, "And,&&If you can.&&Bring back the joke to me,&&\n")) dialscript.eyes.animation.play("smug", true);
            }
        }
    ];

    dialscript.endingCallback = function () {
        dialscript.fadeOut = dialscript.fastFirstFade = true; dialscript.blackTime = 0;
        dialscript.menuMusic.stop(); dialscript.introSound.volume = 0.3;
        dialscript.eyes.animation.play("normal", true);
        (new FlxTimer()).start(2/8, function () dialscript.introSound.play(), 8);
        (new FlxTimer()).start(2.2, function () {FlxG.switchState(new TitleState());});
    };
}

function postCreate() {
    dialscript.fastFirstFade = false; 
    dialscript.introSound = FlxG.sound.load(Paths.sound('easteregg/snd_test'), 0.4);
	(new FlxTimer()).start(4/8, function () dialscript.introSound.play(), 8);
	if (FlxG.save.data.arlenePhase == -1 || !FlxG.save.data.canVisitArlene) return;
	(new FlxTimer()).start(6.2, function () FlxG.sound.play(Paths.sound('easteregg/mus_sfx_cinematiccut'), 0.1));
	(new FlxTimer()).start(8, dialscript.progressDialogue);

    trace("ARELINE DIALOGUE PHASE 1 LOADED");
}