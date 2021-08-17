class AddHostnameToCounters < ActiveRecord::Migration[6.1]
  def change
    add_column :counters, :hostname, :string
    add_index :counters, :hostname
  end
end
