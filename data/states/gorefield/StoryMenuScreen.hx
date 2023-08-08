
import flixel.FlxObject;

var canMove:Bool = true;

var menuOptions:Array<FlxSprite> = [];
var selector:FlxSprite;

var camFollow:FlxObject;
var __camFollowPos:FlxObject;

var selectorPos:FlxPoint;

var selectorDirection:String = "UP";
var curWeek:Int = 0;

function create() {
    FlxG.camera.bgColor = FlxColor.fromRGB(17,5,33);

    add(camFollow = new FlxObject(0, 0, 1, 1));
    add(__camFollowPos = new FlxObject(0, 0, 1, 1));

    FlxG.camera.follow(__camFollowPos, null, 1);
    FlxG.camera.antialiasing = true;

    for (i in 0...5) {
        var sprite:FlxSprite = new FlxSprite();
        sprite.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
        sprite.animation.addByPrefix("_", "STORY MENU 0" + Std.string(i + 1));
        sprite.animation.play("_");

        sprite.updateHitbox();
        sprite.offset.set();

        sprite.screenCenter("X");
        sprite.y = (sprite.height + 35) * i;

        sprite.ID = i;
        menuOptions.push(add(sprite));

        sprite.x -= 600;
        FlxTween.tween(sprite, {x: 322}, 1.5, {ease: FlxEase.circInOut, startDelay: 0.2 * i});
    }

    selector = new FlxSprite();
    selector.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
    selector.animation.addByPrefix("_", "SELECT");
    selector.animation.play("_");

    selector.updateHitbox();

    selector.alpha = 0;
    selector.angle = -90;
    add(selector);

    FlxTween.tween(selector, {angle: 90, alpha: 1}, 0.4, {ease: FlxEase.circInOut});

    selectorPos = FlxPoint.get(0, 0);
    changeWeek(0);

    selector.x = selectorPos.x; selector.x = selectorPos.y;
    __camFollowPos.x = camFollow.x; __camFollowPos.y = camFollow.y;
}

function update(elapsed:Float) {
    var lerpVal:Float = elapsed * 8;

    __camFollowPos.x = FlxMath.lerp(__camFollowPos.x, camFollow.x, lerpVal);
    __camFollowPos.y = FlxMath.lerp(__camFollowPos.y, camFollow.y, lerpVal);

    selector.setPosition(FlxMath.lerp(selector.x, selectorPos.x, lerpVal), FlxMath.lerp(selector.y, selectorPos.y, lerpVal));

    if (controls.BACK) {
        canMove = false;
        FlxG.sound.play(Paths.sound("menu/cancelMenu"));
        FlxG.switchState(new MainMenuState());
    }

    if (!canMove) return;

    if (controls.DOWN_P)
        changeWeek(1);
    else if (controls.UP_P)
        changeWeek(-1);

}

function changeWeek(amount:Int) {
    curWeek += amount;
    selectorDirection = amount > 0 ? "DOWN" : "UP";

    var blocked:Bool = (curWeek > menuOptions.length - 1) || (curWeek < 0);

    if (!blocked)
        FlxG.sound.play(Paths.sound('menu/scrollMenu'));

    if (curWeek > menuOptions.length - 1)
        curWeek = menuOptions.length - 1;
    if (curWeek < 0)
        curWeek = 0;

    camFollow.x = 640; // menuOptions[curWeek].x + (menuOptions[curWeek].width / 2)
    camFollow.y = menuOptions[curWeek].y + (menuOptions[curWeek].height / 2);

    camFollow.y += ((menuOptions[curWeek].height / 2) + (35 / 2)) * (selectorDirection == "UP" ? 1 : -1);

    // 955 because the options change in width alot
    selectorPos.set(995, (menuOptions[curWeek].y + (menuOptions[curWeek].height / 2)) - (selector.height / 2));

    for (option in menuOptions)
    {
        FlxTween.cancelTweensOf(option);

        if (option.ID == curWeek)
            FlxTween.tween(option, {x: 322 - 40}, 0.3, {ease: FlxEase.quadInOut});
        else if (option.x != 322)
            FlxTween.tween(option, {x: 322}, 0.2, {ease: FlxEase.circOut});
    }
}

function onDestroy() {FlxG.camera.bgColor = FlxColor.fromRGB(0,0,0);}