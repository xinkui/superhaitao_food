require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe WeightsController do

  login_admin

  # This should return the minimal set of attributes required to create a valid
  # Weight. As you add validations to Weight, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "weight" => "1" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WeightsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all weights as @weights" do
      weight = Weight.create! valid_attributes
      get :index, {}, valid_session
      assigns(:weights).should eq([weight])
    end
  end

  describe "GET show" do
    it "assigns the requested weight as @weight" do
      weight = Weight.create! valid_attributes
      get :show, {:id => weight.to_param}, valid_session
      assigns(:weight).should eq(weight)
    end
  end

  describe "GET new" do
    it "assigns a new weight as @weight" do
      get :new, {}, valid_session
      assigns(:weight).should be_a_new(Weight)
    end
  end

  describe "GET edit" do
    it "assigns the requested weight as @weight" do
      weight = Weight.create! valid_attributes
      get :edit, {:id => weight.to_param}, valid_session
      assigns(:weight).should eq(weight)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Weight" do
        expect {
          post :create, {:weight => valid_attributes}, valid_session
        }.to change(Weight, :count).by(1)
      end

      it "assigns a newly created weight as @weight" do
        post :create, {:weight => valid_attributes}, valid_session
        assigns(:weight).should be_a(Weight)
        assigns(:weight).should be_persisted
      end

      it "redirects to the created weight" do
        post :create, {:weight => valid_attributes}, valid_session
        response.should redirect_to(Weight.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved weight as @weight" do
        # Trigger the behavior that occurs when invalid params are submitted
        Weight.any_instance.stub(:save).and_return(false)
        post :create, {:weight => { "weight" => "invalid value" }}, valid_session
        assigns(:weight).should be_a_new(Weight)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Weight.any_instance.stub(:save).and_return(false)
        post :create, {:weight => { "weight" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested weight" do
        weight = Weight.create! valid_attributes
        # Assuming there are no other weights in the database, this
        # specifies that the Weight created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Weight.any_instance.should_receive(:update).with({ "weight" => "1" })
        put :update, {:id => weight.to_param, :weight => { "weight" => "1" }}, valid_session
      end

      it "assigns the requested weight as @weight" do
        weight = Weight.create! valid_attributes
        put :update, {:id => weight.to_param, :weight => valid_attributes}, valid_session
        assigns(:weight).should eq(weight)
      end

      it "redirects to the weight" do
        weight = Weight.create! valid_attributes
        put :update, {:id => weight.to_param, :weight => valid_attributes}, valid_session
        response.should redirect_to(weight)
      end
    end

    describe "with invalid params" do
      it "assigns the weight as @weight" do
        weight = Weight.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Weight.any_instance.stub(:save).and_return(false)
        put :update, {:id => weight.to_param, :weight => { "weight" => "invalid value" }}, valid_session
        assigns(:weight).should eq(weight)
      end

      it "re-renders the 'edit' template" do
        weight = Weight.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Weight.any_instance.stub(:save).and_return(false)
        put :update, {:id => weight.to_param, :weight => { "weight" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested weight" do
      weight = Weight.create! valid_attributes
      expect {
        delete :destroy, {:id => weight.to_param}, valid_session
      }.to change(Weight, :count).by(-1)
    end

    it "redirects to the weights list" do
      weight = Weight.create! valid_attributes
      delete :destroy, {:id => weight.to_param}, valid_session
      response.should redirect_to(weights_path)
    end
  end

end
