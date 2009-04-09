package co.uk.BetaDesigns.utils.application
{
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	
	/**
	 * Utility class for Retrieving values placed in the 
	 * trailing end of a url without the use of any External
	 * JavaScript functions. 
	 * This class can be used instead of the 
	 * Flex utils which require the include of the history 
	 * folder and history.js / history.css files on the server;
	 *  
	 * @author Anthony McCormick
	 * 
	 */	
	public class ExternalUtilities
	{
 		private static var _fragmemtsArray 			: Array;
 		private static var _fragmentDictionary 		: Dictionary;
		
		/**
		 * Return an array of elements starting from the endOfURL string
		 * seperated by the deliminator
		 * @see getFragmentsAsDictionary to return value object pairs; 
		 * 
		 * @param deliminator 	: String = '&';
		 * @param endOfURL		: String = '#''
		 * @return Array;
		 * 
		 */		
		public static function getFragmentsAsArray( deliminator : String = '&', endOfURL : String = '#') : Array
		{
			if( _fragmemtsArray ) return _fragmemtsArray;
			
			var pattern 	: RegExp = new RegExp("%20", 'g');
			_fragmemtsArray = new Array( );
			
        	if( ExternalInterface.available )
        	{     
        		var url : String 	= ExternalInterface.call( 'window.location.href.toString'  );
        	//	Alert.show( url );
        		var pos : int 		= url.indexOf( endOfURL );
        		if( pos == -1 || pos == url.length - 1 )
        		{
        			//No fragments so return;
        			return null;
        		}else{
        			
        			var st : String = url.substring( pos + 1 );
        				st = st.replace( pattern, ' ' );
        			_fragmemtsArray = st.split( deliminator );	
        			
        			return _fragmemtsArray;
        		}
        	}
        	return null;
 		}
 		
 		/**
 		 * Returns a dictionary of value object pairs from the end of the URL starting from the
 		 * endOfURL String, you can seperate the values by the deliminator and seperate each value object pair
 		 * by the objectSplitter;
 		 * 
 		 * @objectSplitter 		: String = '=';
 		 * @param deliminator 	: String = '&';
		 * @param endOfURL		: String = '#''
		 * @return Dictionary;
		 * 
		 */ 
 		public static function getFragmentsAsDictionary( objectSplitter : String = '=', deliminator : String = '&', endOfURL : String = '#' ) : Dictionary
 		{
 			if( _fragmentDictionary ) return _fragmentDictionary;
 			
 			var a : Array = getFragmentsAsArray( deliminator, endOfURL );
 			if( !a ) return null;
 			_fragmentDictionary = new Dictionary( );
 			for each( var i : String in a )
 			{
 				var vop : Array = i.split( objectSplitter );
 				_fragmentDictionary[ vop[ 0 ] ] = vop[ 1 ];
 			}
 			return _fragmentDictionary;
 		}
 		
 		/**
 		 * Returns an Array of FragmentObjects each object has a command which is identified
 		 * in the URL by the commandSeparator and it's params identified by the objectSplitter 
 		 * and valueSplitter params.
 		 * 
 		 * with the default setting a URL of
 		 * 
 		 * #validEmail?email=anthony.mccormick@gmail.com&token=<TOKEN>?item?id=12345'
 		 *
 		 * will return two FragmentObjects as follows.
 		 * 
 		 * 1. command = validEmail
 		 * 	    email = anthony.mccormick@gmail.com;
 		 * 		token = <TOKEN>
 		 * 2. command = item;
 		 * 		id    = 12345 
 		 * 
 		 * @param commandSplitter 		: String = '?';
 		 * @param objectSplitter 		: String = '&';
 		 * @param valueSplitter 		: String = '=';
		 * @param endOfURL				: String = '#''
		 * @return Array;
		 * 
		 */ 
 		public static function getFragmentsAsCommandParameters( commandSeparator : String = '?', objectSplitter : String = '&',
 																valueSplitter : String = '=', endOfURL : String = '#' ) : Array
 		{
 			var a : Array = getFragmentsAsArray( commandSeparator, endOfURL );
 			if( !a ) return null;
 			
 			var commands : Array = new Array( );
 			for( var i : int = 0; i < a.length; i += 2 )
 			{
 				var command : FragmentObject = new FragmentObject( );
 					command.command = a[ i ];
 					
 				var params : Array = String( a[ i + 1 ] ).split( objectSplitter );
 				for each( var s : String in params )
 				{
 					var value : Array = s.split( valueSplitter );
 					command[ value[ 0 ] ] = value[ 1 ];
 					
 				}
 				commands.push( command );
 			}
 			return commands;
 		}
 		
		/**
		 * Force it so no-one can make an instance of this Utility class
		 * as it's static; 
		 * @param se
		 * 
		 */ 		
		public function ExternalUtilities( se : SingletonEnforcer )
		{
		}
	}
}
class SingletonEnforcer{ }