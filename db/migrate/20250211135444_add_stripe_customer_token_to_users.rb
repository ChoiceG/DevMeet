class AddStripeCustomerTokenToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :stripe_customer_token, :string
  end
end
