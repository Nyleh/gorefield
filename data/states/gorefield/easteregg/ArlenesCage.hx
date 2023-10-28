//
import flixel.util.FlxAxes;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import flixel.sound.FlxSound;
import funkin.backend.system.framerate.Framerate;
import flixel.text.FlxTextBorderStyle;

var box:FlxSprite;
var bars:FlxSprite;
var eyes:FlxSprite;
var black:FlxSprite;

var dialoguetext:FlxText;
var __curTxTIndx:Int = -1;
var __finishedMessage:String = "";
var __skippedText:Bool = false;
var __canAccept:Bool = false;

var __randSounds:Array<String> = ["easteregg/snd_text", "easteregg/snd_text_2"];
var dialogueList:Array<{message:String, expression:String, typingSpeed:Float, startDelay:Float, event:Int->Void}> = [];
var endingCallback:Void->Void = function () {
    dialoguetext.alpha = 1;
    dialoguetext.text = "END DIALOGUE PHASE 0\n(ESC to go back to title)";
};
var curDialogue:Int = -1;

var menuMusic:FlxSound;
var wind:FlxSound;
var introSound:FlxSound;

function create()
{
    Framerate.instance.visible = false;

	FlxG.sound.music.volume = 0;
    /**
     * Idea for this:
     * -1 cant visit (not there)
     * 0 first visit
     * 1 first dialogue after visit
     * 2 first note first found
     * 3 first note after found
     * 4 second note
     * 5 second note after found
     * 6 third note
     * 7 third note after found
     */
    FlxG.save.data.arlenePhase = 0;
    //FlxG.save.data.canVisitArlene = true;

    switch (FlxG.save.data.arlenePhase) {
        case 0: dialogueList = firstVisitDialogue;
    }

    bars = new FlxSprite(0, FlxG.height/6).loadGraphic(Paths.image("easteregg/Arlene_Box"));
    bars.scale.set(6, 6); bars.updateHitbox(); bars.screenCenter(FlxAxes.X);
    
    if (FlxG.save.data.arlenePhase != -1)
        menuMusic = FlxG.sound.load(Paths.sound('easteregg/menu_clown'), 1.0, true);
        
    wind = FlxG.sound.play(Paths.sound('easteregg/Wind_Sound'), 0, true);
    FlxTween.tween(wind, {volume: 1}, 6);
        
    eyes = new FlxSprite().loadGraphic(Paths.image("easteregg/Arlene_Eyes"), true, 80, 34);
    eyes.animation.add("normal", [0], 0); eyes.animation.add("left", [1], 0);
    eyes.animation.add("smug", [2], 0); eyes.animation.add("confused", [3], 0);
    eyes.animation.play("normal");
    eyes.alpha = 0; eyes.scale.set(3.5, 3.5); 
    eyes.updateHitbox(); eyes.screenCenter(FlxAxes.X);
    if (FlxG.save.data.arlenePhase != -1) add(eyes); add(bars);

    box = new FlxSprite(0, (FlxG.height/6)*3).loadGraphic(Paths.image("easteregg/Arlene_Text"));
    box.scale.set(3.7,3.7); box.alpha = 0;
    box.updateHitbox(); box.screenCenter(FlxAxes.X);
    add(box);

    dialoguetext = new FlxText(box.x + 80, box.y + 70, box.width - 160, "", 24);
	dialoguetext.setFormat("fonts/pixelart.ttf", 44, 0xff8f93b7, "left", FlxTextBorderStyle.SHADOW, 0xFF19203F);
	dialoguetext.borderSize = 2; dialoguetext.shadowOffset.x += 1; dialoguetext.shadowOffset.y += 1; dialoguetext.wordWrap = true;
	add(dialoguetext);

    black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    add(black);

    for (member in members) {
        member.antialiasing = false;
        member.visible = member == bars || member == black ? true : FlxG.save.data.canVisitArlene;
    }

    fastFirstFade = FlxG.save.data.arlenePhase >= 1;
    introSound = FlxG.sound.load(Paths.sound('easteregg/snd_test'), 0.4);
    (new FlxTimer()).start((FlxG.save.data.arlenePhase >= 1 ? 2 : 4)/8, function () introSound.play(), 8);
    if (FlxG.save.data.arlenePhase == -1 && FlxG.save.data.canVisitArlene) return;
    (new FlxTimer()).start(FlxG.save.data.arlenePhase >= 1 ? 4.2 : 6.2, function () FlxG.sound.play(Paths.sound('easteregg/mus_sfx_cinematiccut'), 0.2));
    (new FlxTimer()).start(FlxG.save.data.arlenePhase >= 1 ? 6 : 8, progressDialogue);
}

var fastFirstFade:Bool = false;
var tottalTime:Float = 0;
function update(elapsed) {
    tottalTime += elapsed;

    eyes.y = bars.y + ((bars.height/2)-(eyes.height/2)) + Math.floor(5 * Math.sin(tottalTime + (Math.PI/2)));
    black.alpha = FlxMath.bound(1 - (Math.floor(((tottalTime * (fastFirstFade ? 2 : 1))/4) * 8) / 8), 0, 1);

    if (tottalTime >= (fastFirstFade ? 2 : 4)) eyes.alpha = FlxMath.bound((Math.floor(((tottalTime-(fastFirstFade ? 4 : 6))/2) * 8) / 8), 0, 1);

    if (controls.ACCEPT && __canAccept) progressDialogue();

    if (controls.BACK) FlxG.switchState(new TitleState());
}

function progressDialogue() {
    if (__curTxTIndx != __finishedMessage.length-1) {__skippedText = true; return;}

    if (curDialogue++ >= dialogueList.length-1) {box.alpha = dialoguetext.alpha = 0; endingCallback(); __canAccept = false; return;}
    var dialogueData = dialogueList[curDialogue];

    __curTxTIndx = 0; __canAccept = true;
    dialoguetext.text = __finishedMessage = "";

    (new FlxTimer()).start(dialogueData.startDelay == null ? 0 : dialogueData.startDelay, function () {
        __finishedMessage = dialogueData.message;
        __typeDialogue(dialogueData.typingSpeed);
    });
}

function __typeDialogue(time:Float = 0) {
    box.alpha = 1;
    (new FlxTimer()).start(Math.max(0, time + FlxG.random.float(-0.005, 0.015)), function () {
        if (__skippedText) {
            __skippedText = false; dialoguetext.text = __finishedMessage;
            while (__curTxTIndx < __finishedMessage.length) {
                __curTxTIndx++; if (dialogueList[curDialogue].event != null) dialogueList[curDialogue].event(__curTxTIndx);
            }
            __curTxTIndx--; return;
        }

        if (__finishedMessage.charAt(__curTxTIndx) != "&") {
            FlxG.sound.play(Paths.sound(__randSounds[FlxG.random.int(0, __randSounds.length-1)]), 0.4 + FlxG.random.float(-0.1, 0.1));
        }
        dialoguetext.text += __finishedMessage.charAt(__curTxTIndx);
        if (dialogueList[curDialogue].event != null) dialogueList[curDialogue].event(__curTxTIndx);
        __curTxTIndx++; if (__curTxTIndx < __finishedMessage.length) {
            if (__finishedMessage.charAt(__curTxTIndx) != "&") __typeDialogue(time);
            else {(new FlxTimer()).start(0.15, function() __typeDialogue(time));}
        } else __curTxTIndx--;
    });
}

function isCharPhrase(char:Int, string:String)
    return char == string.length-1;

function onDestroy() Framerate.instance.visible = true;

var testingDialogue:Array<{message:String, expression:String, typingSpeed:Float, startDelay:Float, event:Int->Void}> = [
    {
        message: "LINE\nLINE\nLINE\nLINE\nLINE", 
        typingSpeed: 0.04, startDelay: 2,
        event: function (char:Int) {
            if (char == 0) {wind.stop(); menuMusic.play();}
            if (char == ("Hi guys welcome to the test dialogue...&&&&&&&&&&&&&").length-1)
                eyes.animation.play("smug", true);
        }
    },
    {
        message: "This is tottaly not too insipired off deltarune...&&&&&&&&&&&&&&&&&&&&&&&&&&&&&Thanks for asking.....",
        typingSpeed: 0.04, startDelay: 0.0,
        event: function (char:Int) {
            if (char == 0) eyes.animation.play("normal", true);
            if (char == ("This is tottaly not too insipired off deltarune...&&&&&&&&&&&&&&&&&&&&&&&&&&&&&").length-1)
                eyes.animation.play("left", true);
        }
    },
    {
        message: "Ok ill send you to a cool song now,&&&&&&&&&&&&&&& \nsee you later?\n&&&&&&&&&&&&&&&&&I guess.",
        typingSpeed: 0.04, startDelay: 0.0,
        event: function (char:Int) {
            if (char == 0) eyes.animation.play("normal", true);
            if (char == ("Ok ill send you to a cool song now,&&&&&&&&&&&&&&& ").length-1) eyes.animation.play("confused", true);
            if (char == ("Ok ill send you to a cool song now,&&&&&&&&&&&&&&& \nsee you later?\n&&&&&&&&&&&&&&&&&").length-1) eyes.animation.play("smug", true);
        }
    }
];

var firstVisitDialogue:Array<{message:String, expression:String, typingSpeed:Float, startDelay:Float, event:Int->Void}> = [
    {
        message: "Hello??? && Who are you??? &&&How did you get trapped down here???", 
        typingSpeed: 0.07, startDelay: 2,
        event: function (char:Int)
            if (char == 0) {wind.stop(); eyes.animation.play("confused", true);}
    },
    {
        message: "I mean you don't look trapped... &&&You look funny... &&&&&Are you from that stupid clown???", 
        typingSpeed: 0.055, startDelay: 0,
        event: function (char:Int) {
            if (isCharPhrase(char, "I mean you don't look trapped... &&&")) eyes.animation.play("left", true);
            if (isCharPhrase(char, "I mean you don't look trapped... &&&You look funny... &&&&&")) eyes.animation.play("smug", true);
        }
    },
    {
        message: "I'm sorry...,&&&  I'm Sorry. &&&\nI didn't mean it that way.", 
        typingSpeed: 0.05, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true); menuMusic.play();}
    },
    {
        message: "Guess being alone down here so long has made me a bit miserable...&&&&&", 
        typingSpeed: 0.05, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("smug", true);}
    },
    {
        message: "Hey,&&& since your down here already...&&&&\nCan you get a hold of nermal or garfield for me?", 
        typingSpeed: 0.05, startDelay: 0,
        event: function (char:Int) {
            if (char == 0) {eyes.animation.play("normal", true);}
            if (isCharPhrase(char, "Hey,&&& since your already down here...&&&&\n")) eyes.animation.play("confused", true);
        }
    },
    {
        message: "I've been trying to reaach them for the longest time...&&&&\nBut they never seem to notice for some reason.&", 
        typingSpeed: 0.05, startDelay: 0,
        event: function (char:Int) {
            if (char == 0) {eyes.animation.play("normal", true);}
            if (isCharPhrase(char, "I've been trying to reaach them for the longest time...&&&&\n")) eyes.animation.play("left", true);
            if (isCharPhrase(char, "I've been trying to reaach them for the longest time...&&&&\nBut they never seem to notice for some reason.&")) eyes.animation.play("normal", true);
        }
    },
    {
        message: "What?&&&& You dont feel like answering my question or something???&&&&&\nYou know it's rude to ignore someone...&", 
        typingSpeed: 0.035, startDelay: 1,
        event: function (char:Int) {
            if (char == 0) {eyes.animation.play("confused", true);}
            if (isCharPhrase(char, "What?&&&& You dont feel like answering my question or something???&&&&&\n")) eyes.animation.play("smug", true);
        }
    },
    {
        message: "Ehh it doesn't matter.&&&& I just really need someone to talk to...", 
        typingSpeed: 0.055, startDelay: 0,
        event: function (char:Int) {
            if (char == 0) {eyes.animation.play("normal", true);}
            if (isCharPhrase(char, "Ehh it doesn't matter.&&&&")) eyes.animation.play("left", true);
        }
    },
    {
        message: "I haven't had social interactions in a really long time...&&&&&\nIt's made me alot more observant to my sourrondings.", 
        typingSpeed: 0.046, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true);}
    },
    {
        message: "Like why are you carrying a microphone with you???&&&\nWhat do you want to sing together or something???", 
        typingSpeed: 0.04, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("confused", true);}
    },
    {
        message: "Reminds me of the other day...&&&&\nOk so listen.", 
        typingSpeed: 0.05, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("left", true);}

    },
    {
        message: "The clown was saying that a blue haired dwarf,&& and a delivery man are going to stop a monsterous cat.", 
        typingSpeed: 0.04, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true);}

    },
    {
        message: "Yeah I know right!&&&\nBiggest lies I've ever heard...", 
        typingSpeed: 0.035, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true);}
    },
    {
        message: "That clown is crazy...&&\nSo crazy that he hides his jokes???", 
        typingSpeed: 0.035, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true);}
    },
    {
        message: "Why would a clown do that???&&& Doesn't that defeat the purpose of being funny???", 
        typingSpeed: 0.035, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("smug", true);}
    },
    {
        message: "He said he hid it behind a very particular painting...\nI'm still not sure why but I'm sure the clown has his reasons", 
        typingSpeed: 0.045, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true);}
    },
    {
        message: "Find the joke for me,\nand I will reward you with a adventure.", 
        typingSpeed: 0.045, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true);}
    },
    {
        message: "Thanks for talking to me.&&&\nI was one step away from becoming the unstable clown.", 
        typingSpeed: 0.045, startDelay: 0,
        event: function (char:Int)
            if (char == 0) {eyes.animation.play("normal", true);}
    },
];