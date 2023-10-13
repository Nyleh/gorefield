static var curMainMenuSelected:Int = 0;
static var curStoryMenuSelected:Int = 0;

static var redirectStates:Map<FlxState, String> = [
    TitleState => "gorefield/TitleScreen",
    MainMenuState => "gorefield/MainMenuScreen",
    StoryMenuState => "gorefield/StoryMenuScreen"

];

function preStateSwitch() {
    FlxG.camera.bgColor = 0xFF000000;
    for (redirectState in redirectStates.keys()) 
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function onDestroy() FlxG.camera.bgColor = 0xFF000000;