/**
 * BezierCurve.as by Lee Burrows
 * Apr 06, 2011
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
package parts
{
	import flash.geom.Point;

	public class BezierCurve
	{
		public function BezierCurve()
		{
		}
		
		static public function getPoint(t:Number, points:Array):Point
		{
			//clear totals
			var x:Number = 0;
			var y:Number = 0;
			//calculate n
			var n:uint = points.length-1;
			//calculate !n
			var factn:Number = factoral(n);
			//loop thru points
			for (var i:uint=0;i<=n;i++)
			{
				//calc binominal coefficent
				var b:Number = factn/(factoral(i)*factoral(n-i));
				//calc powers
				var k:Number = Math.pow(1-t, n-i)*Math.pow(t, i);
				//add weighted points to totals
				x += b*k*points[i].x;
				y += b*k*points[i].y;
			}
			//return result
			return new Point(x, y);
		}
		
		static public function factoral(value:uint):Number
		{
			//return special case
			if (value==0)
				return 1;
			//calc factoral of value
			var total:Number = value;
			while (--value>1)
				total *= value;
			//return result
			return total;
		}

	}
}