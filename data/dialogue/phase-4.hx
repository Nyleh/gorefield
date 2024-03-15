//

function create() {
    dialscript.menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
    dialscript.clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);

    // for future refernce, set this to the first portiat you want, THEN use switch portriat -lunar
    dialscript.cloudPortaitName = "Clown";

    dialscript.dialogueList = [
        {
            message_en: "Welcome back again...&&\nI think this is finally the last note!", 
            message_es: "spanish text here", 
            typingSpeed: 0.06, startDelay: 0,
            onEnd: function () {
                dialscript.wind.fadeOut(0.8);
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (count:Int){}  
        },
        {
            message_en: "You know the drill...&&\n%Let's read some more HILARIOUS jokes... ", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 1,
            onEnd: function () {
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;

                dialscript.showCloud(true);
            },
            event: function (count:Int){
                switch (count) {
                    case 0: dialscript.eyes.animation.play("smug", true);
                }
            }    
        },
        {
            message_en: "%'Blue balled boy,&& BLUE BALLED BOY!&&\nThis joke will have you &CRACKING!& UP!!!&& BHAHAAHAHA!!!'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 2,
            onEnd: function () {},
            event: function (count:Int){
                switch (count) {
                    case 0: 
                        dialscript.__randSounds = ["easteregg/snd_binky", "easteregg/snd_binky_2", "easteregg/snd_binky_3"];
                        dialscript.eyes.animation.play("normal", true);
                }
            }    
        },
        {
            message_en: "'What did the match &say to the firecraker?&& BOOM!!!!!&&& BAHHAHAHHAHAA!!!!!!!'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}    
        },
        {
            message_en: "'Also,& SORRY!!!!&& NO EXPLANATION THIS TIME!!!&&\nYour friend got a little &too annoying...'", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}    
        },
        {
            message_en: "'Turn the paper around for your clue,&&\nBLUE BALLED BOY!!& HEE HEE!'%", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch(count){
                    case 0: dialscript.__randSounds = ["easteregg/snd_text", "easteregg/snd_text_2"];
                }
            }    
        },
        {
            message_en: "Okay...&& He's acuttaly getting better the more he writes us jokes.", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}  
        },
        {
            message_en: "But still...&& These hints keep on getting more and more confusing...", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}    
        },
        {
            message_en: "This time it reads:&& ITS LUNAR THIS ISNT DONE!!!!&& BYE!!!!", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
                
                dialscript.showCloud(false);
            },
            event: function (count:Int){}  
        },
        {
            message_en: "%Either way,&& come back with a note or I'm just gonna repeat the same thing over and over...", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 2,
            onEnd: function () {},
            event: function (count:Int){
                switch (count) {
                    case 0: 
                        dialscript.wind.stop(); 
                        dialscript.menuMusic.play();
                }
            }  
        },
        {
            message_en: "Bye darling!", 
            message_es: "spanish text here", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}  
        }
    ];

    dialscript.endingCallback = function () {
        dialscript.fadeOut = dialscript.fastFirstFade = true; dialscript.blackTime = 0;
        dialscript.menuMusic.fadeOut(2); dialscript.introSound.volume = 0.3;
        dialscript.eyes.animation.play("normal", true);
        (new FlxTimer()).start(2/8, function () dialscript.introSound.play(), 8);
        (new FlxTimer()).start(2.2, function () {FlxG.switchState(new StoryMenuState()); FlxG.save.data.hasVisitedPhase = true;});
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