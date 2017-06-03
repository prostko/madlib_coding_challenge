class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.references :mad_lib
      t.text :solution_hash

      t.timestamps
    end
  end
end
