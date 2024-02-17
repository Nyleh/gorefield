var card:FlxSprite;

var camIntroTitleCard:FlxCamera;
var data:T;

function postCreate() {
    var path:String = "assets/songs/" + SONG.meta.name.toLowerCase() + "/intro-title-card.json";
    if (!Assets.exists(path)) { disableScript(); return; }

    data = Json.parse(Assets.getText(path));

    camIntroTitleCard = new FlxCamera();
    camIntroTitleCard.bgColor = 0x00000000;
    FlxG.cameras.add(camIntroTitleCard, false);

    card = new FlxSprite();
    card.loadGraphic(Paths.image("intro-title-cards/" + data.image));
    card.cameras = [camIntroTitleCard];
    card.screenCenter();
    if (data.offset != null) {
        card.x += data.offset[0];
        card.y += data.offset[1];
    }
    card.alpha = 0;
    add(card);
}

function onSongStart() {
    FlxTween.tween(card, {alpha: 1}, 0.5, {startDelay: data.startDelay ?? 0});

    var sixthOfDuration:Float = (data.duration ?? 2.5) / 5;
    FlxTween.tween(card, {alpha: 0}, sixthOfDuration,
    {
        startDelay: (data.startDelay ?? 0) + 0.5 + sixthOfDuration * 4,
        onComplete: function() {
            card.kill();
            remove(card);
            card.destroy();

            FlxG.cameras.remove(camIntroTitleCard, true);

            disableScript();
        }
    });
}