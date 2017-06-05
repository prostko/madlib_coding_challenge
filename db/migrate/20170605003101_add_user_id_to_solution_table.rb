class AddUserIdToSolutionTable < ActiveRecord::Migration
  def change
    change_table :solutions do |t|
      t.references :user
    end
  end
end
