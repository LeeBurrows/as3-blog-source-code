/**
 * DrawTrianglesExample9.as by Lee Burrows
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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#F0F0F0", frameRate="30", width="300", height="200")]
	public class DrawTrianglesExample9 extends Sprite
	{
		private var shape:Shape;
		
		private var cube:Vector.<Vector3D> = new Vector.<Vector3D>();
		
		private var vertices:Vector.<Number> = new Vector.<Number>();
		private var indicesFront:Vector.<int> = new Vector.<int>();
		private var indicesBack:Vector.<int> = new Vector.<int>();
		private var indicesLeft:Vector.<int> = new Vector.<int>();
		private var indicesRight:Vector.<int> = new Vector.<int>();
		private var indicesTop:Vector.<int> = new Vector.<int>();
		private var indicesBottom:Vector.<int> = new Vector.<int>();
		
		public function DrawTrianglesExample9()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//define x,y,z points of cube
			cube.push(new Vector3D(-50, -50, -50));
			cube.push(new Vector3D(50, -50, -50));
			cube.push(new Vector3D(50, 50, -50));
			cube.push(new Vector3D(-50, 50, -50));
			cube.push(new Vector3D(-50, -50, 50));
			cube.push(new Vector3D(50, -50, 50));
			cube.push(new Vector3D(50, 50, 50));
			cube.push(new Vector3D(-50, 50, 50));
			
			//define indices
			//front face
			indicesFront.push(0, 1, 3);
			indicesFront.push(1, 2, 3);
			//back face
			indicesBack.push(5, 4, 7);
			indicesBack.push(6, 5, 7);
			//left face
			indicesLeft.push(1, 5, 2);
			indicesLeft.push(5, 6, 2);
			//right face
			indicesRight.push(4, 0, 3);
			indicesRight.push(4, 3, 7);
			//top face
			indicesTop.push(4, 5, 0);
			indicesTop.push(5, 1, 0);
			//bottom face
			indicesBottom.push(3, 2, 7);
			indicesBottom.push(2, 6, 7);
			
			//create shape to draw into and center it on stage
			shape = new Shape();
			shape.x = 150;
			shape.y = 100;
			addChild(shape);
			
			//loop
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			//get x and y rotation from mouse position
			var angle:Vector3D = new Vector3D(2*Math.PI*mouseX/300, 2*Math.PI*mouseY/200, 0);
			//calculate vertices
			vertices = new Vector.<Number>();
			for each (var v:Vector3D in cube)
			{
				var p:Point = convertTo2D(rotate3D(v, angle));
				vertices.push(p.x, p.y);
			}
			//clear existing graphics
			shape.graphics.clear();
			//draw front
			shape.graphics.beginFill(0x999900);
			shape.graphics.drawTriangles(vertices, indicesFront, null, TriangleCulling.NEGATIVE);
			//draw back
			shape.graphics.beginFill(0x000099);
			shape.graphics.drawTriangles(vertices, indicesBack, null, TriangleCulling.NEGATIVE);
			//draw left
			shape.graphics.beginFill(0x990099);
			shape.graphics.drawTriangles(vertices, indicesLeft, null, TriangleCulling.NEGATIVE);
			//draw right
			shape.graphics.beginFill(0x009900);
			shape.graphics.drawTriangles(vertices, indicesRight, null, TriangleCulling.NEGATIVE);
			//draw top
			shape.graphics.beginFill(0x009999);
			shape.graphics.drawTriangles(vertices, indicesTop, null, TriangleCulling.NEGATIVE);
			//draw bottom
			shape.graphics.beginFill(0x990000);
			shape.graphics.drawTriangles(vertices, indicesBottom, null, TriangleCulling.NEGATIVE);
			//finish
			shape.graphics.endFill();
		}
		
		private function convertTo2D(v:Vector3D):Point
		{
			var focalLength:Number = 200;
			var perspective:Number = focalLength/(focalLength+v.z);
			return new Point(v.x*perspective, v.y*perspective);
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