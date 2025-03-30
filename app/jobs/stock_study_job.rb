class StockStudyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    notifier = Slack::Notifier.new(ENV["SLACK_STOCK_WEBHOOK_URL"])
    notifier.ping("참치 참치... 먹고싶당")
  end
end
