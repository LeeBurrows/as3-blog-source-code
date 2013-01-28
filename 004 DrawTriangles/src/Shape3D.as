/**
 * Shape3D.as by Lee Burrows
 * Nov 6, 2010
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
	import flash.display.TriangleCulling;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class Shape3D extends Shape
	{
		static public const FOCAL_LENGTH:Number = 500;

		public var angle:Point;
		public var position:Vector3D;
		public var scale:Vector3D;
		
		public var distance:Number;
		
		private var points:Vector.<Vector3D>;
		private var vertices:Vector.<Number>;
		private var indices:Array;
		private var uvt:Array;
		private var texture:Array;

		public function Shape3D(points:Vector.<Vector3D>, indices:Array, uvt:Array, texture:Array)
		{
			super();
			this.points = points;
			this.indices = indices;
			this.uvt = uvt;
			this.texture = texture;
			//initial settings
			angle = new Point(0, 0);
			position = new Vector3D(0, 0, 0);
			scale = new Vector3D(1, 1, 1);
		}
		
		public function update():void
		{
			//calculate vertices and t part of uvt
			vertices = new Vector.<Number>();
			var uvtIndex:uint = 2;
			var len:uint = indices.length;
			for each (var v:Vector3D in points)
			{
				//get rotated position
				var adjustedV:Vector3D = rotate3D(v, angle);
				//scale result
				adjustedV.x *= scale.x;
				adjustedV.y *= scale.y;
				adjustedV.z *= scale.z;
				//adjust for position
				adjustedV.incrementBy(position);
				//calculate vertices
				var perspective:Number = FOCAL_LENGTH/(FOCAL_LENGTH+adjustedV.z);
				vertices.push(adjustedV.x*perspective, adjustedV.y*perspective);
				//update uvt
				for (var i:uint=0;i<len;i++)
					uvt[i][uvtIndex] = perspective;
				uvtIndex += 3;
			}
			//clear existing graphics
			graphics.clear();
			//draw
			for (i=0;i<len;i++)
			{
				graphics.beginBitmapFill(texture[i]);
				graphics.drawTriangles(vertices, indices[i], uvt[i], TriangleCulling.NEGATIVE);
			}
			//finish
			graphics.endFill();
			//set distance for depth sorting
			distance = position.z;
		}
		
		private function rotate3D(v:Vector3D, angle:Point):Vector3D
		{
			//calculate trigonometry
			var sinx:Number = Math.sin(angle.x);
			var cosx:Number = Math.cos(angle.x);
			var siny:Number = Math.sin(angle.y);
			var cosy:Number = Math.cos(angle.y);
			//rotate around x axis
			var y1:Number = (v.y * cosx) - (v.z * sinx);
			var z1:Number = (v.z * cosx) + (v.y * sinx);
			//rotate around y axis
			var x2:Number = (v.x * cosy) - (z1 * siny);
			var z2:Number = (z1 * cosy) + (v.x * siny);

			return new Vector3D(x2, y1, z2);
		}
		
	}
}