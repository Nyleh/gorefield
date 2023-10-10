
import flixel.FlxObject;
import funkin.savedata.FunkinSave;
import funkin.backend.assets.AssetsLibraryList.AssetSource;

var canMove:Bool = true;

var menuOptions:Array<FlxSprite> = [];
var selector:FlxSprite;

var weeks:Array<Dynamic> = [];
var curWeek:Int = curStoryMenuSelected;

function create() {
    CoolUtil.playMenuSong();

    FlxG.camera.bgColor = FlxColor.fromRGB(17,5,33);
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
        //FlxTween.tween(sprite, {x: 322}, 1.5, {ease: FlxEase.circInOut, startDelay: 0.2 * i});
    }

    selector = new FlxSprite();
    selector.frames = Paths.getSparrowAtlas("menus/storymenu/STORY_MENU_ASSETS");
    selector.animation.addByPrefix("_", "SELECT");
    selector.animation.play("_");

    selector.updateHitbox();

    selector.alpha = 0;
    selector.angle = 90;
    add(selector);

    FlxTween.tween(selector, {angle: -90, alpha: 1}, 0.4, {ease: FlxEase.circInOut});

    changeWeek(0);
}

var __firstFrame = true;
var __totalTime:Float = 0;

function update(elapsed:Float) {
    __totalTime += elapsed;
    
    if (controls.BACK) {
        canMove = false;
        FlxG.sound.play(Paths.sound("menu/cancelMenu"));
        FlxG.switchState(new MainMenuState());
    }

    for (menuOption in menuOptions) {
        var y:Float = ((FlxG.height - menuOption.height) / 2) + ((menuOption.ID - curWeek) * menuOption.height);
        var x:Float = 50 - ((Math.abs(Math.cos((menuOption.y + (menuOption.height / 2) - (FlxG.camera.scroll.y + (FlxG.height / 2))) / (FlxG.height * 1.25) * Math.PI)) * 150));

        menuOption.y = __firstFrame ? y : CoolUtil.fpsLerp(menuOption.y, y, 0.25);
        menuOption.x = FlxG.width - menuOption.width + 50 + x;
    }
    __firstFrame = false;

    selector.setPosition((menuOptions[curWeek].x - selector.width - 36) + (-Math.abs(-20 * Math.sin(__totalTime * 0.8))), menuOptions[curWeek].y + ((menuOptions[curWeek].height/2) - (selector.height/2)));

    if (!canMove) return;

    if (controls.DOWN_P)
        changeWeek(1);
    else if (controls.UP_P)
        changeWeek(-1);

}

function changeWeek(amount:Int) {
    curWeek += amount;

    if (curWeek > menuOptions.length - 1) curWeek = 0;
    if (curWeek < 0) curWeek = menuOptions.length - 1;
    FlxG.sound.play(Paths.sound('menu/scrollMenu'));

    //trace(FunkinSave.getWeekHighscore(weeks[curWeek].name, weeks[curWeek].difficulties[curDifficulty]).score);
}

function onDestroy() {FlxG.camera.bgColor = FlxColor.fromRGB(0,0,0); curStoryMenuSelected = curWeek;}


// BOILER PLATE

public function getWeeksFromSource(weeks:Array<String>, source:AssetSource) {
    var path:String = Paths.txt('freeplaySonglist');
    var weeksFound:Array<String> = [];
    if (Paths.assetsTree.existsSpecific(path, "TEXT", source)) {
        var trim = "";
        weeksFound = CoolUtil.coolTextFile(Paths.txt('weeks/weeks'));
    } else {
        weeksFound = [for(c in Paths.getFolderContent('data/weeks/weeks/', false, source)) if (Path.extension(c).toLowerCase() == "xml") Path.withoutExtension(c)];
    }
    
    if (weeksFound.length > 0) {
        for(s in weeksFound)
            weeks.push(s);
        return false;
    }
    return true;
}