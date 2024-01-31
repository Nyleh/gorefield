function postCreate() 
{
    camFollowChars = false; camFollow.setPosition(1500, 750);
    snapCam();

    for (strum in strumLines) 
        for (char in strum.characters)
            if (char.curCharacter == "jon-cc") {
                char.x += 450;
                char.y -= 530;
            }

    for (strum in strumLines) 
        for (char in strum.characters)
            if (char.curCharacter == "cartoonfield") {
                char.x += 1800;
                char.y += 230;
            }
}