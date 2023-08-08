import flixel.text.FlxTextBorderStyle;
trace("ddd");

function create() {
    CoolUtil.playMenuSong(true);
    FlxG.camera.bgColor = FlxColor.fromRGB(17,5,33);

    var menuInfomation = new FlxText(0, 675, FlxG.width, "Press enter lool (i havent ported this part yet)", 28);
    menuInfomation.setFormat("fonts/pixelart.ttf", 28, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    menuInfomation.borderSize = 2;
    add(menuInfomation);
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ENTER) 
        FlxG.switchState(new MainMenuState());
}