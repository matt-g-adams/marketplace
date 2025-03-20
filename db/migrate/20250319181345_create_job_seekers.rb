class CreateJobSeekers < ActiveRecord::Migration[8.0]
  def change
    create_table :job_seekers do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
