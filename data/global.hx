static var curMainMenuSelected:Int = 0;
static var curStoryMenuSelected:Int = 0;

static var redirectStates:Map<FlxState, String> = [
    TitleState => "gorefield/TitleScreen",
    MainMenuState => "gorefield/MainMenuScreen",
    StoryMenuState => "gorefield/StoryMenuScreen"

];

function new() {
    if (FlxG.save.data.mechanics == null) FlxG.save.data.mechanics = true;
    if (FlxG.save.data.shaders == null) FlxG.save.data.shaders = true;
    if (FlxG.save.data.trails == null) FlxG.save.data.trails = true;
    if (FlxG.save.data.flashing == null) FlxG.save.data.flashing = true;
    if (FlxG.save.data.dev == null) FlxG.save.data.dev = false;
}

function preStateSwitch() {
    FlxG.camera.bgColor = 0xFF000000;

    if (Std.isOfType(FlxG.state, PlayState) && Std.isOfType(FlxG.game._requestedState, PlayState) && PlayState.isStoryMode)
        {FlxG.switchState(new ModState("gorefield/LoadingScreen")); return;} // LOADING SCREENS IN STORY MODE - lunar

    for (redirectState in redirectStates.keys()) 
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function onDestroy() FlxG.camera.bgColor = 0xFF000000;