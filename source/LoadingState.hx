package;

import flixel.text.FlxText;
import openfl.Assets;
import flixel.FlxSprite;
import sys.FileSystem;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxState;

using StringTools;

class LoadingState extends FlxState
{
    public static var bitmapData:Map<String, FlxGraphic>;

    var images = [];
    var music = [];

	var debugLoad:FlxText;

    override function create()
    {
        FlxG.worldBounds.set(0, 0);

        bitmapData = new Map<String, FlxGraphic>();

        debugLoad = new FlxText(10, 10, 0, "", 24);
        add(debugLoad);

        var loadingClock:FlxSprite = new FlxSprite().loadGraphic("assets/images/loading.png");
        loadingClock.x = (FlxG.width - loadingClock.width) - 25;
        loadingClock.y = (FlxG.height - loadingClock.height) - 25;
        add(loadingClock);

        FlxGraphic.defaultPersist = true; // ???

        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/")))
        {
            if (!i.endsWith(".png"))
                continue;
            
            images.push(i);
        }

        sys.thread.Thread.create(() ->
        {
            cache();
        });

		super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    function cache()
    {
        for (i in images)
        {
            trace("Loading asset: " + i);
            var data = Assets.getBitmapData("assets/images/" + i);
            var graphic = FlxGraphic.fromBitmapData(data);
            graphic.persist = true;
            graphic.destroyOnNoUse = true;
            bitmapData.set(i, graphic);
			debugLoad.text += "Loaded asset: " + i + "\n";
        }

        trace("done lmaooo");
        FlxG.switchState(new PlayState());
    }
}