//
import StringTools;
import Xml;

var pizza:Character;

var finishedLoading:Bool = false;
var pressedEnter:Bool = false;

function create() {
    if (FlxG.sound.music != null) FlxG.sound.music.stop();
    FlxG.camera.alpha = 0;

    var path:String = "assets/songs/" + PlayState.SONG.meta.name.toLowerCase() + "/loadingscreen.json";
    var loadingData:Dynamic = {
        loadingbg: "loadingbg1",
        loadingimage: "rightloadingimage1",
        loadinganim: "BF 1",
        loadingpos: [561.46, -42.08]
    };

    if (Assets.exists(path)) loadingData = Json.parse(Assets.getText(path));
    else trace("LOADING SCREEN NOT FOUND!!!11 | PATH: " + path);
    
    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingscreens/' +loadingData.loadingbg));
    if (loadingData.loadingbg != 'loadingbg1' && loadingData.loadingbg != 'loadingbg2' && loadingData.loadingbg != 'loadingbg3')
        bg.scale.set(0.68, 0.68);
    bg.screenCenter();
    bg.antialiasing = true;
    add(bg);

    var portrait:FlxSprite = new FlxSprite();
    portrait.frames = Paths.getSparrowAtlas('loadingscreens/' + loadingData.loadingimage);
    portrait.animation.addByPrefix('idle', loadingData.loadinganim, 24, true);
    portrait.animation.play('idle');
    portrait.scale.set(0.68, 0.68);
    portrait.updateHitbox();
    portrait.setPosition(loadingData.loadingpos[0], loadingData.loadingpos[1]);
    portrait.antialiasing = true;
    add(portrait);

    pizza = new Character(0,0, "loading");
    pizza.updateHitbox();
    pizza.x = 0 - (pizza.width / 3.5) + 1;
    pizza.y = FlxG.height - (pizza.height + (pizza.height / 2)) - 2;
    add(pizza);
    pizza.playAnim('idle');

    FlxG.sound.play(Paths.sound("loadingsound"));

    new FlxTimer().start(1.5, (tmr:FlxTimer) -> {
		FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5, {onComplete: (tween:FlxTween) -> {loadAssets();}});
	});
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ESCAPE) 
        FlxG.switchState(new FreeplayState());
    if (FlxG.keys.justPressed.ENTER && finishedLoading && !pressedEnter) {goToSong(); pressedEnter = true;}
}

function loadAssets() { // GET BAMBOOZLED LLLLL YOU THOUGHT IT WAS ACUTTALY LOADING
    var timeToLoadalldat = 0;

    for (sprite in 0...FlxG.random.int(8, 14)) {
        timeToLoadalldat += FlxG.random.float(0.1, 0.225);
    }

    new FlxTimer().start(timeToLoadalldat, (tmr:FlxTimer) -> {
        pizza.playAnim('enter');
		pizza.animation.finishCallback = (name:String) -> {if (name == 'enter') {pizza.playAnim('enterloop'); finishedLoading = true;}};
	});
}

function goToSong() {
    FlxTween.tween(FlxG.camera, {alpha: 0}, 0.75, {onComplete: (tween:FlxTween) -> {FlxG.switchState(new PlayState());}});
}