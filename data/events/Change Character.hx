var preloadedCharacters:Map<String, Character> = [];
var preloadedIcons:Map<String, FlxSprite> = [];

function create() {
    for (event in PlayState.SONG.events)
        if (event.name == "Change Character" && !preloadedCharacters.exists(event.params[1])) {
            var oldCharacter = strumLines.members[event.params[0]].characters[0];
            var newCharacter = new Character(oldCharacter.x, oldCharacter.y, event.params[1], oldCharacter.isPlayer);
            newCharacter.active = newCharacter.visible = false;
            newCharacter.drawComplex(FlxG.camera); // Push to GPU
            preloadedCharacters.set(event.params[1], newCharacter);
            
            //Adjust Camera Offset to Accomedate Stage Offsets
            if(newCharacter.isGF){
                trace('Is GF ' + newCharacter.curCharacter);
                newCharacter.cameraOffset.x += stage.characterPoses["gf"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["gf"].camyoffset;
            }
            else if(newCharacter.playerOffsets){
                trace('Is BF ' + newCharacter.curCharacter);
                newCharacter.cameraOffset.x += stage.characterPoses["boyfriend"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["boyfriend"].camyoffset;
            }
            else{
                trace('Is DAD ' + newCharacter.curCharacter);
                newCharacter.cameraOffset.x += stage.characterPoses["dad"].camxoffset;
                newCharacter.cameraOffset.y += stage.characterPoses["dad"].camyoffset;
            }
            
            if (preloadedIcons.exists(newCharacter.getIcon())) continue;
            var newIcon = createIcon(newCharacter); // ! GOREFIELD ONLY
            newIcon.active = newIcon.visible = false;
            newIcon.drawComplex(FlxG.camera); // Push to GPU
            preloadedIcons.set(newCharacter.getIcon(), newIcon);
        }
}

function onEvent(_) {
    var params:Array = _.event.params;
    if (_.event.name == "Change Character") {
        var oldCharacter = strumLines.members[params[0]].characters[0];
        var newCharacter = preloadedCharacters.get(params[1]);
        if (oldCharacter.curCharacter == newCharacter.curCharacter) return;

        insert(members.indexOf(oldCharacter), newCharacter);
        newCharacter.active = newCharacter.visible = true;
        remove(oldCharacter);

        newCharacter.setPosition(oldCharacter.x, oldCharacter.y);
        newCharacter.playAnim(oldCharacter.animation.name);
        newCharacter.animation?.curAnim?.curFrame = oldCharacter.animation?.curAnim?.curFrame;
        strumLines.members[params[0]].characters[0] = newCharacter;

        var oldIcon = oldCharacter.isPlayer ? gorefieldiconP1 : gorefieldiconP2; // ! GOREFIELD ONLY
        var newIcon = preloadedIcons.get(newCharacter.getIcon());

        if (oldIcon == newIcon) return;
        insert(members.indexOf(oldIcon), newIcon);
        newIcon.active = newIcon.visible = true;
        remove(oldIcon);
        if (oldCharacter.isPlayer) gorefieldiconP1 = newIcon;
        else gorefieldiconP2 = newIcon;
        updateIcons(); 

        //if (newCharacter == dad) timeBar.createFilledBar(0xFF000000, newCharacter.iconColor);
    }
}