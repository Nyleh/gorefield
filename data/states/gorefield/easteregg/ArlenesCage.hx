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
var dialogueList:Array<{message:String, expression:String, typingSpeed:Float, startDelay:Float, event:Int->Void}> = [
    {
        message: "Hi guys welcome to the test dialogue...&&&&&&&&&&&&&ikr its really cool......", 
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
var endingCallback:Void->Void = function () {
    dialoguetext.alpha = 1;
    dialoguetext.text = "pretend she sent you to a cool song...\n(ESC to go back to title)";
};
var curDialogue:Int = -1;

var menuMusic:FlxSound;
var wind:FlxSound;
var introSound:FlxSound;

function create()
{
    Framerate.instance.visible = false;

	FlxG.sound.music.volume = 0;
    FlxG.save.data.canVisitArlene = true; //This should be set to true when the credits video is shown -EstoyAburridow

    bars = new FlxSprite(0, FlxG.height/6).loadGraphic(Paths.image("easteregg/Arlene_Box"));
    bars.scale.set(6, 6); bars.updateHitbox(); bars.screenCenter(FlxAxes.X);
    
    if (FlxG.save.data.canVisitArlene)
        menuMusic = FlxG.sound.load(Paths.sound('easteregg/menu_clown'), 1.0, true);
        
    wind = FlxG.sound.play(Paths.sound('easteregg/Wind_Sound'), 0, true);
    FlxTween.tween(wind, {volume: 1}, 6);
        
    eyes = new FlxSprite().loadGraphic(Paths.image("easteregg/Arlene_Eyes"), true, 80, 34);
    eyes.animation.add("normal", [0], 0); eyes.animation.add("left", [1], 0);
    eyes.animation.add("smug", [2], 0); eyes.animation.add("confused", [3], 0);
    eyes.animation.play("normal");
    eyes.alpha = 0; eyes.scale.set(3.5, 3.5); 
    eyes.updateHitbox(); eyes.screenCenter(FlxAxes.X);
    add(eyes); add(bars);

    box = new FlxSprite(0, (FlxG.height/6)*3).loadGraphic(Paths.image("easteregg/Arlene_Text"));
    box.scale.set(3.7,3.7); box.alpha = 0;
    box.updateHitbox(); box.screenCenter(FlxAxes.X);
    add(box);

    dialoguetext = new FlxText(box.x + 80, box.y + 70, box.width - 160, "", 24);
	dialoguetext.setFormat("fonts/pixelart.ttf", 48, 0xff8f93b7, "left", FlxTextBorderStyle.SHADOW, 0xFF19203F);
	dialoguetext.borderSize = 2; dialoguetext.shadowOffset.x += 1; dialoguetext.shadowOffset.y += 1; dialoguetext.wordWrap = true;
	add(dialoguetext);

    black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    add(black);

    for (member in members) {
        member.antialiasing = false;
        member.visible = member == bars || member == black ? true : FlxG.save.data.canVisitArlene;
    }

    introSound = FlxG.sound.load(Paths.sound('easteregg/snd_test'), 0.4);
    (new FlxTimer()).start(4/8, function () introSound.play(), 8);
    (new FlxTimer()).start(6.2, function () FlxG.sound.play(Paths.sound('easteregg/mus_sfx_cinematiccut'), 0.2));
    (new FlxTimer()).start(8, progressDialogue);
}

var tottalTime:Float = 0;
function update(elapsed) {
    tottalTime += elapsed;

    eyes.y = bars.y + ((bars.height/2)-(eyes.height/2)) + Math.floor(5 * Math.sin(tottalTime + (Math.PI/2)));
    black.alpha = FlxMath.bound(1 - (Math.floor((tottalTime/4) * 8) / 8), 0, 1);

    if (tottalTime >= 4) eyes.alpha = FlxMath.bound((Math.floor(((tottalTime-6)/2) * 8) / 8), 0, 1);

    if (controls.ACCEPT && __canAccept)
        progressDialogue();

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
        __curTxTIndx++; if (__curTxTIndx < __finishedMessage.length) __typeDialogue(time); else __curTxTIndx--;
    });
}

function onDestroy() Framerate.instance.visible = true;