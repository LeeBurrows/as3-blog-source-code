/**
 * ShapeFactory.as by Lee Burrows
 * Nov 11, 2010
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
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	public class ShapeFactory
	{
		public function ShapeFactory()
		{
		}
		
		static public function getBoxData(width:Number, height:Number, depth:Number, texture:BitmapData):Array
		{
			//calculate half of width, height and depth
			var w2:Number = width*0.5;
			var h2:Number = height*0.5;
			var d2:Number = depth*0.5;

			//define box points
			var points:Vector.<Vector3D> = new Vector.<Vector3D>;
			points.push(new Vector3D(-w2, -h2, -d2));
			points.push(new Vector3D(w2, -h2, -d2));
			points.push(new Vector3D(w2, h2, -d2));
			points.push(new Vector3D(-w2, h2, -d2));
			points.push(new Vector3D(-w2, -h2, d2));
			points.push(new Vector3D(w2, -h2, d2));
			points.push(new Vector3D(w2, h2, d2));
			points.push(new Vector3D(-w2, h2, d2));
			
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
			
			return [points,
					[indicesFront, indicesBack, indicesLeft, indicesRight, indicesTop, indicesBottom],
					[uvtFront, uvtBack, uvtLeft, uvtRight, uvtTop, uvtBottom],
					[texture, texture, texture, texture, texture, texture]];
		}
		
		static public function getPyramidData(width:Number, height:Number, depth:Number, texture:BitmapData):Array
		{
			//calculate half of width, height and depth
			var w2:Number = width*0.5;
			var h2:Number = height*0.5;
			var d2:Number = depth*0.5;
			
			//define pyramid points (tip and 4 base corners)
			var points:Vector.<Vector3D> = new Vector.<Vector3D>;
			points.push(new Vector3D(0, -h2, 0));
			points.push(new Vector3D(w2, h2, -d2));
			points.push(new Vector3D(-w2, h2, -d2));
			points.push(new Vector3D(w2, h2, d2));
			points.push(new Vector3D(-w2, h2, d2));
			
			//define indices
			var indicesFront:Vector.<int> = new Vector.<int>();
			indicesFront.push(0, 1, 2);
			var indicesBack:Vector.<int> = new Vector.<int>();
			indicesBack.push(0, 4, 3);
			var indicesLeft:Vector.<int> = new Vector.<int>();
			indicesLeft.push(0, 2, 4);
			var indicesRight:Vector.<int> = new Vector.<int>();
			indicesRight.push(0, 3, 1);
			var indicesBottom:Vector.<int> = new Vector.<int>();
			indicesBottom.push(2, 1, 4, 1, 3, 4);
			
			//define uvt
			var uvtFront:Vector.<Number> = new Vector.<Number>();
			uvtFront.push(0.5, 0, NaN, 1, 1, NaN, 0, 1, NaN, NaN, NaN, NaN, NaN, NaN, NaN);
			var uvtBack:Vector.<Number> = new Vector.<Number>();
			uvtBack.push(0.5, 0, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 1, 1, NaN, 0, 1, NaN);
			var uvtLeft:Vector.<Number> = new Vector.<Number>();
			uvtLeft.push(0.5, 0, NaN, NaN, NaN, NaN, 0, 1, NaN, NaN, NaN, NaN, 1, 1, NaN);
			var uvtRight:Vector.<Number> = new Vector.<Number>();
			uvtRight.push(0.5, 0, NaN, 0, 1, NaN, NaN, NaN, NaN, 1, 1, NaN, NaN, NaN, NaN);
			var uvtBottom:Vector.<Number> = new Vector.<Number>();
			uvtBottom.push(NaN, NaN, NaN, 1, 1, NaN, 0, 1, NaN, 1, 0, NaN, 0, 0, NaN);
			
			return [points,
				[indicesFront, indicesBack, indicesLeft, indicesRight, indicesBottom],
				[uvtFront, uvtBack, uvtLeft, uvtRight, uvtBottom],
				[texture, texture, texture, texture, texture]];
		}

	}
}