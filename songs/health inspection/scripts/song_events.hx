import hxvlc.flixel.FlxVideo;
var video:FlxVideo;

function create() 
{
    gf.scrollFactor.set(1, 1);
    gf.visible = false;

    video = new FlxVideo();
	video.load(Assets.getPath(Paths.video("OH_NO_AGAIN")));
	video.onEndReached.add(
		function()
		{
			canPause = true;
			startedCountdown = true;

			startTimer = new FlxTimer();

			video.dispose();
		}
	); 
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 832:
            video.play();
        case 864:
            gf.visible = true;
            
            dad.x = -1200;
        case 870:
            FlxTween.tween(dad, { x: -500}, 1);
        case 1662:
            gf.visible = false;
    }
}