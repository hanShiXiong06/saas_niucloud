/**
 * 将时间戳转化为时分秒的格式，用作倒计时
 */
export function intervalTime(endTime:number){
	var date1 = (Date.parse(new Date()))/1000;//计算当前时间戳 (毫秒级)
	var date2 = endTime; //结束时间
	// var date3 = date2.getTime() - date1.getTime(); //时间差的毫秒数
	var date3 =  (date2- date1)*1000; //时间差的毫秒数
	//计算出相差天数
	var days = Math.floor(date3 / (24 * 3600 * 1000));
	//计算出小时数
 
	var leave1 = date3 % (24 * 3600 * 1000); //计算天数后剩余的毫秒数
	var hours = Math.floor(leave1 / (3600 * 1000));
	//计算相差分钟数
	var leave2 = leave1 % (3600 * 1000); //计算小时数后剩余的毫秒数
	var minutes = Math.floor(leave2 / (60 * 1000));
 
	//计算相差秒数
	var leave3 = leave2 % (60 * 1000); //计算分钟数后剩余的毫秒数
	var seconds = Math.round(leave3 / 1000);
	// console.log(days + "天 " + hours + "小时 ")
	var sun = days*24 + hours;
	var min = minutes;
	var sec = seconds;
	if(sun == 0){
		sun = '00';
	}else if(sun < 10){
		sun = '0'+sun;
	}
	if(min < 10){
		min = '0'+minutes;
	}
	if(sec < 10){
		sec = '0'+seconds;
	}
	
	if((days*24 + hours)<= 0 && minutes <= 0 && seconds <= 0){
		return '00:00:00'
	}else{
		return   (sun) + ":" + min + ":" + sec;
	}
}

