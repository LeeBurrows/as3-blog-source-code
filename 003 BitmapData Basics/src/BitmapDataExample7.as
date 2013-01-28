/**
 * BitmapDataExample7.as by Lee Burrows
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
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="200", height="200")]
	public class BitmapDataExample7 extends Sprite
	{
		private var bm:Bitmap;
		private var filter:BitmapFilter;
		private var ct:ColorTransform;

		public function BitmapDataExample7()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//create filter
			filter = new BlurFilter(2, 2, 1);
			//create colour transform
			ct = new ColorTransform(1.012, 1.012, 1.012, 1.012);
			//create a new BitmapData object
			var bmd:BitmapData = new BitmapData(100, 100, false, 0x000000);
			//create bitmap and pass in BitmapData object
			bm = new Bitmap(bmd);
			//add bitmap to stage
			bm.x = 50;
			bm.y = 50;
			addChild(bm);
			//add loop
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		//called every frame
		private function loop(event:Event):void
		{
			//apply a blur
			bm.bitmapData.applyFilter(bm.bitmapData, bm.bitmapData.rect, new Point(0, 0), filter);
			//apply a colour transform
			bm.bitmapData.colorTransform(bm.bitmapData.rect, ct);
			//draw new block randomly
			var rect:Rectangle = new Rectangle(Math.random()*90, Math.random()*90, 10, 10);
			bm.bitmapData.fillRect(rect, Math.random()*0xFFFFFF);
		}

	}
}