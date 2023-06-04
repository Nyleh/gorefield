import flixel.addons.effects.FlxTrail;
import funkin.backend.shaders.CustomShader;

var jonTrail:FlxTrail;
var trailBloom:CustomShader;

function create() {
    jonTrail = new FlxTrail(dad, null, 4, 10, 0.4, 0.069);
    jonTrail.color = 0xFFF200FF;

    trailBloom = new CustomShader("glow");
    trailBloom.size = 18.0; trailBloom.quality = 8.0;
    trailBloom.dim = 0.8; trailBloom.directions = 16.0;

    for (trailSpr in jonTrail.members) {
        trailSpr.shader = trailBloom;
        trailSpr.animation.callback = (name:String, frameNumber:Int, frameIndex:Int) -> {
            if (dad != null && dad.animOffsets.exists(trailSpr.animation.name)) 
                trailSpr.offset.set(dad.animOffsets[trailSpr.animation.name].x, dad.animOffsets[trailSpr.animation.name].y);
        };
    }

    insert(members.indexOf(dad), jonTrail);
}