require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "task#index action" do
    it "should add tasks to the database" do
      task1 = FactoryBot.create(:task)
      task2 = FactoryBot.create(:task)
      task1.update_attributes(title: "something else")
      get :index
      expect(response).to have_http_status :success
      response_value = ActiveSupport::JSON.decode(@response.body)
      expect(response_value.count).to eq(2)
      response_ids = response_value.collect do |task|
        task["id"]
      end
      expect(response_ids).to eq([task1.id, task2.id])
    end
  end

  describe "task#update action" do 
    it "should allow tasks to be marked as done" do
      task = FactoryBot.create(:task, done: false)
      put :update, params: {id: task.id, task: { done: true }}
      expect(response).to have_http_status(:success)
      task.reload
      expect(task.done).to eq(true)
    end
  end

  describe "task#create action" do 
    it "should allow users to create a task" do
      post :create, params: {task: {title: "Fix things"}}
      expect(response).to have_http_status(:success)
      response_value = ActiveSupport::JSON.decode(@response.body)
      expect(response_value['title']).to eq("Fix things")
      expect(Task.last.title).to eq("Fix things")
    end
  end

end
