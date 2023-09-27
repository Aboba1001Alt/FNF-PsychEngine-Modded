package experimental.online;

import experimental.backend.InternetLoader;

class Config {
    public var url:String = "https://raw.githubusercontent.com/Hiho2950/modsOnline/main/";
    public static setUrl(user:String,repo:String) {
        url = "https://raw.githubusercontent.com/" + user + "/" + repo + "/main/";
    }
    public static getModsList():String {
        
    }
}