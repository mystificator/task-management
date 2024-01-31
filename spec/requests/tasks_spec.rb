# spec/requests/tasks_spec.rb
require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  
  describe "GET /tasks" do
    before do
      get "/tasks"
    end

    it "should returns ok HTTP status" do
      expect(response).to have_http_status(:ok)
    end

    it "should return an array" do
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end


  describe "POST /tasks" do
    context "with valid parameters" do
      before do
        post "/tasks", params: { task: { title: "Phyllis Bogan I", body: "Dolores nam temporibus. Doloremque vero odit. Atque est expedita." } }
      end
      
      it "should return a created HTTP status" do
        expect(response).to have_http_status(:created)
      end
      
      it "should have valid body" do
        expect(JSON.parse(response.body)).to include("title", "body")
      end
    end

    context "with invalid parameters" do            
      before do
        post "/tasks", params: { task: { title: nil, body: "Task description" } }
      end

      it "should return an unprocessable_entity HTTP status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "should return error message" do
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end
  
  
  describe "GET /tasks/:id" do
    let(:task) { create(:task) }
    before do
      get "/tasks/#{task.id}"
    end
    
    it "should return an ok HTTP status" do
      expect(response).to have_http_status(:ok)
    end
    
    it "should have valid body" do
      expect(JSON.parse(response.body)).to include("title", "body")
    end
  end
  
  
  describe "PUT /tasks/:id" do
    let!(:task) { create(:task) }
    
    context "with valid parameters" do
      before do
        put "/tasks/#{task.id}", params: { task: { title: "Updated Task" } }
      end
      
      it "should update the requested task" do
        expect(response).to be_successful
      end
    end
    
    context "with invalid parameters" do
      before do
        put "/tasks/#{task.id}", params: { task: { title: nil } }
      end
      
      it "should return an unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "should return error message" do
        expect(JSON.parse(response.body)).to include("errors")
      end
    end

    context "when the task does not exist" do
      before do
        put "/tasks/invalid_id", params: { task: { title: "Updated Title",  } }
      end

      it "should return a not found status" do
        expect(response).to have_http_status(:not_found)
      end

      it "should return an error message of Task not found" do
        expect(JSON.parse(response.body)["errors"]).to eq("Task not found")
      end
    end
  end
  
  describe "DELETE /tasks/:id" do
    let!(:task) { create(:task) }
    
    context "when the task exists" do
      before do
        delete "/tasks/#{task.id}"
      end
      
      it "should return a no content status" do
        expect(response).to have_http_status(:no_content)
      end
    end
    
    context "when the task does not exist" do
      before do
        delete "/tasks/invalid_id"
      end
      
      it "should return a not found status" do
        expect(response).to have_http_status(:not_found)
      end
    
      it "should return an error message of Task not found" do
        expect(JSON.parse(response.body)["errors"]).to eq("Task not found")
      end
    end
    
  end
end
