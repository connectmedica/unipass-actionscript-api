package unipass.utils {
	import flash.net.URLVariables;
	
	public class UnipassDataUtils {
		
        public static function stringToDate(value:String):Date  {
            if (value == null) { return null; }
            
            if (/[^0-9]/g.test(value) == false) {
                return new Date(parseInt(value)*1000);
            }
            
            if (/(\d\d)\/(\d\d)(\/\d+)?/ig.test(value)) {
                var datePeices:Array = value.split('/');
                if (datePeices.length == 3) {
                    return new Date(datePeices[2], Number(datePeices[0])-1, datePeices[1]);
                } else {
                    return new Date(0, Number(datePeices[0])-1, datePeices[1]);
                }
            }
            
            if (/\d{4}-\d\d-\d\d[\sT]\d\d:\d\d(:\d\d)?[\.\-Z\+]?(\d{0,4})?(\:)?(\-\d\d:)?/ig.test(value)) {
                return iso8601ToDate(value);
            }
            
            //We don't know the format, let Date try and parse it.
            return new Date(value);
        }
        
        protected static function iso8601ToDate(value:String):Date {
            var parts:Array = value.toUpperCase().split('T');
            
            var date:Array = parts[0].split('-');
            var time:Array = (parts.length <= 1) ? [] : parts[1].split(':');
            
            var year:uint = date[0]=='' ? 0 : Number(date[0]);
            var month:uint = date[1]=='' ? 0 : Number(date[1] - 1);
            var day:uint = date[2]=='' ? 1 : Number(date[2]);
            var hour:int = time[0]=='' ? 0 : Number(time[0]);
            var minute:uint = time[1]=='' ? 0 : Number(time[1]);
            
            var second:uint = 0;
            var millisecond:uint = 0;
            
            if (time[2] != null) {
                var index:int = time[2].length;
                
                if (time[2].indexOf('+') > -1) {
                    index = time[2].indexOf('+');
                } else if (time[2].indexOf('-') > -1) {
                    index = time[2].indexOf('-');
                } else if (time[2].indexOf('Z') > -1) {
                    index = time[2].indexOf('Z');
                }
                
                if (!isNaN(index)) {
                    var temp:Number = Number(time[2].slice(0, index));
                    second = temp<<0;
                    millisecond = 1000 * ((temp % 1) / 1);
                }
                
                if (index != time[2].length) {
                    var offset:String = time[2].slice(index);
                    var userOffset:Number =
                        new Date(year, month, day).getTimezoneOffset() / 60;
                    
                    switch (offset.charAt(0)) {
                        case '+' :
                        case '-' :
                            hour -= userOffset + Number(offset.slice(0));
                            break;
                        case 'Z' :
                            hour -= userOffset;
                            break;
                    }
                }
            }
            
            return new Date(year, month, day, hour, minute, second, millisecond);
        }
        
		/**
		 *
		 * Obtains the query string from the current HTML location
		 * and returns its values in a URLVariables instance.
		 *
		 */
		public static function getURLVariables(url:String):URLVariables {
			var params:String;
			
			if (url.indexOf('#') != -1) {
				params = url.slice(url.indexOf('#') + 1);
			} else if (url.indexOf('?') != -1) {
				params = url.slice(url.indexOf('?') + 1);
			}
			
			var vars:URLVariables = new URLVariables();
			vars.decode(params);
			
			return vars;
		}
		
	}
	
}