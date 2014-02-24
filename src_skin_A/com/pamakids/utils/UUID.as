package com.pamakids.utils
{
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	/**
	 * 唯一ID生成器
	 * @author mani
	 */
	public class UUID
	{
		// Char codes for 0123456789ABCDEF
		private static const ALPHA_CHAR_CODES:Array=[48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];

		private var buff:ByteArray;
		private var str:String;

		public function UUID()
		{
			str=null;
			var r:uint=uint(new Date().time);
			buff=new ByteArray();
			buff.writeUnsignedInt(System.totalMemory ^ r);
			buff.writeInt(getTimer() ^ r);
			buff.writeDouble(Math.random() * r);
		}

		public function toString():String
		{
			if (str)
				return str
			buff.position=0;
			var chars:Array=new Array(36);
			var index:uint=0;
			for (var i:uint=0; i < 16; i++)
			{
				if (i == 4 || i == 6 || i == 8 || i == 10)
				{
					chars[index++]=45; // Hyphen char code
				}
				var b:int=buff.readByte();
				chars[index++]=ALPHA_CHAR_CODES[(b & 0xF0) >>> 4];
				chars[index++]=ALPHA_CHAR_CODES[(b & 0x0F)];
			}
			str=String.fromCharCode.apply(null, chars);
			str=DateUtil.getDateString(0, 0, true) + '-' + str;
			return str;
		}
	}
}
