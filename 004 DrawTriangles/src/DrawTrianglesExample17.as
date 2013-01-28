/**
 * DrawTrianglesExample17.as by Lee Burrows
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
	public class DrawTrianglesExample17 extends Sprite
	{
		private var shape1:Shape3D;
		private var shape2:Shape3D;
		
		[Embed(source="../assets/image1.jpg")]
		public var img1:Class;
		[Embed(source="../assets/image2.jpg")]
		public var img2:Class;
		
		public function DrawTrianglesExample17()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//setup
			init();
		}

		private function init():void
		{
			//get references to embedded bitmapdatas
			var texture1:BitmapData = (new img1() as Bitmap).bitmapData;
			var texture2:BitmapData = (new img2() as Bitmap).bitmapData;

			//generate data for a pyramid
			var shapeData1:Array = ShapeFactory.getPyramidData(100, 100, 100, texture1);
			//generate data for a box
			var shapeData2:Array = ShapeFactory.getBoxData(100, 100, 100, texture2);

			//create some 3d shapes
			shape1 = new Shape3D(shapeData1[0],
								shapeData1[1],
								shapeData1[2],
								shapeData1[3]);
			shape1.x = 150;
			shape1.y = 100;
			addChild(shape1);
			shape2 = new Shape3D(shapeData2[0],
								shapeData2[1],
								shapeData2[2],
								shapeData2[3]);
			shape2.x = 150;
			shape2.y = 100;
			addChild(shape2);
	
			//start loop
			addEventListener(Event.ENTER_FRAME, loop);
		}

		private function loop(event:Event):void
		{
			//update positions and rotations based on mouse
			shape1.position.x = 200*Math.sin(mouseX/300*Math.PI*2);
			shape1.position.z = 200*Math.cos(mouseX/300*Math.PI*2);
			shape1.angle.y = -mouseX/300*Math.PI*2;
			shape2.position.x = -shape1.position.x;
			shape2.position.z = -shape1.position.z;
			shape2.angle.y = shape1.angle.y;
			//draw
			shape1.update();
			shape2.update();
			//depth sort
			sortDepths();
		}
		
		private function sortDepths():void
		{
			//array to store references to shapes
			var shapes:Array = [];
			//get number of objects in the display list
			var len:uint = this.numChildren;
			//loop thru objects and add Shape3D objects to our array
			for (var i:uint=0;i<len;i++)
			{
				if (this.getChildAt(i) is Shape3D)
					shapes.push(this.getChildAt(i));
			}
			//sort the array based on the z position of the objects
			shapes = shapes.sortOn(["distance"], Array.NUMERIC|Array.DESCENDING);
			//move each object in turn to the top (front) of the display list
			len = shapes.length;
			for (i=0;i<len;i++)
				this.addChild(shapes[i]);
		}

	}
}