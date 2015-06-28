class AddPaidAtToItems < ActiveRecord::Migration
  def change
    add_column:items, :paid_at, :date
  end
end
