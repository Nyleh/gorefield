import flixel.input.keyboard.FlxKeyList;
import flixel.FlxG;

importScript("data/scripts/pixel-gorefield");

function create()
{
    var floorText:FlxText = new FlxText(0, 0, 0, 
        FlxG.save.data.spanish ?
        "Piso 2" :
        "Floor 2");
	floorText.setFormat("fonts/pixelart.ttf", 62, 0xFFD0DF8E, "center");
	floorText.screenCenter();
    floorText.scrollFactor.set();
    floorText.alpha = 0;
    add(floorText);
    
    camHUD.alpha = 0;

    // Countdown time is 1.8
    FlxTween.tween(floorText, {alpha: 1}, 0.5, {startDelay: 2.3});
    
    FlxTween.tween(camHUD, {alpha: 1}, 1.3, {startDelay: 3});
    FlxTween.tween(stage.stageSprites["nonblack"], {alpha: 0}, 1.3, {startDelay: 3});
    FlxTween.tween(floorText, {alpha: 0}, 1.3, {startDelay: 3});
}

function update()
{
    moveSprite(boyfriend, "Boyfriend", false);
}

function moveSprite(sprite:FlxSprite, ?id:String, ?updateHitbox:Bool = true) 
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
                sprite.setGraphicSize(Std.int(sprite.width + 100));
            if (fnfKey.E)
                sprite.setGraphicSize(Std.int(sprite.width + 1));
            if (fnfKey.D)
                sprite.setGraphicSize(Std.int(sprite.width - 1));
            if (fnfKey.RIGHT)
                sprite.x += 1;
            if (fnfKey.LEFT)
                sprite.x -= 1;
            if (fnfKey.UP)
                sprite.y -= 1;
            if (fnfKey.DOWN)
                sprite.y += 1;

            if (updateHitbox)
                sprite.updateHitbox();

            var traceText:String =
            ((id != null) ? 'ID: ' + id + ' ' : '') +
            'X: ' + sprite.x + ', ' +
            'Y: ' + sprite.y + ', ' +
            'Width: ' + sprite.width + ', ' +
            'Height: ' + sprite.height + ', ' +
            'ScaleX: ' + (sprite.width / sprite.frameWidth) + ', ' +
            'ScaleY: ' + (sprite.height / sprite.frameHeight);
            
            trace(traceText);
        }
    }
}