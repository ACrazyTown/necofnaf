package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxSubState;

class DaySubstate extends FlxSubState
{
    var night:Int = 0;

    public function new(whichNight:Int = 0)
    {
        super();

        FlxG.mouse.visible = false;

        night = whichNight + 1;

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        var coolText:FlxText = new FlxText(0, 0, FlxG.width, "12:00 AM\n" + night + dumbassMethod(night) + " Night", 42);
        coolText.antialiasing = false;
		coolText.setFormat("assets/fonts/ocr.ttf", 42, FlxColor.WHITE, CENTER);
        coolText.screenCenter();
        add(coolText);

		FlxG.sound.play("assets/sounds/camswitch" + MenuState.audioFormat);

		var dumbass = new FlxSprite().loadGraphic("assets/images/glitchy.png", true, 1280, 720);
		dumbass.animation.add("glitchy", [0, 1, 2, 3, 4, 5, 6], 24, false);
		add(dumbass);

		dumbass.animation.play("glitchy");

        new FlxTimer().start(5, function(tmr:FlxTimer)
        {
            FlxTween.tween(coolText, {alpha: 0}, 1.25, {onComplete: function(t:FlxTween)
            {
                PlayState.night = night;
                FlxG.switchState(new LoadingState());
            }});
        });
    }

    function dumbassMethod(daNight:Int)
    {
        switch (daNight) 
        {
            case 0: return "th";
            case 1: return "st";
            case 2: return "nd";
            case 3: return "rd";
            case 4: return "th";
            case 5: return "th";
            case 6: return "th";
            case 7: return "th";
            default: return "th";
        }
    }
}