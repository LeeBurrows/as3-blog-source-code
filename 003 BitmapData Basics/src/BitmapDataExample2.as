/**
 * BitmapDataExample2.as by Lee Burrows
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
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="350", height="200")]
	public class BitmapDataExample2 extends Sprite
	{
		private var bm:Bitmap;
		private var mc:Sprite;
		
		//store scale and rotation angle for draw(...)
		private var xscale:Number = 1;
		private var yscale:Number = 1;
		private var angle:Number = 0;

		public function BitmapDataExample2()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			//create a new display object to copy from
			//filled with any old stuff
			mc = new Sprite();
			mc.x = 50;
			mc.y = 50;
			addChild(mc);
			resetSource();
			//draw a border behind it so we can see the bounds
			graphics.lineStyle(1, 0xFFFF00);
			graphics.drawRect(50, 50, 100, 100);

			//create a new BitmapData object to copy to
			var bmd:BitmapData = new BitmapData(100, 100, false, 0x000000);
			//create bitmap and pass in BitmapData object
			bm = new Bitmap(bmd);
			//add bitmap to stage
			bm.x = 200;
			bm.y = 50;
			addChild(bm);
			//add loop
			addEventListener(Event.ENTER_FRAME, loop);
			//add listener
			stage.addEventListener(MouseEvent.CLICK, reset);
		}
		
		//run every frame
		private function loop(event:Event):void
		{
			//create matrix to do transformation
			var m:Matrix = new Matrix();
			//scale and rotate
			//translate x and y set to mid point of destination so it will rotate around that point
			m.createBox(xscale, yscale, angle, 50, 50);
			//copy
			bm.bitmapData.draw(mc, m);
			//reduce the scale each time
			xscale -= 0.005;
			yscale -= 0.005;
			//update angle
			angle += Math.PI/50;
		}
		
		private function reset(event:MouseEvent):void
		{
			//remove old bitmapData object
			bm.bitmapData.dispose();
			//insert new bitmapData object
			bm.bitmapData = new BitmapData(100, 100, false, 0x000000);
			//redraw source
			resetSource();
			//reset scales
			xscale = 1;
			yscale = 1;
		}
		
		private function resetSource():void
		{
			//clear existing content
			mc.graphics.clear();
			//random circles
			for (var i:uint=0;i<20;i++)
			{
				mc.graphics.beginFill(Math.random()*0xFFFFFF);
				mc.graphics.drawCircle(Math.random()*80+10, Math.random()*80+10, 10);
			}
		}
		
	}
}