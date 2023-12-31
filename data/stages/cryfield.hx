//
import funkin.game.ComboRating;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;
import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;


var heatWaveShader:CustomShader;
public var rain:FlxBackdrop;
public var rain2:FlxBackdrop;

var maxMisses:Int = 4;
function create() 
{
    comboGroup.x += 300;
    comboGroup.y += 300;

    gameOverSong = "gameOvers/cryfield/Gorefield_Gameover_Cryfield";
	retrySFX = "gameOvers/cryfield/Continue";

	rain = new FlxBackdrop(Paths.image("stages/cryfield/lluvia_2"), 0x11, 0, -10);
	rain.velocity.set(-80, 1200);
    rain2 = new FlxBackdrop(Paths.image("stages/cryfield/lluvia"), 0x11, 0, -10);
	rain2.velocity.set(-80, 1200);
    rain2.visible = false;

    rain.alpha = rain2.alpha = 0.2;
    remove(stage.stageSprites["black_overlay"]);
	add(rain);
    add(rain2);
    add(stage.stageSprites["black_overlay"]);

    if (PlayState.instance.SONG.meta.name == 'Nocturnal Meow')
    {
        maxMisses = 12;

        stage.stageSprites["BG_C"].color = 0xFF7C7C7C;

        for (char in [boyfriend, dad]) 
        {
            var newShader = new CustomShader("wrath");
            newShader.uDirection = 45;
            newShader.uOverlayOpacity = 0.5;
            newShader.uDistance = 30.;
            newShader.uChoke = 20.;
            newShader.uPower = char == dad ? .2 : .7;
        
            newShader.uShadeColor = [219 / 255, 106 / 255, 104 / 255];
            newShader.uOverlayColor = [41 / 255, 8 / 255, 33 / 255];
        
            var uv = char.frame.uv;
            newShader.applyRect = [uv.x, uv.y, uv.width, uv.height];

            if (FlxG.save.data.wrath) char.shader = newShader;
        }
        rain.velocity.set(-80, 1700);
    }

    heatWaveShader = new CustomShader("heatwave");
    heatWaveShader.time = 0; heatWaveShader.speed = 10; 
    heatWaveShader.strength = 1.38; 

    if (FlxG.save.data.heatwave) rain.shader = heatWaveShader;

    comboRatings = [
		new ComboRating(0, "F", 0xFF941616),
		new ComboRating(0.5, "E", 0xFFCF1414),
		new ComboRating(0.7, "D", 0xFFFFAA44),
		new ComboRating(0.8, "C", 0xFFFFA02D),
		new ComboRating(0.85, "B", 0xFFFE8503),
		new ComboRating(0.9, "A", 0xFF933AB6),
		new ComboRating(0.95, "S", 0xFFB11EEA),
		new ComboRating(1, "S++", 0xFFC63BFD),
	];

    scripts.getByName("ui_healthbar.hx").call("disableScript");
}

var tottalTime:Float = 0;
function update(elapsed:Float){
    tottalTime += elapsed;
    heatWaveShader.time = tottalTime;

    //moveSprite(gorefieldhealthBar);
}

function draw(e) {
	for (char in [boyfriend, dad]) 
    {
        if (char.shader == null) continue;

        var uv = char.frame.uv;
        char.shader.applyRect = [uv.x, uv.y, uv.width, uv.height];
    }
}

function createHealthbar()
{
    for (sprite in [healthBar, healthBarBG, iconP1, iconP2]) 
        remove(sprite);

    gorefieldhealthBarBG = new FlxSprite(1177);
    gorefieldhealthBarBG.loadGraphic(Paths.image("game/healthbar/CONVENCIMIENTO_BAR"));
    gorefieldhealthBarBG.screenCenter(FlxAxes.Y);
    add(gorefieldhealthBarBG);

    gorefieldhealthBar = new FlxBar(1216, 176, FlxBarFillDirection.TOP_TO_BOTTOM, 19, 384, PlayState.instance, "misses", 0, maxMisses);
    gorefieldhealthBar.createImageBar(Paths.image("game/healthbar/C_BAR"), Paths.image("game/healthbar/C_NO_BAR"));
    add(gorefieldhealthBar);

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar])
    {
        spr.cameras = [camHUD]; 
        spr.antialiasing = true;
        spr.scrollFactor.set();
    }

    for (newIcon in 0...2) 
    {
        var icon = createIcon(newIcon == 1 ? boyfriend : dad);
        icon.x = 1181;
        switch (newIcon) 
        {
            case 1: 
                gorefieldiconP1 = icon;
                gorefieldiconP1.y = 587;
            case 0: 
                gorefieldiconP2 = icon;
                gorefieldiconP2.y = 52;
                gorefieldiconP2.flipX = true;
                if (PlayState.instance.SONG.meta.name == 'Nocturnal Meow')
                    gorefieldiconP2.setPosition(1165, 3);
        }
        icon.scale.set(0.75, 0.75);
        icon.updateHitbox();
        add(icon);
    }
}

function onPlayerMiss(event)
{
    PlayState.instance.health = 2;
    var totalMisses:Int = PlayState.instance.misses + event.misses;

    if (totalMisses >= maxMisses)
        PlayState.instance.health = 0;

    if (totalMisses >= maxMisses / 2)
        for (icon in [gorefieldiconP1, gorefieldiconP2])
            icon.animation.play("losing", true);
}

function postCreate()
{
    createHealthbar();

    if (PlayState.instance.SONG.meta.name == 'Nocturnal Meow')
    {
        dad.setPosition(300,0);
        boyfriend.setPosition(1450,600);
        defaultCamZoom = 1;
        strumLineDadZoom = 0.8;
        strumLineBfZoom = 1.5;
        snapCam();
    }
}