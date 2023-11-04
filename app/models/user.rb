# frozen_string_literal: true

class User < ApplicationRecord
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  include UserConcern
end
