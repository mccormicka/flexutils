package co.uk.BetaDesigns.utils.VersionControler.VersionControl
{
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.resources.ResourceBundle;		
	
	/**
    * Version Controller.
    * Add this file to your main application to get
    * version control elements in the right click menue
    * 
    * <code>VersionController.getInstance( YOUR APP INSTANCE )</code>;
    */
    public class VersionController extends Application
	{
		//This is the name of our .properties file.
		[ResourceBundle( 'VersionControl' )]
		private static var _rb 	: ResourceBundle;
		private static var _rbi : Dictionary;
    	private static var _class : VersionController;
		private static var _application	: UIComponent;
		
		/**
		 * This method is called when we get 
		 * an instance of the class through
		 * VersionController.getInstance( ); 
		 * 
		 */		
		private static function update(  ) : void
		{
			_rbi = new Dictionary( );
			var rbi : Object = _rb.content;
			var cm : ContextMenu = new ContextMenu( );
			//Loop through the .properties file building our menu
			//Items.
			for( var i : String in rbi )
			{
				var properties 	: Array = String( rbi[ i ] ).split( '&' );
				var value 		: String = properties[ 0 ];
				var separator 	: Boolean = properties[ 1 ] ? properties[ 1 ] == 'false' ? false : true : true;
				var enabled		: Boolean = properties[ 2 ] ? properties[ 2 ] == 'false' ? false : true : true;
				var visible		: Boolean = properties[ 3 ] ? properties[ 3 ] == 'false' ? false : true : true;
				var open		: Boolean = properties[ 4 ] ? properties[ 4 ] == 'false' ? false : true : true;
				var cmi : ContextMenuItem = new ContextMenuItem( value, separator, enabled, visible );
					cm.customItems.push( cmi ); 
					cm.hideBuiltInItems( );			
				//If they have a URL add a click event handler;
				if( open )
				{
					cmi.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, openWindow );
					_rbi[ value ] = properties[ 4 ] ? properties[ 4 ] : 'http://www.betadesigns.co.uk/Blog';			
				}
			}
			_application.contextMenu = cm;
		}
		
		/**
		 * Controls opening a new browser
		 * window to the clicked menu item; 
		 * @param e : ContextMenuEvent;
		 * 
		 */		
		private static function openWindow( e : ContextMenuEvent ) : void
		{
			navigateToURL( new URLRequest( _rbi[ e.target.caption ] ), "_blank" );
		}

		/**
    	* Forces this class to use the singleton pattern;
    	*
    	*/
		public static function getInstance( item :UIComponent  ) :  VersionController
    	{
    		_application = item;
			if( !_class )
				_class = new VersionController( new SingletonEnforcer( ) );
				
				update( );

			return _class;
    	}
    	
    	/**
    	 * @private
    	 * 
    	 */
    	public function VersionController( se : SingletonEnforcer )
    	{
    		//can Never get here without calling getInstance( );
    	}
    }
}
class SingletonEnforcer{ }