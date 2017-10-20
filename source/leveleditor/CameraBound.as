package leveleditor
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class CameraBound extends Sprite
	{
		private var editorWorld:EditorWorld;
		
		var lt:NodeView = new NodeView();
		var rt:NodeView = new NodeView();
		var rb:NodeView = new NodeView();
		var lb:NodeView = new NodeView();
		
		var draggedElement:NodeView;
		
		public function CameraBound(editorWorld:EditorWorld)
		{
			this.editorWorld = editorWorld;
			
			addChild(lt);
			addChild(rt);
			addChild(rb);
			addChild(lb);
		}
		
		public function init(rect:Rectangle):void
		{
			lt.x = rect.x;
			lt.y = rect.y;
			lt.addEventListener( MouseEvent.MOUSE_DOWN, startDragHandler );
			
			rt.x = rect.x + rect.width;
			rt.y = rect.y;
			rt.addEventListener( MouseEvent.MOUSE_DOWN, startDragHandler );
			
			rb.x = rect.x + rect.width;
			rb.y = rect.y + rect.height;
			rb.addEventListener( MouseEvent.MOUSE_DOWN, startDragHandler );
			
			lb.x = rect.x;
			lb.y = rect.y + rect.height;
			lb.addEventListener( MouseEvent.MOUSE_DOWN, startDragHandler );
			
			stage.addEventListener( MouseEvent.MOUSE_UP, stopDragHandler );
			update();
		}
		
		private function update():void 
		{
			graphics.clear();
			graphics.lineStyle(3, 0xFFFFFF);
			graphics.moveTo(lt.x, lt.y);
			graphics.lineTo(rt.x, rt.y);
			graphics.lineTo(rb.x, rb.y);
			graphics.lineTo(lb.x, lb.y);
			graphics.lineTo(lt.x, lt.y);
		}
		
		public function getData():Rectangle
		{
			return new Rectangle( Math.round(lt.x), Math.round(lt.y), Math.round(rt.x - lt.x), Math.round(rb.y - rt.y));
		}
		
		function startDragHandler(e:MouseEvent):void
		{
			editorWorld.blockWorldDrag = true;
		
			draggedElement = e.currentTarget as NodeView;
			draggedElement.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if ( draggedElement == lt )
			{
				lt.x = 0;
				lb.x = lt.x;
				rt.y = lt.y;
			}
			else if ( draggedElement == rt )
			{
				rt.x = editorWorld.width;
				rb.x = rt.x;
				lt.y = rt.y;
			}
			else if ( draggedElement == lb )
			{
				lb.x = 0;
				lt.x = lb.x;
				rb.y = lb.y;
			}
			else if ( draggedElement == rb )
			{
				rb.x = editorWorld.width;
				rt.x = rb.x;
				lb.y = rb.y;
			}
			
			update();
		}
		
		function stopDragHandler(e:MouseEvent):void
		{
			if ( draggedElement )
			{
				draggedElement.stopDrag();
				
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
				
				editorWorld.blockWorldDrag = false;
			}
		}
	}
}