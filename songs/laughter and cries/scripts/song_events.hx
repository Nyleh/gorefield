import hxvlc.flixel.FlxVideo;

var video:FlxVideo;

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
            stage.stageSprites["floor"].visible = stage.stageSprites["background"].visible = false;
            stage.stageSprites["light"].alpha = 1;

            snapCam();
        case 768:
            (new FlxTimer()).start((Conductor.stepCrochet / 1000) * 8, function () {
                devControlBotplay = !(player.cpu = false);
            });
    }
}