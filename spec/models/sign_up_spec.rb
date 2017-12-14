require "rails_helper"

RSpec.describe SignUp, type: :model do
  it { should validate_presence_of(:organization_name) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_confirmation) }

  describe "#save" do
    context "when successful" do
      it "creates a new organization" do
        expect { SignUp.new(sign_up_params).save }.to change { Organization.count }.by(1)
      end

      it "creates a new user" do
        expect { SignUp.new(sign_up_params).save }.to change { User.count }.by(1)
      end
    end

    context "when unsuccessful" do
      before do
        create(:organization, name: "My organization")
      end

      it "does not create a new organization when organization fails validations" do
        expect { SignUp.new(sign_up_params).save }.to_not change { Organization.count }
      end

      it "does not create a new organization when user fails validations" do
        params = sign_up_params.merge(organization_name: "New Organization", password: "piramid45", password_confirmation: "piramid56")
        expect { SignUp.new(params).save }.to_not change { Organization.count }
      end

      it "delegates errors" do
        sign_up = SignUp.new(sign_up_params)
        sign_up.save
        expect(sign_up.errors[:organization_name]).to include("has already been taken")
      end
    end
  end

  def sign_up_params
    {
      organization_name: "My organization",
      time_zone: "UTC",
      first_name: "John",
      last_name: "Doe",
      email: "johnd@sample.com",
      password: "random456773",
      password_confirmation: "random456773"
    }
  end
end
