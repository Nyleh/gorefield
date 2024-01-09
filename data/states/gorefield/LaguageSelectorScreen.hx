import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;

var curSelected:Int = -1;
var selected_something:Bool = false;

var languages:Array<String> = ["English", "Espanol"];
var options:FlxTypedGroup<FlxSprite>;

var colowTwn:FlxTween;

var camBG:FlxCamera;

function create()
{
    FlxG.mouse.visible = FlxG.mouse.useSystemCursor = true;
    FlxG.cameras.remove(FlxG.camera, false);

    camBG = new FlxCamera(0, 0);
    for (cam in [camBG, FlxG.camera])
	{
        FlxG.cameras.add(cam, cam == FlxG.camera); 
        cam.bgColor = 0x00000000; 
        cam.antialiasing = true;
    }

    camBG.bgColor = FlxColor.fromRGB(17,5,33);

    var warpShader:CustomShader = new CustomShader("warp");
	warpShader.distortion = 0;
	if (FlxG.save.data.warp) FlxG.camera.addShader(warpShader);

	bgSprite = new FlxBackdrop(Paths.image("menus/WEA_ATRAS"), 0x11, 0, 0);
    bgSprite.cameras = [camBG];
	bgSprite.colorTransform.color = 0xFFFFFFFF;
	bgSprite.velocity.set(100, 100);
	add(bgSprite);

	colowTwn = FlxTween.color(null, 5.4, 0xFF90D141, 0xFFF09431, {ease: FlxEase.qaudInOut, type: 4 /*PINGPONG*/, onUpdate: function () {
		bgSprite.colorTransform.color = colowTwn.color;
	}});

    var bgShader:CustomShader = new CustomShader("warp");
	bgShader.distortion = 2;
	if (FlxG.save.data.warp) camBG.addShader(bgShader);

    var bloomShader:CustomShader = new CustomShader("glow");
	bloomShader.size = 18.0;
    bloomShader.dim = 1;
	if (FlxG.save.data.bloom) bgSprite.shader = bloomShader;

    options = new FlxTypedGroup();
    add(options);

    for (i => language in languages)
    {
        var option:FlxSprite = new FlxSprite(83 + i * 697);
        option.loadGraphic(Paths.image("menus/language/" + language.toUpperCase()));
        option.ID = i;
        option.screenCenter(FlxAxes.Y);
        option.antialiasing = true;
        option.alpha = 0.5;
        options.add(option);
        
        /* option.x = 640;
        if (i == 0)
            option.x -= 140 + option.width;
        else
            option.x += 140;
        trace("option: " + option); */
    }
}

function update(elapsed:Float)
{
    if (!selected_something)
    {
        if (FlxG.mouse.justMoved)
        {
            var overSomething:Bool = false;
            for (option in options)
            {
                if (FlxG.mouse.overlaps(option))
                {
                    overSomething = true;
                    changeItem(option.ID, true);
                }
            }

            if (!overSomething)
                changeItem(-1, true);
        }

        if (controls.RIGHT_P)
            changeItem(1, false);
        else if (controls.LEFT_P)
            changeItem(-1, false);

        if (curSelected != -1
            && ((FlxG.mouse.justPressed && FlxG.mouse.overlaps(options.members[curSelected]))
            || controls.ACCEPT))
        {
            FlxG.sound.play(Paths.sound('menu/confirmMenu'));

            FlxG.save.data.spanish = curSelected == 1;
            FlxG.save.flush();

            new FlxTimer().start(0.2, 
                function (tmr:FlxTimer) 
                {
                    FlxG.switchState(new ModState("gorefield/AlphaWarningScreen"));
                }
            );
        }
    }
}

function changeItem(change:Int, force:Bool)
{
    if (force && curSelected == change)
        return;

    FlxG.sound.play(Paths.sound("menu/scrollMenu"));

    if (curSelected != -1)
    {
        var prevText:FlxText = options.members[curSelected];
        prevText.alpha = 0.5;
    }

    if (force)
        curSelected = change;
    else
    {
        curSelected += change;

        if (curSelected >= options.members.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = options.members.length - 1;
    }

    if (curSelected != -1)
    {
        var curText:FlxText = options.members[curSelected];   
        curText.alpha = 1;
    }
}