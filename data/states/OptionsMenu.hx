import funkin.backend.system.framerate.Framerate;

function postCreate() {
    var bg:FlxSprite = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.fromRGB(17,5,33));
    bg.scrollFactor.set(0,0);
    insert(1, bg); // 1 is right after bg WHICH IS NOT A VAR FOR SOME REASON!!!11

    var logoBl:FlxSprite = new FlxSprite(1020, 6);
	logoBl.frames = Paths.getSparrowAtlas('menus/logoMod');
	logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
	logoBl.animation.play('bump');
	logoBl.scale.set(0.3, 0.3);
    logoBl.scrollFactor.set(0,0);
	logoBl.updateHitbox();
	logoBl.antialiasing = true;
	add(logoBl);


	for (option in main.members)
		if (option.desc == "Modify mod options here")
			main.members.remove(option);
}

function update(elapsed:Float) {
	Framerate.offset.y = pathBG.height;
}