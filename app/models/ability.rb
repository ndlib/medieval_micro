class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :administrators
      can :manage,  :all
      can :masquerade, User
      cannot :destroy, Role
    elsif user.has_role? :editors
      can :manage, :all
      cannot :manage,  DateRange
      cannot :manage,  Role
      cannot :manage,  Site

      cannot :edit,    User, :roles => { :name => 'administrators' }
      cannot :destroy, User, :roles => { :name => 'administrators' }

      cannot :destroy, City
      cannot :destroy, Collection
      cannot :destroy, DateRange
      cannot :destroy, Facsimile
      cannot :destroy, Language
      cannot :destroy, Library
      cannot :destroy, Location
      cannot :destroy, Microfilm
      cannot :destroy, Role
    else
      can :read, :all
    end
  end
end
