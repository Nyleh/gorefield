import flixel.addons.effects.FlxTrail;
import funkin.backend.shaders.CustomShader;

var jonTrail:FlxTrail;

var trailBloom:CustomShader;
public var particleShader:CustomShader; // yes it is a shader

public var isLymanFlying:Bool = true;

public function addTrail(){
    jonTrail.visible = jonTrail.active = true;
}

public function removeTrail(){
    jonTrail.visible = jonTrail.active = false;
}

function create() {
    jonTrail = new FlxTrail(dad, null, 4, 10, 0.4, 0.069);
    jonTrail.beforeCache = dad.beforeTrailCache;
    jonTrail.afterCache = () -> {
		dad.afterTrailCache();
        jonTrail.members[0].x += FlxG.random.float(-1, 4);
		jonTrail.members[0].y += FlxG.random.float(-1, 4);
	}
    jonTrail.color = 0xFFF200FF;

    trailBloom = new CustomShader("jonTrail");
    trailBloom.size = 18.0;// trailBloom.quality = 8.0;
    trailBloom.dim = 0.8;// trailBloom.directions = 16.0;
    trailBloom.sat = 1;

    for (trailSpr in jonTrail.members) {
        trailSpr.shader = trailBloom;
    }

    if (FlxG.save.data.trails) insert(members.indexOf(dad), jonTrail);

    particleShader = new CustomShader("bigotes_particles");
    particleShader.time = 0; particleShader.v = 0.0;
	particleShader.res = [FlxG.width, FlxG.height];
    FlxG.camera.addShader(particleShader);
}

var bgTween:FlxTween;

function measureHit(curMeasure:Int){
    stage.stageSprites["BIGOTESBG"].alpha = 1;
    bgTween = FlxTween.tween(stage.stageSprites["BIGOTESBG"],{alpha: 0.7},Conductor.stepCrochet/100);
}

function postCreate() {
    for (strum in cpuStrums) strum.visible = false;
}

function update(elapsed:Float) {
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));
    particleShader.time = _curBeat;

    if(!isLymanFlying) return;
    dad.y = 200 + (20 * Math.sin(_curBeat));
    dad.x = 1460 + (50 * Math.sin(_curBeat/2));

    trailBloom.sat = 1.2 + (.2 * Math.sin(_curBeat + ((Conductor.stepCrochet / 1000) * 16) + ((Conductor.stepCrochet / 1000))));
    for (i=>trail in jonTrail.members) {
        var scale = FlxMath.bound(1 + (.11 * Math.sin(_curBeat + (i * FlxG.random.float((Conductor.stepCrochet / 1000) * 0.5, (Conductor.stepCrochet / 1000) * 1.2)))), 0.9, 999);
        trail.scale.set(scale, scale);
    }
}

function onPlayerHit(event) {event.showRating = false; songScore += event.score;}