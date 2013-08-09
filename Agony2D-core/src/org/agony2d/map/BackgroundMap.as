package org.agony2d.map 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import org.agony2d.utils.MathUtil;

	/**
	 *                         walkable      property 
	 *                             ↓            ↓
	 * 0x 1111 1111 - 1111 1111 - 1111 - 1111 1111 1111
	 */
public class BackgroundMap 
{
	
	
	private const tile_walkableFlag:uint = 0xF000
	
	
	final public function get mapWidth()  : int { return m_numColumns * m_tileSize }
	final public function get mapHeight() : int { return m_numRows    * m_tileSize }
	
	final public function get numColumns() : int { return m_numColumns }
	final public function get numRows()    : int { return m_numRows }
	
	final public function get numImagesColumns():int { return Math.ceil(this.mapWidth  / m_splitSize) }
	final public function get numImagesRows():int    { return Math.ceil(this.mapHeight / m_splitSize) }
	
	final public function get filePath() : String { return m_filePath }
	final public function get source() : BitmapData { return m_source }
	
	
	final public function reset( source:BitmapData, tileSize:Number, splitSize:int, filePath:String ) : Boolean
	{
		var i:int
		var data:Vector.<uint>
		
		if (!MathUtil.isInt(source.width / tileSize) || !MathUtil.isInt(source.height / tileSize))
		{
			return false
		}
		
		if (m_source)
		{
			m_source.dispose()
		}
		
		m_source      =  source
		m_tileSize    =  tileSize
		m_splitSize   =  splitSize
		m_numColumns  =  source.width / tileSize
		m_numRows     =  source.height / tileSize
		m_filePath    =  filePath
		m_mapData     =  new Vector.<Vector.<uint>>(numRows, true)
		
		for (i = 0; i < numRows; i++)
		{
			m_mapData[i] = new Vector.<uint>(numColumns, true)
		}
		
		return true
	}
	
	public function getWalkableAt() : Boolean
	{
		return Boolean(m_mapData[numRows][numColumns] & tile_walkableFlag)
	}
	
	public function setWalkableAt( numColumns:int, numRows:int, b:Boolean ) : void
	{
		if (b)
		{
			m_mapData[numRows][numColumns] |= tile_walkableFlag
		}
		else
		{
			m_mapData[numRows][numColumns] &= ~tile_walkableFlag
		}
	}
	
	public function getPropertyAt() : uint
	{
		return m_mapData[numRows][numColumns] & 0xFF
	}
	
	public function setPropertyAt( numColumns:int, numRows:int, property:uint ) : void
	{
		m_mapData[numRows][numColumns] &= ~0xFF
		m_mapData[numRows][numColumns] |= property
	}
	
	public function toMapX( x:int ) : Number
	{
		return Math.round(x / m_tileSize)
	}
	
	public function toMapY( y:int ) : Number
	{
		return Math.round(y / m_tileSize)
	}
	
	public function toScreenX( x:int ) : Number
	{
		return x * m_tileSize
	}
	
	public function toScreenY( y:int ) : Number
	{
		return y * m_tileSize
	}
	
	final public function fromByteArray( bytes:ByteArray ) : void
	{
		
	}
	
	final public function toByteArray() : ByteArray
	{
		var bytes:ByteArray
		var i:int, ii:int
		
		bytes = new ByteArray()
		bytes.writeShort(m_tileSize)
		bytes.writeShort(m_splitSize)
		bytes.writeShort(m_numColumns)
		bytes.writeShort(m_numRows)
		bytes.writeUTF(m_filePath)
		
		for (i = 0; i < m_numRows; i++)
		{
			for (ii = 0; ii < m_numColumns; ii++)
			{
				bytes.writeUnsignedInt(m_mapData[i][ii])
			}
		}
		return bytes
	}
	
	public function toString():String{
		return "Tile尺寸 :"+m_tileSize+
			   "\nTile数目 :"+m_numColumns+"×"+m_numRows+
			   "\nSplit尺寸 :"+m_splitSize+
			   "\nSplit数目 :"+this.numImagesColumns+"×"+this.numImagesRows+
			   "\n地图范围 :"+this.mapWidth+"×"+this.mapHeight
	}
	
	public function dispose() : void
	{
		if(m_source)
		{
			m_source.dispose()
			m_source = null
		}
		m_mapData = null
	}
	
	
	private var m_tileSize:int, m_numColumns:int, m_numRows:int, m_splitSize:int;
	
	private var m_mapData:Vector.<Vector.<uint>>
	
	private var m_source:BitmapData
	
	private var m_filePath:String
	
}

}