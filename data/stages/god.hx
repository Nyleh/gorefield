import flixel.addons.effects.FlxTrail;
import funkin.backend.shaders.CustomShader;

public var jonTrail:FlxTrail;
var bloom:CustomShader;
var drunk:CustomShader;
var chromatic:CustomShader;
var warpShader:CustomShader;
var particleShader:CustomShader;

function create() {
    comboGroup.x += 300;
    comboGroup.y += 300;

    jonTrail = new FlxTrail(dad, null, 4, 10, 0.3, 0.0052);
    jonTrail.beforeCache = dad.beforeTrailCache;
    jonTrail.afterCache = () -> {
		dad.afterTrailCache();
        jonTrail.members[0].x += FlxG.random.float(-1, 4);
		jonTrail.members[0].y += FlxG.random.float(-1, 4);
	}
    jonTrail.color = 0xFFB3B1D8;
    if (FlxG.save.data.trails) insert(members.indexOf(dad), jonTrail);

    particleShader = new CustomShader("particles");
    particleShader.time = 0; particleShader.particlealpha = 1;
	particleShader.res = [FlxG.width, FlxG.height];
    particleShader.particleXY = [0, 0];
    particleShader.particleColor = [.7,.7,.7];
    particleShader.particleDirection = [-1, 0];
    particleShader.particleZoom = .2; particleShader.layers = 10;
    if (FlxG.save.data.particles) FlxG.camera.addShader(particleShader);

    bloom = new CustomShader("glow");
    bloom.size = 8.0; bloom.dim = 1.8;
    FlxG.camera.addShader(bloom);

    drunk = new CustomShader("drunk");
    drunk.strength = .35; drunk.time = 0;
    FlxG.camera.addShader(drunk);

    chromatic = new CustomShader("chromaticWarp");
    chromatic.distortion = 0.2; 
    if (FlxG.save.data.warp) FlxG.camera.addShader(chromatic);

    warpShader = new CustomShader("warp");
    warpShader.distortion = .3;
    if (FlxG.save.data.warp) camGame.addShader(warpShader);

    stage.stageSprites["black_overlay"].cameras = [camHUD];
}

function update(elapsed:Float){
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));
    dad.y = 400 + (40 * FlxMath.fastSin(_curBeat*0.8));
    drunk.time = _curBeat/2;
    particleShader.time = _curBeat;

    for (i=>trail in jonTrail.members) {
        var scale = FlxMath.bound(1.5 + (.2 * FlxMath.fastSin((_curBeat/4) + (i * FlxG.random.float((Conductor.stepCrochet / 1000) * 0.5, (Conductor.stepCrochet / 1000) * 1.2)))), 0.9, 999);
        trail.scale.set(scale, scale);
    }
    particleShader.particleZoom = .2 * (3*FlxG.camera.zoom);
}

function destroy() {FlxG.game.setFilters([]);}