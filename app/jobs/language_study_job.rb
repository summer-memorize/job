class LanguageStudyJob < ApplicationJob
  queue_as :default

  SEQUENCE = 1

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
    "Asking if there is a two-person table available at a café",
    "Ordering a takeout meal over the phone",
    "Returning an item at a store",
    "Exchanging money at a currency exchange booth",
    "Asking for directions to a subway station",
    "Reporting a lost item at the airport",
    "Reserving a table at a restaurant",
    "Checking bus schedules at a terminal",
    "Ordering an Uber or Lyft ride",
    "Requesting a wake-up call at a hotel",
    "Using a laundromat for the first time",
    "Asking for allergy-friendly menu options",
    "Explaining a food allergy at a restaurant",
    "Checking into an Airbnb",
    "Canceling a hotel reservation",
    "Asking for help with a broken vending machine",
    "Requesting help at a pharmacy",
    "Asking for a SIM card at the airport",
    "Buying a metro card and asking how to use it",
    "Booking a last-minute tour at a tourist center",
    "Asking for an English menu",
    "Asking if tips are included",
    "Reserving tickets at a theater or cinema",
    "Ordering dessert after your meal",
    "Asking for water with no ice",
    "Letting the waiter know you're in a hurry",
    "Complaining about a cold dish",
    "Giving feedback after a meal",
    "Buying a train ticket at the station",
    "Asking where to validate your ticket",
    "Asking for a locker to store your bag",
    "Asking for help using a kiosk machine",
    "Trying to find your gate at the airport",
    "Going through TSA security",
    "Asking if your flight is delayed",
    "Requesting an aisle seat on the plane",
    "Finding a charger or outlet at the airport",
    "Asking a stranger to take your photo",
    "Buying souvenirs at a local shop",
    "Asking if an item is on sale",
    "Negotiating prices at a market",
    "Using a public restroom without change",
    "Asking where to buy a transit pass",
    "Asking how to get to a tourist attraction",
    "Booking a taxi from your hotel",
    "Reporting a noisy room to the hotel desk",
    "Asking if the hotel has a gym or pool",
    "Requesting help with luggage",
    "Buying a SIM card and asking how to activate it",
    "Explaining you lost your passport",
    "Going to a clinic for a fever",
    "Asking if a product contains meat or dairy",
    "Asking to split the bill at a restaurant",
    "Asking if you can pay separately",
    "Letting the staff know you're vegan",
    "Requesting a quiet table at a restaurant",
    "Ordering food using a tablet menu",
    "Requesting a taxi with a child seat",
    "Calling room service for bottled water",
    "Checking out and leaving your luggage",
    "Complimenting the food or service",
    "Telling a driver to drop you off early",
    "Explaining that you don't speak English well",
    "Asking to speak to someone who speaks Korean",
    "Apologizing for a mistake in English",
    "Calling the airline to change a flight",
    "Requesting a window seat when boarding",
    "Explaining why you're traveling (at immigration)",
    "Buying over-the-counter medicine in the U.S.",
    "Asking if you can take photos inside a store",
    "Reserving a spot for a guided tour",
    "Explaining motion sickness on a boat or car",
    "Talking to your Airbnb host about late arrival"
  ]

  ENGLISH_DIALOGUE_PROMPT_FORMAT = <<~ENGLISH_DIALOGUE_PROMPT_FORMAT
    The language is: English.
    The topic is: "%<topic>s".

    [Today's Dialogue]
    Write a natural and realistic conversation between two fictional characters in the United States.
    The conversation should be about "%<topic>s", and contain 5 to 10 back-and-forth exchanges.
    Use casual, everyday English with common expressions. Avoid overly formal or textbook-style language.
    After each line, provide a natural Korean translation that reflects the tone and context.

    Format:
    *Name1*: ...
            : ... (Korean translation)
    *Name2*: ...
            : ... (Korean translation)
    ...
  ENGLISH_DIALOGUE_PROMPT_FORMAT

  ENGLISH_PHRASES_PROMPT_FORMAT = <<~ENGLISH_PHRASES_PROMPT_FORMAT
    The topic is: "%<content>s".

    [Useful Expressions]
    Extract 5 to 10 useful and natural expressions commonly used by native English speakers in the context of "%<content>s".
    For each expression, include the following:
    - The phrase
    - A natural Korean translation that reflects the meaning and tone
    - A short example sentence in English
    - A natural Korean translation of the example sentence

    Format:
    - *Phrase*: ...
            : ... (Korean translation)
      - *Meaning*: ...
              : ... (Korean translation)
      - Example: ...
              : ... (Korean translation)
  ENGLISH_PHRASES_PROMPT_FORMAT

  JAPANESE_DIALOGUE_PROMPT_FORMAT = <<~JAPANESE_DIALOGUE_PROMPT_FORMAT
    The language is: Japanese.
    The topic is: "%<topic>s".

    [Today's Dialogue]
    Write a natural and realistic conversation between two fictional characters in Japan.
    The conversation should be about "%<topic>s", and contain 5 to 10 back-and-forth exchanges.
    Use casual, everyday Japanese with common expressions. Avoid overly formal or textbook-style language.
    After each line, provide the Hiragana reading and a natural Korean translation that reflects the tone and context.

    Format:
    *名前1*: ...
            : ... (Hiragana)
            : ... (Korean translation)
    *名前2*: ...
            : ... (Hiragana)
            : ... (Korean translation)
    ...
  JAPANESE_DIALOGUE_PROMPT_FORMAT

  JAPANESE_PHRASES_PROMPT_FORMAT = <<~JAPANESE_PHRASES_PROMPT_FORMAT
    The topic is: "%<content>s".

    [Useful Expressions]
    Extract 5 to 10 useful and natural expressions commonly used by native Japanese speakers in the context of "%<content>s".
    For each expression, include the following:
    - The expression
    - The Hiragana reading
    - A natural Korean translation that reflects the meaning and tone
    - A short example sentence in Japanese
    - The Hiragana reading of the sentence
    - A natural Korean translation of the example sentence

    Format:
    - *表現*: ...
            : ... (Hiragana)
            : ... (Korean translation)
      - *例文*: ...
              : ... (Hiragana)
              : ... (Korean translation)
  JAPANESE_PHRASES_PROMPT_FORMAT

  LANGUAGES_CONFIG = {
    english: {
      webhook_url: ENV["SLACK_ENGLISH_WEBHOOK_URL"],
      dialogue_prompt_format: ENGLISH_DIALOGUE_PROMPT_FORMAT,
      phrases_prompt_format: ENGLISH_PHRASES_PROMPT_FORMAT
    },
    japanese: {
      webhook_url: ENV["SLACK_JAPANESE_WEBHOOK_URL"],
      dialogue_prompt_format: JAPANESE_DIALOGUE_PROMPT_FORMAT,
      phrases_prompt_format: JAPANESE_PHRASES_PROMPT_FORMAT
    }
  }

  def perform
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    LANGUAGES_CONFIG.each do |language, config|
      notifier = Slack::Notifier.new(config[:webhook_url])
      SEQUENCE.times do
        topic = TOPICS.sample
        dialogue_prompt_format = config[:dialogue_prompt_format]
        phrases_prompt_format = config[:phrases_prompt_format]

        dialogue_response = client.chat(
          parameters: {
            model: "gpt-4o-mini",
            messages: [ { role: "user", content: format(dialogue_prompt_format, topic: topic) } ]
          }
        )
        ai_dialogue_content = dialogue_response.dig("choices", 0, "message", "content")
        binding.pry
        phrases_response = client.chat(
          parameters: {
            model: "gpt-4o-mini",
            messages: [ { role: "user", content: format(phrases_prompt_format, content: ai_dialogue_content) } ]
          }
        )
        ai_phrases_content = phrases_response.dig("choices", 0, "message", "content")
        Lesson.create(
          topic: topic,
          dialogue: ai_dialogue_content,
          phrases: ai_phrases_content,
          language: language
        )
        notifier.ping(ai_dialogue_content)
        notifier.ping(ai_phrases_content)
      end
    end
  end
end
