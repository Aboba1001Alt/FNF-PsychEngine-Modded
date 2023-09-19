package experimental.backend;

import extension.youtubeplayer.YouTubePlayer;

class YoutubeLoader {

	function new() {
		YouTubePlayer.init("AIzaSyCUVflJAW6N7fHqXVrRxnEuPZHPdIAo2ys"); //Google app developer Key
	}
	
	function loadVideo(url:String) {
		YouTubePlayer.loadVideo(url, true);
	}	
}
