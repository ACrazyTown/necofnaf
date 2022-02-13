package shader;

import flixel.system.FlxAssets.FlxShader;

class PanoramaDistortionShader extends FlxShader
{
    /*
	 * Original shader by The Concept Boy (https://www.youtube.com/watch?v=-Ah8vvXwv5Y&ab_channel=TheConceptBoy)
     * Adjusted for HaxeFlixel/OpenFL by A Crazy Town
    */

    // Figure out why it breaks when at a lower resolution
    @:glFragmentSource('
    #pragma header

    void main()
    {
        vec2 coordinates;
        float pixelDistanceX;
        float pixelDistanceY;
        float offset;
        float dir;

        pixelDistanceX = distance(openfl_TextureCoordv.x, 0.5);
        pixelDistanceY = distance(openfl_TextureCoordv.y, 0.5);

        offset = (pixelDistanceX * 0.2) * pixelDistanceY;

        if (openfl_TextureCoordv.y <= 0.5)
            dir = 1.0;
        else
            dir = -1.0;

        coordinates = vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + pixelDistanceX * (offset * 8.0 * dir));
        vec4 test = flixel_texture2D(bitmap, coordinates);
        gl_FragColor = test;
    }
    ')

    public function new()
    {
        super();
    }
}