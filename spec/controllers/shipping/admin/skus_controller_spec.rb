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

describe SkusController do

  # This should return the minimal set of attributes required to create a valid
  # Sku. As you add validations to Sku, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SkusController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all skus as @skus" do
      sku = Sku.create! valid_attributes
      get :index, {}, valid_session
      assigns(:skus).should eq([sku])
    end
  end

  describe "GET show" do
    it "assigns the requested sku as @sku" do
      sku = Sku.create! valid_attributes
      get :show, {:id => sku.to_param}, valid_session
      assigns(:sku).should eq(sku)
    end
  end

  describe "GET new" do
    it "assigns a new sku as @sku" do
      get :new, {}, valid_session
      assigns(:sku).should be_a_new(Sku)
    end
  end

  describe "GET edit" do
    it "assigns the requested sku as @sku" do
      sku = Sku.create! valid_attributes
      get :edit, {:id => sku.to_param}, valid_session
      assigns(:sku).should eq(sku)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Sku" do
        expect {
          post :create, {:sku => valid_attributes}, valid_session
        }.to change(Sku, :count).by(1)
      end

      it "assigns a newly created sku as @sku" do
        post :create, {:sku => valid_attributes}, valid_session
        assigns(:sku).should be_a(Sku)
        assigns(:sku).should be_persisted
      end

      it "redirects to the created sku" do
        post :create, {:sku => valid_attributes}, valid_session
        response.should redirect_to(Sku.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved sku as @sku" do
        # Trigger the behavior that occurs when invalid params are submitted
        Sku.any_instance.stub(:save).and_return(false)
        post :create, {:sku => { "name" => "invalid value" }}, valid_session
        assigns(:sku).should be_a_new(Sku)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Sku.any_instance.stub(:save).and_return(false)
        post :create, {:sku => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested sku" do
        sku = Sku.create! valid_attributes
        # Assuming there are no other skus in the database, this
        # specifies that the Sku created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Sku.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => sku.to_param, :sku => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested sku as @sku" do
        sku = Sku.create! valid_attributes
        put :update, {:id => sku.to_param, :sku => valid_attributes}, valid_session
        assigns(:sku).should eq(sku)
      end

      it "redirects to the sku" do
        sku = Sku.create! valid_attributes
        put :update, {:id => sku.to_param, :sku => valid_attributes}, valid_session
        response.should redirect_to(sku)
      end
    end

    describe "with invalid params" do
      it "assigns the sku as @sku" do
        sku = Sku.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Sku.any_instance.stub(:save).and_return(false)
        put :update, {:id => sku.to_param, :sku => { "name" => "invalid value" }}, valid_session
        assigns(:sku).should eq(sku)
      end

      it "re-renders the 'edit' template" do
        sku = Sku.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Sku.any_instance.stub(:save).and_return(false)
        put :update, {:id => sku.to_param, :sku => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested sku" do
      sku = Sku.create! valid_attributes
      expect {
        delete :destroy, {:id => sku.to_param}, valid_session
      }.to change(Sku, :count).by(-1)
    end

    it "redirects to the skus list" do
      sku = Sku.create! valid_attributes
      delete :destroy, {:id => sku.to_param}, valid_session
      response.should redirect_to(skus_url)
    end
  end

end
