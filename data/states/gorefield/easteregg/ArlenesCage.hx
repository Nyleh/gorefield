import flixel.util.FlxAxes;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;

var canPress:Bool = false;
var wind:FlxSound;

function create()
{
    var bars:FlxSprite = new FlxSprite(0, 120);
    bars.loadGraphic(Paths.image("easteregg/Arlene_Box"));
    bars.scale.set(4, 4);
    bars.updateHitbox();
    bars.screenCenter(FlxAxes.X);

    // FlxG.save.data.canVisitArlene = true; This should be set to true when the credits video is shown -EstoyAburridow

    if (!FlxG.save.data.canVisitArlene)
    {
        add(bars);
        FlxG.sound.music.fadeOut(0.5);
        FlxG.sound.play(Paths.sound('easteregg/Wind_Sound'), 1, true);

        return;
    }

    var eyes:FlxSprite = new FlxSprite(0, bars.y + 12);
    eyes.loadGraphic(Paths.image("easteregg/Arlene_Eyes"), true, 80, 34);
    eyes.animation.add("eyes", [0, 1, 2, 3], 0, false);
    eyes.animation.play("eyes");
    eyes.scale.set(3.5, 3.5);
    eyes.updateHitbox();
    eyes.screenCenter(FlxAxes.X);
    eyes.alpha = 0;
    add(eyes);

    FlxTween.tween(eyes, {alpha: 1}, 1.4, {
        onComplete: function(_) 
        {
            canPress = true;
        },
        startDelay: 0.4,
        ease: FlxEase.quadOut
    });

    add(bars);

    var box:FlxSprite = new FlxSprite(0, 370);
    box.makeGraphic(960, 250, FlxColor.WHITE);
    box.pixels.colorTransform(new Rectangle(5, 5, 950, 240),
        new ColorTransform(0, 0, 0, 1));
    box.screenCenter(FlxAxes.X);
    box.alpha = 0;
    add(box);

    FlxTween.tween(box, {alpha: 1}, 1, {startDelay: 1});
}

function update(elapsed)
{
    if (controls.BACK)
        FlxG.switchState(new TitleState());

    if (!canPress)
        return;

    // Arlene's dialogues
}