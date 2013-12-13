package assets
{
	public class SoundAssets
	{
		public function SoundAssets()
		{
		}
		
		[Embed(source="/data/sounds/press.mp3")]public static const press:Class;
		
		[Embed(source="sounds/cnlet.mp3")]public static const cnlet:Class;
		[Embed(source="sounds/del.mp3")]public static const del:Class;
		[Embed(source="sounds/logo.mp3")]public static const logo:Class;
		
	}
}