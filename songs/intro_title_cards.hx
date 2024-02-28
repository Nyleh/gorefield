var card:FlxSprite;

var camIntroTitleCard:FlxCamera;
var data:T;

var previousCardY:Float = 0;
var slideUp:Bool = false;
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
    if (data.slideUp != null) slideUp = data.slideUp;
    previousCardY = card.y;
    card.alpha = 0;
    add(card);

    if(slideUp)
        card.y += 350;
}

function onSongStart() {
    FlxTween.tween(card, {alpha: 1, y: previousCardY}, slideUp ? 1 : 0.5, {startDelay: data.startDelay ?? 0, ease: FlxEase.cubeInOut});

    var sixthOfDuration:Float = (data.duration ?? 2.5) / 5;
    FlxTween.tween(card, {alpha: 0, y: previousCardY + (slideUp ? 400 : 0)}, sixthOfDuration * (slideUp ? 3 : 1),
    {
        startDelay: (data.startDelay ?? 0) + 0.5 + sixthOfDuration * 4,
        ease: FlxEase.cubeInOut,
        onComplete: function() {
            card.kill();
            remove(card);
            card.destroy();

            FlxG.cameras.remove(camIntroTitleCard, true);

            disableScript();
        }
    });
}