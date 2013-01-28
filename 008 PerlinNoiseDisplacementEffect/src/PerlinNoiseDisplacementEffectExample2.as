/**
 * PerlinNoiseDisplacementEffectExample2.as by Lee Burrows
 * Feb 15, 2011
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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="400", height="400")]
	public class PerlinNoiseDisplacementEffectExample2 extends Sprite
	{
		static private const NEWPOINT:Point = new Point();

		[Embed(source="../assets/image1.jpg")]
		private var imgClass:Class;
		
		private var viewBitmap:Bitmap;

		private var mapBmd:BitmapData;

		private var filter1:DisplacementMapFilter;
		private var filter2:ConvolutionFilter;

		public function PerlinNoiseDisplacementEffectExample2()
		{
			super();
			init();
		}

		private function init():void
		{
			//create bitmapdata instance to hold perlin noise
			mapBmd = new BitmapData(400, 400, false, 0x000000);
			//add perlin noise (red and green channels only)
			mapBmd.perlinNoise(400, 400, 6, Math.random()*10, false, true, BitmapDataChannel.RED|BitmapDataChannel.GREEN);
			//create displacement filter from perlin noise bitmapdata
			filter1 = new DisplacementMapFilter(mapBmd, NEWPOINT, BitmapDataChannel.RED, BitmapDataChannel.GREEN, 2, 2, DisplacementMapFilterMode.WRAP);
			//create a convolution filter to reduce brightness slightly
			filter2 = new ConvolutionFilter(1, 1, [1], 0.98);
			//create bitmap to apply filter to
			viewBitmap = new Bitmap(null);
			refreshImage();
			addChild(viewBitmap);
			//listen for click
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			//start loop
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function refreshImage():void
		{
			viewBitmap.bitmapData = (new imgClass()).bitmapData;
		}
		
		private function loop(event:Event):void
		{
			var bmd:BitmapData = viewBitmap.bitmapData;
			//apply displacement filter
			bmd.applyFilter(bmd, bmd.rect, NEWPOINT, filter1);
			//apply convolution filter
			bmd.applyFilter(bmd, bmd.rect, NEWPOINT, filter2);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			refreshImage();
		}

	}
}