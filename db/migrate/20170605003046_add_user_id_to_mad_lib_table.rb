class AddUserIdToMadLibTable < ActiveRecord::Migration
  def change
    change_table :mad_libs do |t|
      t.references :user
    end
  end
end
