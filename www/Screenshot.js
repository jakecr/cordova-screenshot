/*
 *  This code is adapted from the work of Michael Nachbaur
 *  by Simon Madine of The Angry Robot Zombie Factory
 *   - Converted to Cordova 1.6.1 by Josemando Sobral.
 *   - Converted to Cordova 2.0.0 by Simon MacDonald
 *  2012-07-03
 *  MIT licensed
 */
var exec = require('cordova/exec'), formats = ['png','jpg'];
module.exports = {
	save:function(callback,format,quality, filename, x, y, width, height) {
		format = (format || 'png').toLowerCase();
		filename = filename || 'screenshot_'+Math.round((+(new Date()) + Math.random()));
		if(formats.indexOf(format) === -1){
			return callback && callback(new Error('invalid format '+format));
		}
		quality = typeof(quality) !== 'number'?100:quality;
		x = typeof(x) !== 'number'?0:x;
		y = typeof(y) !== 'number'?0:y;
		width = typeof(width) !== 'number'?0:width;
		height = typeof(height) !== 'number'?0:height;
		exec(function(res){
			callback && callback(null,res);
		}, function(error){
			callback && callback(error);
		}, "Screenshot", "saveScreenshot", [format, quality, filename, x, y, width, height]);
	},

	URI:function(callback, quality){
		quality = typeof(quality) !== 'number'?100:quality;
		exec(function(res){
			callback && callback(null, res);
		}, function(error){
			callback && callback(error);
		}, "Screenshot", "getScreenshotAsURI", [quality]);

	}
};
