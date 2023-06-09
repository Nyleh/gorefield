function onSelect(event) {
    event.cancel();
    
    Options.freeplayLastSong = songs[curSelected].name;
    Options.freeplayLastDifficulty = songs[curSelected].difficulties[curDifficulty];

    PlayState.loadSong(event.song, event.difficulty, event.opponentMode, event.coopMode);
    FlxG.switchState(new ModState("gorefield/LoadingScreen"));
}