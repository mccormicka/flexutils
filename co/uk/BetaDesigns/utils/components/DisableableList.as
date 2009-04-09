package co.uk.BetaDesigns.utils.components
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;

	/**
	 * A fixed version of the Flex Cookbook Recipe 5.8:
	 * Allow Certain items in a list to be selectable.
	 * 
	 * See my post at 
	 * http://www.betadesigns.co.uk/Blog/2009/03/12/flex-cookbook-recipe-58-allow-certain-items-in-a-list-to-be-selectable-doesnt-quite-work-correctly/
	 * 
	 */
	public class DisableableList extends List
	{
		//Setup a default filter that always returns
		//true.
		public var disabledFilterFunction 	: Function = 
				function( value : Object ) : Boolean{ return true };
		
		//Moving up or down?
		private var _selectionIsAbove 		: Boolean;
		
		/**
		* Constructor
		*
		*/
		public function DisableableList( )
		{
			super( );
		}
	
//OVERRIDES.
	
		/**
		* @inheritDoc.
		* set our offscreen items to at least 4 so 
		* that if the last / first visible item
		* is disabled we can still move the view 
		* up or down without getting stuck?   
		*/
		override public function initialize():void
		{
			super.initialize( );
			offscreenExtraRowsOrColumns = 
				Math.max( 4, offscreenExtraRowsOrColumns );
		}
		
		/**
		* @inheritDoc.
		* capture key directions.
		*/
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
			if( event.keyCode == Keyboard.UP )
			{
				_selectionIsAbove = true;
				
			}else if( event.keyCode == Keyboard.DOWN )
			{
				_selectionIsAbove = false;
			}
			super.keyDownHandler( event );  
		}
		
		/**
		* @inheritDoc.
		* check to see if our selected item is 
		* allowed to be selected or not. 
		*/
		override protected function finishKeySelection():void
		{
			super.finishKeySelection( );
			
			var i : int;
			var rowCount : int = listItems.length;
			var count : Number = 0;
						
			var item : IListItemRenderer = listItems[ caretIndex - 
					    verticalScrollPosition + offscreenExtraRowsTop ][ 0 ];
			
			if( item )
			{
				if( item.data )
				{
					if( disabledFilterFunction( item.data ) )
					{
						//trace( 'ITEM IS DISABLED : ' + disabledFilterFunction( item.data ) );
						//trace( 'SELECTION IS ABOVE : ' + _selectionIsAbove );
						var currIndex : int = caretIndex - verticalScrollPosition;
						if( _selectionIsAbove )
						{
							//LookUp
							i = currIndex + offscreenExtraRowsTop;
							count = 0;
							while( i > 0 )
							{
								item = listItems[ i ][ 0 ];
								if( !disabledFilterFunction( item.data ) )
								{
									selectedIndex = selectedIndex + count;
									return;
								}
								count --;
								i--;
							}
							selectedIndex = selectedIndex +1;
							//trace( 'CANT GO UP ANYMORE' );
							return;
							
						}else{
							//Look down.
							i = currIndex + offscreenExtraRowsTop;
							count = 0;
							while( i < rowCount )
							{
								item = listItems[ i ][ 0 ];
								if( !disabledFilterFunction( item.data ) )
								{
									selectedIndex = selectedIndex + count;
									return;
								}
								count ++;
								i++;
							}
							
							selectedIndex = selectedIndex -1;
							//trace( 'CANT GO DOWN ANYMORE' );
							return;
							
						}
					}
				}
			}
		}
	
		/**
		* @inheritDoc.
		* Override so we can remove our search groups
		* from Rollover events.
		*/
		override protected function mouseEventToItemRenderer(event:MouseEvent):IListItemRenderer
		{
			var item : IListItemRenderer = super.mouseEventToItemRenderer( event );
			
			if( item )
			{
				if( item.data )
				{
					if( disabledFilterFunction( item.data ) )
						return null;
				}
			}
			return item;
		}
		
	}
}