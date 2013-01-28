/**
 * PerlinNoiseExample3.as by Lee Burrows
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
	import flash.events.Event;
	import flash.geom.Point;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="200", height="200")]
	public class PerlinNoiseExample3 extends Sprite
	{
		//store properties in class scope so we can refer to them from the loop method
		private var baseX:Number = 200;
		private var baseY:Number = 200;
		private var octaves:uint = 4;
		private var seed:int = Math.random()*100;
		private var stitch:Boolean = true;
		private var fractal:Boolean = false;
		private var channels:uint = BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE;
		private var grayscale:Boolean = false;
		private var offsets:Array;
		private var bm:Bitmap;

		public function PerlinNoiseExample3()
		{
			//general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//start offsets at zero
			offsets = new Array(4);
			offsets[0] = new Point(0, 0);
			offsets[1] = new Point(0, 0);
			offsets[2] = new Point(0, 0);
			offsets[3] = new Point(0, 0);

			//create a new bitmapdata instance to hold the noise
			var bmd:BitmapData = new BitmapData(200, 200, true, 0x00000000);
			//add bitmapdata to a bitmap
			bm = new Bitmap(bmd);
			//add the bitmap to the stage
			addChild(bm);
			//start animating
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			//move octave 1 up and left
			offsets[0].x--;
			offsets[0].y--;
			//move octave 2 up and right
			offsets[1].x++;
			offsets[1].y--;
			//move octave 3 down and left
			offsets[2].x--;
			offsets[2].y++;
			//move octave 4 down and right
			offsets[3].x++;
			offsets[3].y++;
			//generate new noise
			bm.bitmapData.perlinNoise(baseX, baseY, octaves, seed, stitch, fractal, channels, grayscale, offsets);
		}

	}
}