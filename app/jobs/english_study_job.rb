class EnglishStudyJob < ApplicationJob
  queue_as :default

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

  def perform(*args)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    topic = TOPICS.sample
    content = <<~PROMPT
    #{topic}

    [Today's Dialogue]
    Write a natural and realistic conversation between a customer and an employee in the U.S. The topic is: "{topic}". The conversation should include 5 to 10 back-and-forth lines (alternating between customer and employee). Use natural, everyday English with commonly used American phrases and expressions. Keep it casual and realistic. Avoid overly formal or textbook-style language.

    [Today's Words and Phrases]
    From the dialogue above, extract the most useful and natural words and expressions commonly used by native American English speakers (about 5 to 10).
    For each word or phrase, provide:
    1. The word or phrase
    2. The phonetic pronunciation (IPA)
    3. The meaning in Korean
    4. One short example sentence using that word or phrase

    [Korean Translation]
    Translate the full conversation above into natural and conversational Korean, as if it were spoken between a customer and an employee in Korea. Keep the tone casual and appropriate for each character.

    Make sure to format the response exactly like this structure:

    **#{topic}**

    [Today's Dialogue]
    customer: ...
    employee: ...
    ...

    [Today's Words and Phrases]
    1. word [pronunciation]
    - 뜻: ...
    - 예시: ...
    ...

    [Korean Translation]
    고객: ...
    점원: ...
    PROMPT

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [ { role: "user", content: content } ]
      }
    )

    Lesson.create(topic: topic, content: response, language: "english")

    notifier = Slack::Notifier.new(ENV["SLACK_ENGLISH_WEBHOOK_URL"])
    notifier.ping(response)
  end
end
