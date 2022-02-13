package;

import flixel.FlxSprite;

class Static extends FlxSprite
{
    public function new()
    {
        super(0, 0);

        loadGraphic("assets/images/static.png", true, 1280, 720);
        animation.add("static", [0, 1, 2, 3, 4, 5, 6, 7], 24);
    }
}