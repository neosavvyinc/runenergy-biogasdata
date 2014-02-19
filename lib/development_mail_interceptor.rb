class DevelopmentMailInterceptor
	def self.delivering_email(message)
		message.to = defined?(PERSONAL_EMAIL) ? PERSONAL_EMAIL : "tewen@neosavvy.com"
	end
end