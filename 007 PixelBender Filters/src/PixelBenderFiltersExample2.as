/**
 * PixelBenderFiltersExample2.as by Lee Burrows
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
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;
	
	[SWF(backgroundColor="#333333", frameRate="30", width="400", height="200")]
	public class PixelBenderFiltersExample2 extends Sprite
	{
		private var shape:Shape;
		
		private var shader:Shader;
		private var filter:ShaderFilter;
		
		//embed the PixelBender file
		[Embed(source="../assets/pbDemo1.pbj", mimeType="application/octet-stream")]
		private var pbClass:Class;

		public function PixelBenderFiltersExample2()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//create Shader object
			shader = new Shader(new pbClass() as ByteArray);
			//set parameters
			shader.data.fade.value = [0.5];
			//create ShaderFilter object as a wrapper for our Shader
			filter = new ShaderFilter(shader);
			
			//generate some random ellipses
			shape = new Shape();
			for (var i:uint=0;i<100;i++)
			{
				shape.graphics.beginFill(getColour(), Math.random());
				shape.graphics.drawEllipse(400*Math.random(), 200*Math.random(), 100*Math.random(), 100*Math.random());
			}
			//add to stage
			addChild(shape);

			//listen for mouse movement
			stage.addEventListener(MouseEvent.MOUSE_MOVE, update);
		}
		
		private function update(event:MouseEvent):void
		{
			//update parameter in shader
			shader.data.fade.value = [event.stageX/400];
			//reapply shader to filter
			filter = new ShaderFilter(shader);
			//apply filter to object
			shape.filters = [filter];
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

