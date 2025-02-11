class Users::RegistrationsController < Devise::RegistrationsController
  before_action :validate_plan, only: [ :new, :create ]  # Ensure we validate before creating the user

  # GET /users/sign_up
  def new
    super # This will continue to render the registration form if plan is valid
  end

  # POST /users
  # def create
  #   # Create a new user with the provided user parameters
  #   @user = User.new(user_params)
  #   @user.plan_id = @plan.id  # Associate the selected plan with the user

  #   if @user.valid?
  #     begin
  #       # Create a Stripe customer using the email and stripeToken (payment method) passed in the request
  #       customer = Stripe::Customer.create(
  #         description: @user.email,
  #         email: @user.email,
  #         source: params[:stripeToken]  # The Stripe token for the payment method
  #       )

  #       # Save the Stripe customer ID for future reference
  #       @user.stripe_customer_token = customer.id

  #       # Handle subscriptions based on the selected plan (Pro or Basic)
  #       if @plan.id == 2 # Pro plan
  #         subscription = Stripe::Subscription.create(
  #           customer: customer.id,
  #           items: [ { price: "price_1QdCqEE1sSOCEmuor86NKBoA" } ]
  #         )
  #         @user.stripe_subscription_id = subscription.id
  #       elsif @plan.id == 1 # Basic plan
  #         price_id_basic = "price_1QdCpiE1sSOCEmuo4RN4elGq"
  #         subscription = Stripe::Subscription.create(
  #           customer: customer.id,
  #           items: [ { price: price_id_basic } ]
  #         )
  #         @user.stripe_subscription_id = subscription.id
  #       end

  #       # Save the user object to the database
  #       @user.save!
  #       # Automatically sign the user in after successful registration
  #       sign_in(@user)

  #       # Redirect the user to the homepage with a success notice
  #       redirect_to root_path, notice: "Account created successfully!"
  #     rescue Stripe::StripeError => e
  #       @user.errors.add(:base, "Stripe error: #{e.message}")
  #       render :new
  #     rescue => e
  #       @user.errors.add(:base, "There was an error processing your request: #{e.message}")
  #       render :new
  #     end
  #   else
  #     render :new
  #   end
  # end
  def create
    # Fetch the plan using the plan ID passed in the params
    @plan = Plan.find_by(id: params[:plan])

    # If no plan is found, add an error and re-render the form
    if @plan.nil?
      @user.errors.add(:base, "Invalid plan selected.")
      render :new and return
    end

    # Create a new user with the provided user parameters
    @user = User.new(user_params)
    @user.plan_id = @plan.id  # Associate the selected plan with the user

    if @user.valid?
      begin
        # Create a Stripe customer using the email and stripeToken (payment method) passed in the request
        customer = Stripe::Customer.create(
          description: @user.email,
          email: @user.email,
          source: params[:stripeToken]  # The Stripe token for the payment method
        )

        # Save the Stripe customer ID for future reference
        @user.stripe_customer_token = customer.id

        # Handle subscriptions based on the selected plan (Pro or Basic)
        if @plan.id == 2 # Pro plan
          subscription = Stripe::Subscription.create(
            customer: customer.id,
            items: [ { price: "price_1QdCqEE1sSOCEmuor86NKBoA" } ]
          )
          @user.stripe_subscription_id = subscription.id
        elsif @plan.id == 1 # Basic plan
          price_id_basic = "price_1QdCpiE1sSOCEmuo4RN4elGq"
          subscription = Stripe::Subscription.create(
            customer: customer.id,
            items: [ { price: price_id_basic } ]
          )
          @user.stripe_subscription_id = subscription.id
        end

        # Save the user object to the database
        @user.save!
        # Automatically sign the user in after successful registration
        sign_in(@user)

        # Redirect the user to the homepage with a success notice
        redirect_to root_path, notice: "Account created successfully!"
      rescue Stripe::StripeError => e
        @user.errors.add(:base, "Stripe error: #{e.message}")
        render :new
      rescue => e
        @user.errors.add(:base, "There was an error processing your request: #{e.message}")
        render :new
      end
    else
      render :new
    end
  end

  private

  # Strong parameters: only allow specific user attributes to be submitted
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  # This method will be called before both 'new' and 'create' actions to validate the selected plan
  # def validate_plan
  #   plan_id = params[:plan]
  #   unless plan_id.nil? || plan_id == "1" || plan_id == "2"
  #     flash[:alert] = "Please select a valid membership plan (Basic or Pro)."
  #     redirect_to root_path and return
  #   end
  # end
  #
  def validate_plan
    Rails.logger.info "Checking plan ID: #{params[:plan]}"

    # Ensure the plan ID is an integer before searching in the DB
    @plan = Plan.find_by(id: params[:plan].to_i)

    if @plan.nil?
      Rails.logger.info "Plan not found: #{params[:plan]}"
      flash[:alert] = "Please select a valid membership plan (Basic or Pro)."
      redirect_to root_path and return
    end
  end

  # def validate_plan
  #   plan_id = params[:plan]
  #   unless plan_id && (plan_id == "1" || plan_id == "2")
  #     flash[:alert] = "Please select a valid membership plan (Basic or Pro)."
  #     redirect_to root_path
  #   end
  # end
end
