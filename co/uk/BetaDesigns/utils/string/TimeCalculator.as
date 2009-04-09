package co.uk.BetaDesigns.utils.string
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * When the current time elapses a <code>TIME_EXPIRED</code>
	 * event will be fired.
	 * 
	 */
	[Event( name='TIME_EXPIRED', type='flash.events.Event')]
	
	/**
	 * @Author : Anthony McCormick
	 * @Date : 07 / 01 / 09
	 * 
	 * Example at
	 * http://www.betadesigns.co.uk/Blog/2009/01/05/countdown-timer/
	 * 
	 * The TimeCalculator class takes a due date in either the past or the 
	 * future and gives you the time that has / needs to elapse in order to 
	 * reach that time.
	 * 
	 * it Also fires an event if the time has expired.
	 * 
	 * There are several ways to use the class
	 * 
	 * Firstly you can call <code>calculateTime( )</code>
	 * this will return you the time split down to years, months, days,
	 * hours, minutes, and optionally milliseconds. to the due date.
	 * for example <code>calculateTime( TimeCalculator.DAYS )</code>
	 * with a due date of tommorrow will return a String of 
	 * 00 : 23 : 59 : 59 : MILLISECONDS.
	 * 
	 * Secondly you can call one of the time types and it will return you 
	 * the exact ammount of time until the due date
	 * for example <code>_time.Months</code>
	 * with a due date of 2 years 8 months and 6 days will return 30 ( months )
	 * 
	 * 
	 */
	public class TimeCalculator extends EventDispatcher
	{
		//Constant for our event.
		public static const TIME_EXPIRED 			: String = 'TIME_EXPIRED';
		
		//Our time constants.
		public static const millisecondsPerSecond	: int = 1000;
		public static const millisecondsPerMinute	: int = 1000 * 60;
		public static const millisecondsPerHour		: int = 1000 * 60 * 60;
		public static const millisecondsPerDay		: int = 1000 * 60 * 60 * 24;
		public static const millisecondsPerWeek		: int = 1000 * 60 * 60 * 24 * 7;
		public static const millisecondsPerYear		: Number = 1000 * 60 * 60 * 24 * 365;
		public static const millisecondsPerLeapYear	: Number = 1000 * 60 * 60 * 24 * 366;
		
		//Time interval constants.
		public static const YEARS			: String = 'YEARS'; 
		public static const MONTHS			: String = 'MONTHS';
		public static const WEEKS			: String = 'WEEKS';
		public static const DAYS			: String = 'DAYS';
		public static const HOURS			: String = 'HOURS';
		public static const MINUTES			: String = 'MINUTES';
		public static const SECONDS			: String = 'SECONDS';
		public static const MILLISECONDS	: String = 'MILLISECONDS';
		
		private var _precision 			: String = YEARS;
		private var _expirationText		: String;
		
		private var _dueDate 			: Date;
		private var _dueDateMS			: Number;
		
		//Return strings.
		private var _years 				: String;
		private var _months 			: String;
		private var _weeks				: String;
		private var _days				: String;
		private var _hours 				: String;
		private var _minutes 			: String;
		private var _seconds 			: String;
		private var _milliseconds 		: String;
		
		//Flags
		private var _removeEmptyTimes		: Boolean = true;
		private var _internalremoveEmpty	: Boolean = true;
		private var _showMonths 		: Boolean = true;
		private var _showWeeks	 		: Boolean = true;
		private var _showDays	 		: Boolean = true;
		private var _showHours	 		: Boolean = true;
		private var _showMinutes 		: Boolean = true;
		private var _showSeconds 		: Boolean = true;
		private var _showMilliSeconds 	: Boolean = true;
		
		//Labels
		private var _separator			: String;
		private var _yearLabel			: String = '';
		private var _monthLabel			: String = '';
		private var _weekLabel			: String = '';
		private var _dayLabel			: String = '';
		private var _hourLabel			: String = '';
		private var _minuteLabel		: String = '';
		private var _secondsLabel		: String = '';
		private var _milliSecondLabel	: String = '';
		
		
		/**
		 * Constructor.
		 * 
		 * @param date : <code>Date</code>;
		 * @param displayMilliseconds : <code>Boolean = true</code>;
		 * @param separator : <code>String = ' : ' </code>;
		 * @param precision : <code>String = TimeCalculator.YEARS</code>
		 * 
		 * Sets the time to count down to.
		 * 
		 */
		public function TimeCalculator( date : Date, separator : String = ' : ', precison : String = YEARS )
		{
			_precision 			= precison
			_separator 			= separator;
			dueDate 			= date;
		}

//PUBLIC METHODS.
		
		/**
		 * Remove time elements that have a value of 00 
		 * unless there preceding value is greater than 00;
		 * 
		 */
		 public function set removeEmptyTimes( value : Boolean ) : void
		 {
		 	_removeEmptyTimes = value;
		 	_internalremoveEmpty = value;
		 }
		 
		/**
		 * Set show seconds.
		 * 
		 */
		public function set showMonths( value : Boolean ) : void
		{
			_showMonths = value;
		}
		/**
		 * Set show seconds.
		 * 
		 */
		public function set showWeeks( value : Boolean ) : void
		{
			_showWeeks = value;
		}
		/**
		 * Set show seconds.
		 * 
		 */
		public function set showDays( value : Boolean ) : void
		{
			_showDays = value;
		}
		/**
		 * Set show seconds.
		 * 
		 */
		public function set showHours( value : Boolean ) : void
		{
			_showHours = value;
		}
		
		/**
		 * Set show seconds.
		 * 
		 */
		public function set showMinutes( value : Boolean ) : void
		{
			_showMinutes = value;
		}
		
		/**
		 * Set show seconds.
		 * 
		 */
		public function set showSeconds( value : Boolean ) : void
		{
			_showSeconds = value;
		}
		
		/**
		 * Set show milliseconds.
		 * 
		 */
		public function set showMilliseconds( value : Boolean ) : void
		{
			_showMilliSeconds = value;
		}
		
		/**
		 * Reset the due date.
		 * 
		 */
		public function set dueDate( d : Date ) : void
		{
			_dueDate = d;
			
			_dueDateMS = _dueDate.getTime( );
			
			calculateTime( );
		}
		
		/**
		 * Set the text that should be returned once the date has 
		 * expired.
		 * 
		 */
		public function set expirationText( s : String ) : void
		{
			_expirationText = s;
		}
		
		/**
		 * Set the labels to be placed after each time interval.
		 * 
		 */
		 public function labels( years : String = '', months : String = '', weeks : String = '', days : String = '',
		 						 hours : String = '', minutes : String = '', seconds : String = '', milliseconds : String = '' ) : void
 		 {
 		 	_yearLabel 			= years;
 		 	_monthLabel 		= months;
 		 	_weekLabel 			= weeks;
 		 	_dayLabel 			= days;
 		 	_hourLabel 			= hours;
 		 	_minuteLabel 		= minutes;
 		 	_secondsLabel 		= seconds;
 		 	_milliSecondLabel 	= milliseconds;
 		 }
		 
		 /**
		 * Set the precision value.
		 * Valid values are.
		 * TimeCalculator.YEARS.
		 * TimeCalculator.MONTHS.
		 * TimeCalculator.WEEKS.
		 * TimeCalculator.DAYS.
		 * TimeCalculator.HOURS.
		 * TimeCalculator.MINUTES.
		 * TimeCalculator.SECONDS.
		 * TimeCalculator.MILLISECONDS.
		 * 
		 */
		public function set precision( value : String ) : void
		{
			if( value != YEARS || value != MONTHS || value != WEEKS || value != DAYS ||
				value != HOURS || value != MINUTES || value != SECONDS ) _precision = YEARS;
				
			_precision = value;	
		}
		
		/**
		 * Return the number of years left.
		 * 
		 */
		public function get years( ) : String
		{
			
			calculateYears( timeLeft );
			return _years;
		}
		

		/**
		 * Return the number of weeks left.
		 * 
		 */
		public function get months( ) : String
		{
			calculateMonths( timeLeft );
			return _months;
		}
		/**
		 * Return the number of weeks left.
		 * 
		 */
		public function get weeks( ) : String
		{
			calculateWeeks( timeLeft );
			return _weeks;
		}
		
		/**
		 * Return the number of days left.
		 * 
		 */
		public function get days( ) : String
		{
			calculateDays( timeLeft );
			return _days;
		}
		
		/**
		 * return the number of hours left.
		 * 
		 */
		public function get hours( ) : String
		{
			calculateHours( timeLeft );
			return _hours;
		}
		
		/**
		 * Return the number of minutes left.
		 * 
		 */
		public function get minutes( ) : String
		{
			calculateMinutes( timeLeft );
			return _minutes;
		}
		
		/**
		 * Return the number of second left.
		 * 
		 */
		public function get seconds( ) : String
		{
			calculateSeconds( timeLeft );
			return _seconds;
		}
		
		/**
		 * Return the number of milliseconds left.
		 * 
		 */
		public function get milliSeconds( ) : String
		{
			return String( timeLeft ) + _milliSecondLabel;
		}

		/**
		 * Returns if the current year is a leap year or not.
		 * 
		 * @param year : <code>Number</code> The year in milliseconds 
		 * since January 1st 1970;
		 * 
		 */
		public function checkLeapYear( year : Number ) : Boolean
		{
			return ( ( year % 4 == 0) && !( year % 100 == 0 )) || ( year % 400 == 0 );	
		}
		
		
		/**
		 * Returns the full time left depending on the precision set.
		 * 
		 * 
		 */
		public function calculateTime( precision : String = '', currentTime : Number = NaN ) : String
		{
			if( precision == '' ) precision = _precision;
			if( isNaN( currentTime ))
				currentTime	= new Date( ).getTime( );
			
			var timeLeftOver 	: Number 	= _dueDateMS - currentTime;
			if( timeLeftOver < 0 )
			{
				timeLeftOver = -timeLeftOver;
				//Dispatch our event.
				dispatchEvent( new Event( TIME_EXPIRED ) );
				if( _expirationText )
				{
					return _expirationText;				
				}
			}
			_internalremoveEmpty = _removeEmptyTimes;
			switch( precision )
			{
				case SECONDS :
					 return calculateSeconds( timeLeftOver );
					break;
				case MINUTES :
					 return calculateMinutes( timeLeftOver );
					break;
				case HOURS :
					 return calculateHours( timeLeftOver );
					break;
				case DAYS :
					 return calculateDays( timeLeftOver );
					break;
				case WEEKS :
					 return calculateWeeks( timeLeftOver );
					break;
				case MONTHS :
					 return calculateMonths( timeLeftOver );
					break;
				case YEARS :
					 return calculateYears( timeLeftOver );
					break;
			}
			return null;
			
		}

//PRIVATE METHODS.
		
		/**
		 * Returns years, weeks, days, hours, minutes, seconds and optionally milliseconds
		 * from the time in milliseonds. if you just want to 
		 * use a <code>Date</code> object use
		 * 
		 * @see dueDate( );
		 * @see #calculateTime( );
		 * 
		 * @param time : <code>Number</code> set the time in milliseconds since
		 * January 1st 1970;
		 * 
		 * @private
		 * 
		 */
		private function calculateYears( time : Number ) : String
		{
			var leapYear : Boolean;
			
			//Test to see if were in a leapyear or not
			if( new Date( ).getMonth( ) < 1 )
				leapYear = checkLeapYear( new Date( ).getFullYear( ) );
			else
				leapYear = checkLeapYear( _dueDate.getFullYear( ) );
			var milliseconds : Number  	= leapYear == true ? millisecondsPerLeapYear : millisecondsPerYear;

			_years 						= addLeadingZero( Math.floor( time / milliseconds ) ) + _yearLabel;
			var yearOver 	: Number 	= time % milliseconds;
			
			if( _internalremoveEmpty )
			{
				if( _years == '00' + _yearLabel )
				{
					if( _showMonths )
						return calculateMonths( yearOver );
					else
						return '';
				}
			}
			_internalremoveEmpty = false;
			
			if( _showMonths )
				return _years + _separator + calculateMonths( yearOver );
			else
				return _years;
		}
		
		/**
		 * Returns months, weeks, days, hours, minutes, seconds and optionally milliseconds
		 * from the time in milliseonds. if you just want to 
		 * use a <code>Date</code> object use
		 * 
		 * @see dueDate( );
		 * @see #calculateTime( );
		 * 
		 * @param time : <code>Number</code> set the time in milliseconds since
		 * January 1st 1970;
		 * 
		 * @private
		 */
		private function calculateMonths( time : Number ) : String
		{
			_months = '';
			var m : Number = 0;
			var month : Number = new Date( ).getMonth( );	
			var year  : Number = new Date( ).getFullYear( );	
			var monthTime : Number = time;
			while( monthTime > 0 )
			{
				monthTime = calculateMonth( year, month, time );
				if( monthTime > 0 )
				{
					time = calculateMonth( year, month, time );
					if( month > 11 )
					{
						year ++;
						month = -1;
					}
					month ++;
					m ++;
				}
			}
			_months = addLeadingZero( m ) + _monthLabel;
			
			if( _internalremoveEmpty )
			{
				if( _months == '00' + _monthLabel )
				{
					if( _showWeeks )
						return calculateWeeks( time );
					else
						return '';
				}
			}
			_internalremoveEmpty = false;
			
			if( _showWeeks )
				return _months + _separator + calculateWeeks( time );
			else
				return _months;
		}
		
		/**
		 * 
		 * Calculate the number fo days in the given month.
		 * 
		 */
		private function calculateMonth( year : Number, month : Number, time : Number/* , invert : Boolean = false */ ) : Number
		{
			var thisMonth : Date = new Date( year, month, 1 );
			var nm : Number = month +1
			//if new month is higher than 11 ( the highest ) then increase the year
			//and set the new month back to 0 ( january );
			if( nm  > 11 )
			{
				nm = 0;
				year ++;
			}
			var nextMonth : Date = new Date( year, nm, 1 );
			var numDays : Number = ( nextMonth.getTime() - thisMonth.getTime( ) ) /  millisecondsPerDay;			
			
			return time - ( numDays * millisecondsPerDay );
		}
		
		/**
		 * Returns weeks, days, hours, minutes, seconds and optionally milliseconds
		 * from the time in milliseonds. if you just want to 
		 * use a <code>Date</code> object use
		 * 
		 * @see dueDate( );
		 * @see #calculateTime( );
		 * 
		 * @param time : <code>Number</code> set the time in milliseconds since
		 * January 1st 1970;
		 * 
		 * @private
		 */
		private function calculateWeeks( time : Number ) : String
		{
			_weeks 						= addLeadingZero(  Math.floor( time / millisecondsPerWeek ) ) + _weekLabel;
			var weekOver 	: Number 	= time % millisecondsPerWeek;
			
			if( _internalremoveEmpty )
			{
				if( _weeks == '00' + _weekLabel )
				{
					if( _showDays )
						return calculateDays( weekOver );
					else
						return '';
				}
			}
			_internalremoveEmpty = false;
			
			if( _showDays )
				return _weeks + _separator + calculateDays( weekOver );
			else
				return _weeks;
		}
		
		/**
		 * Returns days, hours, minutes, seconds and optionally milliseconds
		 * from the time in milliseonds. if you just want to 
		 * use a <code>Date</code> object use
		 * 
		 * @see dueDate( );
		 * @see #calculateTime( );
		 * 
		 * @param time : <code>Number</code> set the time in milliseconds since
		 * January 1st 1970;
		 * 
		 * @private
		 * 
		 */
		private function calculateDays( time : Number ) : String
		{
			_days 						= addLeadingZero(  Math.floor( time / millisecondsPerDay ) ) + _dayLabel;
			var daysOver 	: Number 	= time % millisecondsPerDay;
			
			if( _internalremoveEmpty )
			{
				if( _days == '00' + _dayLabel )
				{
					if( _showHours )
						return calculateHours( daysOver );
					else
						return '';
				}
			}
			_internalremoveEmpty = false;
			
			if( _showHours )
				return _days + _separator + calculateHours( daysOver );
			else
				return _days;
		}
		
		/**
		 * Returns hours, minutes, seconds and optionally milliseconds
		 * from the time in milliseonds. if you just want to 
		 * use a <code>Date</code> object use
		 * 
		 * @see dueDate( );
		 * @see #calculateTime( );
		 * 
		 * @param time : <code>Number</code> set the time in milliseconds since
		 * January 1st 1970;
		 * 
		 * @private
		 * 
		 */
		private function calculateHours( time : Number ) : String
		{
			_hours						= addLeadingZero( Math.floor( time / millisecondsPerHour ) ) + _hourLabel;
			var hoursOver 	: Number 	= time % millisecondsPerHour;
			
			if( _internalremoveEmpty )
			{
				if( _hours == '00' + _hourLabel )
				{
					if( _showMinutes )
						return calculateMinutes( hoursOver );
					else
						return '';
				}
			}
			_internalremoveEmpty = false;
			
			if( _showMinutes )
				return _hours + _separator + calculateMinutes( hoursOver );
			else 
				return _hours;
		}
		
		/**
		 * Returns minutes, seconds and optionally milliseconds
		 * from the time in milliseonds. if you just want to 
		 * use a <code>Date</code> object use
		 * 
		 * @see dueDate( );
		 * @see #calculateTime( );
		 * 
		 * @param time : <code>Number</code> set the time in milliseconds since
		 * January 1st 1970;
		 * 
		 * @private
		 * 
		 */
		private function calculateMinutes( time : Number ) : String
		{
			_minutes					= addLeadingZero( Math.floor( time / millisecondsPerMinute ) ) + _minuteLabel;
			var minutesOver : Number 	= time % millisecondsPerMinute;
			
			if( _internalremoveEmpty )
			{
				if( _minutes == '00' + _minuteLabel )
				{
					if( _showSeconds )
						return calculateSeconds( minutesOver );
					else
						return '';
				}
			}
			_internalremoveEmpty = false;
			
			if( _showSeconds )
				return _minutes + _separator + calculateSeconds( minutesOver );
			else
				return _minutes;
		}
		
		/**
		 * Returns seconds and optionally milliseconds
		 * from the time in milliseonds. if you just want to 
		 * use a <code>Date</code> object use
		 * 
		 * @see dueDate( );
		 * @see #calculateTime( );
		 * 
		 * @param time : <code>Number</code> set the time in milliseconds since
		 * January 1st 1970;
		 * 
		 * @private
		 * 
		 */
		private function calculateSeconds( time : Number ) : String
		{
			_seconds					= addLeadingZero( Math.floor( time / millisecondsPerSecond ) ) + _secondsLabel;
			var secondsOver : Number 	= time % millisecondsPerSecond;
			_milliseconds				= addLeadingZero( secondsOver );
			 
			 if( _internalremoveEmpty )
			{
				if( _seconds == '00' + _secondsLabel )
				{
					if( _showMilliSeconds )
						return _milliseconds + _milliSecondLabel;
					else
						return '';
				}
			}
			_internalremoveEmpty = false;
			
			if( _showMilliSeconds )
				return _seconds + _separator + _milliseconds + _milliSecondLabel;
			else
				return _seconds;
		}
		
		/**
		 * Convert a negative time into a positive time
		 * if required.
		 * 
		 * @private
		 * @return Number;
		 * 
		 */		
		private function get timeLeft( ) : Number
		{
			var leftOver 	: Number 	= _dueDateMS - new Date( ).getTime( );
			if( leftOver < 0 )
			{
				leftOver = -leftOver;
			}
			
			return leftOver;
		}
		
		/**
		*	THIS METHOD IS FROM THE CORELIB LIBRARY AND IS PLACED HERE AS 
		*   A CONVENIENCE SO WE DON'T NEED TO HAVE THE LIBRARY TO USE THIS CLASS.
		*  	coreLib can be found at :: http://code.google.com/p/as3corelib/
		*   
		*   Formats a number to include a leading zero if it is a single digit
		*	between -1 and 10. 	
		* 
		* 	@param n The number that will be formatted
		*
		*	@return A string with single digits between -1 and 10 padded with a 
		*	leading zero.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function addLeadingZero(n:Number):String
		{
			var out:String = String(n);
			
			if(n < 10 && n > -1)
			{
				out = "0" + out;
			}
			
			return out;
		}
	}
}