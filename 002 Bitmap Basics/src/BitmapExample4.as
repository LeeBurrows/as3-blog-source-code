/**
 * BitmapExample4.as by Lee Burrows
 * Sep 12, 2010
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
	import flash.geom.Rectangle;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="200", height="200")]
	public class BitmapExample4 extends Sprite
	{
		public function BitmapExample4()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//create a new BitmapData object
			var bmd:BitmapData = new BitmapData(100, 100, false, 0x000000);
			//rectangle object points to area of bitmapdata to fill
			var rect:Rectangle = new Rectangle(0, 0, 100, 5);
			//keep looping until rect.y equals height of bitmapdata
			while (rect.y!=100)
			{
				//fill the area of bitmapdata signified
				//by rect with a random colour
				bmd.fillRect(rect, Math.random()*0xFFFFFF);
				//move rect down 5 rows
				rect.y += 5;
			}
			//create bitmap and pass in BitmapData object
			var bm:Bitmap = new Bitmap(bmd);
			//add bitmap to stage
			bm.x = 50;
			bm.y = 50;
			addChild(bm);
		}

	}
}