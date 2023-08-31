package experimental.backend;

import extension.youtubeplayer.YouTubePlayer;

class YoutubeLoader {

	function new() {
		// first of all... call init on the main method.
		YouTubePlayer.init("BIcaSyDFTNiRQz56Wn146Mud6DwmaYNds2tG000"); //Google app developer Key
	}
	
	function loadVideo(videoId:String, ?fullscreen:Bool = true) {
		// The string parameter is the youtube video ID to play.
		// The boolean parameter forces the fullscreen mode and hide the player fullscreen button.
		YouTubePlayer.loadVideo(videoId, fullscreen);
	}	
}
