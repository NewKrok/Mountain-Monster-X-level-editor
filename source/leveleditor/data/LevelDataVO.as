package leveleditor.data
{
	import flash.geom.Rectangle;
	
	public class LevelDataVO
	{
		public var worldId:int = 0;
		public var levelId:int = 0;
		
		public var cameraBounds:Rectangle;
		public var starValues:Array = [];
		public var groundPoints:Array = [];
		public var starPoints:Array = [];
		public var bridgePoints:Array = [];
		public var libraryElements:Array = [];
		public var gameObjects:Array = [];
		public var startPoint:Object = {};
		public var finishPoint:Object = {};
	}
}