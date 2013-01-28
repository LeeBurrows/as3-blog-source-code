/**
 * DrawTrianglesExample5.as by Lee Burrows
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
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	[SWF(backgroundColor="#F0F0F0", frameRate="30", width="300", height="200")]
	public class DrawTrianglesExample5 extends Sprite
	{
		private var shape:Shape;

		public function DrawTrianglesExample5()
		{
			//do some general housekeeping
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
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

			//define vertices
			var vertices:Vector.<Number> = new Vector.<Number>();
			for each (var v:Vector3D in cube)
			{
				var p:Point = convertTo2D(v);
				vertices.push(p.x, p.y);
			}

			//define indices
			var indices:Vector.<int> = new Vector.<int>();
			//front face
			indices.push(0, 1, 3);
			indices.push(1, 2, 3);
			//back face
			indices.push(5, 4, 7);
			indices.push(6, 5, 7);
			//left face
			indices.push(1, 5, 2);
			indices.push(5, 6, 2);
			//right face
			indices.push(4, 0, 3);
			indices.push(4, 3, 7);
			//top face
			indices.push(4, 5, 0);
			indices.push(5, 1, 0);
			//bottom face
			indices.push(3, 2, 7);
			indices.push(2, 6, 7);

			//create shape to draw into and center it on stage
			shape = new Shape();
			shape.x = 150;
			shape.y = 100;
			addChild(shape);

			//set draw colours (black edge, no fill)
			shape.graphics.lineStyle(1, 0x000000);
			//draw triangle
			shape.graphics.drawTriangles(vertices, indices);
			//finish
			shape.graphics.endFill();
		}
		
		private function convertTo2D(v:Vector3D):Point
		{
			var focalLength:Number = 200;
			var perspective:Number = focalLength/(focalLength+v.z);
			return new Point(v.x*perspective, v.y*perspective);
		}
		
	}
}