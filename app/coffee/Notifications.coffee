Settings = require 'settings-sharelatex'
logger = require('logger-sharelatex')
mongojs = require('mongojs')
db = mongojs(Settings.mongo?.url, ['notifications'])
ObjectId = require("mongojs").ObjectId

module.exports =

	getUserNotifications: (user_id, callback = (err, notifications)->)->
		query =
			user_id: user_id
			templateKey: {"$exists":true}
		db.notifications.find query, (err, notifications)->
			callback err, notifications

	addNotification: (user_id, notification, callback)->
		query =
			user_id: user_id
			key: notification.key
		db.notifications.count query, (err, number)->
			if number > 0
				logger.log number:number, user_id:user_id, key:notification.key, "alredy has notification key for user"
				callback number
			else
				doc = 
					user_id: user_id
					key: notification.key
					messageOpts: notification.messageOpts
					templateKey: notification.templateKey
				db.notifications.insert(doc, callback)

	removeNotification: (user_id, notification_id, callback)->
		searchOps = 
			user_id:user_id
			_id:ObjectId(notification_id)
		updateOperation = 
			"$unset": {templateKey:true, messageOpts: true}
		db.notifications.update searchOps, updateOperation, callback
