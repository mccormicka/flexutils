package co.uk.BetaDesigns.utils.string
{
	
	public class Romanizer
	{
		/**
		 * Function that turns any number into it's roman numeral 
		 * equivelant.
		 * We have to use an array to hold the values as if we use
		 * a Dictionary / Object actionScript sorts it alphabetically.
		 * and we don't get the correct results.
		 * 
		 * @param value : Number 0 - 9999;
		 * 
		 * Example at
		 * http://www.betadesigns.co.uk/Blog/2009/01/27/numberromanizer/
		 */
		public static function romanize( value : Number ) : String
		{
			var numerals : Array = [
									{ label : 'M', value : 1000 },
									{ label : 'CM', value : 900 },
									{ label : 'D', value : 500 },
									{ label : 'CD', value : 400 },
									{ label : 'C', value : 100 },
									{ label : 'XC', value : 90 },
									{ label : 'L', value : 50 },
									{ label : 'XL', value : 40 },
									{ label : 'X', value : 10 },
									{ label : 'IX', value : 9 },
									{ label : 'V', value : 5 },
									{ label : 'IV', value : 4 },
									{ label : 'I', value : 1 }									
									]
									
										
			var roman : String = '';
			
			for( var i : String in numerals )
			{
				while( value >= numerals[ i ].value )
				{
					roman += numerals[ i ].label;
					value -= numerals[ i ].value;
				}
			}
			
			return roman;
		}
		
		/**
		 * Constructor.
		 * 
		 */
		public function Romanizer( )
		{
				
		}
}
}