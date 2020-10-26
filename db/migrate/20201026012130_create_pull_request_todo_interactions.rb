class CreatePullRequestTodoInteractions < ActiveRecord::Migration[6.0]
  def change
    create_table :pull_request_todo_interactions do |t|
      t.string :pr_url
      t.string :todo_url
      t.string :pr_state

      t.timestamps
    end
  end
end
