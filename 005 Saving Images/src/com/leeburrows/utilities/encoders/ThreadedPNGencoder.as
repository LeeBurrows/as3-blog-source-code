/**
 * ThreadedPNGencoder.as by Lee Burrows
 * Dec 31, 2010
 * Visit blog.leeburrows.com for more stuff
 *
 * Code based on PNGEncoder.as which is part of as3corelib (https://github.com/mikechambers/as3corelib)
 * as3corelib is Copyright (c) 2008, Adobe Systems Incorporated. All rights reserved
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
package com.leeburrows.utilities.encoders
{
	import com.leeburrows.utilities.encoders.events.ThreadedEncoderEvent;
	import com.leeburrows.utilities.encoders.interfaces.IThreadedImageEncoder;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	public class ThreadedPNGencoder extends Sprite implements IThreadedImageEncoder
	{
		public function ThreadedPNGencoder()
		{
			super();
			initializeCRCTable();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Used for computing the cyclic redundancy checksum
		 *  at the end of each chunk.
		 */
		private var crcTable:Array;
		
		
		private var png:ByteArray;
		private var IDAT:ByteArray;
		
		private var bitmapData:BitmapData;
		private var bitmapWidth:uint;
		private var bitmapHeight:uint;
		private var bitmapTransparent:Boolean;
		
		private var xpos:uint;
		private var ypos:uint;
		
		private var blocksDone:uint;
		private var blocksTotal:uint;
		
		private var maxFrameTime:uint;
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function encode(bitmapData:BitmapData, maxFrameTime:uint=30):void
		{
			png = new ByteArray();
			this.bitmapData = bitmapData.clone();
			this.maxFrameTime = maxFrameTime;
			bitmapWidth = bitmapData.width;
			bitmapHeight = bitmapData.height;
			bitmapTransparent = bitmapData.transparent;
			// Write PNG signature
			png.writeUnsignedInt(0x89504E47);
			png.writeUnsignedInt(0x0D0A1A0A);
			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(bitmapWidth);
			IHDR.writeInt(bitmapHeight);
			IHDR.writeByte(8); // bit depth per channel
			IHDR.writeByte(6); // color type: RGBA
			IHDR.writeByte(0); // compression method
			IHDR.writeByte(0); // filter method
			IHDR.writeByte(0); // interlace method
			writeChunk(png, 0x49484452, IHDR);
			// Image
			IDAT = new ByteArray();
			IDAT.writeByte(0);
			//ratio
			blocksDone = 0;
			blocksTotal = bitmapWidth*bitmapHeight;
			xpos = 0;
			ypos = 0;
			//start
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			if (internalEncode())
			{
				this.removeEventListener(Event.ENTER_FRAME, loop);
				encodeFinish();
			}
			else
				dispatchEvent(new ThreadedEncoderEvent(ThreadedEncoderEvent.PROGRESS, blocksDone/blocksTotal));
		}

		private function encodeFinish():void
		{
			IDAT.compress();
			writeChunk(png, 0x49444154, IDAT);
			// Build IEND chunk
			writeChunk(png, 0x49454E44, null);
			//end
			png.position = 0;
			dispatchEvent(new ThreadedEncoderEvent(ThreadedEncoderEvent.COMPLETED, 1, png));
		}

		public function get data():ByteArray
		{
			return png;
		}

		private function initializeCRCTable():void
		{
			crcTable = [];
			
			for (var n:uint = 0; n < 256; n++)
			{
				var c:uint = n;
				for (var k:uint = 0; k < 8; k++)
				{
					if (c & 1)
						c = uint(uint(0xedb88320) ^ uint(c >>> 1));
					else
						c = uint(c >>> 1);
				}
				crcTable[n] = c;
			}
		}
		
		private function internalEncode():Boolean
		{
			var endTime:uint = getTimer()+maxFrameTime;
			var pixel:uint;
			while (endTime>getTimer())
			{
				if (!bitmapTransparent)
				{
					pixel = bitmapData.getPixel(xpos, ypos);
					IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | 0xFF));
				}
				else
				{
					pixel = bitmapData.getPixel32(xpos, ypos);
					IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | (pixel >>> 24)));
				}
				blocksDone++;
				xpos++;
				if (xpos>=bitmapWidth)
				{
					xpos = 0;
					ypos++;
					if (ypos>=bitmapHeight)
					{
						return true;
					}
					else
						IDAT.writeByte(0);
				}
			}
			return false;
		}
		
		private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void
		{
			// Write length of data.
			var len:uint = 0;
			if (data)
				len = data.length;
			png.writeUnsignedInt(len);
			
			// Write chunk type.
			var typePos:uint = png.position;
			png.writeUnsignedInt(type);
			
			// Write data.
			if (data)
				png.writeBytes(data);
			
			// Write CRC of chunk type and data.
			var crcPos:uint = png.position;
			png.position = typePos;
			var crc:uint = 0xFFFFFFFF;
			for (var i:uint = typePos; i < crcPos; i++)
			{
				crc = uint(crcTable[(crc ^ png.readUnsignedByte()) & uint(0xFF)] ^
					uint(crc >>> 8));
			}
			crc = uint(crc ^ uint(0xFFFFFFFF));
			png.position = crcPos;
			png.writeUnsignedInt(crc);
		}

	}
}
