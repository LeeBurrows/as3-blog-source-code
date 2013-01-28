/**
 * PixelBenderFiltersExample1.as by Lee Burrows
 * Jan 27, 2011
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
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ShaderFilter;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	[SWF(backgroundColor="#333333", frameRate="30", width="400", height="400")]
	public class PixelBenderFiltersExample1 extends Sprite
	{
		private var bitmap:Bitmap;
		private var source:BitmapData;
		
		private var shader:Shader;
		private var filter:ShaderFilter;
		
		private var angle:Number;
		
		[Embed(source="../assets/kaleidoscope.pbj", mimeType="application/octet-stream")]
		private var pbClass:Class;

		public function PixelBenderFiltersExample1()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//create bitmap and add to stage
			var bmd:BitmapData = new BitmapData(400, 400, true, 0x00000000);
			bitmap = new Bitmap(bmd);
			addChild(bitmap);
			
			//create shader and shader filter
			shader = new Shader(new pbClass() as ByteArray);
			shader.data.originX.value = [200];
			shader.data.originY.value = [200];
			shader.data.sections.value = [3];
			shader.data.maxRadius.value = [190];
			filter = new ShaderFilter(shader);
			
			//generate some random ellipses
			var shape:Shape = new Shape();
			for (var i:uint=0;i<100;i++)
			{
				shape.graphics.beginFill(getColour(), Math.random());
				shape.graphics.drawEllipse(400*Math.random(), 400*Math.random(), 100*Math.random(), 100*Math.random());
			}
			//copy random shapes to a BitmapData object
			source = new BitmapData(400, 400, true, 0x00000000);
			source.draw(shape);
			
			//set initial angle
			angle = 0;

			//start looping
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			//update angle parameter in shader
			angle += Math.PI/300;
			shader.data.reflectionAngle.value = [angle];
			//reapply shader to filter
			filter = new ShaderFilter(shader);
			//apply filter to source and place result in bitmap.bitmapData
			bitmap.bitmapData.applyFilter(source, source.rect, new Point(), filter);
		}
		
		private function getColour():uint
		{
			//return a random colour (0xRRGGBB)
			var r:uint = 0xFF*Math.random();
			var g:uint = 0xFF*Math.random();
			var b:uint = 0xFF*Math.random();
			return r<<16 | g<<8 | b;
		}
		
	}
}

