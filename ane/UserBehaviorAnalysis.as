package
{
	import flash.system.Capabilities;

	import eu.alebianco.air.extensions.analytics.Analytics;
	import eu.alebianco.air.extensions.analytics.api.ITracker;


	/**
	 *
	 * @author Administrator
	 */
	public class UserBehaviorAnalysis
	{
		/**
		 *
		 */
		public function UserBehaviorAnalysis()
		{
		}

		/**
		 *
		 * @default
		 */
		public static var tracker:ITracker;
		/**
		 *
		 * @default
		 */
		public static var UID:String;
		private static const GA_ID:String='UA-46023848-3';

		/**
		 *
		 */
		public static function init():void
		{
			if (Capabilities.os.indexOf("Windows") >= 0)
				return;
			UMeng.instance.init("52b1868656240b557713090e");
			UID=UMeng.instance.getUDID();
			var analytics:Analytics=Analytics.getInstance();
			tracker=analytics.getTracker(GA_ID);
			trackView('首页');
			trace("initAnalyst", UID)
//			trackEvent("login", "user", UID);
		}

		/**
		 *
		 * @param catetory click/collect
		 * @param action target
		 * @param label uid
		 * @param value index
		 */
		public static function trackEvent(catetory:String, action:String, label:String='', value:int=0):void
		{
			if (!tracker)
				return;
//			trace("buildEvent", catetory, action, label, value)
			label=label ? label + '&' + UID : UID;
			tracker.buildEvent(catetory, action).withLabel(label).withValue(value).track();
		}

		/**
		 *
		 * @param view classname
		 */
		public static function trackView(view:String):void
		{
			if (!tracker)
				return;
//			trace("buildView", view)
			tracker.buildView(view).track();
		}

		/**
		 *
		 * @param catetory staytime/tasktime
		 * @param value time:ms
		 * @param type classname
		 */
		public static function trackTime(catetory:String, value:int, type:String):void
		{
			if (!tracker)
				return;
//			trace("buildTiming", catetory, value, type, UID)
			tracker.buildTiming(catetory, value).withLabel(UID).withName(type).track();
		}
	}
}
