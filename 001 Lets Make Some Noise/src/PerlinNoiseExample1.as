/**
 * PerlinNoiseExample1.as by Lee Burrows
 * Sep 9, 2010
 * Visit blog.leeburrows.com for more stuff
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 **/
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="200", height="200")]
	public class PerlinNoiseExample1 extends Sprite
	{
		public function PerlinNoiseExample1()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//the width of the noise
			var baseX:Number = 200;
			//the height of the noise
			var baseY:Number = 200;
			//number of passes
			var octaves:uint = 1;
			//random seed
			var seed:int = Math.random()*100;
			//smooth the edges to make tiling easier?
			var stitch:Boolean = false;
			//fractal or turbulence
			var fractal:Boolean = false;
			//colour channels to use
			var channels:uint = BitmapDataChannel.ALPHA | BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE;
			//use grayscale?
			var grayscale:Boolean = false;
			//x & y offsets of different passes
			var offsets:Array = [];

			//create a new bitmapdata instance to hold the noise
			var bmd:BitmapData = new BitmapData(200, 200, true, 0x00000000);
			//generate the noise
			bmd.perlinNoise(baseX, baseY, octaves, seed, stitch, fractal, channels, grayscale, offsets);
			//add the bitmapdata to a bitmap
			var bm:Bitmap = new Bitmap(bmd);
			//add the bitmap to the stage
			addChild(bm);
		}

	}
}