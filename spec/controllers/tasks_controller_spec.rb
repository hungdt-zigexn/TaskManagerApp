require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "GET #index" do
    let!(:tasks) { create_list(:task, 3) }

    context "without filters" do
      before { get :index }

      it "returns a successful response" do
        expect(response).to be_successful
      end

      it "assigns all tasks to @tasks" do
        expect(assigns(:tasks)).to match_array(tasks)
      end
    end

    context "with filters" do
      let!(:completed_task) { create(:task, status: true) }
      let!(:pending_task) { create(:task, status: false) }
      let!(:tagged_task) { create(:task, :with_tags) }

      it "filters by status" do
        get :index, params: { status: true }
        expect(assigns(:tasks)).to include(completed_task)
        expect(assigns(:tasks)).not_to include(pending_task)
      end

      it "filters by due date" do
        future_date = 1.week.from_now
        get :index, params: { due_date: future_date }
        expect(assigns(:tasks).all? { |task| task.due_date <= future_date }).to be true
      end

      it "filters by tag" do
        tag_name = tagged_task.tags.first.name
        get :index, params: { tag: tag_name }
        expect(assigns(:tasks)).to include(tagged_task)
      end
    end
  end

  describe "GET #show" do
    let(:task) { create(:task) }

    it "returns a successful response" do
      get :show, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    let(:task) { create(:task) }

    it "returns a successful response" do
      get :edit, params: { id: task.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for(:task, tag_list: "tag1, tag2") }

      it "creates a new Task" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it "creates new tags" do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Tag, :count).by(2)
      end

      it "redirects to the created task" do
        post :create, params: { task: valid_attributes }
        expect(response).to redirect_to(task_path(Task.last))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { attributes_for(:task, title: "") }

      it "does not create a new Task" do
        expect {
          post :create, params: { task: invalid_attributes }
        }.not_to change(Task, :count)
      end

      it "renders the new template" do
        post :create, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    let(:task) { create(:task) }

    context "with valid parameters" do
      let(:new_attributes) { { title: "Updated Title", tag_list: "new_tag1, new_tag2" } }

      it "updates the requested task" do
        patch :update, params: { id: task.id, task: new_attributes }
        task.reload
        expect(task.title).to eq("Updated Title")
      end

      it "updates the tags" do
        patch :update, params: { id: task.id, task: new_attributes }
        task.reload
        expect(task.tag_list).to eq("new_tag1, new_tag2")
      end

      it "redirects to the task" do
        patch :update, params: { id: task.id, task: new_attributes }
        expect(response).to redirect_to(task_path(task))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { title: "" } }

      it "does not update the task" do
        original_title = task.title
        patch :update, params: { id: task.id, task: invalid_attributes }
        task.reload
        expect(task.title).to eq(original_title)
      end

      it "renders the edit template" do
        patch :update, params: { id: task.id, task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:task) { create(:task) }

    it "destroys the requested task" do
      expect {
        delete :destroy, params: { id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      delete :destroy, params: { id: task.id }
      expect(response).to redirect_to(tasks_url)
    end
  end
end
