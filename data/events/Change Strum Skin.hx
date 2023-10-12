var preloadedFrames:Map<String, Dynamic> = [];

function create()
    for (event in PlayState.SONG.events)
        if (event.name == "Change Strum Skin" && !preloadedFrames.exists(event.params[0]))
            preloadedFrames.set(event.params[0], Paths.getFrames("game/notes/" + event.params[0]));

var strumAnimPrefix = ["left", "down", "up", "right"];
function onEvent(eventEvent)
    if (eventEvent.event.name == "Change Strum Skin")
        for (strumLine in strumLines)
            for (i => strum in strumLine.members) {
                var oldAnimName:String = strum.animation.name;
                var oldAnimFrame:Int = strum.animation?.curAnim?.curFrame;
                if (oldAnimFrame == null) oldAnimFrame = 0;

                strum.frames = preloadedFrames[eventEvent.event.params[0]];
                strum.animation.destroyAnimations();

                strum.animation.addByPrefix('static', 'arrow' + strumAnimPrefix[i % strumAnimPrefix.length].toUpperCase());
                strum.animation.addByPrefix('pressed', strumAnimPrefix[i % strumAnimPrefix.length] + ' press', 24, false);
                strum.animation.addByPrefix('confirm', strumAnimPrefix[i % strumAnimPrefix.length] + ' confirm', 24, false);
                strum.updateHitbox();

                strum.playAnim(oldAnimName, true);
                strum.animation?.curAnim?.curFrame = oldAnimFrame;
            }