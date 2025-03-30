class EnglishStudyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [ { role: "user", content: "영어 공부 시작" } ]
      }
    )
    notifier = Slack::Notifier.new(ENV["SLACK_ENGLISH_WEBHOOK_URL"])
    notifier.ping("영어 공부 시작")
  end
end
