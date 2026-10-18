class Ability
  include CanCan::Ability

  # Список почт команды, которым доступна внутрянка
  TEAM_EMAILS = [
    "admin@kisish.com",
    "designer@melotoria.com"
  ].freeze

  def initialize(user)
    
    unless user
      can :read, :static_pages
      return
    end

   
    is_team_member = user.admin? || TEAM_EMAILS.include?(user.email)

    if is_team_member
      can :manage, :all
      return 
    end

    
    can :read, :static_pages
    
    
    # Раскомментируем эти строки, когда придет время открыть доступ всем!
    
    # can :read, Post, status: 'approved' # Читать только одобренные посты
    # can :read, Comment                  # Читать комментарии
    # can :create, Post                   # Предлагать посты
    # can :create, Comment                # Писать комментарии
    # can :create, Like                   # Ставить лайки
    
    # # Редактировать и удалять можно ТОЛЬКО СВОЁ 
    # can [:update, :destroy], Post, user_id: user.id
    # can :destroy, Comment, user_id: user.id
    # can :destroy, Like, user_id: user.id
    
    # # Смотреть профили других музыкантов (если они не скрыты)
    # can :read, User
    # can :update, User, id: user.id 
  end
end