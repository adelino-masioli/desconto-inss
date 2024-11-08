# User model for handling user authentication and registration using Devise.
# Devise modules: :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
