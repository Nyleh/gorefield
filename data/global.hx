import funkin.game.GameOverSubstate;
import funkin.menus.PauseSubState;

import funkin.backend.utils.WindowUtils;
import openfl.Lib;

static var curMainMenuSelected:Int = 0;
static var curStoryMenuSelected:Int = 0;

static var seenMenuCutscene:Bool = false;

static var redirectStates:Map<FlxState, String> = [
    TitleState => "gorefield/TitleScreen",
    MainMenuState => "gorefield/MainMenuScreen",
    FreeplayState => "gorefield/StoryMenuScreen"
    StoryMenuState => "gorefield/StoryMenuScreen",
];

function new() {
    // MECHANICS
    if (FlxG.save.data.baby == null) FlxG.save.data.baby = false;
    if (FlxG.save.data.ps_hard == null) FlxG.save.data.ps_hard = false;
    if (FlxG.save.data.scare_hard == null) FlxG.save.data.scare_hard = false;
    if (FlxG.save.data.blue_hard == null) FlxG.save.data.blue_hard = false;
    if (FlxG.save.data.orange_hard == null) FlxG.save.data.orange_hard = false;

    // VISUALS
    if (FlxG.save.data.bloom == null) FlxG.save.data.bloom = true;
    if (FlxG.save.data.glitch == null) FlxG.save.data.glitch = true;
    if (FlxG.save.data.warp == null) FlxG.save.data.warp = true;
    if (FlxG.save.data.wrath == null) FlxG.save.data.wrath = true;
    if (FlxG.save.data.heatwave == null) FlxG.save.data.heatwave = true;
    if (FlxG.save.data.static == null) FlxG.save.data.static = true;
    if (FlxG.save.data.drunk == null) FlxG.save.data.drunk = true;

    if (FlxG.save.data.drunk == null) FlxG.save.data.drunk = true;
    if (FlxG.save.data.saturation == null) FlxG.save.data.saturation = true;

    if (FlxG.save.data.trails == null) FlxG.save.data.trails = true;
    if (FlxG.save.data.particles == null) FlxG.save.data.particles = true;
    if (FlxG.save.data.flashing == null) FlxG.save.data.flashing = true;

    // EASTER EGG
    if (FlxG.save.data.canVisitArlene == null) FlxG.save.data.canVisitArlene = false;

    // OTHER
    if (FlxG.save.data.spanish == null) FlxG.save.data.spanish = false;
    if (FlxG.save.data.dev == null) FlxG.save.data.dev = false;
}

function preStateSwitch() {
    WindowUtils.resetTitle();
    FlxG.camera.bgColor = 0xFF000000;

    if (Std.isOfType(FlxG.state, PlayState) && (FlxG.state.subState == null ? true : !Std.isOfType(FlxG.state.subState, GameOverSubstate) && !Std.isOfType(FlxG.state.subState, PauseSubState)) // ! CHECK IN GAME/NOT IN GAME OVER
        && Std.isOfType(FlxG.game._requestedState, PlayState) && PlayState.isStoryMode && !skipLoadingScreen) // ! CHECK STORY MODE/ GOING TO OTHER SONG
        {FlxG.switchState(new ModState("gorefield/LoadingScreen")); return;} // LOADING SCREEN

    for (redirectState in redirectStates.keys()) 
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function onDestroy() FlxG.camera.bgColor = 0xFF000000;