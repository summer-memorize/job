class JapaneseStudyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    notifier = Slack::Notifier.new(ENV["SLACK_JAPANESE_WEBHOOK_URL"])
    notifier.ping("일본어 공부 시작")
  end
end
