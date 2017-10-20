package leveleditor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import leveleditor.data.GameObject;
	import leveleditor.data.LevelDataVO;
	import leveleditor.events.ImportEvent;
	import leveleditor.events.MenuEvent;

	public class ImportPanel extends BaseUIComponent
	{
		private var background:Sprite;

		private var dialog:ImportDialog;
		
		public function ImportPanel( )
		{
			hide( );
		}
		
		override protected function inited( ):void
		{
			addChild( background = new Sprite );
			background.graphics.beginFill( 0x000000, .5 );
			background.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			background.graphics.endFill( );
			
			addChild( dialog = new ImportDialog );
			dialog.inputText.text = '';
			dialog.importButton.addEventListener( MouseEvent.CLICK, startImport );
			dialog.closeButton.addEventListener( MouseEvent.CLICK, closeButtonHandler );
			
			stageResized( );
		}
		
		override protected function stageResized( ):void
		{
			background.width = stage.stageWidth;
			background.height = stage.stageHeight;
			
			dialog.x = width / 2 - dialog.width / 2;
			dialog.y = height / 2 - dialog.height / 2;
		}
		
		protected function closeButtonHandler( e:MouseEvent ):void
		{
			dispatchEvent( new MenuEvent( MenuEvent.CLOSE_REQUEST ) );
		}
		
		protected function startImport( e:MouseEvent ):void
		{
			var data:String = dialog.inputText.text;
			var levelData:LevelDataVO;
			
			levelData = convertJSONDataToLevelData( JSON.parse( data ) );
			dispatchEvent( new ImportEvent( ImportEvent.DATA_IMPORTED, levelData ) );
		}
		
		protected function convertJSONDataToLevelData( data:Object ):LevelDataVO
		{
			var levelData:LevelDataVO = new LevelDataVO;
			
			for ( var i:uint = 0; i < data.groundPoints.length; i++ )
			{
				levelData.groundPoints.push( new Point( data.groundPoints[i].x, data.groundPoints[i].y ) );
			}
			
			for ( i = 0; i < data.starPoints.length; i++ )
			{
				levelData.starPoints.push( new Point( data.starPoints[i].x, data.starPoints[i].y ) );
			}
			
			for ( i = 0; i < data.gameObjects.length; i++ )
			{
				var gameObject:GameObject = new GameObject();
				gameObject.x = data.gameObjects[i].x;
				gameObject.y = data.gameObjects[i].y;
				gameObject.pivotX = data.gameObjects[i].pivotX;
				gameObject.pivotY = data.gameObjects[i].pivotY;
				gameObject.rotation = data.gameObjects[i].rotation;
				gameObject.scaleX = data.gameObjects[i].scaleX;
				gameObject.scaleY = data.gameObjects[i].scaleY;
				gameObject.texture = data.gameObjects[i].texture;
				
				levelData.gameObjects.push( gameObject );
			}
			
			for ( i = 0; i < data.bridgePoints.length; i++ )
			{
				levelData.bridgePoints.push( { 
					bridgeAX: data.bridgePoints[i].bridgeAX, 
					bridgeAY: data.bridgePoints[i].bridgeAY,
					bridgeBX: data.bridgePoints[i].bridgeBX,
					bridgeBY: data.bridgePoints[i].bridgeBY
				} );
			}
			
			levelData.cameraBounds = new Rectangle( data.cameraBounds.x, data.cameraBounds.y, data.cameraBounds.width, data.cameraBounds.height );
			
			levelData.worldId = data.worldId;
			levelData.levelId = data.levelId;
			levelData.startPoint = data.startPoint;
			levelData.finishPoint = data.finishPoint;
			levelData.starValues = data.starValues;
			levelData.libraryElements = data.libraryElements;

			return levelData;
		}
		
		public function show( ):void
		{
			visible = true;
			
			dialog.inputText.text = '';
		}

		public function hide( ):void
		{
			visible = false;
		}
		
	}
}