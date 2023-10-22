var preloadedFrames:Map<String, Dynamic> = [];

function create()
    for (event in PlayState.SONG.events) {
        var skin = event.params[0] == "gorefield" ? "default" : event.params[0];
        if (event.name == "Change Strum Skin" && !preloadedFrames.exists(skin))
            preloadedFrames.set(skin, Paths.getFrames("game/notes/" + skin));
    }


var strumAnimPrefix = ["left", "down", "up", "right"];
function onEvent(eventEvent)
    if (eventEvent.event.name == "Change Strum Skin") {
        var skin:String = eventEvent.event.params[0] == "gorefield" ? "default" : eventEvent.event.params[0];
        for (strumLine in strumLines)
            for (i => strum in strumLine.members) {
                var oldAnimName:String = strum.animation.name;
                var oldAnimFrame:Int = strum.animation?.curAnim?.curFrame;
                if (oldAnimFrame == null) oldAnimFrame = 0;

                strum.frames = preloadedFrames[skin];
                strum.animation.destroyAnimations();

                strum.animation.addByPrefix('static', 'arrow' + strumAnimPrefix[i % strumAnimPrefix.length].toUpperCase());
                strum.animation.addByPrefix('pressed', strumAnimPrefix[i % strumAnimPrefix.length] + ' press', 24, false);
                strum.animation.addByPrefix('confirm', strumAnimPrefix[i % strumAnimPrefix.length] + ' confirm', 24, false);
                strum.updateHitbox();

                strum.playAnim(oldAnimName, true);
                strum.animation?.curAnim?.curFrame = oldAnimFrame;
            }
    }