//

function create() {
    dialscript.menuMusic = FlxG.sound.load(Paths.music('easteregg/areline_theme'), 1.0, true);
    dialscript.clownTheme = FlxG.sound.load(Paths.music('easteregg/menu_clown'), 1.0, true);

    // for future refernce, set this to the first portiat you want, THEN use switch portriat -lunar
    dialscript.cloudPortaitName = "Clown";

    dialscript.dialogueList = [
        {
            message_en: "Welcome back little dwarf...", 
            message_es: "Bienvenido devuelta pequeño enano...", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "%What's that in your hand...?&&&\nIs that the note?", 
            message_es: "%Que tienes en tu mano...?&&&\nEsa es la nota?", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("confused", true);
                }
            }
        },
        {
            message_en: "%Alright,& hand it over...&&\nI don't want to waste too much of your time...", 
            message_es: "%Está bien,& entregamela...&&\nNo quiero hacerte perder demasiado tiempo...", 
            typingSpeed: 0.055, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("normal", true);
                }
            }
        },
        {
            message_en: "%Huh,& this joke is really confusing...", 
            message_es: "%Huh,& este chiste es realmente confuso...", 
            typingSpeed: 0.055, startDelay: .2,
            onEnd: function () {
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;

                dialscript.wind.fadeOut(0.8);
                dialscript.showCloud(true);

            },
            event: function (count:Int) {
                switch (count) {
                    case 0:
                        dialscript.eyes.animation.play("confused", true);
                        dialscript.wind.stop();
                }
            }
        },
        {
            message_en: "%'Blue haired boy,&& BLUE HAIRED BOY!&&\nYour gonna be &SLEIGHED!& out of your seat when you hear this joke!!!'",
            message_es: "%'Chico del pelo azul,&& CHICO DEL PELO AZUL!&&\nTe van a &TRINEO!& Levántate de tu asiento cuando escuches este chiste!!!'",
            typingSpeed: 0.05, startDelay: 2,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0:
                        dialscript.__randSounds = ["easteregg/snd_binky", "easteregg/snd_binky_2", "easteregg/snd_binky_3"];

                        dialscript.wind.stop();
                        dialscript.eyes.animation.play("normal", true);
                }
            }
        },
        {
            message_en: "'What did the penguin say to the pine tree?&&\nDON'T START,& YOUR SLIDING!!!!!'", 
            message_es: "'Que le dijo el pingüino al pino?&&\nNO EMPIECES,& TU DESLIZAMIENTO!!!!!'", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'HEE HEE!!& I'm even cheering my self up today!!'", 
            message_eS: "'HEE HEE!!& Incluso me estoy animando hoy!!'", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'I love to CHEER!!& Cheering is what makes a clown A CLOWN!!!'", 
            message_es: "'Me encanta ANIMAR!!& Animar es lo que hace a un payaso UN PAYASO!!!'", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'What's the purpose of a clown,& if not to CHEER everyone up??'", 
            message_en: "'Cuál es el propósito de ser un payaso,& si no es para ANIMAR a todos??'", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "'Like this one time,& %I saw this poor gray cat in a alley way...&&\nIN THE MIDDLE OF A THUNDERSTORM!'", 
            message_es: "'Como esta vez,& %Vi a ese pobre gato gris en un callejón...&&\nEN MEDIO DE UNA TORMENTA ELÉCTRICA!'", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){
                switch (count) {
                    case 0: dialscript.switchPortrait(.0001, "cryfieldSecret");
                }
            }
        },
        {
            message_en: "'and the cats poor friend...&& they looked like they were crying for hours...'", 
            message_eS: "'y el pobre amigo del gato...&& se veia como si estuvieron llorando por horas...'", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int){}
        },
        {
            message_en: "%'SO I LEFT THEM A JOKE TO BRIGHTEN THEM UP!!!!'", 
            message_es: "%'ASÍ QUE LES DEJE UN CHISTE PARA ILUMINARLOS!!!!'", 
            typingSpeed: 0.045, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.switchPortrait(.0001, "Clown");
                }
            }
        },
        {
            message_en: "'Anyway,& that's all little blue haired boy.&& \nI left your clue on the back...'", 
            message_es: "'De igual forma,& eso es todo pequeño chico del pelo azul.&& \nDejé tu pista en la parte de atrás...'", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.clownTheme.fadeOut(0.8);
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (count:Int){}
        },
        {
            message_en: "%Alright well...&% that was surely something...", 
            message_es: "%Bueno entonces...&% eso fue sin duda algo...", 
            typingSpeed: 0.05, startDelay: .8,
            onEnd: function () {
                dialscript.menuMusic.play();
                dialscript.menuMusic.fadeIn(0.8);

                dialscript.switchPortrait(.5, "Note_Green");

                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;
            },
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.__randSounds = ["easteregg/snd_text", "easteregg/snd_text_2"];
                    case 1: dialscript.eyes.animation.play("smug", true);
                }
            }
        },
        {
            message_en: "%Wow.& He left a explation for the joke again.&&\nI think he knows we can't understand his jokes...", 
            message_es: "%Wow.& El dejó una explicación para el chiste otra vez.&&\nCreo que el sabe que no entendemos sus chistes...", 
            typingSpeed: 0.05, startDelay: 1,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.eyes.animation.play("normal", true);
                }
            }
        },
        {
            message_en: "It reads:& %'Get it?& Because when you cut a pine tree,& it slides like a penguin!&& BAHHAHAHHA!!!!'%", 
            message_es: "Dice así:& %'Lo entiendes?& Porque cuando talas un pino,& se desliza como un pingüino!&& BAJJAJAJJA!!!!'%", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {
                switch (count) {
                    case 0: dialscript.__randSounds = ["easteregg/snd_binky", "easteregg/snd_binky_2", "easteregg/snd_binky_3"];
                    case 1: dialscript.__randSounds = ["easteregg/snd_text", "easteregg/snd_text_2"];
                }
            }
        },
        {
            message_en: "Ok,& that one kinda made me chuckle...", 
            message_es: "Ok,& eso me hizo reír un poco...", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {}
        },
        {
            message_en: "Also it mentions the next clue for the code!", 
            message_es: "También menciona la siguiente pista para el código!", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {}
        },
        {
            message_en: "Apparently, &the second number of the code is the most repeated digit of your highscore??", 
            message_es: "Aparentemente, &el segundo número del código es el digito más repetido de tu mejor puntuación??", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {}
        },
        {
            message_en: "What's a high score???&& The clown just makes up his own things sometimes...", 
            message_es: "Cuál mejor puntuación???&& El payaso sólo inventa sus propias cosas a veces...", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {
                dialscript.__canAccept = false;
                dialscript.box.alpha = dialscript.dialoguetext.alpha = dialscript.prompt.alpha = 0;

                dialscript.showCloud(false);
            },
            event: function (count:Int) {}
        },
        {
            message_en: "Anyway,& I have a gut feeling that those two cats are too dumb to find that note...", 
            message_es: "De cualquier manera,& tengo el presentimiento de que esos dos gatos fueron muy tontos como para encontrar esa nota...", 
            typingSpeed: 0.05, startDelay: 2,
            onEnd: function () {},
            event: function (count:Int) {}
        },
        {
            message_en: "So your probably gonna have to find the note inside a rainy alleyway.", 
            message_es: "Así que posiblemente tengas que buscar la nota en un callejón lluvioso.", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {}
        },
        {
            message_en: "Find it& and bring it here so I can read it.&&\nPlease come back soon...", 
            message_es: "Encuentrala& y tráela acá entonces podré leerla.&&\nPor favor vuelve pronto...", 
            typingSpeed: 0.05, startDelay: 0,
            onEnd: function () {},
            event: function (count:Int) {}
        }
    ];

    dialscript.endingCallback = function () {
        dialscript.fadeOut = dialscript.fastFirstFade = true; dialscript.blackTime = 0;
        dialscript.menuMusic.fadeOut(2); dialscript.introSound.volume = 0.3;
        dialscript.eyes.animation.play("normal", true);
        (new FlxTimer()).start(2/8, function () dialscript.introSound.play(true), 8);
        (new FlxTimer()).start(2.2, function () {FlxG.switchState(new StoryMenuState()); FlxG.save.data.hasVisitedPhase = true;});
    };
}

function postCreate() {
    dialscript.fastFirstFade = true; 
    dialscript.introSound = FlxG.sound.load(Paths.sound('easteregg/snd_test'), 0.4);
	(new FlxTimer()).start(2/8, function () dialscript.introSound.play(true), 8);
	if (FlxG.save.data.arlenePhase == -1 || !FlxG.save.data.canVisitArlene) return;
	(new FlxTimer()).start(4.2, function () FlxG.sound.play(Paths.sound('easteregg/mus_sfx_cinematiccut'), 0.1));
	(new FlxTimer()).start(6, dialscript.progressDialogue);

    if (FlxG.save.data.paintPosition == -1) {
        FlxG.save.data.paintPosition = 12;
        FlxG.save.flush();
    }

    trace("ARLENE DIALOGUE PHASE 2 LOADED");
}