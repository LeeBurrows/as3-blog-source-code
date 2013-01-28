/**
 * SavingImagesExample2.as by Lee Burrows
 * Jan 6, 2011
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
	import com.bit101.components.PushButton;
	import com.leeburrows.utilities.encoders.ThreadedJPEGencoder;
	import com.leeburrows.utilities.encoders.events.ThreadedEncoderEvent;
	import com.leeburrows.utilities.encoders.interfaces.IThreadedImageEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.FileReference;

	[SWF(backgroundColor="#F0F0F0", frameRate="30", width="400", height="400")]
	public class SavingImagesExample2 extends Sprite
	{
		private var bitmap:Bitmap;
		private var file:FileReference;
		//ThreadedJPEGencoder and ThreadedPNGencoder both implement IThreadedImageEncoder
		private var encoder:IThreadedImageEncoder;
		
		private var btnEncode:PushButton;
		private var btnSave:PushButton;
		private var bar:Shape;

		public function SavingImagesExample2()
		{
			//create a bitmap image to save
			buildBitmap();
			//add buttons and progress bar
			buildControls();
			//setup encoding object
			buildEncoder();
			//setup FileReference object
			buildFileRef();
		}
		
		private function buildBitmap():void
		{
			//create a 2000x2000 bitmap
			bitmap = new Bitmap(new BitmapData(2000, 2000, false, 0x000000));
			bitmap.x = 50;
			bitmap.y = 50;
			//scale it down so we can see it all
			bitmap.scaleX = bitmap.scaleY = 0.15;
			//fill bitmap with random coloured squares
			var rect:Rectangle = new Rectangle();
			for (var i:uint=0;i<1000;i++)
			{
				rect.x = Math.random()*2000;
				rect.y = Math.random()*2000;
				rect.width = 20+Math.random()*100;
				rect.height = 20+Math.random()*100;
				bitmap.bitmapData.fillRect(rect, Math.random()*0xFFFFFF);
			}
			//add to stage
			addChild(bitmap);
		}

		private function buildControls():void
		{
			//add start encoding button
			btnEncode = new PushButton(this, 100, 15, "Encode Bitmap", clickHandler);
			btnEncode.width = 200;
			addChild(btnEncode);
			//add progress bar
			bar = new Shape();
			bar.graphics.clear();
			bar.graphics.beginFill(0xFF0000, 0.25);
			bar.graphics.drawRect(0, 0, 380, 5);
			bar.x = 10;
			bar.y = 360;
			addChild(bar);
			//add save button
			btnSave =new PushButton(this, 100, 370, "Save", clickHandler);
			btnSave.width = 200;
			btnSave.enabled = false;
			addChild(btnSave);
		}

		private function buildEncoder():void
		{
			//use this line to encode as a JPG, argument defines quality (1-100)
			encoder = new ThreadedJPEGencoder(80);
			//use this line to encode as a PNG
			//encoder = new ThreadedPNGencoder();
			//add encoder listeners
			encoder.addEventListener(ThreadedEncoderEvent.PROGRESS, encodingHandler);
			encoder.addEventListener(ThreadedEncoderEvent.COMPLETED, encodingHandler);
		}

		
		private function buildFileRef():void
		{
			file = new FileReference();
			//add all available listeners
			file.addEventListener(Event.OPEN, fileEventHandler);
			file.addEventListener(ProgressEvent.PROGRESS, fileEventHandler);
			file.addEventListener(Event.COMPLETE, fileEventHandler);
			file.addEventListener(Event.CANCEL, fileEventHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, fileEventHandler);
		}

		private function clickHandler(event:MouseEvent):void
		{
			if (event.target==btnEncode)
				//if btnEncode clicked then start encoding (for 30 milliseconds each frame)
				encoder.encode(bitmap.bitmapData, 30);
			else if (event.target==btnSave)
				//if btnSave clicked then save image
				saveImage();
		}
		
		private function encodingHandler(event:ThreadedEncoderEvent):void
		{
			//update progress bar
			bar.graphics.clear();
			bar.graphics.beginFill(0xFF0000, 0.25);
			bar.graphics.drawRect(0, 0, 380, 5);
			bar.graphics.beginFill(0xFF0000);
			bar.graphics.drawRect(0, 0, event.ratioComplete*380, 5);
			bar.graphics.endFill();
			//if encoding complete, enable save button
			if (event.type==ThreadedEncoderEvent.COMPLETED)
				btnSave.enabled = true;
		}
		
		private function fileEventHandler(event:Event):void
		{
			//trace out any file events
			trace(event.toString());
		}
		
		private function saveImage():void
		{
			//use this line to save as a JPG
			file.save(encoder.data, "myImage.jpg");
			//use this line to save as a PNG
			//file.save(encoder.data, "myImage.png");
		}
		
	}
}