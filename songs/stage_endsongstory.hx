import StringTools;

function onSongEnd(){
    if(PlayState.isStoryMode){
        switch(PlayState.instance.SONG.meta.name.toLowerCase()){
            case 'bigotes':
                if(FlxG.save.data.beatWeekG1) return;

                FlxG.save.data.beatWeekG1 = true;
                FlxG.save.data.weeksFinished = [true, false, false, false, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, false, false, false, false, false, false];
                trace("BEAT WEEK 1");
            case 'health inspection':
                if(FlxG.save.data.beatWeekG2) return;

                FlxG.save.data.beatWeekG2 = true;
                FlxG.save.data.weeksFinished = [true, true, false, false, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, false, false, false, false, false];
                trace("BEAT WEEK 2");           
            case 'ultra field':
                if(FlxG.save.data.beatWeekG3) return;

                FlxG.save.data.beatWeekG3 = true;
                FlxG.save.data.weeksFinished = [true, true, true, false, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, false, false, false, false];
                trace("BEAT WEEK 3");  
            case 'r0ses and quartzs':
                if(FlxG.save.data.beatWeekG4) return;

                FlxG.save.data.beatWeekG4 = true;
                FlxG.save.data.weeksFinished = [true, true, true, true, false, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, true, false, false, false];
                trace("BEAT WEEK 4");       
            case 'nocturnal meow':
                if(FlxG.save.data.beatWeekG5) return;

                FlxG.save.data.beatWeekG5 = true;
                FlxG.save.data.weeksFinished = [true, true, true, true, true, false];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, true, true, false, false];
                trace("BEAT WEEK 5");   
            case 'cataclysm':
                if(FlxG.save.data.beatWeekG6) return;

                FlxG.save.data.beatWeekG6 = true;
                FlxG.save.data.beatWeekG8 = true;
                FlxG.save.data.weeksFinished = [true, true, true, true, true, true];
                FlxG.save.data.weeksUnlocked = [true, true, true, true, true, true, false, true];
                FlxG.save.data.codesUnlocked = true;
                trace("BEAT WEEK 6");   
        }
        FlxG.save.flush();
    }
}