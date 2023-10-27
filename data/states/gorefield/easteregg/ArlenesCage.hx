import flixel.util.FlxAxes;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import flixel.addons.text.FlxTypeText;

var canPress:Bool = false;
var wind:FlxSound;

var eyes:FlxSprite;

var text:FlxText;

function create()
{
    var bars:FlxSprite = new FlxSprite(0, 100);
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
    eyes.animation.add("eyes", [0, 1, 2, 3], 0, false);
    eyes.animation.play("eyes");
    eyes.scale.set(3.5, 3.5);
    eyes.updateHitbox();
    eyes.screenCenter(FlxAxes.X);
    eyes.y = bars.y + (bars.height - eyes.height) / 2;
    eyes.alpha = 0;
    eyes.antialiasing = false;
    add(eyes);

    FlxTween.tween(eyes, {alpha: 1}, 2.8, {
        onComplete: function(_) 
        {
            canPress = true;
        },
        startDelay: 0.8,
        ease: FlxEase.quadOut
    });

    // vertical eyes movement
    FlxTween.tween(eyes, {y: bars.y + 35}, 2, {
        onComplete: function(_) 
        {
            FlxTween.tween(eyes, {y: bars.y + bars.height - 35 - eyes.height}, 3, {
                onComplete: function(_) 
                {
                    FlxTween.tween(eyes, {y: bars.y + 35}, 3);
                },
                loopDelay: 3,
                type: FlxTween.LOOPING
            });
        },
        startDelay: 3.6,
    });

    add(bars);

    var box:FlxSprite = new FlxSprite(0, 370);
    box.makeGraphic(960, 250, FlxColor.WHITE);
    box.pixels.colorTransform(new Rectangle(5, 5, 950, 240), new ColorTransform(0, 0, 0, 1));
    box.screenCenter(FlxAxes.X);
    box.alpha = 0;
    add(box);

    text = new FlxText(0, box.y + 40, 930, "Test Text.");
    text.setFormat("fonts/pixelart.ttf", 30, 0xFFFFFFFF, "lefter");
    text.screenCenter(FlxAxes.X);
    text.alpha = 0;
    add(text);

    FlxTween.tween(box, {alpha: 1}, 2, {startDelay: 2});
    FlxTween.tween(text, {alpha: 1}, 2, {startDelay: 2});
}

function update(elapsed)
{
    if (controls.BACK)
        FlxG.switchState(new TitleState());

    if (!canPress)
        return;

    // Arlene's dialogues
    
}