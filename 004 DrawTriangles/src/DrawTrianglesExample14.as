/**
 * DrawTrianglesExample14.as by Lee Burrows
 * Oct 27, 2010
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
	
	[SWF(backgroundColor="#F0F0F0", frameRate="30", width="300", height="200")]
	public class DrawTrianglesExample14 extends Sprite
	{
		private var shape:Shape3D;
		
		[Embed(source="../assets/image1.jpg")]
		public var img:Class;
		
		public function DrawTrianglesExample14()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//setup
			init();
		}

		private function init():void
		{
			//get reference to embedded bitmapdata
			var texture:BitmapData = (new img() as Bitmap).bitmapData;

			//generate data for a cube
			var cubeData:Array = ShapeFactory.getBoxData(100, 100, 100, texture);

			//create 3d shape and center it on stage
			shape = new Shape3D(cubeData[0],
								cubeData[1],
								cubeData[2],
								cubeData[3]);

			shape.x = 150;
			shape.y = 100;
			addChild(shape);
	
			//start loop
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(event:Event):void
		{
			//update angle
			shape.angle.y = (mouseX/300-0.5)*Math.PI*2;
			shape.angle.x = (mouseY/200-0.5)*Math.PI;
			//draw
			shape.update();
		}

	}
}