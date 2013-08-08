package org.agony2d.utils {

public class ArrayUtil {
	
	/** 产生一个洗牌后的新数组 */
	public static function shuffle( AY:Array ) : Array {
		var index:int, i:int, l:int
		var result:Array, tAY:Array
		var item:*
		
		result  =  []
		tAY     =  AY.concat()
		l       =  tAY.length
		while (--l > -1) {
			index        =  (l + 1) * Math.random()
			result[i++]  =  tAY[index]
			tAY[index]   =  tAY[l]
		}
		return result
	}
	
	/** 随机抽取一个数组单位
	 *  @param	AY
	 *  @param	discard		是否丢弃，true时会丢弃[ 会影响数组次序 ]
	 *  @param	startIndex	开始索引[ 包含其自身 ]
	 *  @param	length		长度
	 *  @return	被抽取的对象
	 */
	public static function pullRandom( AY:Array, discard:Boolean = true, startIndex:int = 0, length:int = -1 ) : * {
		var index:int, l:int
		var item:*
		
		l      =  AY.length
		index  =  startIndex + Math.random() * ((startIndex + length > l || length <= 0) ? l - startIndex : length)
		item   =  AY[index]
		if (item && discard) {
			if (index + 1 < l) {
				AY[index] = AY.pop()
			}
			else {
				AY.pop()
			}
		}
		return item
	}
}
}