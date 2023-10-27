import flixel.util.FlxAxes;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import flixel.addons.text.FlxTypeText;

var wind:FlxSound;

var eyes:FlxSprite;

var dialoguetext:FlxTypeText;
var box:FlxSprite;
var bars:FlxSprite;

var black:FlxSprite;

var dialogueList:Array<Dynamic> = [];

function create()
{
    bars = new FlxSprite(0, 100);
    bars.loadGraphic(Paths.image("easteregg/Arlene_Box"));
    bars.scale.set(6, 6);
    bars.updateHitbox();
    bars.screenCenter(FlxAxes.X);

    FlxG.save.data.canVisitArlene = true; //This should be set to true when the credits video is shown -EstoyAburridow
	FlxG.sound.music.fadeOut(0.5);

	FlxG.sound.play(Paths.sound('easteregg/menu_clown'), 1, true);

    if (!FlxG.save.data.canVisitArlene)
    {
        add(bars);
        FlxG.sound.play(Paths.sound('easteregg/Wind_Sound'), 1, true);

        return;
    }

    eyes = new FlxSprite();
    eyes.loadGraphic(Paths.image("easteregg/Arlene_Eyes"), true, 80, 34);
    eyes.animation.add("normal", [0], 0);
    eyes.animation.add("left", [1], 0);
    eyes.animation.add("smug", [2], 0);
    eyes.animation.add("confused", [3], 0);
    eyes.animation.play("normal");
    eyes.scale.set(3.5, 3.5);
    eyes.updateHitbox();
    eyes.screenCenter(FlxAxes.X);
    eyes.y = bars.y + (bars.height - eyes.height) / 2;
    eyes.alpha = 0;
    eyes.antialiasing = false;
    add(eyes);

    add(bars);

    box = new FlxSprite(0, 370);
    box.makeGraphic(960, 250, FlxColor.WHITE);
    box.pixels.colorTransform(new Rectangle(5, 5, 950, 240), new ColorTransform(0, 0, 0, 1));
    box.screenCenter(FlxAxes.X);
    box.alpha = 0;
    add(box);

    dialoguetext = new FlxTypeText(0, box.y + 40, 930, "Test Text.");
    dialoguetext.setFormat("fonts/pixelart.ttf", 30, 0xFFFFFFFF, "lefter");
    dialoguetext.screenCenter(FlxAxes.X);
    dialoguetext.alpha = 0;
    dialoguetext.sounds = [FlxG.sound.load(Paths.sound('snd_text'), 0.6)];
    add(dialoguetext);

    black = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
    add(black);


    if(FlxG.random.bool(30)){
        dialogueList = [
            {message: "knock knock, who's there?", expression: "confused", speed: 0.07},
            {message: "chicken butt.", expression: "smug", speed: 0.04},
            {message: "HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAH!!!!!!", expression: "normal", speed: 0.02},
        ];
    }
    else if(FlxG.random.bool(50)){
        dialogueList = [
            {message: "one day my dialogue will be made properly.", expression: "normal", speed: 0.05},
            {message: "it'll be very fun to speak things that are actually canon!", expression: "normal", speed: 0.05},
            {message: "I hope at least.", expression: "smug", speed: 0.1}
        ];
    }
    else{
        dialogueList = [
            {message: "hihihi", expression: "normal", speed: 0.05},
            {message: "im like a pair of eyes", expression: "left", speed: 0.05},
            {message: "i think...", expression: "smug", speed: 0.1},
            {message: "right????", expression: "confused", speed: 0.07},
            {message: "whatever lol", expression: "normal", speed: 0.05}
        ];
    }
}

var dialogueStarted:Bool = false;
var dialogueEnded:Bool = false;
var isEnding:Bool = false;

var currentText:String = '';
var currentTime:Float = 0;
var currentEmotion:String = '';

function arleneDial(text:String,time:Float,emotion:String){ //show the cosmetic stuff
    dialogueEnded = false;
    dialoguetext.resetText(text);
    dialoguetext.alpha = 1;
    box.alpha = 1;
    dialoguetext.start(time);
    eyes.animation.play(emotion);
}

function nextDialogue(shift:Bool){ //get the next dialogue from the list
    if(shift) dialogueList.shift();

    for (dialogueArray in dialogueList){
        var text = dialogueArray.message;
        var time = dialogueArray.speed;
        var emotion = dialogueArray.expression;

        currentText = text;
        currentTime = time;
        currentEmotion = emotion;

        break;
    }
}

function startDialogue(){  //actually show the dialogue
    arleneDial(
        currentText != null ? currentText : '', 
        currentTime != null ? currentTime : 0, 
        currentEmotion != null ? currentEmotion : 'normal'
        );

    dialoguetext.completeCallback = function(){
        dialogueEnded = true;
    }
}

var tottalTime:Float = 0;

var finishFadeIn:Bool = false;
function update(elapsed) {
    tottalTime += elapsed;

    eyes.y = bars.y + ((bars.height/2)-(eyes.height/2)) + Math.floor(6 * Math.sin(tottalTime));
    black.alpha = FlxMath.bound(1 - (Math.floor((tottalTime/4) * 8) / 8), 0, 1);

    if (tottalTime >= 4) eyes.alpha = FlxMath.bound((Math.floor(((tottalTime-4)/2) * 8) / 8), 0, 1);

    if (controls.BACK)
        FlxG.switchState(new TitleState());


    // Arlene's dialogues

    if(!finishFadeIn && eyes.alpha == 1){
        finishFadeIn = true;
        nextDialogue(false);
        startDialogue();
        dialogueStarted = true;
    }

    if (FlxG.keys.justPressed.ANY && !controls.BACK && dialogueEnded && !isEnding)
        {
            nextDialogue(true);
            if (dialogueList[0] == null)
            {
                if (!isEnding)
                {
                    isEnding = true;
                    FlxG.switchState(new TitleState());
                }
            }
            else
            {
                startDialogue();
            }
        }
        else if (FlxG.keys.justPressed.ANY && !controls.BACK && dialogueStarted && !isEnding)
            dialoguetext.skip();
}