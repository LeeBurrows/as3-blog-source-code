/**
 * BitmapDataExample4.as by Lee Burrows
 * Sep 19, 2010
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
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="350", height="200")]
	public class BitmapDataExample4 extends Sprite
	{
		private var bmSrc:Bitmap;
		private var bmDest:Bitmap;

		public function BitmapDataExample4()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//create source BitmapData object filled with random noise
			var bmd:BitmapData = new BitmapData(100, 100, true, 0x00000000);
			bmd.noise(Math.random()*int.MAX_VALUE, 0, 255, 15);
			//create bitmap and pass in BitmapData object
			bmSrc = new Bitmap(bmd);
			//add bitmap to stage
			bmSrc.x = 50;
			bmSrc.y = 50;
			addChild(bmSrc);
			// create destination bitmap
			bmDest = new Bitmap(new BitmapData(100, 100, true, 0x00000000));
			bmDest.x = 200;
			bmDest.y = 50;
			addChild(bmDest);
			//copy with threshold
			bmDest.bitmapData.threshold(bmSrc.bitmapData, bmSrc.bitmapData.rect, new Point(0, 0), ">=", 0x00800000, 0xFFFFFF00, 0x00FF0000, false);
		}

	}
}