class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.string :topic, null: false
      t.text :content, null: false
      t.integer :language, null: false
      t.timestamps
    end
  end
end
