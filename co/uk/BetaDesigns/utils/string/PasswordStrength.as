package co.uk.BetaDesigns.utils.string
{
	/**
	 * Simple password strength indicator.
	 * 
	 * Example at 
	 * http://www.betadesigns.co.uk/Blog/2008/07/31/password-strength-indicator-in-actionscript-3/
	 *
	 */
	public class PasswordStrength
	{
		private static var _strength 	: Number = 0;
		private static var _regSmall 	: RegExp = new RegExp( /([a-z]+)/ );
		private static var _regBig		: RegExp = new RegExp( /([A-Z]+)/ );
		private static var _regNum		: RegExp = new RegExp( /([0-9]+)/ );
		private static var _regSpecial	: RegExp = new RegExp( /(\W+)/ );
		
		public static function checkStrength( password : String ) : Number
		{
			_strength = 0;

     		if( password.search( _regSmall ) != -1 )
     		{
     			_strength ++;
     		}
     		if( password.search( _regBig ) != -1 )
     		{
     			_strength ++;
     		}
     		if( password.search( _regNum ) != -1 )
     		{
     			_strength ++;
     		}
     		if( password.search( _regSpecial ) != -1 )
     		{
     			_strength ++;
     		}
     		return _strength;
  		}
		public function PasswordStrength( se : SingletonEnforcer )
		{
			//Force it so the user can't get here;
		}
	}
}
class SingletonEnforcer{}