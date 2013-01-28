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

	public class ShadedShape3D extends Shape
	{
		static public const FOCAL_LENGTH:Number = 500;

		public var angle:Point;
		public var position:Vector3D;
		public var scale:Vector3D;
		
		public var lightDirection:Vector3D = new Vector3D(0, 0, -1);
		
		public var distance:Number;
		
		private var points:Vector.<Vector3D>;
		private var vertices:Vector.<Number>;
		private var indices:Array;
		private var normals:Array;
		private var colour:uint;

		public function ShadedShape3D(points:Vector.<Vector3D>, indices:Array, normals:Array, colour:uint)
		{
			super();
			this.points = points;
			this.indices = indices;
			this.normals = normals;
			this.colour = colour;
			//initial settings
			angle = new Point(0, 0);
			position = new Vector3D(0, 0, 0);
			scale = new Vector3D(1, 1, 1);
		}
		
		public function update():void
		{
			//calculate vertices
			vertices = new Vector.<Number>();
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
			}
			//clear existing graphics
			graphics.clear();
			//draw
			for (var i:uint=0;i<len;i++)
			{
				var adjustedColour:uint = getAdjustedColour(colour, normals[i]);
				graphics.beginFill(adjustedColour);
				graphics.drawTriangles(vertices, indices[i], null, TriangleCulling.NEGATIVE);
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
		
		private function getAdjustedColour(colour:uint, normal:Vector3D):uint
		{
			//rotate normal to match rotation of shape
			normal = rotate3D(normal, angle);
			//get angle between surface and light source
			var angleToLight:Number = Math.abs(Vector3D.angleBetween(lightDirection, normal));
			//calculate adjustment to brightness
			var brightness:Number = Math.cos(angleToLight*0.5);
			//split colour into RGB parts
			var red:uint = colour>>16;
			var green:uint = colour>>8 & 0xFF;
			var blue:uint = colour & 0xFF;
			//adjust brightness of RGB parts
			red *= brightness;
			green *= brightness;
			blue *= brightness;
			//return new colour;
			return red<<16|green<<8|blue;
		}
		
	}
}