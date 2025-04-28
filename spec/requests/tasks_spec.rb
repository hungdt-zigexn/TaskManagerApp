require 'rails_helper'

RSpec.describe "/tasks", type: :request do
  describe "GET /index" do
    let!(:tasks) { create_list(:task, 3) }

    context "without filters" do
      before { get tasks_path }

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "includes all tasks" do
        expect(assigns(:tasks)).to match_array(tasks)
      end
    end

    context "with filters" do
      let!(:completed_task) { create(:task, status: true) }
      let!(:pending_task) { create(:task, status: false) }
      let!(:tagged_task) { create(:task, :with_tags) }

      it "filters by status" do
        get tasks_path, params: { status: true }
        expect(assigns(:tasks)).to include(completed_task)
        expect(assigns(:tasks)).not_to include(pending_task)
      end

      it "filters by due date" do
        future_date = 1.week.from_now
        get tasks_path, params: { due_date: future_date }
        expect(assigns(:tasks).all? { |task| task.due_date <= future_date }).to be true
      end

      it "filters by tag" do
        tag_name = tagged_task.tags.first.name
        get tasks_path, params: { tag: tag_name }
        expect(assigns(:tasks)).to include(tagged_task)
      end
    end
  end

  describe "GET /show" do
    let(:task) { create(:task) }

    it "returns a successful response" do
      get task_path(task)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "returns a successful response" do
      get new_task_path
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    let(:task) { create(:task) }

    it "returns a successful response" do
      get edit_task_path(task)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for(:task, tag_list: "tag1, tag2") }

      it "creates a new Task" do
        expect {
          post tasks_path, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "creates new tags" do
        expect {
          post tasks_path, params: { task: valid_attributes }
        }.to change(Tag, :count).by(2)
      end

      it "redirects to the created task" do
        post tasks_path, params: { task: valid_attributes }
        expect(response).to redirect_to(task_path(Task.last))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { attributes_for(:task, title: "") }

      it "does not create a new Task" do
        expect {
          post tasks_path, params: { task: invalid_attributes }
        }.not_to change(Task, :count)
      end

      it "renders a response with 422 status" do
        post tasks_path, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    let(:task) { create(:task) }

    context "with valid parameters" do
      let(:new_attributes) { { title: "Updated Title", tag_list: "new_tag1, new_tag2" } }

      it "updates the requested task" do
        patch task_path(task), params: { task: new_attributes }
        task.reload
        expect(task.title).to eq("Updated Title")
      end

      it "updates the tags" do
        patch task_path(task), params: { task: new_attributes }
        task.reload
        expect(task.tag_list).to eq("new_tag1, new_tag2")
      end

      it "redirects to the task" do
        patch task_path(task), params: { task: new_attributes }
        expect(response).to redirect_to(task_path(task))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { title: "" } }

      it "does not update the task" do
        original_title = task.title
        patch task_path(task), params: { task: invalid_attributes }
        task.reload
        expect(task.title).to eq(original_title)
      end

      it "renders a response with 422 status" do
        patch task_path(task), params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:task) { create(:task) }

    it "destroys the requested task" do
      expect {
        delete task_path(task)
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      delete task_path(task)
      expect(response).to redirect_to(tasks_url)
    end
  end
end
