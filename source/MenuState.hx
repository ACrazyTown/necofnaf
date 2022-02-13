package;

import openfl.events.KeyboardEvent;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class MenuState extends FlxState
{
    public static var audioFormat:String = #if web ".mp3" #else ".ogg" #end;

    var nights:Array<String> = [
        "Night Neco",
        "Night Neco/20",
        "Custom Night"
    ];

    var nightGroup:FlxTypedGroup<FlxText>;

    var necoMenu:FlxSprite;

	var menuMusic:FlxSound;

    var selectTextPrev:Float = -80;
    var selectText:FlxText;

    override function create()
    {
		var stat:Static = new Static();
        stat.alpha = 0.25;
		stat.animation.play("static");
		add(stat);

        var menuText:FlxText = new FlxText(105, 35, FlxG.width, "One\nNight\nat\nNeco Arc's\nBETA", 48, false);
        menuText.setFormat("assets/fonts/ocr.ttf", 48);
        add(menuText);

        necoMenu = new FlxSprite().loadGraphic("assets/images/necomenu.png");
        necoMenu.x = FlxG.width - necoMenu.width;
        necoMenu.y = FlxG.height - necoMenu.width;
        add(necoMenu);

        nightGroup = new FlxTypedGroup<FlxText>();
        add(nightGroup);

        selectText = new FlxText(-80, -80, 0, ">>", 48);
		selectText.setFormat("assets/fonts/ocr.ttf", 48);
        add(selectText);

        if (1 == 1) // DEBUG
        {
            var menuStar1:FlxSprite = new FlxSprite(menuText.x, 0);
            menuStar1.loadGraphic("assets/images/menustar.png");
            menuStar1.y = (menuText.y + menuText.height) + 20;
            add(menuStar1);

			var menuStar2:FlxSprite = new FlxSprite(menuStar1.x + menuStar1.width * 1.5, menuStar1.y);
			menuStar2.loadGraphic("assets/images/menustar.png");
			add(menuStar2);
        }

        for (i in 0...nights.length)
        {
            if (i > 0 && FlxG.save.data.beatMain == true) continue; // DEBUG

            var nightText:FlxText = new FlxText(105, i * 70, 0, nights[i], 48);
			nightText.setFormat("assets/fonts/ocr.ttf", 48);
            nightText.ID = i;
            nightText.y += menuText.height + 180;
            nightGroup.add(nightText);
        }

        var versionText:FlxText = new FlxText(0, 0, 0, "v1.00_beta_01", 16, false);
        versionText.y = FlxG.height - versionText.height;
		versionText.setFormat("assets/fonts/ocr.ttf", 16);
        add(versionText);

        var creditsText:FlxText = new FlxText(0, 0, 0, "By A Crazy Town\nInspired by FNAF from Scott Cawthon\nFeaturing assets from FNAF\n", 16);
		creditsText.setFormat("assets/fonts/ocr.ttf", 16, RIGHT);
		creditsText.x = (FlxG.width - creditsText.width) - 5;
        add(creditsText);

		super.create();

        menuMusic = new FlxSound();
        FlxG.sound.list.add(menuMusic);

        menuMusic.volume = 0.7;
		menuMusic.loadEmbedded("assets/music/menu_musicloop" + audioFormat, true);
        menuMusic.play();

        FlxG.sound.playMusic("assets/music/menuintro" + audioFormat, 0.6, false);
        FlxG.sound.music.onComplete = () -> {
            FlxG.sound.playMusic("assets/music/menuloop" + audioFormat, 0.3);
        };

        dripCheck();
    }

    var curSelected:Int = 0;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.mouse.overlaps(necoMenu) && FlxG.mouse.justPressed)
        {
            FlxG.sound.play("assets/sounds/neco_menu_sfx" + audioFormat);
        }

        if (FlxG.mouse.overlaps(nightGroup))
        {
            nightGroup.forEach(function(nightTxt:FlxText)
            {
                if (FlxG.mouse.overlaps(nightTxt))
                {
                    curSelected = nightTxt.ID;
                    playSoundShit();
                    selectText.setPosition(nightTxt.x - selectText.width, nightTxt.y);
                }
            });

            if (FlxG.mouse.justPressed)
            {
                startNight();
            }
        }
    }

    function playSoundShit()
    {
        if (selectTextPrev != selectText.y)
        {
			FlxG.sound.play("assets/sounds/camswitch" + audioFormat);
            selectTextPrev = selectText.y;  
        }
    }

    function startNight()
    {
        FlxG.sound.music.stop();
        menuMusic.stop();

        super.openSubState(new DaySubstate(curSelected));
    }

    function dripCheck()
    {
        var dripSeq:Array<Int> = [68, 82, 73, 80]; // D,R,I,P - charcode
        var pressHistory:Array<Dynamic> = [];

        var goodSeq:Array<Dynamic> = [];

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent)
        {
            pressHistory.push(event.keyCode);

            trace(pressHistory);

            for (i in 0...dripSeq.length)
            {
                if (pressHistory[0] == dripSeq[i])
                {
                    pressHistory.shift();
                    trace("awes2");
                    goodSeq.push(pressHistory[0]);
                }
                else {
                    pressHistory = [];
                    trace("awes");
                }
            }

            if (goodSeq.length == dripSeq.length)
            {
                trace("drip mode activated");
            }
        });
    }
}