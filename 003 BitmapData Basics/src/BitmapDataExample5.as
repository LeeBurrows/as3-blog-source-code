/**
 * BitmapDataExample5.as by Lee Burrows
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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="30", width="500", height="200")]
	public class BitmapDataExample5 extends Sprite
	{
		private var bm:Bitmap;
		
		private var shape:Shape;

		public function BitmapDataExample5()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//create shape to draw on
			shape = new Shape();
			shape.x = 200;
			shape.y = 50;
			addChild(shape);
			
			//create a new BitmapData object filled with random noise
			var bmd:BitmapData = new BitmapData(100, 100, true, 0x00000000);
			bmd.noise(Math.random()*int.MAX_VALUE, 0, 255, 15);
			//create bitmap and pass in BitmapData object
			bm = new Bitmap(bmd);
			//add bitmap to stage
			bm.x = 50;
			bm.y = 50;
			addChild(bm);
			//draw graph
			drawGraph(bm.bitmapData);
			//add listener
			stage.addEventListener(MouseEvent.CLICK, reset);
		}
		
		private function drawGraph(bmd:BitmapData):void
		{
			//clear any existing graph
			shape.graphics.clear();
			//graph colours
			var cols:Array = [0xFF0000, 0x00FF00, 0x0000FF, 0xFFFFFF];
			//get histogram data
			var v:Vector.<Vector.<Number>> = bmd.histogram(null);
			//loop through each channel
			for (var i:uint=0;i<4;i++)
			{
				//set colour
				shape.graphics.beginFill(cols[i]);
				//loop through each value
				for (var j:uint=0;j<256;j++)
				{
					//draw data to graph
					//we use a negative value so graph points up
					shape.graphics.drawRect(j, i*25+25, 1, -v[i][j]/5);
				}
			}
		}

		//called when user clicks anywhere
		private function reset(event:MouseEvent):void
		{
			//remove old bitmapData object
			bm.bitmapData.dispose();
			//insert new bitmapData object
			bm.bitmapData = new BitmapData(100, 100, true, 0x00000000);
			//fill with noise
			bm.bitmapData.noise(Math.random()*int.MAX_VALUE, 0, 255, 15);
			//redraw graph
			drawGraph(bm.bitmapData);
		}

	}
}