/**
 * DrawTrianglesExample13.as by Lee Burrows
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
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#F0F0F0", frameRate="30", width="300", height="200")]
	public class DrawTrianglesExample13 extends Sprite
	{
		private var shape:Shape3D;
		
		[Embed(source="../assets/image1.jpg")]
		public var img:Class;
		
		public function DrawTrianglesExample13()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//setup
			init();
		}

		private function init():void
		{
			//define x,y,z points of cube
			var cube:Vector.<Vector3D> = new Vector.<Vector3D>();
			cube.push(new Vector3D(-50, -50, -50));
			cube.push(new Vector3D(50, -50, -50));
			cube.push(new Vector3D(50, 50, -50));
			cube.push(new Vector3D(-50, 50, -50));
			cube.push(new Vector3D(-50, -50, 50));
			cube.push(new Vector3D(50, -50, 50));
			cube.push(new Vector3D(50, 50, 50));
			cube.push(new Vector3D(-50, 50, 50));
			
			//define indices
			var indicesFront:Vector.<int> = new Vector.<int>();
			indicesFront.push(0, 1, 3, 1, 2, 3);
			var indicesBack:Vector.<int> = new Vector.<int>();
			indicesBack.push(5, 4, 7, 6, 5, 7);
			var indicesLeft:Vector.<int> = new Vector.<int>();
			indicesLeft.push(1, 5, 2, 5, 6, 2);
			var indicesRight:Vector.<int> = new Vector.<int>();
			indicesRight.push(4, 0, 3, 4, 3, 7);
			var indicesTop:Vector.<int> = new Vector.<int>();
			indicesTop.push(4, 5, 0, 5, 1, 0);
			var indicesBottom:Vector.<int> = new Vector.<int>();
			indicesBottom.push(3, 2, 7, 2, 6, 7);
			
			//define uvt
			var uvtFront:Vector.<Number> = new Vector.<Number>();
			uvtFront.push(0, 0, NaN, 1, 0, NaN, 1, 1, NaN, 0, 1, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN);
			var uvtBack:Vector.<Number> = new Vector.<Number>();
			uvtBack.push(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 1, 0, NaN, 0, 0, NaN, 0, 1, NaN, 1, 1, NaN);
			var uvtLeft:Vector.<Number> = new Vector.<Number>();
			uvtLeft.push(NaN, NaN, NaN, 0, 0, NaN, 0, 1, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 1, 0, NaN, 1, 1, NaN, NaN, NaN, NaN);
			var uvtRight:Vector.<Number> = new Vector.<Number>();
			uvtRight.push(1, 0, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 1, 1, NaN, 0, 0, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 0, 1, NaN);
			var uvtTop:Vector.<Number> = new Vector.<Number>();
			uvtTop.push(0, 1, NaN, 1, 1, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 0, 0, NaN, 1, 0, NaN, NaN, NaN, NaN, NaN, NaN, NaN);
			var uvtBottom:Vector.<Number> = new Vector.<Number>();
			uvtBottom.push(NaN, NaN, NaN, NaN, NaN, NaN, 1, 0, NaN, 0, 0, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 1, 1, NaN, 0, 1, NaN);
			
			//get reference to embedded bitmapdata
			var texture:BitmapData = (new img() as Bitmap).bitmapData;
			
			//create 3d shape and center it on stage
			shape = new Shape3D(cube,
								[indicesFront, indicesBack, indicesLeft, indicesRight, indicesTop, indicesBottom],
								[uvtFront, uvtBack, uvtLeft, uvtRight, uvtTop, uvtBottom],
								[texture, texture, texture, texture, texture, texture]);
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