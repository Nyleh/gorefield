function postCreate() 
{
    camFollowChars = false; camFollow.setPosition(1500, 750);

    for (strum in strumLines) 
        for (char in strum.characters)
            if (char.curCharacter == "pico") {
                char.x += 300;
                char.y -= 240;
            }

    for (strum in strumLines) 
        for (char in strum.characters)
            if (char.curCharacter == "dad") {
                char.x += 2800;
                char.y += 600;
            }
}