//[rule: raw -(.*)]
//[rule: raw 出错了呜呜呜]
//[disable: false]

var s = Sender
var p = param(1)
if (s.GetImType() == "tg" && !isAdmin()) {//
     s.RecallMessage(s.GetMessageID())
     var id = s.Reply("出错了呜呜呜 ~ 脑子好像进水了。")
     sleep(300)
     s.RecallMessage(id)
} else {
     Continue()
}

