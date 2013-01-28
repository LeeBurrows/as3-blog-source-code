/**
 * PixelBenderFiltersExample4.as by Lee Burrows
 * Feb 11, 2011
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
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ShaderEvent;
	import flash.utils.ByteArray;
	
	[SWF(backgroundColor="#333333", frameRate="30", width="300", height="300")]
	public class PixelBenderFiltersExample4 extends Sprite
	{
		private var sourceBitmap:Bitmap;
		private var displayBitmap:Bitmap;

		private var shader:Shader;
		
		private var shaderJob:ShaderJob;
		
		//embed the PixelBender file
		[Embed(source="../assets/pbDemo2.pbj", mimeType="application/octet-stream")]
		private var pbClass:Class;

		//embed the image
		[Embed(source="../assets/pbImage.jpg")]
		private var imgClass:Class;

		public function PixelBenderFiltersExample4()
		{
			super();
			init();
		}
		
		private function init():void
		{
			//add source bitmap
			sourceBitmap = new imgClass() as Bitmap;
			
			//add display bitmap
			displayBitmap = new Bitmap(sourceBitmap.bitmapData.clone());
			addChild(displayBitmap);

			//create Shader object
			shader = new Shader(new pbClass() as ByteArray);
			//set non-changing parameters
			shader.data.src.input = sourceBitmap.bitmapData;

			//listen for mouse movement
			stage.addEventListener(MouseEvent.MOUSE_MOVE, update);
		}
		
		private function update(event:MouseEvent):void
		{
			//update parameters in shader
			shader.data.xval.value = [event.stageX/300];
			shader.data.yval.value = [event.stageY/300];
			//create a shader job
			shaderJob = new ShaderJob(shader, displayBitmap.bitmapData);
			//add listener for job completion
			shaderJob.addEventListener(ShaderEvent.COMPLETE, completeHandler);
			//run job
			shaderJob.start();
		}
		
		private function completeHandler(event:Event):void
		{
			shaderJob.removeEventListener(ShaderEvent.COMPLETE, completeHandler);
			trace("shader job has completed");
		}
		
	}
}

