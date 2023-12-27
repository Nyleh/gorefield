import flixel.input.keyboard.FlxKeyList;

function create()
{
    var pixelScript = importScript("data/scripts/pixel-gorefield"); 
    pixelScript.set("noteType", "binky");

    stage.stageSprites["reference"].alpha = 0.5;
    stage.stageSprites["reference"].updateHitbox();
}

function update()
{
    moveSprite(boyfriend);
}

public static function moveSprite(sprite:flixel.FlxSprite) 
{
    if (sprite != null) 
    {
        var fnfKey:FlxKeyList;
        if (FlxG.keys.pressed.SHIFT)
            fnfKey = FlxG.keys.pressed;
        else
            fnfKey = FlxG.keys.justPressed;

        if (FlxG.keys.pressed.CONTROL &&
            (fnfKey.G || fnfKey.E || fnfKey.D || fnfKey.RIGHT || fnfKey.LEFT || fnfKey.UP || fnfKey.DOWN))
        {
            if (fnfKey.G)
                sprite.scale.set(sprite.scale.x + 1, sprite.scale.y + 1);
            if (fnfKey.E)
                sprite.scale.set(sprite.scale.x + 0.01, sprite.scale.y + 0.01);
            if (fnfKey.D)
                sprite.scale.set(sprite.scale.x - 0.01, sprite.scale.y - 0.01);
            if (fnfKey.RIGHT)
                sprite.x += 1;
            if (fnfKey.LEFT)
                sprite.x -= 1;
            if (fnfKey.UP)
                sprite.y -= 1;
            if (fnfKey.DOWN)
                sprite.y += 1;

            //sprite.updateHitbox();

            var traceText:String =
            'X: ' + sprite.x + ', ' +
            'Y: ' + sprite.y + ', ' +
            'Width: ' + sprite.width + ', ' +
            'Height: ' + sprite.height + ', ' +
            'ScaleX: ' + sprite.scale.x + ', ' +
            'ScaleY: ' + sprite.scale.y;

            trace(traceText);
        }
    }
}