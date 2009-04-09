package co.uk.BetaDesigns.utils.string
{
	import flash.events.FocusEvent;
	
	import mx.controls.TextInput;

	/**
	 * Creates a simple text input that 
	 * can have a default value displayed when 
	 * the user hasn't entered any data / or they 
	 * delete the data. 
	 *
	 */
	public class DefaultTextTextInput extends TextInput
	{
		private var _defaultText : String;
		
		//Flags
		private var _displayAsPassword : Boolean;
	
		/**
		 * Constructor.
		 * 
		 */
		public function DefaultTextTextInput()
		{
			super( );
			addEventListener( FocusEvent.FOCUS_IN, focused );
			addEventListener( FocusEvent.FOCUS_OUT, focused );
		}
		
//PUBLIC

		/**
		 * Set the default value for this textInput.
		 * 
		 */
		 public function set defaultText( value : String ) : void
		 {
		 	_defaultText = value;
		 	
		 	super.text = value;
		 }
	
//PUBLIC OVERRIDES.
	 
		 /**
		 * Override displayAsPassword so we can set it to false
		 * when displayiing the default text but set it to true
		 * when the user starts typing.
		 * 
		 */
		 override public function set displayAsPassword(value:Boolean):void
		 {
		 	_displayAsPassword = value;
		 }
		 
//PRIVATE METHODS.

		/**
		 * Update the textInput to show our default text
		 * if no text was entered from the user.
		 * 
		 */
		private function focused( e : FocusEvent ) : void
		{
			switch( e.type )
			{
				case FocusEvent.FOCUS_IN :
					if( text == _defaultText )
					{
						text = '';
					}
					super.displayAsPassword = _displayAsPassword;
					break;
				case FocusEvent.FOCUS_OUT :
					if( text == '' )
					{
						text = _defaultText;
						super.displayAsPassword = false;				
					}
					break;
			}
		}
		
	}
}