class CreateMadLibs < ActiveRecord::Migration
  def change
    create_table :mad_libs do |t|
      t.string :title
      t.string :text, null: false

      t.timestamps
    end
  end
end
