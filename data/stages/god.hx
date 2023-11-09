import flixel.addons.effects.FlxTrail;
import funkin.backend.shaders.CustomShader;

public var jonTrail:FlxTrail;

function create() {
    comboGroup.x += 300;
    comboGroup.y += 300;

    jonTrail = new FlxTrail(dad, null, 4, 8, 0.3, 0.0052);
    jonTrail.beforeCache = dad.beforeTrailCache;
    jonTrail.afterCache = () -> {
		dad.afterTrailCache();
        jonTrail.members[0].x += FlxG.random.float(-1, 4);
		jonTrail.members[0].y += FlxG.random.float(-1, 4);
	}
    jonTrail.color = 0xFFB3B1D8;
    if (FlxG.save.data.trails) insert(members.indexOf(dad), jonTrail);
}

function update(elapsed:Float){
    var _curBeat:Float = ((Conductor.songPosition / 1000) * (Conductor.bpm / 60) + ((Conductor.stepCrochet / 1000) * 16));
    dad.y = 400 + (40 * FlxMath.fastSin(_curBeat*0.8));

    for (i=>trail in jonTrail.members) {
        var scale = FlxMath.bound(1.5 + (.11 * FlxMath.fastSin(_curBeat + (i * FlxG.random.float((Conductor.stepCrochet / 1000) * 0.5, (Conductor.stepCrochet / 1000) * 1.2)))), 0.9, 999);
        trail.scale.set(scale, scale);
    }
}