import hxvlc.flixel.FlxVideo;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxAxes;

var video:FlxVideo;

var dadBackdrop:FlxBackdrop;

function create() {
    video = new FlxVideo();
    video.load(Assets.getPath(Paths.video("BinkyLaugh")));
    video.onEndReached.add(
        function()
        {
            canPause = true;
            startedCountdown = true;

            startTimer = new FlxTimer();

            video.dispose();

            FlxG.camera.flash(0xff000000);
        }
    );

    dadBackdrop = new FlxBackdrop(null, FlxAxes.X);
    dadBackdrop.setPosition(dad.x, dad.y + 120);
    dadBackdrop.frames = Paths.getSparrowAtlas("characters/Binky_alt");
    dadBackdrop.scale.set(0.65, 0.65);
    dadBackdrop.velocity.x -= 500;
    dadBackdrop.visible = dadBackdrop.active = false;
    insert(members.indexOf(boyfriend), dadBackdrop);
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 752:
            devControlBotplay = !(player.cpu = true);
            video.play();
            canPause = false;
        case 760:
            cpuStrums.visible = false;

            for (sprite in ["floor", "background", "light"])
                stage.stageSprites[sprite].visible = stage.stageSprites[sprite].active = sprite == "light";

            snapCam();
        case 761:
            for (spr in [gorefieldhealthBarBG, gorefieldhealthBar, gorefieldiconP1, gorefieldiconP2, scoreTxt, missesTxt, accuracyTxt])
                spr.alpha = 0.3;

            dadBackdrop.visible = dadBackdrop.active = true;

            dad.alpha = 0;
            dad.fixChar(true);
        case 768:
            (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 8, function () {
                devControlBotplay = !(player.cpu = false);
            });
    }
}

function update(elapsed:Float)
{
    if (dadBackdrop == null || !dadBackdrop.active)
        return;

    dadBackdrop.animation.addByPrefix("b", dad.animation.frameName, 1, true);
    dadBackdrop.animation.play("b", true);
    
    dadBackdrop.frameOffset = dad.frameOffset;
}