import hxvlc.flixel.FlxVideo;

var videos:Array<FlxVideo> = [];

function create() 
{
    for (path in ["OH_NO_AGAIN"])
    {
        video = new FlxVideo();
        video.load(Assets.getPath(Paths.video(path)));
        video.onEndReached.add(
            function()
            {
                canPause = true;
                startedCountdown = true;

                startTimer = new FlxTimer();
    
                videos[0].dispose();
                videos.shift();   

                FlxG.camera.flash(0xffD4DE8F);
            }
        );
        videos.push(video);
    }    

    gf.scrollFactor.set(1, 1);
    gf.visible = false;
}

function stepHit(step:Int) 
{
    switch (step) 
    {
        case 832:
            videos[0].play();
            canPause = false;
        case 864:
            gf.visible = true;
            
            dad.x = -1200;
        case 870:
            FlxTween.tween(dad, { x: -500}, 1);
        case 1662:
            gf.visible = false;
    }
}