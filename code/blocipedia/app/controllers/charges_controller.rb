class ChargesController < ApplicationController
  
  after_action :make_premium, only: :create
  
  def new
    role = current_user.role
    case role
      when "standard"
        @stripe_btn_data = {
          key: "#{ Rails.configuration.stripe[:publishable_key] }",
          description: "Premium Membership - #{current_user.name}",
          amount: 15_00
        } 
      when "premium"
        flash[:alert] = "You are already signed up as a Premium member!"
        redirect_to root_path
    end
  end
  
  def create
    @user = current_user
    
    # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
    
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: 15_00,
      description: "Upgrade to Premium Membership - #{current_user.email}",
      currency: 'usd'
    )
    
    flash[:notice] = "Thank you for you payment, #{current_user.email}! You can now create and edit private wikis."
    redirect_to root_path
    
    # Stripe will send back CardErrors when something goes wrong. This block catches and displays the errors.
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end
  
  def edit
  end
  
  def downgrade
    current_user.update_attributes(role: 'standard')
    flash[:notice] = "You've been downgraded to standard membership."
    redirect_to root_path
  end
  
  private
  
  def make_premium
    current_user.update_attribute(:role, 'premium')
  end
  
end
