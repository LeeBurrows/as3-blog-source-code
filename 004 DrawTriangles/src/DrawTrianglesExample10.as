/**
 * DrawTrianglesExample10.as by Lee Burrows
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
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	[SWF(backgroundColor="#F0F0F0", frameRate="30", width="300", height="200")]
	public class DrawTrianglesExample10 extends Sprite
	{
		static private const FOCAL_LENGTH:Number = 500;

		private var ldr:Loader;
		private var texture:BitmapData;
		private var shape:Shape;
		
		private var plane:Vector.<Vector3D> = new Vector.<Vector3D>();
		private var vertices:Vector.<Number> = new Vector.<Number>();
		private var indices:Vector.<int> = new Vector.<int>();
		private var uvt:Vector.<Number> = new Vector.<Number>();
		
		public function DrawTrianglesExample10()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//define x,y,z points of plane
			plane.push(new Vector3D(-100, -100, 0));
			plane.push(new Vector3D(100, -100, 0));
			plane.push(new Vector3D(100, 100, 0));
			plane.push(new Vector3D(-100, 100, 0));
			
			//define indices
			indices.push(0, 1, 3);
			indices.push(1, 2, 3);

			//define uvt
			uvt.push(0, 0, NaN);
			uvt.push(1, 0, NaN);
			uvt.push(1, 1, NaN);
			uvt.push(0, 1, NaN);
			
			//create shape to draw into and center it on stage
			shape = new Shape();
			shape.x = 150;
			shape.y = 100;
			addChild(shape);
			
			//load bitmap from file
			ldr = new Loader();
			var req:URLRequest = new URLRequest("image1.jpg");
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, loadHandler);
			ldr.load(req);
		}
		
		//called when image has loaded
		private function loadHandler(event:Event):void
		{
			//grab bitmapdata from loaded image
			texture = Bitmap(ldr.content).bitmapData;
			//remove listener from loader
			ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadHandler);
			//delete loader object
			ldr = null;
			//start loop
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			//get y and z rotation from mouse position
			var angle:Vector3D = new Vector3D(0, 2*Math.PI*mouseX/300, 2*Math.PI*mouseY/200);
			//calculate vertices and t part of uvt
			vertices = new Vector.<Number>();
			var uvtIndex:uint = 2;
			for each (var v:Vector3D in plane)
			{
				var rotatedV:Vector3D = rotate3D(v, angle);
				var perspective:Number = FOCAL_LENGTH/(FOCAL_LENGTH+rotatedV.z);
				vertices.push(rotatedV.x*perspective, rotatedV.y*perspective);
				uvt[uvtIndex] = perspective;
				uvtIndex += 3;
			}
			//clear existing graphics
			shape.graphics.clear();
			//draw
			shape.graphics.beginBitmapFill(texture);
			shape.graphics.drawTriangles(vertices, indices, uvt);
			//finish
			shape.graphics.endFill();
		}
		
		private function rotate3D(v:Vector3D, angle:Vector3D):Vector3D
		{
			//rotate v around x axis by angle.x, around y axis by angle.y and around z axis by angle.z
			var sinx:Number = Math.sin(angle.x);
			var cosx:Number = Math.cos(angle.x);
			var siny:Number = Math.sin(angle.y);
			var cosy:Number = Math.cos(angle.y);
			var sinz:Number = Math.sin(angle.z);
			var cosz:Number = Math.cos(angle.z);
			var y1:Number = (v.y * cosx) - (v.z * sinx);
			var z1:Number = (v.z * cosx) + (v.y * sinx);
			var x2:Number = (v.x * cosy) - (z1 * siny);
			var z2:Number = (z1 * cosy) + (v.x * siny);
			var x3:Number = (x2 * cosz) - (y1 * sinz);
			var y3:Number = (y1 * cosz) + (x2 * sinz);
			return new Vector3D(x3, y3, z2);
		}
		
	}
}