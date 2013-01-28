/**
 * SavingImagesExample1.as by Lee Burrows
 * Dec 31, 2010
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
	import com.adobe.images.JPGEncoder;
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	[SWF(backgroundColor="#F0F0F0", frameRate="30", width="400", height="400")]
	public class SavingImagesExample1 extends Sprite
	{
		private var bitmap:Bitmap;
		
		private var file:FileReference;
		
		private var ba:ByteArray;

		private var btnSave:PushButton;

		public function SavingImagesExample1()
		{
			//create a bitmap image to save
			buildBitmap();
			//add a button to allow user to initiate saving
			buildControls();
			//setup FileReference object
			buildFileRef();
		}
		
		private function buildBitmap():void
		{
			//create a 300x300 bitmap
			bitmap = new Bitmap(new BitmapData(300, 300, false, 0x000000));
			bitmap.x = 50;
			bitmap.y = 50;
			//fill bitmap with random coloured squares
			var rect:Rectangle = new Rectangle();
			for (var i:uint=0;i<100;i++)
			{
				rect.x = Math.random()*300;
				rect.y = Math.random()*300;
				rect.width = 10+Math.random()*30;
				rect.height = 10+Math.random()*30;
				bitmap.bitmapData.fillRect(rect, Math.random()*0xFFFFFF);
			}
			//add bitmap to stage
			addChild(bitmap);
		}

		private function buildControls():void
		{
			//add save button
			btnSave = new PushButton(this, 100, 15, "Save Bitmap", clickHandler);
			btnSave.width = 200;
			addChild(btnSave);
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
			//use these lines to convert to JPG
			var encoder:JPGEncoder = new JPGEncoder(80);
			ba = encoder.encode(bitmap.bitmapData);
			//use this line to convert to PNG
			//ba = PNGEncoder.encode(bitmap.bitmapData);
			//save resulting byteArray
			saveImage();
		}

		private function fileEventHandler(event:Event):void
		{
			//trace out any file events
			trace(event.toString());
		}
		
		private function saveImage():void
		{
			//use this line to save as a JPG
			file.save(ba, "myImage.jpg");
			//use this line to save as a PNG
			//file.save(ba, "myImage.png");
		}
		
	}
}