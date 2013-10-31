package org.agony2d.utils.bytes {
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
public class BytesUtil {
	
	/** 合并ByteArray列表... */
	public static function merge( AY:Array, result:ByteArray = null ) : ByteArray {
		var bytes_A:ByteArray
		var i:int, l:int
		
		if (!result) {
			result = new ByteArray
		}
		else if (result.bytesAvailable) {
			result.position = result.length
		}
		l = AY.length
		while (i < l) {
			bytes_A = AY[i++]
			if(bytes_A){
				result.writeUnsignedInt(bytes_A.length)
				result.writeBytes(bytes_A)
			}
			else {
				result.writeUnsignedInt(0)
			}
		}
		return result
	}
	
	/** 拆散ByteArray列表，若单个ByteArray中不存在数据，为null... */
	public static function unmerge( bytes:ByteArray ) : Array {
		var AY:Array
		var i:int, offset:int, length:int
		var bytes_A:ByteArray
		
		bytes.position = 0
		AY = []
		while (bytes.bytesAvailable) {
			length = bytes.readUnsignedInt()
			AY[i++] = bytes_A = (length > 0) ? new ByteArray : null
			if (bytes_A) {
				bytes_A.writeBytes(bytes, offset + 4, length)
			}
			offset += length + 4
			bytes.position = offset
		}
		return AY
	}
	
	
	
	
	
	
	
	

	
	
    private static var bytes:ByteArray;
    private static var className:Array ;
    private static var tagNum:int ;
    public static function getSWFClazz(swfBytes:ByteArray):Array
    {
        tagNum = 0 ;
        className = [];
        
        bytes = new ByteArray();
        bytes.writeBytes(swfBytes);
        bytes.position = 0;
        bytes.endian = Endian.LITTLE_ENDIAN ;
        
        var compressModal:String ;
        
        compressModal = bytes.readUTFBytes(3);
        if (compressModal != "FWS" && compressModal != "CWS") {
            throw new Error("不能识别的SWF文件格式");
        }
        bytes.readByte()
        bytes.readUnsignedInt();
        bytes.readBytes(bytes);
        bytes.length = bytes.length - 8;
        
        if (compressModal == "CWS") {
            bytes.uncompress();
        }
        bytes.position=13
        
        var tag:int;
        var tagFlag:int;
        var tagLength:int;
        
        var tagBytes:ByteArray ;
        while (bytes.bytesAvailable) {
            readSWFTag(bytes);
        }
        return className.splice(0,className.length);
    }
    
    private static function readSWFTag(tagBytes:ByteArray):void 
    {
        var tag:int=tagBytes.readUnsignedShort();
        //   tracer("tag = " + tag);
        var tagFlag:int=tag >> 6;
        var tagLength:int=tag & 63;   
        if ((tagLength & 63 )== 63) {
            tagLength = tagBytes.readUnsignedInt();
        }
        if (tagFlag == 76) {
            var tagContent:ByteArray=new ByteArray () ;
            if (tagLength != 0) {
                tagBytes.readBytes(tagContent,0,tagLength);
            }
            getClass(tagContent);
        } else {
            tagBytes.position=tagBytes.position + tagLength;
        }
    }
    
    private static function getClass(tagBytes:ByteArray):void {
        var name:String;   
        var readLength:int = readUI16(tagBytes);
        var count:int=0;   
        while (count < readLength) {    
            readUI16(tagBytes);    
            name = readSwfString(tagBytes); 
            
            className.push(name);
            count++;
            tagNum++
            if(tagNum>400){
                return 
            }
        }
    }
    
    private static function readSwfString(tagBytes:ByteArray):String {
        var nameBytes:ByteArray;
        var length:int = 1;
        var num:int = 0;
        var name:String;
        while (true) {
            num = tagBytes.readByte();    
            if (num == 0) {
                nameBytes = new ByteArray () ;
                nameBytes.writeBytes(tagBytes,tagBytes.position - length,length);
                nameBytes.position = 0;
                name=nameBytes.readUTFBytes(length);
                break;
            }
            length++;
        }
        return name;
    }
    
    private static function readUI16(bytes:ByteArray):int {
        var num1:* =bytes.readUnsignedByte();
        var num2:* =bytes.readUnsignedByte();   
        return num1 +(num2 << 8);
    }
	
}

}