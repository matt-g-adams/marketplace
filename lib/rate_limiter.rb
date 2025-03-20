class RateLimiter
  MAX_REQUESTS = 3
  WINDOW = 30

  def initialize
    @requests = {}
  end

  def allow_request?(timestamp, user_id)
    @requests[user_id] ||= []
    user_requests = @requests[user_id]
    window_start = timestamp - WINDOW

    user_requests.reject! do |t|
      t < window_start
    end

    if user_requests.length < MAX_REQUESTS
      user_requests << timestamp
      true
    else
      false
    end
  end
end
