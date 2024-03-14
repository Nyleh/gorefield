//

function create() {
    dialscript.menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
    dialscript.clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);

    // for future refernce, set this to the first portiat you want, THEN use switch portriat -lunar
    dialscript.cloudPortaitName = "Clown";

    dialscript.dialogueList = [
        {
            message_en: "Welcome back little dwarf...", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "%What's that in your hand...?&&&\nIs that the note?", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("confused", true);
                }
            }
        },
        {
            message_en: "%Alright,& hand it over...&&\nI don't want to waste too much of your time...", 
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
            message_en: "%Huh,& this joke is really confusing...", 
            message_es: "spanish text here", 
            typingSpeed: 0.055, startDelay: .2,
            onEnd: function () {
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;

                dialscript.wind.fadeOut(0.8);
                dialscript.showCloud(true);

            },
            event: function (count:Int) {
                switch (count) {
                    case 0:
                        dialscript.eyes.animation.play("confused", true);
                        dialscript.wind.stop();
                }
            }
        },
        {
            message_en: "%'BLUE HAIRED BOY,&& BLUE HAIRED BOY!&& \nYour gonna be SLEIGHED out of your seat when you hear this joke!!!'",
            message_es: "spanish text here",
            typingSpeed: 0.05, startDelay: 2,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0:
                        dialscript.__randSounds = ["easteregg/snd_binky", "easteregg/snd_binky_2", "easteregg/snd_binky_3"];

                        dialscript.wind.stop();
                        dialscript.eyes.animation.play("normal", true);
                }
            }
        },
        {
            message_en: "'What did the penguin say to the pine tree?&&\nDON'T START,& YOUR SLIDING!!!!!'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'HAHAHAHAHAHA!!!!& I am the best joke writer in the world!!!'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'Not only that!& I am the most uplifting person in the world!!!'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'Like this one time,& I saw this poor gray cat in a alley way...&&\nIN THE MIDDLE OF A THUNDERSTORM!'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'and the cats poor friend...&& they looked like they were crying for hours...'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'SO I LEFT THEM A JOKE TO CHEER THEM UP!!!!'", 
            message_es: "spanish text here", 
            typingSpeed: 0.045, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'Anyway,& that's all little blue haired boy.&& \nI left your clue on the back...'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.clownTheme.fadeOut(0.8);
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (count:Int){}
        },
        {
            message_en: "%Alright well...&% that was surely something...", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: .8,
            onEnd: function () {
                dialscript.menuMusic.play();
                dialscript.menuMusic.fadeIn(0.8);

                dialscript.switchPortrait(.5, "Note_Green");

                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.__randSounds = ["easteregg/snd_text", "easteregg/snd_text_2"];
                    case 1: dialscript.eyes.animation.play("smug", true);
                }
            }
        },
        {
            message_en: "%Wow.& He left a explation for the joke again.&&\nI think he knows we can't understand his jokes...", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 1,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("normal", true);
                }
            }
        },
        {
            message_en: "It reads:& %'Get it?& Because when you cut a pine tree,& it slides like a penguin!&& BAHHAHAHHA!!!!'%", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.__randSounds = ["easteregg/snd_binky", "easteregg/snd_binky_2", "easteregg/snd_binky_3"];
                    case 1: dialscript.__randSounds = ["easteregg/snd_text", "easteregg/snd_text_2"];
                }
            }
        },
        {
            message_en: "Ok,& that one kinda made me chuckle...", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;

                dialscript.showCloud(false);
            },
            event: function (count:Int) {}
        },
        {
            message_en: "I have a gut feeling that those two cats are too dumb to find that note...", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 2,
            onEnd: function () {},
            event: function (count:Int) {}
        },
        {
            message_en: "So your probably gonna have to find the note inside a rainy alleyway.", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {}
        },
        {
            message_en: "Find it& and bring it here so I can read it.&&\nPlease come back soon...", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {}
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