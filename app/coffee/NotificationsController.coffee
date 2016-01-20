Notifications = require("./Notifications")
logger = require("logger-sharelatex")
metrics = require('metrics-sharelatex')

module.exports =

	getUserNotifications: (req, res)->
		logger.log user_id: req.params.user_id, "getting user unread notifications"
		metrics.inc "getUserNotifications"
		Notifications.getUserNotifications req.params.user_id, (err, notifications)->
			res.json(notifications)

	addNotification: (req, res)->
		logger.log user_id: req.params.user_id, notification:req.body, "adding notification"
		metrics.inc "addNotification"
		Notifications.addNotification req.params.user_id, req.body, (err, notifications)->
			if err?
				res.send 500
			else
				res.send()

	removeNotification: (req, res)->
		logger.log user_id: req.params.user_id, notification_id: req.params.notification_id, "mark notification as read"
		metrics.inc "removeNotification"
		Notifications.removeNotification req.params.user_id, req.params.notification_id, (err, notifications)->
			res.send()
