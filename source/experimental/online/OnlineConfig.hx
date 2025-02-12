package experimental.online;

import experimental.backend.InternetLoader;

class OnlineConfig {
    public static var url:String = "https://raw.githubusercontent.com/Hiho2950/modsOnline/main/";
    public static var curMod:String = "";

    public static function setUrl(user:String, repo:String) {
        url = "https://raw.githubusercontent.com/" + user + "/" + repo + "/main/";
    }

    public static function setMod(mod:String) {
        curMod = mod;
    }

    public static function getModsList():Array<String> {
        var rawlist:String = InternetLoader.getTextFromUrl(url + "ModsList.txt");
        return CoolUtil.listFromString(rawlist);
    }

    public static function getModUrl():String {
        var returned = url + curMod + "/";
        return returned;
    }
}
