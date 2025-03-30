class LanguageStudyJob < ApplicationJob
  queue_as :default

  SEQUENCE = 1

  LANGUAGES_CONFIG = {
    english: {
      webhook_url: ENV["SLACK_ENGLISH_WEBHOOK_URL"]
    },
    japanese: {
      webhook_url: ENV["SLACK_JAPANESE_WEBHOOK_URL"]
    }
  }

  TOPICS = [
    "Ordering coffee at a café",
    "Understanding the latest memes on social media",
    "Useful phrases for small talk",
    "Greeting people while walking your dog in the park",
    "Asking for menu recommendations and ordering at Five Guys",
    "Customizing your Starbucks drink: switching to soy milk and asking for less sweetness",
    "Going through immigration at the airport",
    "Requesting a front-row seat when checking in at the airport",
    "Asking for wet wipes or a pen on the plane",
    "Asking for a bag and receipt while paying at a convenience store",
    "Asking for the restroom location in a shopping mall",
    "Telling your destination to a taxi driver",
    "Asking the hotel front desk for nearby restaurant recommendations",
    "Asking the hotel front desk about nearby convenience stores or supermarkets",
    "Requesting early check-in at a hotel",
    "Requesting late check-out at a hotel",
    "Requesting room service at a hotel",
    "Requesting additional amenities or towels at a hotel",
    "Asking about the wait time at a restaurant with a waiting list",
    "Asking how many people a dish is meant to serve at a restaurant",
    "Changing your drink order from a cola to sparkling water after ordering",
    "Asking if leftover food can be packed to-go at a restaurant",
    "Asking if the café has Wi-Fi and what the password is",
    "Asking for the restroom location in a café",
    "Asking if there is a two-person table available at a café"
  ]

  ENGLISH_PROMPT_FORMAT = <<~ENGLISH_PROMPT_FORMAT
    The language is: English.
    The topic is: "%<topic>s".

    [Today's Dialogue]
    Write a natural and realistic conversation between two fictional characters in the U.S. The topic is: "%<topic>s". The conversation should include 5 to 10 back-and-forth lines (alternating between the characters). Use natural, everyday English with commonly used American phrases and expressions. Keep it casual and realistic. Avoid overly formal or textbook-style language.
    [Today's Dialogue Example]
    Customer: Hi, I'd like to order a coffee.
    Employee: Sure thing! What can I get for you today?
    Customer: I'll have a large iced coffee with soy milk.
    Employee: Got it! One large iced coffee with soy milk coming right up.
    Customer: And can you add a little less sweetness?
    Employee: Absolutely! I'll make it just the way you like it.

    [Today's Words and Phrases]
    From the dialogue above, extract the most useful and natural words and expressions commonly used by native American English speakers (about 5 to 10).
    [Today's Words and Phrases Example]
    - coffee 커피
    - iced coffee 아이스 커피
    - soy milk 소이 우유
    - less sweetness 덜 달다
    - absolutely 정말로
    - i am sorry 죄송합니다
    - i am human 나는 사람이야
  ENGLISH_PROMPT_FORMAT

  JAPANESE_PROMPT_FORMAT = <<~JAPANESE_PROMPT_FORMAT
    The language is: Japanese.
    The topic is: "%<topic>s".

    [Today's Dialogue]
    Write a natural and realistic conversation between two fictional characters in Japan. The topic is: "%<topic>s". The conversation should include 5 to 10 back-and-forth lines (alternating between the characters). Use natural, everyday Japanese with commonly used Japanese phrases and expressions. Keep it casual and realistic. Avoid overly formal or textbook-style language.
    [Today's Dialogue Example]
    Customer: こんにちは、お茶をお願いします。
    Employee: はい、お茶ですね。
    Customer: お茶を入れてください。
    Employee: はい、お茶を入れますね。

    [Today's Dialogue Example]
    Customer: こんにちは、お茶をお願いします。
    Employee: はい、お茶ですね。
    Customer: お茶を入れてください。
    Employee: はい、お茶を入れますね。

    [Today's Words and Phrases]
    From the dialogue above, extract the most useful and natural words and expressions commonly used by native Japanese speakers (about 5 to 10).
    [Today's Words and Phrases Example]
    - こんにちは こんにちは
    - お茶 お茶
    - お願いします お願いします
    - 入れてください 入れてください
    - 入れますね 入れますね
  JAPANESE_PROMPT_FORMAT

  def perform
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    LANGUAGES_CONFIG.each do |language, config|
      SEQUENCE.times do
        topic = TOPICS.sample
        content = format(PROMPT_FORMAT, topic: topic)
        response = client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [ { role: "user", content: content } ]
          }
        )

        message_content = response.dig("choices", 0, "message", "content")
        Lesson.create(topic: topic, content: response, language: language)
        notifier = Slack::Notifier.new(config[:webhook_url])
        notifier.ping(message_content)
      end
    end
  end
end
