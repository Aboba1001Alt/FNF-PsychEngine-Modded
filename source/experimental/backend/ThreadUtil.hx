package experimental.backend;

import lime.system.ThreadPool;

class ThreadUtil {
	public var thread:ThreadPool;
	public function new(min:Int,max:Int) {
		thread = new ThreadPool(min,max);
	}
	public function runSafe(func:Void->Void) {
		try {
			thread.doWork.add(function(state){
			    func();
				thread.sendComplete();
		    });
			thread.queue();
	    } catch(e) {
			trace(e.message);
			try { func(); }
		}
	}
}