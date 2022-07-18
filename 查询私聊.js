// [rule: 查询 ]  有问题tg频道留言 https://t.me/silly_MaiArk
// [rule:^打开查询私聊$]
// [rule: ^关闭查询私聊$] 
// [priority:9247039939]


var msg=GetContent()
var isAdmin = isAdmin()
var checkprivate = bucketGet("jd_cookie", "check_private")
    
function mian(){
    
    if(msg== "查询"){
        
        if (checkprivate =="true" && GetChatID()!=0) {//登录私聊判断
            sendText("请私聊我发送“查询”")
            return
        }else{
        Continue()
        }
    }	
    else if(msg== "打开查询私聊") {
    	
        if (isAdmin) {
        	bucketSet("jd_cookie", "check_private", "true")
        	sendText("已打开查询私聊")
            }
    	return;	
	}
	else if(msg== "关闭查询私聊") {
	
    	if (isAdmin) {
        	bucketSet("jd_cookie", "check_private", "false")
        	sendText("已关闭查询私聊")
    	    }
    	return;	
	}

}
mian()
