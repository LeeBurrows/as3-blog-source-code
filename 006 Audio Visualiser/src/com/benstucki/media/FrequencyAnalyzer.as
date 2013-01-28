package com.benstucki.media {
	
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class FrequencyAnalyzer {
		
		public static const CHANNEL_LEFT:String = "left";
		public static const CHANNEL_RIGHT:String = "right";
		public static const CHANNEL_MONO:String = "mono";
		
		// values above 11025 may be duplicate
		public static const FOUR_BAND:Array = [125, 500, 1000, 2000];
		public static const FOUR_BAND_VISUAL:Array = [250, 400, 600, 800];
		public static const EIGHT_BAND:Array = [63, 125, 500, 1000, 2000, 4000, 6000, 8000];
		public static const TEN_BAND:Array = [31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];// ~= ISO Standard, ITunes & WinAmp
		public static const TWENTY_SIX_BAND_CUSTOM:Array = [25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000];
		public static const THIRTY_ONE_BAND:Array = [20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, 16000, 20000]; // Behringer 3102
		
		/**
		 * Returns approxamite spectral density (amplitude) for the frequency bands defined.
		 * @param frequencies An array of center frequencies used to define each frequency band.
		 * @param bandwidth The bandwidth, in octaves, of each frequency band.
		 * @param channel The channel used for sampling: left, right or mono.
		 * @param stretchFactor Used to determine the sampling rate.
		 * @return A Vector.<Number> of amplitude values for each frequency band defined. The length of this vector will match the length of the frequencies array.
		**/
		public static function computeFrequencies(frequencies:Array, bandwidth:Number = 1, channel:String = "mono", stretchFactor:int = 0):Vector.<Number> {
			var bytes:ByteArray = new ByteArray();
			SoundMixer.computeSpectrum(bytes, true, stretchFactor);
			var spectrum:Vector.<Number>;
			if(channel==FrequencyAnalyzer.CHANNEL_LEFT) {
				spectrum = toLeft(bytes);
			} else if(channel==FrequencyAnalyzer.CHANNEL_RIGHT) {
				spectrum = toRight(bytes);
			} else {
				spectrum = toMono(bytes);
			}
			var output:Vector.<Number> = computeFrequencyBands(spectrum, frequencies, bandwidth, stretchFactor);
			return output;
		}
		
		public static function sampleFrequencyBands(spectrum:Vector.<Number>, frequencies:Array, stretchFactor:int = 0):Vector.<Number> {
			var length:int = frequencies.length;
			var sampleRate:Number = 44100/(stretchFactor+1);
			var output:Vector.<Number> = new Vector.<Number>(length, true);
			for(var i:int = 0; i < length; i++) {
				var frequency:Number = frequencies[i];
				var index:int = frequencyToIndex(frequency, sampleRate);
				output[i] = spectrum[Math.min(index, 255)];
			}
			return output;
		}
		
		public static function computeFrequencyBands(spectrum:Vector.<Number>, frequencies:Array, bandwidth:Number = 1, stretchFactor:int = 0):Vector.<Number> {
			var length:int = frequencies.length;
			var sampleRate:Number = (stretchFactor == 0) ? 44100 : 44100/(stretchFactor*2);
			var output:Vector.<Number> = new Vector.<Number>(length, true);
			for(var i:int = 0; i < length; i++) {
				var frequency:Number = frequencies[i];
				output[i] = computeFrequencyBand(spectrum, frequency, bandwidth, sampleRate);
			}
			return output;
		}
		
		public static function toMono( bytes:ByteArray ):Vector.<Number> {
			bytes.position = 0;
			var output:Vector.<Number> = new Vector.<Number>(256, true);
			if(bytes.length==2048) {
				var left:ByteArray = new ByteArray();
				var right:ByteArray = new ByteArray();
				bytes.readBytes(left, 0, 1024);
				bytes.readBytes(right, 0, 1024);
				for (var i:uint = 0; i < 256 ; i++) {
					output[i] = (left.readFloat()+right.readFloat())/2;
				}
				bytes.position = 0;
			}
			return output;
		}
		
		public static function toLeft( bytes:ByteArray ):Vector.<Number> {
			bytes.position = 0;
			var output:Vector.<Number> = new Vector.<Number>(256, true);
			if(bytes.length==2048) {
				for (var i:uint = 0; i < 256 ; i++) {
					output[i] = bytes.readFloat();
				}
				bytes.position = 0;
			}
			return output;
		}
		
		public static function toRight( bytes:ByteArray ):Vector.<Number> {
			bytes.position = 0;
			var output:Vector.<Number> = new Vector.<Number>(256, true);
			if(bytes.length==2048) {
				bytes.position = 1023;
				for (var i:uint = 0; i < 256 ; i++) {
					output[i] = bytes.readFloat();
				}
				bytes.position = 0;
			}
			return output;
		}
		
		private static function computeFrequencyBand(spectrum:Vector.<Number>, frequency:Number, bandwidth:Number, sampleRate:Number):Number {
			var max:Number = 0;
			var indexMin:int = frequencyToIndex(frequency/(bandwidth+1), sampleRate);
			var indexMax:int = Math.min(frequencyToIndex(frequency*(bandwidth+1), sampleRate), 255);
			for(var i:int = indexMin; i <= indexMax; i++) {
				max = Math.max(spectrum[i], max);
			}
			return max;
		}
		
		private static function frequencyToIndex(frequency:Number, sampleRate:Number):int {
			return Math.min(Math.round(frequency/sampleRate * 1024), 255);
		}
		
	}
}